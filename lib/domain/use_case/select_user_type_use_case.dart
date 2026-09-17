import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/auth_session_model/auth_session_model.dart';
import 'package:mizan/domain/repository/auth_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

class SelectUserTypeInput {
  final String userType;
  final String? shopName;
  final String? address;
  SelectUserTypeInput(this.userType, {this.shopName, this.address});
}

@injectable
class SelectUserTypeUseCase extends BaseUsecase<SelectUserTypeInput, AuthSession> {
  final AuthRepository _authRepository;
  SelectUserTypeUseCase(this._authRepository);

  @override
  Future<Either<Failure, AuthSession>> execute(SelectUserTypeInput input) =>
      _authRepository.selectUserType(
        userType: input.userType,
        shopName: input.shopName,
        address: input.address,
      );
}
