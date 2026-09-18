class CreateContactRequest {
  final String name;
  final String phoneNumber;
  final String? notes;
  final bool isVip;
  final String contactEmail;

  CreateContactRequest(
    this.name,
    this.phoneNumber,
    this.notes,
    this.isVip,
    this.contactEmail,
  );
}

class UpdateContactRequest {
  final String id;
  final String name;
  final String phoneNumber;
  final String? notes;
  final bool isVip;
  final String contactEmail;

  UpdateContactRequest(
    this.id,
    this.name,
    this.phoneNumber,
    this.notes,
    this.isVip,
    this.contactEmail,
  );
}

class GetContactsRequest {
  final int page;
  final int pageSize;
  final String? search;

  GetContactsRequest({required this.page, required this.pageSize, this.search});
}

class GetVipContactsRequest {
  final int page;
  final int pageSize;

  GetVipContactsRequest({required this.page, required this.pageSize});
}
