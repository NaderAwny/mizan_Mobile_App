// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) =>
    NotificationData(
      id: json['id'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      transactionId: json['transactionId'] as String?,
      installmentId: json['installmentId'] as String?,
      isRead: json['isRead'] as bool?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'transactionId': instance.transactionId,
      'installmentId': instance.installmentId,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt,
    };

NotificationsPageData _$NotificationsPageDataFromJson(
  Map<String, dynamic> json,
) => NotificationsPageData(
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => NotificationData.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
);

Map<String, dynamic> _$NotificationsPageDataToJson(
  NotificationsPageData instance,
) => <String, dynamic>{
  'items': instance.items,
  'totalCount': instance.totalCount,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalPages': instance.totalPages,
};

NotificationsPageResponse _$NotificationsPageResponseFromJson(
  Map<String, dynamic> json,
) => NotificationsPageResponse(
  data: json['data'] == null
      ? null
      : NotificationsPageData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$NotificationsPageResponseToJson(
  NotificationsPageResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

MarkNotificationReadData _$MarkNotificationReadDataFromJson(
  Map<String, dynamic> json,
) => MarkNotificationReadData(
  id: json['id'] as String?,
  isRead: json['isRead'] as bool?,
);

Map<String, dynamic> _$MarkNotificationReadDataToJson(
  MarkNotificationReadData instance,
) => <String, dynamic>{'id': instance.id, 'isRead': instance.isRead};

MarkNotificationReadResponse _$MarkNotificationReadResponseFromJson(
  Map<String, dynamic> json,
) => MarkNotificationReadResponse(
  data: json['data'] == null
      ? null
      : MarkNotificationReadData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$MarkNotificationReadResponseToJson(
  MarkNotificationReadResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

RunRemindersScanData _$RunRemindersScanDataFromJson(
  Map<String, dynamic> json,
) => RunRemindersScanData(
  remindersProcessed: (json['remindersProcessed'] as num?)?.toInt(),
  timestamp: json['timestamp'] as String?,
);

Map<String, dynamic> _$RunRemindersScanDataToJson(
  RunRemindersScanData instance,
) => <String, dynamic>{
  'remindersProcessed': instance.remindersProcessed,
  'timestamp': instance.timestamp,
};

RunRemindersScanResponse _$RunRemindersScanResponseFromJson(
  Map<String, dynamic> json,
) => RunRemindersScanResponse(
  data: json['data'] == null
      ? null
      : RunRemindersScanData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$RunRemindersScanResponseToJson(
  RunRemindersScanResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
