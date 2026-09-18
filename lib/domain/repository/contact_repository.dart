import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/contact_request.dart';
import 'package:mizan/domain/model/contact_model.dart';

abstract class ContactRepository {
  Future<Either<Failure, Contact>> createContact(
    CreateContactRequest createContactRequest,
  );

  Future<Either<Failure, ContactsPage>> getContacts(
    GetContactsRequest getContactsRequest,
  );

  Future<Either<Failure, ContactsPage>> getVipContacts(
    GetVipContactsRequest getVipContactsRequest,
  );

  Future<Either<Failure, Contact>> getContactById(String id);

  Future<Either<Failure, Contact>> toggleVip(String id);

  Future<Either<Failure, ContactProfile>> getContactProfile(String id);

  Future<Either<Failure, Contact>> updateContact(
    UpdateContactRequest updateContactRequest,
  );

  Future<Either<Failure, void>> deleteContact(String id);
}
