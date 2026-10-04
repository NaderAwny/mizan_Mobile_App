import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/request/auth_request.dart';
import 'package:mizan/data/response/auth_session_responses/auth_session_responses.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionResponse> verifyOtp(VerifyOtpRequest request);
  Future<AuthSessionResponse> selectUserType(SelectUserTypeRequest request);
  Future<BaseResponse> logout(LogoutRequest request);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AppServiceClient _api;
  AuthRemoteDataSourceImpl(this._api);

  @override
  Future<AuthSessionResponse> verifyOtp(VerifyOtpRequest request) =>
      _api.verifyOtp(request.toJson());

  @override
  Future<AuthSessionResponse> selectUserType(SelectUserTypeRequest request) =>
      _api.selectUserType(request.toJson());

  @override
  Future<BaseResponse> logout(LogoutRequest request) =>
      _api.logout(request.toJson());
}
