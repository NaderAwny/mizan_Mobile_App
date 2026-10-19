import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';
import 'package:mizan/data/response/notifications_responses/notifications_responses.dart';

abstract class NotificationRemoteDataSource {
  /// GET /api/notifications
  Future<NotificationsPageResponse> getNotifications({
    required int page,
    required int pageSize,
    required bool unreadOnly,
  });

  /// PATCH /api/notifications/{id}/read
  Future<MarkNotificationReadResponse> markNotificationRead(String id);

  /// PATCH /api/notifications/read-all
  Future<BaseResponse> markAllNotificationsRead();

  /// POST /api/notifications/run-reminders-scan
  Future<RunRemindersScanResponse> runRemindersScan();
}

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final AppServiceClient _appServiceClient;

  NotificationRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<NotificationsPageResponse> getNotifications({
    required int page,
    required int pageSize,
    required bool unreadOnly,
  }) {
    return _appServiceClient.getNotifications(page, pageSize, unreadOnly);
  }

  @override
  Future<MarkNotificationReadResponse> markNotificationRead(String id) {
    return _appServiceClient.markNotificationRead(id);
  }

  @override
  Future<BaseResponse> markAllNotificationsRead() {
    return _appServiceClient.markAllNotificationsRead();
  }

  @override
  Future<RunRemindersScanResponse> runRemindersScan() {
    return _appServiceClient.runRemindersScan();
  }
}
