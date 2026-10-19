import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/request/device_request.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

abstract class DeviceRemoteDataSource {
  Future<BaseResponse> registerDevice(RegisterDeviceRequest request);
  Future<BaseResponse> unregisterDevice(UnregisterDeviceRequest request);
}

@LazySingleton(as: DeviceRemoteDataSource)
class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final AppServiceClient _api;
  DeviceRemoteDataSourceImpl(this._api);

  @override
  Future<BaseResponse> registerDevice(RegisterDeviceRequest request) =>
      _api.registerDevice(request.toJson());

  @override
  Future<BaseResponse> unregisterDevice(UnregisterDeviceRequest request) =>
      _api.unregisterDevice(request.toJson());
}
