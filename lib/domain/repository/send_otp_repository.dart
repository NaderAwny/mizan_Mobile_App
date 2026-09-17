import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/send_otp.dart';
import 'package:mizan/domain/model/register_model.dart';

abstract class SendOtpRepository {
  Future<Either<Failure, RegisterModel>> sendOtpRepository(
    SendOtpRequest sendOtpRequest,
  );
}
