import 'package:flutter/material.dart';
import 'package:mizan/presentation/resources/color_manager.dart';

class TransactionTypeStyle {
  const TransactionTypeStyle({required this.background, required this.text});
  final Color background;
  final Color text;
}

extension TransactionTypeStyleX on String? {
  TransactionTypeStyle get typeStyle {
    if (this == null) {
      return const TransactionTypeStyle(
        background: ColorManager.transactionTypeBg,
        text: ColorManager.transactionTypeText,
      );
    }
    final String lower = this!.toLowerCase();
    if (lower == 'collect' ||
        lower == 'تحصيل' ||
        lower == 'sale' ||
        lower == 'بيع') {
      return const TransactionTypeStyle(
        background: ColorManager.successContainer,
        text: ColorManager.success,
      );
    }
    if (lower == 'pay' ||
        lower == 'دفع' ||
        lower == 'purchase' ||
        lower == 'شراء') {
      return const TransactionTypeStyle(
        background: ColorManager.errorContainer,
        text: ColorManager.error,
      );
    }
    return const TransactionTypeStyle(
      background: ColorManager.transactionTypeBg,
      text: ColorManager.transactionTypeText,
    );
  }
}
