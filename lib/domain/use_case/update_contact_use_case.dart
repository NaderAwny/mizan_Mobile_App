import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/contact_request.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/domain/repository/contact_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

typedef UpdateContactInput = UpdateContactRequest;

@injectable
class UpdateContactUseCase extends BaseUsecase<UpdateContactInput, Contact> {
  final ContactRepository _repository;

  UpdateContactUseCase(this._repository);

  @override
  Future<Either<Failure, Contact>> execute(UpdateContactInput input) =>
      _repository.updateContact(input);
}
