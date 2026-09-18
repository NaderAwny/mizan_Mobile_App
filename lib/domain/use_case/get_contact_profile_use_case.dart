import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/domain/repository/contact_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class GetContactProfileUseCase extends BaseUsecase<String, ContactProfile> {
  final ContactRepository _repository;

  GetContactProfileUseCase(this._repository);

  @override
  Future<Either<Failure, ContactProfile>> execute(String input) =>
      _repository.getContactProfile(input);
}
