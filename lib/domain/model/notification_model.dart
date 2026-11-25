class NotificationModel {
  final String id;
  final String type; // "InstallmentReminder" (only value in the API contract)
  final String title;
  final String message;
  final String transactionId; // "" when null
  final String installmentId; // "" when null
  final bool isRead;
  final String createdAt; // ISO-8601 UTC

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.transactionId,
    required this.installmentId,
    required this.isRead,
    required this.createdAt,
  });
}

class NotificationsPage {
  final List<NotificationModel> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage; // derived in mapper: page < totalPages

  const NotificationsPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
  });
}

/// نتيجة PATCH /api/notifications/{id}/read
class NotificationReadStatus {
  final String id;
  final bool isRead;

  const NotificationReadStatus({required this.id, required this.isRead});
}

/// نتيجة POST /api/notifications/run-reminders-scan
class RemindersScanResult {
  final int remindersProcessed;
  final String timestamp;

  const RemindersScanResult({
    required this.remindersProcessed,
    required this.timestamp,
  });
}
