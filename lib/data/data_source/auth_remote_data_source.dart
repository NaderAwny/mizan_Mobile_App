import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/response/auth_session_responses/auth_session_responses.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionResponse> verifyOtp(Map<String, dynamic> body);
  Future<AuthSessionResponse> selectUserType(Map<String, dynamic> body);
  Future<BaseResponse> logout(Map<String, dynamic> body);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AppServiceClient _api;
  AuthRemoteDataSourceImpl(this._api);

  @override
  Future<AuthSessionResponse> verifyOtp(Map<String, dynamic> body) =>
      _api.verifyOtp(body);

  @override
  Future<AuthSessionResponse> selectUserType(Map<String, dynamic> body) =>
      _api.selectUserType(body);

  @override
  Future<BaseResponse> logout(Map<String, dynamic> body) =>
      _api.logout(body);
}
