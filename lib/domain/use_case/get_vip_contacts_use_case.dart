import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/contact_request.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/domain/repository/contact_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

typedef GetVipContactsInput = GetContactsRequest;

@injectable
class GetVipContactsUseCase
    extends BaseUsecase<GetVipContactsInput, ContactsPage> {
  final ContactRepository _repository;

  GetVipContactsUseCase(this._repository);

  @override
  Future<Either<Failure, ContactsPage>> execute(GetVipContactsInput input) =>
      _repository.getVipContacts(
        GetVipContactsRequest(page: input.page, pageSize: input.pageSize),
      );
}
