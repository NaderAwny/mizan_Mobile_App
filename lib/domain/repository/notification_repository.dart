import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/notification_model.dart';

abstract class NotificationRepository {
  /// GET /api/notifications
  Future<Either<Failure, NotificationsPage>> getNotifications({
    required int page,
    required int pageSize,
    required bool unreadOnly,
  });

  /// PATCH /api/notifications/{id}/read
  Future<Either<Failure, NotificationReadStatus>> markNotificationRead(
    String id,
  );

  /// PATCH /api/notifications/read-all
  Future<Either<Failure, void>> markAllNotificationsRead();

  /// POST /api/notifications/run-reminders-scan
  Future<Either<Failure, RemindersScanResult>> runRemindersScan();
}
