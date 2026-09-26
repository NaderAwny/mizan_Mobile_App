// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_installment_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayInstallmentResponse _$PayInstallmentResponseFromJson(
  Map<String, dynamic> json,
) => PayInstallmentResponse(
  data: json['data'] == null
      ? null
      : TransactionDataById.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$PayInstallmentResponseToJson(
  PayInstallmentResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
