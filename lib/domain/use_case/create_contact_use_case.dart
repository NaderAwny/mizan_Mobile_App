import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/contact_request.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/domain/repository/contact_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

typedef CreateContactInput = CreateContactRequest;

@injectable
class CreateContactUseCase extends BaseUsecase<CreateContactRequest, Contact> {
  final ContactRepository _repository;

  CreateContactUseCase(this._repository);

  @override
  Future<Either<Failure, Contact>> execute(CreateContactRequest input) =>
      _repository.createContact(input);
}
