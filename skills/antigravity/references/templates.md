# Templates — Authentication & Accounts (Glowy style + Token layer)

> استبدل `glowy` باسم الـ package الحقيقي بتاع مشروع المستخدم (من `pubspec.yaml`).
> كل الأكواد دي على نفس نمط Glowy الحقيقي الموصوف في `glowy_conventions.md`.
> الأشكال (shapes) هنا مأخوذة حرفيًا من `api_contract.md`.

---
## أ) طبقة التوكن (إضافة جديدة — مش موجودة في Glowy الأصلي)

### `data/local/token_local_data_source.dart`
```dart
abstract class TokenLocalDataSource {
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
  });
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<bool> hasValidSession(); // بيتأكد من وجود refresh token
  Future<void> clear();
}
```

### `data/local/secure_token_local_data_source.dart`
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'token_local_data_source.dart';

@LazySingleton(as: TokenLocalDataSource)
class SecureTokenLocalDataSource implements TokenLocalDataSource {
  final FlutterSecureStorage _storage;
  SecureTokenLocalDataSource(this._storage);

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kExpiresAt = 'expires_at';

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
  }) async {
    final expiry = DateTime.now().add(Duration(seconds: expiresInSeconds));
    await Future.wait([
      _storage.write(key: _kAccess, value: accessToken),
      _storage.write(key: _kRefresh, value: refreshToken),
      _storage.write(key: _kExpiresAt, value: expiry.toIso8601String()),
    ]);
  }

  @override
  Future<String?> getAccessToken() => _storage.read(key: _kAccess);

  @override
  Future<String?> getRefreshToken() => _storage.read(key: _kRefresh);

  @override
  Future<bool> hasValidSession() async {
    final r = await getRefreshToken();
    return r != null && r.isNotEmpty;
  }

  @override
  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _kAccess),
      _storage.delete(key: _kRefresh),
      _storage.delete(key: _kExpiresAt),
    ]);
  }
}
```

### `data/local/onboarding_local_data_source.dart` (+ impl بـ shared_preferences)
```dart
abstract class OnboardingLocalDataSource {
  Future<bool> hasSeenOnboarding();
  Future<void> markOnboardingAsSeen();
}
```
```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import 'onboarding_local_data_source.dart';

@LazySingleton(as: OnboardingLocalDataSource)
class SharedPrefsOnboardingDataSource implements OnboardingLocalDataSource {
  final SharedPreferences _prefs;
  SharedPrefsOnboardingDataSource(this._prefs);
  static const _kSeen = 'seen_onboarding';

  @override
  Future<bool> hasSeenOnboarding() async => _prefs.getBool(_kSeen) ?? false;

  @override
  Future<void> markOnboardingAsSeen() async => _prefs.setBool(_kSeen, true);
}
```

### `data/network/auth_interceptor.dart`
نفس الميكانيزم اللي في الملف اللي رفعه المستخدم (lock بـ `_isRefreshing` + طابور
`_pendingRequests` + `authDio` منفصل بدون الـ Interceptor نفسه). الفرق الوحيد: بيستخدم
`TokenLocalDataSource.saveSession(...)` بدل `saveTokens(...)`، وبيتصل بـ
`/api/auth/refresh-token` بالظبط (مش مسار مخترع)، وبيبعت `refreshToken` في الـ body زي
عقد الـ API الحقيقي.
```dart
import 'dart:async';
import 'package:dio/dio.dart';
import '../local/token_local_data_source.dart';

class AuthInterceptor extends Interceptor {
  final TokenLocalDataSource tokenLocalDataSource;
  final Dio authDio;
  final void Function() onSessionExpired;

  AuthInterceptor({
    required this.tokenLocalDataSource,
    required this.authDio,
    required this.onSessionExpired,
  });

  bool _isRefreshing = false;
  final List<Completer<void>> _pendingRequests = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenLocalDataSource.getAccessToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) return handler.next(err);

    if (_isRefreshing) {
      final completer = Completer<void>();
      _pendingRequests.add(completer);
      try {
        await completer.future;
        return handler.resolve(await _retry(err.requestOptions));
      } catch (_) {
        return handler.next(err);
      }
    }

    _isRefreshing = true;
    try {
      final refreshToken = await tokenLocalDataSource.getRefreshToken();
      if (refreshToken == null) {
        throw DioException(requestOptions: err.requestOptions, error: 'No refresh token');
      }
      final response = await authDio.post(
        '/api/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );
      final data = response.data['data'];
      await tokenLocalDataSource.saveSession(
        accessToken: data['token'],
        refreshToken: data['refreshToken'],
        expiresInSeconds: data['expiresInSeconds'],
      );
      for (final c in _pendingRequests) {
        c.complete();
      }
      _pendingRequests.clear();
      return handler.resolve(await _retry(err.requestOptions));
    } catch (e) {
      for (final c in _pendingRequests) {
        c.completeError(e);
      }
      _pendingRequests.clear();
      await tokenLocalDataSource.clear();
      onSessionExpired();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response> _retry(RequestOptions o) {
    final options = Options(method: o.method, headers: o.headers);
    return authDio.request(o.path, data: o.data, queryParameters: o.queryParameters, options: options);
  }
}
```

### تعديل `data/network/dio_client.dart` (`DioFactory`)
ضيف `authDio` منفصل (بدون الـ Interceptor نفسه، تفاديًا للـ loop) وركّب الـ `AuthInterceptor`
على الـ `dio` الرئيسي، مع الاحتفاظ بالـ `PrettyDioLogger`/الـ debugPrint logging الموجود
بالظبط زي ما هو.

### تعديل `app/app_module.dart`
```dart
@lazySingleton
FlutterSecureStorage provideSecureStorage() => const FlutterSecureStorage();
```
(نفس أسلوب تسجيل `InternetConnectionChecker`/`Dio` الموجود فعلاً في نفس الملف.)

### تعديل `app/di.dart` (`configureDependencies`)
`SharedPreferences` async، فلازم تتسجل يدوي قبل `getIt.init()` بالظبط زي ما Glowy
مش بيعمله حاليًا لإنه مش مستخدم، لكن ده هو النمط الصح المطابق لسلوك injectable:
```dart
Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt.init();
}
```

---
## ب) الـ Responses (`data/responses/auth_responses/`)

### `otp_response.dart`
```dart
import 'package:json_annotation/json_annotation.dart';
import '../base_responses/base_responses.dart';

part 'otp_response.g.dart';

@JsonSerializable()
class OtpData {
  @JsonKey(name: "email") String? email;
  @JsonKey(name: "otpSent") bool? otpSent;
  @JsonKey(name: "expiresInSeconds") int? expiresInSeconds;
  OtpData(this.email, this.otpSent, this.expiresInSeconds);
  factory OtpData.fromJson(Map<String, dynamic> json) => _$OtpDataFromJson(json);
  Map<String, dynamic> toJson() => _$OtpDataToJson(this);
}

@JsonSerializable()
class OtpResponse extends BaseResponse {
  @JsonKey(name: "data") OtpData? data;
  OtpResponse({this.data, super.success, super.message});
  factory OtpResponse.fromJson(Map<String, dynamic> json) => _$OtpResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$OtpResponseToJson(this);
}
```
(`register` و`send-otp` الاتنين بيرجعوا `OtpResponse` — نفس شكل الداتا بالظبط.)

### `auth_session_response.dart`
```dart
import 'package:json_annotation/json_annotation.dart';
import '../base_responses/base_responses.dart';

part 'auth_session_response.g.dart';

@JsonSerializable()
class AuthSessionData {
  @JsonKey(name: "token") String? token;
  @JsonKey(name: "refreshToken") String? refreshToken;
  @JsonKey(name: "expiresInSeconds") int? expiresInSeconds;
  @JsonKey(name: "isNewUser") bool? isNewUser;
  @JsonKey(name: "userId") String? userId;
  @JsonKey(name: "firstName") String? firstName;
  @JsonKey(name: "lastName") String? lastName;
  @JsonKey(name: "email") String? email;
  @JsonKey(name: "userType") String? userType;
  @JsonKey(name: "shopName") String? shopName;

  AuthSessionData(this.token, this.refreshToken, this.expiresInSeconds, this.isNewUser,
      this.userId, this.firstName, this.lastName, this.email, this.userType, this.shopName);

  factory AuthSessionData.fromJson(Map<String, dynamic> json) => _$AuthSessionDataFromJson(json);
  Map<String, dynamic> toJson() => _$AuthSessionDataToJson(this);
}

@JsonSerializable()
class AuthSessionResponse extends BaseResponse {
  @JsonKey(name: "data") AuthSessionData? data;
  AuthSessionResponse({this.data, super.success, super.message});
  factory AuthSessionResponse.fromJson(Map<String, dynamic> json) => _$AuthSessionResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AuthSessionResponseToJson(this);
}
```
(`verify-otp`, `select-user-type`, `refresh-token` الثلاثة بيرجعوا `AuthSessionResponse`.)

`logout` بيرجع `BaseResponse` العادي (الموجود في Glowy) من غير subclass، لأن `data` دايمًا `null`.

---
## ج) الـ Domain models (`domain/model/auth_models.dart`)
```dart
class OtpResult {
  String email;
  bool otpSent;
  int expiresInSeconds;
  OtpResult(this.email, this.otpSent, this.expiresInSeconds);
}

class AuthSession {
  String token;
  String refreshToken;
  int expiresInSeconds;
  bool isNewUser;
  String userId;
  String firstName;
  String lastName;
  String email;
  String userType; // "customer" | "shop_owner"
  String shopName;
  AuthSession(this.token, this.refreshToken, this.expiresInSeconds, this.isNewUser,
      this.userId, this.firstName, this.lastName, this.email, this.userType, this.shopName);
}
```

## د) الـ Mapper (`data/mapper/auth_mapper.dart`)
```dart
import 'package:glowy/app/constants.dart';
import 'package:glowy/app/extensions.dart';
import 'package:glowy/data/responses/auth_responses/otp_response.dart';
import 'package:glowy/data/responses/auth_responses/auth_session_response.dart';
import 'package:glowy/domain/model/auth_models.dart';

extension OtpResponseMapper on OtpData {
  OtpResult toDomain() => OtpResult(
        email?.orEmpty() ?? Constants.empty,
        otpSent?.orFalse() ?? Constants.isFalse,
        expiresInSeconds?.orZero() ?? Constants.zero,
      );
}

extension AuthSessionResponseMapper on AuthSessionData {
  AuthSession toDomain() => AuthSession(
        token?.orEmpty() ?? Constants.empty,
        refreshToken?.orEmpty() ?? Constants.empty,
        expiresInSeconds?.orZero() ?? Constants.zero,
        isNewUser?.orFalse() ?? Constants.isFalse,
        userId?.orEmpty() ?? Constants.empty,
        firstName?.orEmpty() ?? Constants.empty,
        lastName?.orEmpty() ?? Constants.empty,
        email?.orEmpty() ?? Constants.empty,
        userType?.orEmpty() ?? Constants.empty,
        shopName?.orEmpty() ?? Constants.empty,
      );
}
```

## هـ) `domain/repository/auth_repository.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:glowy/data/network/failure.dart';
import 'package:glowy/domain/model/auth_models.dart';

abstract class AuthRepository {
  Future<Either<Failure, OtpResult>> register({
    required String email, required String firstName, required String lastName});
  Future<Either<Failure, OtpResult>> sendOtp({required String email});
  Future<Either<Failure, AuthSession>> verifyOtp({required String email, required String code});
  Future<Either<Failure, AuthSession>> selectUserType({
    required String userType, String? shopName, String? address});
  Future<Either<Failure, void>> logout();
}
```

## و) `data/data_source/auth_remote_data_source.dart`
```dart
import 'package:glowy/data/network/app_api.dart';
import 'package:glowy/data/responses/auth_responses/otp_response.dart';
import 'package:glowy/data/responses/auth_responses/auth_session_response.dart';
import 'package:glowy/data/responses/base_responses/base_responses.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Future<OtpResponse> register(Map<String, dynamic> body);
  Future<OtpResponse> sendOtp(Map<String, dynamic> body);
  Future<AuthSessionResponse> verifyOtp(Map<String, dynamic> body);
  Future<AuthSessionResponse> selectUserType(Map<String, dynamic> body);
  Future<BaseResponse> logout(Map<String, dynamic> body);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AppServiceClient _api;
  AuthRemoteDataSourceImpl(this._api);

  @override
  Future<OtpResponse> register(Map<String, dynamic> body) => _api.register(body);
  @override
  Future<OtpResponse> sendOtp(Map<String, dynamic> body) => _api.sendOtp(body);
  @override
  Future<AuthSessionResponse> verifyOtp(Map<String, dynamic> body) => _api.verifyOtp(body);
  @override
  Future<AuthSessionResponse> selectUserType(Map<String, dynamic> body) => _api.selectUserType(body);
  @override
  Future<BaseResponse> logout(Map<String, dynamic> body) => _api.logout(body);
}
```

## ز) إضافات على `data/network/app_api.dart` (`AppServiceClient`)
ضيف الميثودز دي جوه نفس الكلاس الموجود (متعملش abstract class تاني):
```dart
@POST("/api/auth/register")
Future<OtpResponse> register(@Body() Map<String, dynamic> body);

@POST("/api/auth/send-otp")
Future<OtpResponse> sendOtp(@Body() Map<String, dynamic> body);

@POST("/api/auth/verify-otp")
Future<AuthSessionResponse> verifyOtp(@Body() Map<String, dynamic> body);

@POST("/api/auth/select-user-type")
Future<AuthSessionResponse> selectUserType(@Body() Map<String, dynamic> body);

@POST("/api/auth/logout")
Future<BaseResponse> logout(@Body() Map<String, dynamic> body);
```
(`/api/auth/refresh-token` متتحطش هنا — بيتناداها `AuthInterceptor` مباشرة عن طريق `authDio`.)

## ح) `data/repository_impl/auth_repository_impl.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:glowy/data/data_source/auth_remote_data_source.dart';
import 'package:glowy/data/local/token_local_data_source.dart';
import 'package:glowy/data/mapper/auth_mapper.dart';
import 'package:glowy/data/network/error_handler.dart';
import 'package:glowy/data/network/failure.dart';
import 'package:glowy/data/network/network_info.dart';
import 'package:glowy/domain/model/auth_models.dart';
import 'package:glowy/domain/repository/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final NetworkInfo _networkInfo;
  final TokenLocalDataSource _tokenLocalDataSource;

  AuthRepositoryImpl(this._remote, this._networkInfo, this._tokenLocalDataSource);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    if (!await _networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
    try {
      return Right(await call());
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, OtpResult>> register({
    required String email, required String firstName, required String lastName,
  }) => _guard(() async {
        final r = await _remote.register({
          'email': email, 'firstName': firstName, 'lastName': lastName,
        });
        if (r.success != true) throw Exception(r.message ?? ResponseMessage.DEAFULT);
        return r.data!.toDomain();
      });

  @override
  Future<Either<Failure, OtpResult>> sendOtp({required String email}) => _guard(() async {
        final r = await _remote.sendOtp({'email': email});
        if (r.success != true) throw Exception(r.message ?? ResponseMessage.DEAFULT);
        return r.data!.toDomain();
      });

  @override
  Future<Either<Failure, AuthSession>> verifyOtp({
    required String email, required String code,
  }) => _guard(() async {
        final r = await _remote.verifyOtp({'email': email, 'code': code});
        if (r.success != true) throw Exception(r.message ?? ResponseMessage.DEAFULT);
        final session = r.data!.toDomain();
        await _tokenLocalDataSource.saveSession(
          accessToken: session.token,
          refreshToken: session.refreshToken,
          expiresInSeconds: session.expiresInSeconds,
        );
        return session;
      });

  @override
  Future<Either<Failure, AuthSession>> selectUserType({
    required String userType, String? shopName, String? address,
  }) => _guard(() async {
        final r = await _remote.selectUserType({
          'userType': userType,
          if (shopName != null) 'shopName': shopName,
          if (address != null) 'address': address,
        });
        if (r.success != true) throw Exception(r.message ?? ResponseMessage.DEAFULT);
        final session = r.data!.toDomain();
        await _tokenLocalDataSource.saveSession(
          accessToken: session.token,
          refreshToken: session.refreshToken,
          expiresInSeconds: session.expiresInSeconds,
        );
        return session;
      });

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = await _tokenLocalDataSource.getRefreshToken();
      if (refreshToken != null) {
        await _remote.logout({'refreshToken': refreshToken});
      }
    } catch (_) {
      // حتى لو السيرفر رفض، لازم نمسح محليًا عشان المستخدم يعرف يخرج فعليًا.
    } finally {
      await _tokenLocalDataSource.clear();
    }
    return const Right(null);
  }
}
```
> ⚠️ نمط `if (response.success == true) Right(...) else Left(Failure(...))` ده هو نفسه
> نمط Glowy الحقيقي (شوف `ListAppRepositoryImpl`)، وهنا لخّصناه في `_guard` لتفادي التكرار
> عبر الخمس عمليات، لكن المنطق (network check → try/catch → success flag check) واحد.

## ط) الـ Usecases (`domain/usecase/`)
نفس نمط `ListAppUsecase` بالظبط، واحد لكل عملية:
```dart
@injectable
class RegisterUsecase implements BaseUsecase<RegisterInput, OtpResult> {
  final AuthRepository _repo;
  RegisterUsecase(this._repo);
  @override
  Future<Either<Failure, OtpResult>> execute(RegisterInput input) =>
      _repo.register(email: input.email, firstName: input.firstName, lastName: input.lastName);
}
class RegisterInput {
  final String email, firstName, lastName;
  RegisterInput(this.email, this.firstName, this.lastName);
}
```
نفس الشكل بالظبط لـ `SendOtpUsecase`, `VerifyOtpUsecase`, `SelectUserTypeUsecase`,
و`LogoutUsecase` (ده الأخير `BaseUsecase<void, void>` زي `ListAppUsecase` اللي بياخد `void`).

## ي) الـ Cubits (`presentation/auth/<action>_cubit/`)
كل action ليه فولدر لوحده بالظبط زي `list_app_cubit`، `state` فيها `freezed` + `flowState`:

مثال `verify_otp_cubit/verify_otp_state.dart`:
```dart
@freezed
abstract class VerifyOtpState with _$VerifyOtpState {
  const factory VerifyOtpState({FlowState? flowState, AuthSession? data}) = _VerifyOtpState;
}
```
`verify_otp_cubit/verify_otp_cubit.dart`:
```dart
@injectable
class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final VerifyOtpUsecase _usecase;
  VerifyOtpCubit(this._usecase) : super(const VerifyOtpState());

  Future<void> verify({required String email, required String code}) async {
    emit(state.copyWith(
      flowState: LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    ));
    (await _usecase.execute(VerifyOtpInput(email, code))).fold(
      (failure) => emit(state.copyWith(
        flowState: ErrorState(StateRendererType.fullScreenErrorState, failure.message),
      )),
      (session) => emit(state.copyWith(data: session, flowState: ContentState())),
    );
  }
}
```
نفس الشكل بالظبط لـ `RegisterCubit`, `SendOtpCubit`, `SelectUserTypeCubit`, `LogoutCubit`.
(الـ `RefreshToken` مالهوش Cubit — بيحصل جوه `AuthInterceptor` بس، شفافة عن الـ UI.)

## ك) `presentation/splash/splash_cubit/` (جديد — مش موجود في Glowy)
Glowy نفسه معندوش splash cubit منفصل (الـ splash page عندهم بيسمع مباشرة على
`ListAppCubit`). هنا محتاجين قرار مختلف (مفيش داتا نجيبها، القرار محلي بس)، فبنعمل
Cubit صغير على نفس فلسفة الـ enum بتاعة Glowy (`StateRendererType`, `MediaType`) —
يعني **enum، مش sealed classes** (ده أقرب لروح Glowy من التفضيل اللي في الملف المرفوع):
```dart
enum SplashDestination { home, login, onboarding }

@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState({FlowState? flowState, SplashDestination? data}) = _SplashState;
}

@injectable
class SplashCubit extends Cubit<SplashState> {
  final TokenLocalDataSource _tokenLocalDataSource;
  final OnboardingLocalDataSource _onboardingLocalDataSource;
  SplashCubit(this._tokenLocalDataSource, this._onboardingLocalDataSource)
      : super(const SplashState());

  Future<void> decide() async {
    emit(state.copyWith(
      flowState: LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    ));
    final hasSession = await _tokenLocalDataSource.hasValidSession();
    if (hasSession) {
      emit(state.copyWith(data: SplashDestination.home, flowState: ContentState()));
      return;
    }
    final seenOnboarding = await _onboardingLocalDataSource.hasSeenOnboarding();
    emit(state.copyWith(
      data: seenOnboarding ? SplashDestination.login : SplashDestination.onboarding,
      flowState: ContentState(),
    ));
  }
}
```
الشاشة (لما تتعمل بعدين بالـ design tool) بتسمع الـ Cubit ده وتعمل
`pushReplacementNamed` على حسب `state.data`.
