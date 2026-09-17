import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'auth_session_responses.g.dart';

@JsonSerializable()
class AuthSessionData {
  @JsonKey(name: "token") String? token;
  @JsonKey(name: "refreshToken") String? refreshToken;
  @JsonKey(name: "expiresInSeconds") int? expiresInSeconds;
  @JsonKey(name: "isNewUser") bool? isNewUser;
  @JsonKey(name: "userId") String? userId;
  @JsonKey(name: "firstName") String? firstName;
  @JsonKey(name: "lastName") String? lastName;
  @JsonKey(name: "email") String? email;
  @JsonKey(name: "userType") String? userType;
  @JsonKey(name: "shopName") String? shopName;

  AuthSessionData(
    this.token,
    this.refreshToken,
    this.expiresInSeconds,
    this.isNewUser,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.userType,
    this.shopName,
  );

  factory AuthSessionData.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDataFromJson(json);
  Map<String, dynamic> toJson() => _$AuthSessionDataToJson(this);
}

@JsonSerializable()
class AuthSessionResponse extends BaseResponse {
  @JsonKey(name: "data") AuthSessionData? data;
  AuthSessionResponse({this.data, super.success, super.message});
  factory AuthSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AuthSessionResponseToJson(this);
}
