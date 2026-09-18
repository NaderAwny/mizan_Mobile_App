// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactData _$ContactDataFromJson(Map<String, dynamic> json) => ContactData(
  id: json['id'] as String?,
  name: json['name'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  notes: json['notes'] as String?,
  isVip: json['isVip'] as bool?,
  contactEmail: json['contactEmail'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$ContactDataToJson(ContactData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'notes': instance.notes,
      'isVip': instance.isVip,
      'contactEmail': instance.contactEmail,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

ContactResponse _$ContactResponseFromJson(Map<String, dynamic> json) =>
    ContactResponse(
      data: json['data'] == null
          ? null
          : ContactData.fromJson(json['data'] as Map<String, dynamic>),
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ContactResponseToJson(ContactResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

ContactsPageData _$ContactsPageDataFromJson(Map<String, dynamic> json) =>
    ContactsPageData(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ContactData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ContactsPageDataToJson(ContactsPageData instance) =>
    <String, dynamic>{
      'items': instance.items,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'totalPages': instance.totalPages,
    };

ContactsPageResponse _$ContactsPageResponseFromJson(
  Map<String, dynamic> json,
) => ContactsPageResponse(
  data: json['data'] == null
      ? null
      : ContactsPageData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$ContactsPageResponseToJson(
  ContactsPageResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

ContactTransactionData _$ContactTransactionDataFromJson(
  Map<String, dynamic> json,
) => ContactTransactionData(
  id: json['id'] as String?,
  partyName: json['partyName'] as String?,
  type: json['type'] as String?,
  amount: json['amount'] as num?,
  paymentMethod: json['paymentMethod'] as String?,
  transactionDate: json['transactionDate'] as String?,
);

Map<String, dynamic> _$ContactTransactionDataToJson(
  ContactTransactionData instance,
) => <String, dynamic>{
  'id': instance.id,
  'partyName': instance.partyName,
  'type': instance.type,
  'amount': instance.amount,
  'paymentMethod': instance.paymentMethod,
  'transactionDate': instance.transactionDate,
};

ContactProfileData _$ContactProfileDataFromJson(Map<String, dynamic> json) =>
    ContactProfileData(
      contactId: json['contactId'] as String?,
      contactName: json['contactName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      notes: json['notes'] as String?,
      contactEmail: json['contactEmail'] as String?,
      isVip: json['isVip'] as bool?,
      totalTransactions: (json['totalTransactions'] as num?)?.toInt(),
      totalAmount: json['totalAmount'] as num?,
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map(
            (e) => ContactTransactionData.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$ContactProfileDataToJson(ContactProfileData instance) =>
    <String, dynamic>{
      'contactId': instance.contactId,
      'contactName': instance.contactName,
      'phoneNumber': instance.phoneNumber,
      'notes': instance.notes,
      'contactEmail': instance.contactEmail,
      'isVip': instance.isVip,
      'totalTransactions': instance.totalTransactions,
      'totalAmount': instance.totalAmount,
      'transactions': instance.transactions,
    };

ContactProfileResponse _$ContactProfileResponseFromJson(
  Map<String, dynamic> json,
) => ContactProfileResponse(
  data: json['data'] == null
      ? null
      : ContactProfileData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$ContactProfileResponseToJson(
  ContactProfileResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
