import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/response/get_profile_responses/get_profile_responses.dart';

abstract class GetProfileDataSource {
  Future<GetProfileDataResponse> getProfile();
}

@LazySingleton(as: GetProfileDataSource)
class GetProfileDataSourceImpl implements GetProfileDataSource {
  final AppServiceClient _appServiceClient;
  GetProfileDataSourceImpl(this._appServiceClient);
  @override
  Future<GetProfileDataResponse> getProfile() async {
    return await _appServiceClient.getProfile();
  }
}
