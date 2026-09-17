import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/send_otp.dart';
import 'package:mizan/domain/model/register_model.dart';
import 'package:mizan/domain/repository/send_otp_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class SendOtpUseCase extends BaseUsecase<SendOtpRequest, RegisterModel> {
  final SendOtpRepository sendOtpRepository;

  SendOtpUseCase(this.sendOtpRepository);

  @override
  Future<Either<Failure, RegisterModel>> execute(SendOtpRequest input) async {
    return await sendOtpRepository.sendOtpRepository(input);
  }
}
