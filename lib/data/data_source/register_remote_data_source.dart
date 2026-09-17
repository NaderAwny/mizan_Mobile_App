import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/request/register_request.dart';
import 'package:mizan/data/response/register_responses/register_responses.dart';

abstract class RegisterRemoteDataSource {
  Future<RegisterDataResponse> register(RegisterRequest registerRequest);
}

@LazySingleton(as: RegisterRemoteDataSource)
class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final AppServiceClient _appServiceClient;

  RegisterRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<RegisterDataResponse> register(RegisterRequest registerRequest) {
    return _appServiceClient.register(
      registerRequest.email,
      registerRequest.firstName,
      registerRequest.lastName,
    );
  }
}
