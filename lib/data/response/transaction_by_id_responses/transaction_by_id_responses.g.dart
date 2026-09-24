// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_by_id_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentDataById _$InstallmentDataByIdFromJson(Map<String, dynamic> json) =>
    InstallmentDataById(
      id: json['id'] as String?,
      installmentNumber: (json['installmentNumber'] as num?)?.toInt(),
      amount: json['amount'] as num?,
      dueDate: json['dueDate'] as String?,
      isPaid: json['isPaid'] as bool?,
      status: json['status'] as String?,
      paidAt: json['paidAt'] as String?,
    );

Map<String, dynamic> _$InstallmentDataByIdToJson(
  InstallmentDataById instance,
) => <String, dynamic>{
  'id': instance.id,
  'installmentNumber': instance.installmentNumber,
  'amount': instance.amount,
  'dueDate': instance.dueDate,
  'isPaid': instance.isPaid,
  'status': instance.status,
  'paidAt': instance.paidAt,
};

TransactionDataById _$TransactionDataByIdFromJson(Map<String, dynamic> json) =>
    TransactionDataById(
      id: json['id'] as String?,
      shopId: json['shopId'] as String?,
      contactId: json['contactId'] as String?,
      contactName: json['contactName'] as String?,
      partyName: json['partyName'] as String?,
      type: json['type'] as String?,
      amount: json['amount'] as num?,
      paymentMethod: json['paymentMethod'] as String?,
      transactionDate: json['transactionDate'] as String?,
      isInstallment: json['isInstallment'] as bool?,
      installmentPlanMode: json['installmentPlanMode'] as String?,
      noteType: json['noteType'] as String?,
      noteText: json['noteText'] as String?,
      hasVoiceNote: json['hasVoiceNote'] as bool?,
      installments: (json['installments'] as List<dynamic>?)
          ?.map((e) => InstallmentDataById.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPaid: json['totalPaid'] as num?,
      totalRemaining: json['totalRemaining'] as num?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$TransactionDataByIdToJson(
  TransactionDataById instance,
) => <String, dynamic>{
  'id': instance.id,
  'shopId': instance.shopId,
  'contactId': instance.contactId,
  'contactName': instance.contactName,
  'partyName': instance.partyName,
  'type': instance.type,
  'amount': instance.amount,
  'paymentMethod': instance.paymentMethod,
  'transactionDate': instance.transactionDate,
  'isInstallment': instance.isInstallment,
  'installmentPlanMode': instance.installmentPlanMode,
  'noteType': instance.noteType,
  'noteText': instance.noteText,
  'hasVoiceNote': instance.hasVoiceNote,
  'installments': instance.installments,
  'totalPaid': instance.totalPaid,
  'totalRemaining': instance.totalRemaining,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

TransactionResponseById _$TransactionResponseByIdFromJson(
  Map<String, dynamic> json,
) => TransactionResponseById(
  data: json['data'] == null
      ? null
      : TransactionDataById.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$TransactionResponseByIdToJson(
  TransactionResponseById instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
