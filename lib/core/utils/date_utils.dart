import 'package:intl/intl.dart';

/// Parses a SYSTEM timestamp (e.g. createdAt, updatedAt) received from the backend as UTC.
/// If the backend omitted the trailing 'Z' or offset, appends 'Z' so Dart parses
/// it as UTC rather than local time, then converts it to local time via [.toLocal()].
DateTime parseServerTime(String s) {
  final String trimmed = s.trim();
  if (trimmed.isEmpty) return DateTime.now();

  try {
    if (trimmed.endsWith('Z') || trimmed.endsWith('z')) {
      return DateTime.parse(trimmed).toLocal();
    }
    // Check if there is an offset (+HH:MM or -HH:MM after date part)
    final bool hasOffset = trimmed.contains('+') ||
        (trimmed.length > 19 && trimmed.substring(19).contains('-'));
    if (hasOffset) {
      return DateTime.parse(trimmed).toLocal();
    }
    // No Z and no offset -> append 'Z' and parse as UTC then toLocal()
    return DateTime.parse('${trimmed}Z').toLocal();
  } catch (_) {
    try {
      return DateTime.parse(trimmed).toLocal();
    } catch (_) {
      return DateTime.now();
    }
  }
}

/// Null-safe variant of [parseServerTime].
DateTime? tryParseServerTime(String? s) {
  if (s == null || s.trim().isEmpty) return null;
  try {
    return parseServerTime(s);
  } catch (_) {
    return null;
  }
}

/// Parses a BUSINESS date (e.g. transaction operationDate, installment dueDate).
/// These dates are user-selected calendar dates and must NOT be timezone-shifted.
/// Any trailing Z or UTC offsets are stripped before parsing as a local calendar date.
DateTime parseBusinessDate(String s) {
  final String trimmed = s.trim();
  if (trimmed.isEmpty) return DateTime.now();

  try {
    String plain = trimmed;
    if (plain.endsWith('Z') || plain.endsWith('z')) {
      plain = plain.substring(0, plain.length - 1);
    }
    final int plusIdx = plain.indexOf('+');
    if (plusIdx != -1) {
      plain = plain.substring(0, plusIdx);
    } else if (plain.length > 19) {
      final int minusIdx = plain.indexOf('-', 19);
      if (minusIdx != -1) {
        plain = plain.substring(0, minusIdx);
      }
    }
    return DateTime.parse(plain);
  } catch (_) {
    try {
      return DateTime.parse(trimmed);
    } catch (_) {
      return DateTime.now();
    }
  }
}

/// Null-safe variant of [parseBusinessDate].
DateTime? tryParseBusinessDate(String? s) {
  if (s == null || s.trim().isEmpty) return null;
  try {
    return parseBusinessDate(s);
  } catch (_) {
    return null;
  }
}

/// Formats a [DateTime] as date string using intl with Arabic locale.
/// Default format: 'dd-MM-yyyy' (e.g. 23-10-2026).
String formatDate(DateTime date, [String format = 'dd-MM-yyyy']) {
  try {
    return DateFormat(format, 'ar').format(date);
  } catch (_) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }
}

/// Formats a [DateTime] as date & time string using intl with Arabic locale.
/// Default format: 'dd-MM-yyyy hh:mm a'.
String formatDateTime(DateTime dateTime, [String format = 'dd-MM-yyyy hh:mm a']) {
  try {
    final String formatted = DateFormat(format, 'ar').format(dateTime);
    return formatted.replaceAll('AM', 'ص').replaceAll('PM', 'م');
  } catch (_) {
    final String date = formatDate(dateTime);
    final String time = formatTimeAr(dateTime);
    return '$date $time';
  }
}

/// Formats the time component in Arabic (e.g. '03:15 م').
String formatTimeAr(DateTime date) {
  final int hour = date.hour > 12
      ? date.hour - 12
      : date.hour == 0
          ? 12
          : date.hour;
  final String minute = date.minute.toString().padLeft(2, '0');
  final String period = date.hour >= 12 ? 'م' : 'ص';
  return '$hour:$minute $period';
}

/// Computes Arabic relative time against [DateTime.now()].
/// ("الآن", "منذ دقيقة", "منذ 3 ساعات", "أمس 10:30 ص", ...).
String timeAgoAr(DateTime date) {
  final DateTime now = DateTime.now();
  final Duration diff = now.difference(date);

  if (diff.isNegative || diff.inSeconds < 60) {
    return 'الآن';
  }

  if (diff.inMinutes < 60) {
    final int m = diff.inMinutes;
    if (m <= 1) return 'منذ دقيقة';
    if (m == 2) return 'منذ دقيقتين';
    if (m >= 3 && m <= 10) return 'منذ $m دقائق';
    return 'منذ $m دقيقة';
  }

  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime itemDay = DateTime(date.year, date.month, date.day);

  if (today == itemDay) {
    final int h = diff.inHours;
    if (h <= 1) return 'منذ ساعة';
    if (h == 2) return 'منذ ساعتين';
    if (h >= 3 && h <= 10) return 'منذ $h ساعات';
    return 'منذ $h ساعة';
  }

  final int daysDiff = today.difference(itemDay).inDays;
  if (daysDiff == 1) {
    return 'أمس ${formatTimeAr(date)}';
  } else if (daysDiff == 2) {
    return 'منذ يومين';
  } else if (daysDiff >= 3 && daysDiff <= 10) {
    return 'منذ $daysDiff أيام';
  }

  return formatDate(date);
}

/// Translates raw English payment method strings into Arabic.
String translatePaymentMethod(String? method) {
  if (method == null || method.trim().isEmpty) return '';
  final String m = method.trim().toLowerCase();
  switch (m) {
    case 'cash':
    case 'كاش':
      return 'نقدي';
    case 'credit':
    case 'deferred':
    case 'آجل':
    case 'اجل':
      return 'آجل';
    case 'installment':
    case 'installments':
    case 'تقسيط':
    case 'قسط':
      return 'أقساط';
    case 'partial':
    case 'جزئي':
      return 'جزئي';
    case 'bank':
    case 'transfer':
      return 'تحويل بنكي';
    case 'cheque':
    case 'check':
      return 'شيك';
    default:
      return method.trim();
  }
}
