import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/domain/repository/contact_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class GetContactByIdUseCase extends BaseUsecase<String, Contact> {
  final ContactRepository _repository;

  GetContactByIdUseCase(this._repository);

  @override
  Future<Either<Failure, Contact>> execute(String input) =>
      _repository.getContactById(input);
}
