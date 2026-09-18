class CreateContactRequest {
  final String name;
  final String phoneNumber;
  final String? notes;
  final bool isVip;
  final String contactEmail;

  CreateContactRequest({
    required this.name,
    required this.phoneNumber,
    this.notes,
    this.isVip = false,
    this.contactEmail = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
        'notes': notes ?? '',
        'isVip': isVip,
        'contactEmail': contactEmail,
      };
}

class UpdateContactRequest {
  final String id;
  final String name;
  final String phoneNumber;
  final String notes;
  final bool isVip;
  final String contactEmail;

  UpdateContactRequest({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.notes,
    required this.isVip,
    required this.contactEmail,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
        'notes': notes,
        'isVip': isVip,
        'contactEmail': contactEmail,
      };
}

class GetContactsRequest {
  final int page;
  final int pageSize;
  final String? search;

  GetContactsRequest({
    required this.page,
    required this.pageSize,
    this.search,
  });
}

class GetVipContactsRequest {
  final int page;
  final int pageSize;

  GetVipContactsRequest({
    required this.page,
    required this.pageSize,
  });
}
