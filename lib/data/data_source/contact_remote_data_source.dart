import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/request/contact_request.dart';
import 'package:mizan/data/response/contact_responses/contact_responses.dart';

abstract class ContactRemoteDataSource {
  Future<ContactResponse> createContact(
    CreateContactRequest createContactRequest,
  );
  Future<ContactsPageResponse> getContacts(
    GetContactsRequest getContactsRequest,
  );
  Future<ContactsPageResponse> getVipContacts(
    GetVipContactsRequest getVipContactsRequest,
  );
  Future<ContactResponse> getContactById(String id);
  Future<ContactResponse> toggleVip(String id);
  Future<ContactProfileResponse> getContactProfile(String id);
  Future<ContactResponse> updateContact(
    UpdateContactRequest updateContactRequest,
  );
  Future<void> deleteContact(String id);
}

@LazySingleton(as: ContactRemoteDataSource)
class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final AppServiceClient _appServiceClient;

  ContactRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<ContactResponse> createContact(
    CreateContactRequest createContactRequest,
  ) {
    return _appServiceClient.createContact(
      createContactRequest.name,
      createContactRequest.phoneNumber,
      createContactRequest.notes,
    );
  }

  @override
  Future<ContactsPageResponse> getContacts(
    GetContactsRequest getContactsRequest,
  ) {
    return _appServiceClient.getContacts(
      getContactsRequest.page,
      getContactsRequest.pageSize,
      getContactsRequest.search,
    );
  }

  @override
  Future<ContactsPageResponse> getVipContacts(
    GetVipContactsRequest getVipContactsRequest,
  ) {
    return _appServiceClient.getVipContacts(
      getVipContactsRequest.page,
      getVipContactsRequest.pageSize,
    );
  }

  @override
  Future<ContactResponse> getContactById(String id) {
    return _appServiceClient.getContactById(id);
  }

  @override
  Future<ContactResponse> toggleVip(String id) {
    return _appServiceClient.toggleVip(id);
  }

  @override
  Future<ContactProfileResponse> getContactProfile(String id) {
    return _appServiceClient.getContactProfile(id);
  }

  @override
  Future<ContactResponse> updateContact(
    UpdateContactRequest updateContactRequest,
  ) {
    return _appServiceClient.updateContact(
      updateContactRequest.id,
      updateContactRequest.name,
      updateContactRequest.phoneNumber,
      updateContactRequest.notes ?? " ",
      updateContactRequest.isVip,
      updateContactRequest.contactEmail.trim().isEmpty
          ? null
          : updateContactRequest.contactEmail.trim(),
    );
  }

  @override
  Future<void> deleteContact(String id) {
    return _appServiceClient.deleteContact(id);
  }
}
