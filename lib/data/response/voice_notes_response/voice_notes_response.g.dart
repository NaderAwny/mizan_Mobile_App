// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_notes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoiceNoteData _$VoiceNoteDataFromJson(Map<String, dynamic> json) =>
    VoiceNoteData(
      id: json['id'] as String?,
      audioPath: json['audioPath'] as String?,
      operationType: json['operationType'] as String?,
      operationTypeLabel: json['operationTypeLabel'] as String?,
      amount: json['amount'] as num?,
      operationDate: json['operationDate'] as String?,
      contactName: json['contactName'] as String?,
      contactId: json['contactId'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$VoiceNoteDataToJson(VoiceNoteData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'audioPath': instance.audioPath,
      'operationType': instance.operationType,
      'operationTypeLabel': instance.operationTypeLabel,
      'amount': instance.amount,
      'operationDate': instance.operationDate,
      'contactName': instance.contactName,
      'contactId': instance.contactId,
      'notes': instance.notes,
      'createdAt': instance.createdAt,
    };

VoiceNoteResponse _$VoiceNoteResponseFromJson(Map<String, dynamic> json) =>
    VoiceNoteResponse(
      data: json['data'] == null
          ? null
          : VoiceNoteData.fromJson(json['data'] as Map<String, dynamic>),
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$VoiceNoteResponseToJson(VoiceNoteResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

VoiceNotesPageData _$VoiceNotesPageDataFromJson(Map<String, dynamic> json) =>
    VoiceNotesPageData(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => VoiceNoteData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VoiceNotesPageDataToJson(VoiceNotesPageData instance) =>
    <String, dynamic>{
      'items': instance.items,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

VoiceNotesPageResponse _$VoiceNotesPageResponseFromJson(
  Map<String, dynamic> json,
) => VoiceNotesPageResponse(
  data: json['data'] == null
      ? null
      : VoiceNotesPageData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$VoiceNotesPageResponseToJson(
  VoiceNotesPageResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
