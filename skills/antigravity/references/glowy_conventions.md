# قواعد Glowy الحقيقية (متسحبة من الكود نفسه، مش تخمين)

> ده اتعمل بتنزيل الريبو فعليًا (`codeload.github.com/NaderAwny/Glowy/tar.gz/refs/heads/main`)
> وقراءة كل ملفات `lib/` — مش من README بس. لو لقيت أي تعليمات تانية (زي الملف اللي المستخدم
> رفعه واتفرض فيه إن الموديلز `freezed`) بتتعارض مع اللي هنا، **اتبع اللي هنا** لأنه الحقيقي.

## 1. الباكدجات الفعلية في `pubspec.yaml`
`dio`, `retrofit` (متسجل بس مش بيتستخدم فعليًا جوه `AppServiceClient` — الـ `@RestApi` فاضل
بدون تفعيل retrofit_generator كامل في كل مكان)، `json_annotation` + `json_serializable`
(للـ Responses)، `freezed_annotation` + `freezed` (بس للـ Cubit **States**، مش للـ Responses)،
`get_it`, `injectable`, `dartz` (`Either<Failure, T>`), `shared_preferences`,
`internet_connection_checker`, `pretty_dio_logger`, `flutter_bloc`/`bloc`.

**⚠️ مهم:** الـ Response models في Glowy **مش freezed** — دي كلاسات `@JsonSerializable()`
عادية بـ constructor positional. الـ freezed مستخدم بس في `*_state.dart` بتاعة كل Cubit.
لو مشروعك فيه غير كده (زي ما يظهر إنك عملت register بطريقتك) خليك على نفس نمط مشروعك
الحالي في الموديلز الجديدة اللي هتضيفها، لكن الأفضلية لنمط Glowy الحقيقي المذكور هنا.

## 2. بنية المجلدات (feature-first جوه كل layer، مش layer جوه كل feature)
```
lib/
├── app/
│   ├── app.dart              # MyApp: MultiBlocProvider + MaterialApp + onGenerateRoute
│   ├── app_module.dart       # @module: InternetConnectionChecker, Dio, ApiServiceClient
│   ├── constants.dart        # class Constants { baseUrl, empty, zero, isFalse, apiTimeOut }
│   ├── di.dart                # getIt + @InjectableInit configureDependencies()
│   ├── di.config.dart        # (مولّد — build_runner)
│   └── extensions.dart       # orEmpty() / orZero() / orFalse() على String?/int?/bool?
├── data/
│   ├── data_source/          # abstract + Impl (@LazySingleton(as: X)) لكل feature
│   ├── mapper/                # extension X on ResponseModel { toDomain() => ... }
│   ├── network/
│   │   ├── app_api.dart       # @RestApi + factory + دوال retrofit-style
│   │   ├── dio_client.dart    # DioFactory: @lazySingleton class فيه late final Dio
│   │   ├── error_handler.dart # ErrorHandler.handle(e) + enum DataSource + ResponseCode/Message
│   │   ├── failure.dart       # class Failure { int code; String message; }
│   │   └── network_info.dart # abstract NetworkInfo + @LazySingleton(as:) Impl
│   ├── repository_impl/       # @LazySingleton(as: XRepository) — بيتشيك NetworkInfo الأول
│   └── responses/
│       ├── base_responses/base_responses.dart   # class BaseResponse {bool? success; String? message;}
│       └── <feature>_responses/<feature>.dart   # @JsonSerializable(), extends BaseResponse لو فيها data
├── domain/
│   ├── model/                 # plain Dart classes بس (مفيش freezed هنا)
│   ├── repository/            # abstract class X { Future<Either<Failure,T>> ... }
│   └── usecase/
│       ├── base_usecase.dart  # abstract class BaseUsecase<In,Out> { execute(In) }
│       └── <feature>_usecase.dart  # @injectable implements BaseUsecase<In,Out>
└── presentation/
    ├── common/state_randrer/
    │   ├── state_randrer.dart       # enum StateRendererType + Widget StateRandrer
    │   └── state_randrer_impl.dart  # abstract FlowState + LoadingState/ErrorState/ContentState/
    │                                  SuccessState/EmptyState + extension getScreenWidget()
    ├── resources/                    # color/font/strings/styles/values/assets/routes managers
    ├── splash/splash_page.dart        # StatefulWidget بيسمع BlocListener مباشرة (مفيش SplashCubit منفصل)
    └── <feature>/
        └── <action>_cubit/
            ├── <action>_cubit.dart    # @injectable extends Cubit<XState>
            └── <action>_state.dart    # @freezed: { FlowState? flowState, T? data }
```

## 3. نمط الـ Cubit/State القياسي (زي `ListAppCubit`/`ListAppState` بالظبط)
```dart
@freezed
abstract class XState with _$XState {
  const factory XState({FlowState? flowState, T? data}) = _XState;
}

@injectable
class XCubit extends Cubit<XState> {
  final XUsecase _usecase;
  XCubit(this._usecase) : super(const XState());

  Future<void> doAction(...) async {
    emit(state.copyWith(
      flowState: LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    ));
    (await _usecase.execute(Input(...))).fold(
      (failure) => emit(state.copyWith(
        flowState: ErrorState(StateRendererType.fullScreenErrorState, failure.message),
      )),
      (result) => emit(state.copyWith(data: result, flowState: ContentState())),
    );
  }
}
```
الشاشة (لو هتتعمل بعدين) بتسمع الـ `state.flowState` وتحول لـ Widget عن طريق
`flowState.getScreenWidget(context, contentWidget, retryFn)` — الميكانيزم ده جاهز في
`state_randrer_impl.dart` ومفيش داعي تعيد اختراعه.

## 4. نمط الـ Repository Impl القياسي
```dart
@LazySingleton(as: XRepository)
class XRepositoryImpl implements XRepository {
  final XRemoteDataSource _remote;
  final NetworkInfo _networkInfo;
  XRepositoryImpl(this._remote, this._networkInfo);

  @override
  Future<Either<Failure, T>> action(...) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remote.action(...);
        if (response.success == true) {
          return Right(response.toDomain());
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE, response.message ?? ResponseMessage.DEAFULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
```

## 5. الـ DI
- كل حاجة `@injectable`/`@LazySingleton(as: ...)` بتتسجل أوتوماتيك في `di.config.dart` بعد
  `dart run build_runner build --delete-conflicting-outputs`.
- الحاجات اللي مش قابلة للـ auto-registration (زي `Dio` نفسه أو حاجة عايزة async init) بتتسجل
  يدوي جوه `@module abstract class AppModule` في `app_module.dart`.
- `SharedPreferences` مش موجودة في Glowy الحالي أصلًا (مضافة هنا جديد للـ onboarding flag
  بس)، فلازم تتسجل يدوي في `app_module.dart` أو في `configureDependencies()` زي ما موضح
  في ملف `templates.md` (لأنها async).
- `FlutterSecureStorage` sync وجاهزة، فبتتسجل عادي جوه `@module` من غير أي init يدوي.

## 6. حاجات لازم تتاخد بالظبط من غير تعديل
- اسم الملف بتاع الـ common state renderer: `state_randrer` (بالغلط الإملائي ده بالظبط،
  علشان الاستيرادات في باقي المشروع هتبقى متسقة).
- `Constants` class فيها `baseUrl`, `empty`, `zero`, `isFalse`, `apiTimeOut` — زوّد عليها
  بس، متعملش كلاس جديد.
- الـ Extensions (`orEmpty()`, `orZero()`, `orFalse()`) هي اللي بتتستخدم في الـ Mapper مش
  null-check يدوي.
