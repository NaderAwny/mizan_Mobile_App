import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'contact_responses.g.dart';

@JsonSerializable()
class ContactData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "phoneNumber")
  String? phoneNumber;
  @JsonKey(name: "notes")
  String? notes;
  @JsonKey(name: "isVip")
  bool? isVip;
  @JsonKey(name: "contactEmail")
  String? contactEmail;
  @JsonKey(name: "createdAt")
  String? createdAt;
  @JsonKey(name: "updatedAt")
  String? updatedAt;

  ContactData({
    this.id,
    this.name,
    this.phoneNumber,
    this.notes,
    this.isVip,
    this.contactEmail,
    this.createdAt,
    this.updatedAt,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) =>
      _$ContactDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDataToJson(this);
}

@JsonSerializable()
class ContactResponse extends BaseResponse {
  @JsonKey(name: "data")
  ContactData? data;

  ContactResponse({this.data, super.success, super.message});

  factory ContactResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ContactResponseToJson(this);
}

@JsonSerializable()
class ContactsPageData {
  @JsonKey(name: "items")
  List<ContactData>? items;
  @JsonKey(name: "totalCount")
  int? totalCount;
  @JsonKey(name: "page")
  int? page;
  @JsonKey(name: "pageSize")
  int? pageSize;
  @JsonKey(name: "totalPages")
  int? totalPages;

  ContactsPageData({
    this.items,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory ContactsPageData.fromJson(Map<String, dynamic> json) =>
      _$ContactsPageDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContactsPageDataToJson(this);
}

@JsonSerializable()
class ContactsPageResponse extends BaseResponse {
  @JsonKey(name: "data")
  ContactsPageData? data;

  ContactsPageResponse({this.data, super.success, super.message});

  factory ContactsPageResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactsPageResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ContactsPageResponseToJson(this);
}

@JsonSerializable()
class ContactTransactionData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "partyName")
  String? partyName;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "amount")
  num? amount;
  @JsonKey(name: "paymentMethod")
  String? paymentMethod;
  @JsonKey(name: "transactionDate")
  String? transactionDate;

  ContactTransactionData({
    this.id,
    this.partyName,
    this.type,
    this.amount,
    this.paymentMethod,
    this.transactionDate,
  });

  factory ContactTransactionData.fromJson(Map<String, dynamic> json) =>
      _$ContactTransactionDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContactTransactionDataToJson(this);
}

@JsonSerializable()
class ContactProfileData {
  @JsonKey(name: "contactId")
  String? contactId;
  @JsonKey(name: "contactName")
  String? contactName;
  @JsonKey(name: "phoneNumber")
  String? phoneNumber;
  @JsonKey(name: "notes")
  String? notes;
  @JsonKey(name: "contactEmail")
  String? contactEmail;
  @JsonKey(name: "isVip")
  bool? isVip;
  @JsonKey(name: "totalTransactions")
  int? totalTransactions;
  @JsonKey(name: "totalAmount")
  num? totalAmount;
  @JsonKey(name: "transactions")
  List<ContactTransactionData>? transactions;

  ContactProfileData({
    this.contactId,
    this.contactName,
    this.phoneNumber,
    this.notes,
    this.contactEmail,
    this.isVip,
    this.totalTransactions,
    this.totalAmount,
    this.transactions,
  });

  factory ContactProfileData.fromJson(Map<String, dynamic> json) =>
      _$ContactProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContactProfileDataToJson(this);
}

@JsonSerializable()
class ContactProfileResponse extends BaseResponse {
  @JsonKey(name: "data")
  ContactProfileData? data;

  ContactProfileResponse({this.data, super.success, super.message});

  factory ContactProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactProfileResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ContactProfileResponseToJson(this);
}
