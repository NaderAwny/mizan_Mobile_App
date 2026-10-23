import 'package:mizan/core/utils/date_utils.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

abstract class NotificationFormatters {
  /// Group label for section headers: اليوم / أمس / أقدم
  static String getGroupLabel(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) {
      return AppStrings.notificationsOlder;
    }
    final DateTime? date = tryParseServerTime(rawDate);
    if (date == null) {
      return AppStrings.notificationsOlder;
    }

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime itemDate = DateTime(date.year, date.month, date.day);

    final int differenceInDays = today.difference(itemDate).inDays;

    if (differenceInDays == 0) {
      return AppStrings.notificationsToday;
    } else if (differenceInDays == 1) {
      return AppStrings.notificationsYesterday;
    } else {
      return AppStrings.notificationsOlder;
    }
  }

  /// Relative or formatted time for notification cards
  static String formatRelativeTime(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    final DateTime? date = tryParseServerTime(rawDate);
    if (date == null) return rawDate;

    return timeAgoAr(date);
  }
}
