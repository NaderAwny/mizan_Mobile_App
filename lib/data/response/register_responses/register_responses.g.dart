// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      otpSent: json['otpSent'] as bool?,
      expiresInSeconds: (json['expiresInSeconds'] as num?)?.toInt(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'otpSent': instance.otpSent,
      'expiresInSeconds': instance.expiresInSeconds,
      'message': instance.message,
    };

RegisterDataResponse _$RegisterDataResponseFromJson(
  Map<String, dynamic> json,
) =>
    RegisterDataResponse(
        registerResponse: json['data'] == null
            ? null
            : RegisterResponse.fromJson(json['data'] as Map<String, dynamic>),
      )
      ..success = json['success'] as bool?
      ..message = json['message'] as String?;

Map<String, dynamic> _$RegisterDataResponseToJson(
  RegisterDataResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.registerResponse,
};
