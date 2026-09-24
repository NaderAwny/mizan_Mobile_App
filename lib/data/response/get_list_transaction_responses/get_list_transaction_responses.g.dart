// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_list_transaction_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetListTransactionData _$GetListTransactionDataFromJson(
  Map<String, dynamic> json,
) => GetListTransactionData(
  id: json['id'] as String?,
  contactId: json['contactId'] as String?,
  contactName: json['contactName'] as String?,
  type: json['type'] as String?,
  amount: json['amount'] as num?,
  paymentMethod: json['paymentMethod'] as String?,
  transactionDate: json['transactionDate'] as String?,
  isInstallment: json['isInstallment'] as bool?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$GetListTransactionDataToJson(
  GetListTransactionData instance,
) => <String, dynamic>{
  'id': instance.id,
  'contactId': instance.contactId,
  'contactName': instance.contactName,
  'type': instance.type,
  'amount': instance.amount,
  'paymentMethod': instance.paymentMethod,
  'transactionDate': instance.transactionDate,
  'isInstallment': instance.isInstallment,
  'createdAt': instance.createdAt,
};

GetListTransactionsPageData _$GetListTransactionsPageDataFromJson(
  Map<String, dynamic> json,
) => GetListTransactionsPageData(
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => GetListTransactionData.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetListTransactionsPageDataToJson(
  GetListTransactionsPageData instance,
) => <String, dynamic>{
  'items': instance.items,
  'totalCount': instance.totalCount,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalPages': instance.totalPages,
};

GetListTransactionsResponse _$GetListTransactionsResponseFromJson(
  Map<String, dynamic> json,
) => GetListTransactionsResponse(
  data: json['data'] == null
      ? null
      : GetListTransactionsPageData.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$GetListTransactionsResponseToJson(
  GetListTransactionsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
