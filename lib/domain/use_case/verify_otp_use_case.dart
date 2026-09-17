import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/auth_session_model/auth_session_model.dart';
import 'package:mizan/domain/repository/auth_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

class VerifyOtpInput {
  final String email;
  final String code;
  VerifyOtpInput(this.email, this.code);
}

@injectable
class VerifyOtpUseCase extends BaseUsecase<VerifyOtpInput, AuthSession> {
  final AuthRepository _authRepository;
  VerifyOtpUseCase(this._authRepository);

  @override
  Future<Either<Failure, AuthSession>> execute(VerifyOtpInput input) =>
      _authRepository.verifyOtp(email: input.email, code: input.code);
}
