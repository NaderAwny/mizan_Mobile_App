import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'register_responses.g.dart';

@JsonSerializable()
class RegisterResponse {
  @JsonKey(name: "otpSent")
  bool? otpSent;
  @JsonKey(name: "expiresInSeconds")
  int? expiresInSeconds;
  @JsonKey(name: "message")
  String? message;

  RegisterResponse({this.otpSent, this.expiresInSeconds, this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class RegisterDataResponse extends BaseResponse {
  @JsonKey(name: "data")
  RegisterResponse? registerResponse;
  RegisterDataResponse({this.registerResponse});
  factory RegisterDataResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$RegisterDataResponseToJson(this);
}
