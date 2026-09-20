// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentData _$InstallmentDataFromJson(Map<String, dynamic> json) =>
    InstallmentData(
      id: json['id'] as String?,
      installmentNumber: (json['installmentNumber'] as num?)?.toInt(),
      amount: json['amount'] as num?,
      dueDate: json['dueDate'] as String?,
      isPaid: json['isPaid'] as bool?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$InstallmentDataToJson(InstallmentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'installmentNumber': instance.installmentNumber,
      'amount': instance.amount,
      'dueDate': instance.dueDate,
      'isPaid': instance.isPaid,
      'status': instance.status,
    };

TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) =>
    TransactionData(
      id: json['id'] as String?,
      contactId: json['contactId'] as String?,
      contactName: json['contactName'] as String?,
      type: json['type'] as String?,
      amount: json['amount'] as num?,
      paymentMethod: json['paymentMethod'] as String?,
      transactionDate: json['transactionDate'] as String?,
      isInstallment: json['isInstallment'] as bool?,
      installments: (json['installments'] as List<dynamic>?)
          ?.map((e) => InstallmentData.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$TransactionDataToJson(TransactionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contactId': instance.contactId,
      'contactName': instance.contactName,
      'type': instance.type,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'transactionDate': instance.transactionDate,
      'isInstallment': instance.isInstallment,
      'installments': instance.installments,
      'createdAt': instance.createdAt,
    };

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    TransactionResponse(
      data: json['data'] == null
          ? null
          : TransactionData.fromJson(json['data'] as Map<String, dynamic>),
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$TransactionResponseToJson(
  TransactionResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
