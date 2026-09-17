import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/repository/auth_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class LogoutUseCase extends BaseUsecase<void, void> {
  final AuthRepository _authRepository;
  LogoutUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> execute(void input) =>
      _authRepository.logout();
}
