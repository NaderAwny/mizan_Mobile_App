// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssistantSessionData _$AssistantSessionDataFromJson(
  Map<String, dynamic> json,
) => AssistantSessionData(
  sessionId: json['sessionId'] as String?,
  expiresAt: json['expiresAt'] as String?,
);

Map<String, dynamic> _$AssistantSessionDataToJson(
  AssistantSessionData instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'expiresAt': instance.expiresAt,
};

AssistantSessionResponse _$AssistantSessionResponseFromJson(
  Map<String, dynamic> json,
) => AssistantSessionResponse(
  data: json['data'] == null
      ? null
      : AssistantSessionData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$AssistantSessionResponseToJson(
  AssistantSessionResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

PendingActionData _$PendingActionDataFromJson(Map<String, dynamic> json) =>
    PendingActionData(
      actionId: json['actionId'] as String?,
      intent: json['intent'] as String?,
      summary: json['summary'] as String?,
      expiresAt: json['expiresAt'] as String?,
    );

Map<String, dynamic> _$PendingActionDataToJson(PendingActionData instance) =>
    <String, dynamic>{
      'actionId': instance.actionId,
      'intent': instance.intent,
      'summary': instance.summary,
      'expiresAt': instance.expiresAt,
    };

AssistantResponseData _$AssistantResponseDataFromJson(
  Map<String, dynamic> json,
) => AssistantResponseData(
  sessionId: json['sessionId'] as String?,
  sessionReset: json['sessionReset'] as bool?,
  type: json['type'] as String?,
  message: json['message'] as String?,
  data: json['data'],
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  pendingAction: json['pendingAction'] == null
      ? null
      : PendingActionData.fromJson(
          json['pendingAction'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$AssistantResponseDataToJson(
  AssistantResponseData instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'sessionReset': instance.sessionReset,
  'type': instance.type,
  'message': instance.message,
  'data': instance.data,
  'options': instance.options,
  'pendingAction': instance.pendingAction,
};

AssistantCommandResponse _$AssistantCommandResponseFromJson(
  Map<String, dynamic> json,
) => AssistantCommandResponse(
  data: json['data'] == null
      ? null
      : AssistantResponseData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$AssistantCommandResponseToJson(
  AssistantCommandResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
