import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';

abstract class DeviceRepository {
  Future<Either<Failure, void>> registerDevice({
    required String token,
    String platform = 'Android',
    String? deviceId,
  });

  Future<Either<Failure, void>> unregisterDevice({
    required String token,
  });
}
