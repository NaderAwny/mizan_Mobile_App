import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'voice_notes_response.g.dart';

@JsonSerializable()
class VoiceNoteData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "audioPath")
  String? audioPath;
  @JsonKey(name: "operationType")
  String? operationType;
  @JsonKey(name: "operationTypeLabel")
  String? operationTypeLabel;
  @JsonKey(name: "amount")
  num? amount;
  @JsonKey(name: "operationDate")
  String? operationDate;
  @JsonKey(name: "contactName")
  String? contactName;
  @JsonKey(name: "contactId")
  String? contactId;
  @JsonKey(name: "notes")
  String? notes;
  @JsonKey(name: "createdAt")
  String? createdAt;

  VoiceNoteData({
    this.id,
    this.audioPath,
    this.operationType,
    this.operationTypeLabel,
    this.amount,
    this.operationDate,
    this.contactName,
    this.contactId,
    this.notes,
    this.createdAt,
  });

  factory VoiceNoteData.fromJson(Map<String, dynamic> json) =>
      _$VoiceNoteDataFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceNoteDataToJson(this);
}

// يستخدم في: create + get by id
@JsonSerializable()
class VoiceNoteResponse extends BaseResponse {
  @JsonKey(name: "data")
  VoiceNoteData? data;

  VoiceNoteResponse({this.data, super.success, super.message});

  factory VoiceNoteResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      final res = _$VoiceNoteResponseFromJson(json);
      // ignore: prefer_conditional_assignment
      if (res.success == null) res.success = true;
      return res;
    }
    if (json.containsKey('audioPath') ||
        json.containsKey('operationType') ||
        json.containsKey('id')) {
      return VoiceNoteResponse(
        data: VoiceNoteData.fromJson(json),
        success: json['success'] as bool? ?? true,
        message: json['message'] as String?,
      );
    }
    return _$VoiceNoteResponseFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$VoiceNoteResponseToJson(this);
}

@JsonSerializable()
class VoiceNotesPageData {
  @JsonKey(name: "items")
  List<VoiceNoteData>? items;
  @JsonKey(name: "totalCount")
  int? totalCount;
  @JsonKey(name: "page")
  int? page;
  @JsonKey(name: "pageSize")
  int? pageSize;

  VoiceNotesPageData({this.items, this.totalCount, this.page, this.pageSize});

  factory VoiceNotesPageData.fromJson(Map<String, dynamic> json) =>
      _$VoiceNotesPageDataFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceNotesPageDataToJson(this);
}

@JsonSerializable()
class VoiceNotesPageResponse extends BaseResponse {
  @JsonKey(name: "data")
  VoiceNotesPageData? data;

  VoiceNotesPageResponse({this.data, super.success, super.message});

  factory VoiceNotesPageResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      final res = _$VoiceNotesPageResponseFromJson(json);
      if (res.success == null) res.success = true;
      return res;
    }
    if (json.containsKey('items')) {
      return VoiceNotesPageResponse(
        data: VoiceNotesPageData.fromJson(json),
        success: json['success'] as bool? ?? true,
        message: json['message'] as String?,
      );
    }
    return _$VoiceNotesPageResponseFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$VoiceNotesPageResponseToJson(this);
}
