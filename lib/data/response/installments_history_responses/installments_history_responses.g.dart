// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installments_history_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentHistoryItemData _$InstallmentHistoryItemDataFromJson(
  Map<String, dynamic> json,
) => InstallmentHistoryItemData(
  installmentId: json['installmentId'] as String?,
  transactionId: json['transactionId'] as String?,
  contactId: json['contactId'] as String?,
  contactName: json['contactName'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  amount: json['amount'] as num?,
  dueDate: json['dueDate'] as String?,
  isPaid: json['isPaid'] as bool?,
  paidAt: json['paidAt'] as String?,
  status: json['status'] as String?,
  daysOverdue: (json['daysOverdue'] as num?)?.toInt(),
);

Map<String, dynamic> _$InstallmentHistoryItemDataToJson(
  InstallmentHistoryItemData instance,
) => <String, dynamic>{
  'installmentId': instance.installmentId,
  'transactionId': instance.transactionId,
  'contactId': instance.contactId,
  'contactName': instance.contactName,
  'phoneNumber': instance.phoneNumber,
  'amount': instance.amount,
  'dueDate': instance.dueDate,
  'isPaid': instance.isPaid,
  'paidAt': instance.paidAt,
  'status': instance.status,
  'daysOverdue': instance.daysOverdue,
};

InstallmentsHistoryPageData _$InstallmentsHistoryPageDataFromJson(
  Map<String, dynamic> json,
) => InstallmentsHistoryPageData(
  items: (json['items'] as List<dynamic>?)
      ?.map(
        (e) => InstallmentHistoryItemData.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  page: (json['page'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  totalCount: (json['totalCount'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  hasPreviousPage: json['hasPreviousPage'] as bool?,
  hasNextPage: json['hasNextPage'] as bool?,
);

Map<String, dynamic> _$InstallmentsHistoryPageDataToJson(
  InstallmentsHistoryPageData instance,
) => <String, dynamic>{
  'items': instance.items,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
  'totalPages': instance.totalPages,
  'hasPreviousPage': instance.hasPreviousPage,
  'hasNextPage': instance.hasNextPage,
};

InstallmentsHistoryResponse _$InstallmentsHistoryResponseFromJson(
  Map<String, dynamic> json,
) => InstallmentsHistoryResponse(
  data: json['data'] == null
      ? null
      : InstallmentsHistoryPageData.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$InstallmentsHistoryResponseToJson(
  InstallmentsHistoryResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
