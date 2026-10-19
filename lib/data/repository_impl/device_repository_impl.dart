import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/data_source/device_remote_data_source.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/data/request/device_request.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';
import 'package:mizan/domain/repository/device_repository.dart';

@LazySingleton(as: DeviceRepository)
class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  DeviceRepositoryImpl(this._remote, this._networkInfo);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    if (!await _networkInfo.isConnected) {
      return Left<Failure, T>(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
    try {
      return Right<Failure, T>(await call());
    } catch (error) {
      return Left<Failure, T>(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, void>> registerDevice({
    required String token,
    String platform = 'Android',
    String? deviceId,
  }) => _guard(() async {
    final BaseResponse r = await _remote.registerDevice(
      RegisterDeviceRequest(token: token, platform: platform, deviceId: deviceId),
    );
    if (r.success != true) {
      throw Exception(r.message ?? ResponseMessage.DEAFULT);
    }
  });

  @override
  Future<Either<Failure, void>> unregisterDevice({
    required String token,
  }) => _guard(() async {
    final BaseResponse r = await _remote.unregisterDevice(
      UnregisterDeviceRequest(token: token),
    );
    if (r.success != true) {
      throw Exception(r.message ?? ResponseMessage.DEAFULT);
    }
  });
}
