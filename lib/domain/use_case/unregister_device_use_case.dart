import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/repository/device_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class UnregisterDeviceUseCase extends BaseUsecase<String, void> {
  final DeviceRepository _deviceRepository;
  UnregisterDeviceUseCase(this._deviceRepository);

  @override
  Future<Either<Failure, void>> execute(String input) =>
      _deviceRepository.unregisterDevice(token: input);
}
