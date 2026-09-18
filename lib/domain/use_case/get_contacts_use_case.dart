import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/contact_request.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/domain/repository/contact_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

typedef GetContactsInput = GetContactsRequest;

@injectable
class GetContactsUseCase extends BaseUsecase<GetContactsInput, ContactsPage> {
  final ContactRepository _repository;

  GetContactsUseCase(this._repository);

  @override
  Future<Either<Failure, ContactsPage>> execute(GetContactsInput input) =>
      _repository.getContacts(input);
}
