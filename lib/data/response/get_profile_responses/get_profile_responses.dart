import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'get_profile_responses.g.dart';

@JsonSerializable()
class GetProfileResponses {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "firstName")
  String? firstName;
  @JsonKey(name: "lastName")
  String? lastName;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "userType")
  String? userType;
  @JsonKey(name: "isActive")
  bool? isActive;
  @JsonKey(name: "shop")
  GetProfileShopData? shop;
  GetProfileResponses({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.userType,
    this.isActive,
    this.shop,
  });
  factory GetProfileResponses.fromJson(Map<String, dynamic> json) =>
      _$GetProfileResponsesFromJson(json);
  @override
  // ignore: override_on_non_overriding_member
  Map<String, dynamic> toJson() => _$GetProfileResponsesToJson(this);
}

@JsonSerializable()
class GetProfileShopData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "shopName")
  String? shopName;
  @JsonKey(name: "address")
  String? address;
  GetProfileShopData({this.id, this.shopName, this.address});
  factory GetProfileShopData.fromJson(Map<String, dynamic> json) =>
      _$GetProfileShopDataFromJson(json);
  @override
  // ignore: override_on_non_overriding_member
  Map<String, dynamic> toJson() => _$GetProfileShopDataToJson(this);
}

@JsonSerializable()
class GetProfileDataResponse extends BaseResponse {
  @JsonKey(name: "data")
  GetProfileResponses? data;
  GetProfileDataResponse({this.data, super.success, super.message});
  factory GetProfileDataResponse.fromJson(Map<String, dynamic> json) =>
      _$GetProfileDataResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GetProfileDataResponseToJson(this);
}
