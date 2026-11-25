import 'package:json_annotation/json_annotation.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';

part 'notifications_responses.g.dart';

@JsonSerializable()
class NotificationData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "transactionId")
  String? transactionId;
  @JsonKey(name: "installmentId")
  String? installmentId;
  @JsonKey(name: "isRead")
  bool? isRead;
  @JsonKey(name: "createdAt")
  String? createdAt;

  NotificationData({
    this.id,
    this.type,
    this.title,
    this.message,
    this.transactionId,
    this.installmentId,
    this.isRead,
    this.createdAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}

@JsonSerializable()
class NotificationsPageData {
  @JsonKey(name: "items")
  List<NotificationData>? items;
  @JsonKey(name: "totalCount")
  int? totalCount;
  @JsonKey(name: "page")
  int? page;
  @JsonKey(name: "pageSize")
  int? pageSize;
  @JsonKey(name: "totalPages")
  int? totalPages;

  NotificationsPageData({
    this.items,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory NotificationsPageData.fromJson(Map<String, dynamic> json) =>
      _$NotificationsPageDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsPageDataToJson(this);
}

// 7.1
@JsonSerializable()
class NotificationsPageResponse extends BaseResponse {
  @JsonKey(name: "data")
  NotificationsPageData? data;

  NotificationsPageResponse({this.data, super.success, super.message});

  factory NotificationsPageResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsPageResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationsPageResponseToJson(this);
}

@JsonSerializable()
class MarkNotificationReadData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "isRead")
  bool? isRead;

  MarkNotificationReadData({this.id, this.isRead});

  factory MarkNotificationReadData.fromJson(Map<String, dynamic> json) =>
      _$MarkNotificationReadDataFromJson(json);

  Map<String, dynamic> toJson() => _$MarkNotificationReadDataToJson(this);
}

// 7.2
@JsonSerializable()
class MarkNotificationReadResponse extends BaseResponse {
  @JsonKey(name: "data")
  MarkNotificationReadData? data;

  MarkNotificationReadResponse({this.data, super.success, super.message});

  factory MarkNotificationReadResponse.fromJson(Map<String, dynamic> json) =>
      _$MarkNotificationReadResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MarkNotificationReadResponseToJson(this);
}

@JsonSerializable()
class RunRemindersScanData {
  @JsonKey(name: "remindersProcessed")
  int? remindersProcessed;
  @JsonKey(name: "timestamp")
  String? timestamp;

  RunRemindersScanData({this.remindersProcessed, this.timestamp});

  factory RunRemindersScanData.fromJson(Map<String, dynamic> json) =>
      _$RunRemindersScanDataFromJson(json);

  Map<String, dynamic> toJson() => _$RunRemindersScanDataToJson(this);
}

// 7.4
@JsonSerializable()
class RunRemindersScanResponse extends BaseResponse {
  @JsonKey(name: "data")
  RunRemindersScanData? data;

  RunRemindersScanResponse({this.data, super.success, super.message});

  factory RunRemindersScanResponse.fromJson(Map<String, dynamic> json) =>
      _$RunRemindersScanResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RunRemindersScanResponseToJson(this);
}
