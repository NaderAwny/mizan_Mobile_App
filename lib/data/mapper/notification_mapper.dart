import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/notifications_responses/notifications_responses.dart';
import 'package:mizan/domain/model/notification_model.dart';

extension NotificationMapper on NotificationData? {
  NotificationModel toDomain() {
    return NotificationModel(
      id: this?.id.orEmpty() ?? '',
      type: this?.type.orEmpty() ?? '',
      title: this?.title.orEmpty() ?? '',
      message: this?.message.orEmpty() ?? '',
      transactionId: this?.transactionId.orEmpty() ?? '',
      installmentId: this?.installmentId.orEmpty() ?? '',
      isRead: this?.isRead.orFalse() ?? false,
      createdAt: this?.createdAt.orEmpty() ?? '',
    );
  }
}

extension NotificationsPageMapper on NotificationsPageData? {
  NotificationsPage toDomain() {
    final int currentPage = this?.page.orZero() ?? 1;
    final int totalPages = this?.totalPages.orZero() ?? 1;
    return NotificationsPage(
      items:
          (this?.items?.map((NotificationData i) => i.toDomain()) ??
                  const <NotificationModel>[])
              .toList(),
      page: currentPage,
      pageSize: this?.pageSize.orZero() ?? 20,
      totalCount: this?.totalCount.orZero() ?? 0,
      totalPages: totalPages,
      hasNextPage: currentPage < totalPages,
    );
  }
}

extension NotificationReadStatusMapper on MarkNotificationReadData? {
  NotificationReadStatus toDomain() {
    return NotificationReadStatus(
      id: this?.id.orEmpty() ?? '',
      isRead: this?.isRead.orFalse() ?? false,
    );
  }
}

extension RemindersScanResultMapper on RunRemindersScanData? {
  RemindersScanResult toDomain() {
    return RemindersScanResult(
      remindersProcessed: this?.remindersProcessed.orZero() ?? 0,
      timestamp: this?.timestamp.orEmpty() ?? '',
    );
  }
}
