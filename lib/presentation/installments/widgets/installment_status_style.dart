// ─────────────────────────────────────────────────────────────
// InstallmentStatusStyle & Helpers
// Mizan Design System — Shared styling, tokens & formatters
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

/// Representation of visual styling tokens for installment badges, chips, and timeline dots
class InstallmentStatusStyle {
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color dotColor;

  const InstallmentStatusStyle({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.dotColor,
  });

  // Pre-defined static styles for performance and memory efficiency
  static const InstallmentStatusStyle paid = InstallmentStatusStyle(
    label: AppStrings.settledStatus,
    textColor: ColorManager.success,
    backgroundColor: ColorManager.successContainer,
    borderColor: Color(0x332D5C43),
    dotColor: ColorManager.success,
  );

  static const InstallmentStatusStyle overdue = InstallmentStatusStyle(
    label: AppStrings.overdueStatus,
    textColor: ColorManager.error,
    backgroundColor: ColorManager.errorContainer,
    borderColor: Color(0x339B3A2C),
    dotColor: ColorManager.error,
  );

  static const InstallmentStatusStyle dueToday = InstallmentStatusStyle(
    label: AppStrings.dueTodayStatus,
    textColor: ColorManager.secondary,
    backgroundColor: ColorManager.lightSecondary,
    borderColor: Color(0x33D1A153),
    dotColor: ColorManager.secondary,
  );

  static const InstallmentStatusStyle upcoming = InstallmentStatusStyle(
    label: AppStrings.upcomingStatus,
    textColor: ColorManager.textSecondary,
    backgroundColor: ColorManager.surfaceVariant,
    borderColor: ColorManager.border,
    dotColor: ColorManager.textTertiary,
  );

  static const InstallmentStatusStyle regular = InstallmentStatusStyle(
    label: AppStrings.regularStatus,
    textColor: ColorManager.primary,
    backgroundColor: ColorManager.lightPrimary,
    borderColor: Color(0x33C57B57),
    dotColor: ColorManager.primary,
  );
}

class InstallmentFormatters {
  static final intl.NumberFormat _amountFormat = intl.NumberFormat('#,##0.##', 'en');
  static final intl.DateFormat _timelineDateFormat = intl.DateFormat('dd/MM/yyyy');

  static const List<String> _arabicMonths = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  static const List<String> _arabicOrdinals = [
    'دفعة أولى',
    'دفعة ثانية',
    'دفعة ثالثة',
    'دفعة رابعة',
    'دفعة خامسة',
    'دفعة سادسة',
    'دفعة سابعة',
    'دفعة ثامنة',
    'دفعة تاسعة',
    'دفعة عاشرة',
    'دفعة حادية عشرة',
    'دفعة ثانية عشرة',
  ];

  /// Arabic ordinal label for installment indices (0 -> دفعة أولى, 1 -> دفعة ثانية)
  static String getOrdinal(int index) {
    if (index >= 0 && index < _arabicOrdinals.length) {
      return _arabicOrdinals[index];
    }
    return '${AppStrings.paymentCountSuffix} ${index + 1}';
  }

  /// Formatted amount string (e.g. "1,000" or "2,450.5")
  static String formatAmount(num? amount) {
    if (amount == null) return '0';
    return _amountFormat.format(amount);
  }

  /// Formatted date in Arabic format (e.g. "15 أكتوبر 2024")
  static String formatArabicDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    final month = _arabicMonths[(dt.month - 1).clamp(0, 11)];
    return '${dt.day} $month ${dt.year}';
  }

  /// Formatted date in short format (e.g. "15/10/2024")
  static String formatShortDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return _timelineDateFormat.format(dt);
  }

  /// Today's date formatted as dd/MM/yyyy
  static String getTodayFormatted() {
    return _timelineDateFormat.format(DateTime.now());
  }

  /// Extracts 1 or 2 initials from a contact's name
  static String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'م';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      final first = parts[0].characters.first;
      final second = parts[1].characters.first;
      return '$first $second';
    }
    return parts[0].characters.first;
  }
}

class InstallmentStatusHelper {
  /// Resolves status style for a plan in Dashboard
  static InstallmentStatusStyle getPlanStatusStyle({
    required bool isOverdue,
    required bool isDueToday,
    required String status,
  }) {
    if (isOverdue) return InstallmentStatusStyle.overdue;
    if (isDueToday) return InstallmentStatusStyle.dueToday;

    final lower = status.toLowerCase();
    if (lower == 'paid' || lower == 'completed' || lower == 'closed') {
      return InstallmentStatusStyle.paid;
    }
    if (lower == 'overdue') return InstallmentStatusStyle.overdue;
    if (lower == 'duetoday' || lower == 'due_today') return InstallmentStatusStyle.dueToday;
    if (lower == 'upcoming' || lower == 'active' || lower == 'pending') {
      return InstallmentStatusStyle.regular;
    }
    return InstallmentStatusStyle.regular;
  }

  /// Resolves status style for a single installment in Dashboard plan row
  static InstallmentStatusStyle getDashboardInstallmentStyle({
    required bool isPaid,
    required int daysOverdue,
    required String status,
  }) {
    if (isPaid) return InstallmentStatusStyle.paid;
    if (daysOverdue > 0) return InstallmentStatusStyle.overdue;

    final lower = status.toLowerCase();
    if (lower == 'paid') return InstallmentStatusStyle.paid;
    if (lower == 'overdue') return InstallmentStatusStyle.overdue;
    if (lower == 'duetoday' || lower == 'due_today') return InstallmentStatusStyle.dueToday;
    return InstallmentStatusStyle.upcoming;
  }

  /// Resolves status style for an item in History Timeline
  static InstallmentStatusStyle getHistoryItemStyle({
    required bool isPaid,
    required int daysOverdue,
    required String status,
  }) {
    if (isPaid) return InstallmentStatusStyle.paid;
    if (daysOverdue > 0) return InstallmentStatusStyle.overdue;

    final lower = status.toLowerCase();
    if (lower == 'paid') return InstallmentStatusStyle.paid;
    if (lower == 'overdue') return InstallmentStatusStyle.overdue;
    if (lower == 'duetoday' || lower == 'due_today') return InstallmentStatusStyle.dueToday;
    return InstallmentStatusStyle.upcoming;
  }
}
