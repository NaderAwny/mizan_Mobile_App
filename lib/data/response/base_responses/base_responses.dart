import 'package:json_annotation/json_annotation.dart';

part 'base_responses.g.dart';

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: 'success')
  bool? success;
  @JsonKey(name: 'message')
  String? message;
  BaseResponse({this.success, this.message});

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}
