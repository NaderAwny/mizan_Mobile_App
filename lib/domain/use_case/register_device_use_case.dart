import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/repository/device_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

class RegisterDeviceInput {
  final String token;
  final String platform;
  final String? deviceId;

  const RegisterDeviceInput({
    required this.token,
    this.platform = 'Android',
    this.deviceId,
  });
}

@injectable
class RegisterDeviceUseCase extends BaseUsecase<RegisterDeviceInput, void> {
  final DeviceRepository _deviceRepository;
  RegisterDeviceUseCase(this._deviceRepository);

  @override
  Future<Either<Failure, void>> execute(RegisterDeviceInput input) =>
      _deviceRepository.registerDevice(
        token: input.token,
        platform: input.platform,
        deviceId: input.deviceId,
      );
}
