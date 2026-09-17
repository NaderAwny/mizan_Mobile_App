import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/register_request.dart';
import 'package:mizan/domain/model/register_model.dart';
import 'package:mizan/domain/repository/register_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class RegisterUseCase extends BaseUsecase<RegisterRequest, RegisterModel> {
  final RegisterRepository registerRepository;

  RegisterUseCase(this.registerRepository);

  @override
  Future<Either<Failure, RegisterModel>> execute(RegisterRequest input) async {
    return await registerRepository.registerRepository(input);
  }
}
