import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/request/send_otp.dart';
import 'package:mizan/data/response/register_responses/register_responses.dart';

abstract class SendOtpRemoteDataSource {
  Future<RegisterDataResponse> sendOtp(SendOtpRequest sendOtpRequest);
}

@LazySingleton(as: SendOtpRemoteDataSource)
class SendOtpRemoteDataSourceImpl implements SendOtpRemoteDataSource {
  final AppServiceClient _appServiceClient;

  SendOtpRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<RegisterDataResponse> sendOtp(SendOtpRequest sendOtpRequest) {
    return _appServiceClient.sendOtp(sendOtpRequest.email);
  }
}
