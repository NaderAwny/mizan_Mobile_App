import 'package:intl/intl.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

abstract class NotificationFormatters {
  static final DateFormat _timeFormat = DateFormat('hh:mm a');

  /// Group label for section headers: اليوم / أمس / أقدم
  static String getGroupLabel(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) {
      return AppStrings.notificationsOlder;
    }
    final DateTime? date = DateTime.tryParse(rawDate)?.toLocal();
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
    final DateTime? date = DateTime.tryParse(rawDate)?.toLocal();
    if (date == null) return rawDate;

    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} د';
    } else if (difference.inHours < 24 && date.day == now.day) {
      return 'منذ ${difference.inHours} س';
    } else if (difference.inDays == 1 || (difference.inHours < 48 && date.day == now.day - 1)) {
      return '${AppStrings.notificationsYesterday} ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  static String _formatTime(DateTime date) {
    final String formatted = _timeFormat.format(date);
    return formatted.replaceAll('AM', 'ص').replaceAll('PM', 'م');
  }
}
