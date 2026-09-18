import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/repository/contact_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class DeleteContactUseCase extends BaseUsecase<String, void> {
  final ContactRepository _repository;

  DeleteContactUseCase(this._repository);

  @override
  Future<Either<Failure, void>> execute(String input) =>
      _repository.deleteContact(input);
}
