// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_profile_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetProfileResponses _$GetProfileResponsesFromJson(Map<String, dynamic> json) =>
    GetProfileResponses(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      userType: json['userType'] as String?,
      isActive: json['isActive'] as bool?,
      shop: json['shop'] == null
          ? null
          : GetProfileShopData.fromJson(json['shop'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetProfileResponsesToJson(
  GetProfileResponses instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'userType': instance.userType,
  'isActive': instance.isActive,
  'shop': instance.shop,
};

GetProfileShopData _$GetProfileShopDataFromJson(Map<String, dynamic> json) =>
    GetProfileShopData(
      id: json['id'] as String?,
      shopName: json['shopName'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$GetProfileShopDataToJson(GetProfileShopData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shopName': instance.shopName,
      'address': instance.address,
    };

GetProfileDataResponse _$GetProfileDataResponseFromJson(
  Map<String, dynamic> json,
) => GetProfileDataResponse(
  data: json['data'] == null
      ? null
      : GetProfileResponses.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$GetProfileDataResponseToJson(
  GetProfileDataResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
