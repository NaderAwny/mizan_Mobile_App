// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSessionData _$AuthSessionDataFromJson(Map<String, dynamic> json) =>
    AuthSessionData(
      json['token'] as String?,
      json['refreshToken'] as String?,
      (json['expiresInSeconds'] as num?)?.toInt(),
      json['isNewUser'] as bool?,
      json['userId'] as String?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['email'] as String?,
      json['userType'] as String?,
      json['shopName'] as String?,
    );

Map<String, dynamic> _$AuthSessionDataToJson(AuthSessionData instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'expiresInSeconds': instance.expiresInSeconds,
      'isNewUser': instance.isNewUser,
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'userType': instance.userType,
      'shopName': instance.shopName,
    };

AuthSessionResponse _$AuthSessionResponseFromJson(Map<String, dynamic> json) =>
    AuthSessionResponse(
      data: json['data'] == null
          ? null
          : AuthSessionData.fromJson(json['data'] as Map<String, dynamic>),
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$AuthSessionResponseToJson(
  AuthSessionResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
