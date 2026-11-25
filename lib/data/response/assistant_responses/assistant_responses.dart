import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'assistant_responses.g.dart';

@JsonSerializable()
class AssistantSessionData {
  @JsonKey(name: 'sessionId')
  String? sessionId;
  @JsonKey(name: 'expiresAt')
  String? expiresAt;

  AssistantSessionData({this.sessionId, this.expiresAt});

  factory AssistantSessionData.fromJson(Map<String, dynamic> json) =>
      _$AssistantSessionDataFromJson(json);

  Map<String, dynamic> toJson() => _$AssistantSessionDataToJson(this);
}

@JsonSerializable()
class AssistantSessionResponse extends BaseResponse {
  @JsonKey(name: 'data')
  AssistantSessionData? data;

  AssistantSessionResponse({this.data, super.success, super.message});

  factory AssistantSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$AssistantSessionResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AssistantSessionResponseToJson(this);
}

@JsonSerializable()
class PendingActionData {
  @JsonKey(name: 'actionId')
  String? actionId;
  @JsonKey(name: 'intent')
  String? intent;
  @JsonKey(name: 'summary')
  String? summary;
  @JsonKey(name: 'expiresAt')
  String? expiresAt;

  PendingActionData({
    this.actionId,
    this.intent,
    this.summary,
    this.expiresAt,
  });

  factory PendingActionData.fromJson(Map<String, dynamic> json) =>
      _$PendingActionDataFromJson(json);

  Map<String, dynamic> toJson() => _$PendingActionDataToJson(this);
}

@JsonSerializable()
class AssistantResponseData {
  @JsonKey(name: 'sessionId')
  String? sessionId;
  @JsonKey(name: 'sessionReset')
  bool? sessionReset;
  @JsonKey(name: 'type')
  String? type;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'data')
  dynamic data;
  @JsonKey(name: 'options')
  List<String>? options;
  @JsonKey(name: 'pendingAction')
  PendingActionData? pendingAction;

  AssistantResponseData({
    this.sessionId,
    this.sessionReset,
    this.type,
    this.message,
    this.data,
    this.options,
    this.pendingAction,
  });

  factory AssistantResponseData.fromJson(Map<String, dynamic> json) =>
      _$AssistantResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$AssistantResponseDataToJson(this);
}

@JsonSerializable()
class AssistantCommandResponse extends BaseResponse {
  @JsonKey(name: 'data')
  AssistantResponseData? data;

  AssistantCommandResponse({this.data, super.success, super.message});

  factory AssistantCommandResponse.fromJson(Map<String, dynamic> json) =>
      _$AssistantCommandResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AssistantCommandResponseToJson(this);
}
