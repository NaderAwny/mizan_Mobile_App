// ─────────────────────────────────────────────────────────────
// PayInstallmentSheet
// تأكيد سداد القسط — تطابق كامل مع الـ Figma design والمقاسات القياسية
// Mizan Design System
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/transactions/pay_installment/pay_installment_cubit.dart';
import 'package:mizan/presentation/transactions/pay_installment/pay_installment_state.dart';

// ─────────────────────────────────────────────────────────────
// Public entry-point
// ─────────────────────────────────────────────────────────────

/// يعرض Bottom Sheet لتأكيد سداد القسط.
/// [onSuccess] يُستدعى بعد نجاح السداد لتحديث الشاشة الأم.
Future<void> showPayInstallmentSheet({
  required BuildContext context,
  required InstallmentbyidModel installment,
  required String contactName,
  String? transactionType,
  int? totalInstallments,
  required VoidCallback onSuccess,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(90),
    builder: (_) => BlocProvider<PayInstallmentCubit>(
      create: (_) => getIt<PayInstallmentCubit>(),
      child: _PayInstallmentSheet(
        installment: installment,
        contactName: contactName,
        transactionType: transactionType,
        totalInstallments: totalInstallments,
        onSuccess: onSuccess,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// Private Sheet Widget
// ─────────────────────────────────────────────────────────────

class _PayInstallmentSheet extends StatefulWidget {
  final InstallmentbyidModel installment;
  final String contactName;
  final String? transactionType;
  final int? totalInstallments;
  final VoidCallback onSuccess;

  const _PayInstallmentSheet({
    required this.installment,
    required this.contactName,
    this.transactionType,
    this.totalInstallments,
    required this.onSuccess,
  });

  @override
  State<_PayInstallmentSheet> createState() => _PayInstallmentSheetState();
}

class _PayInstallmentSheetState extends State<_PayInstallmentSheet> {
  // ─────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────

  String _formatAmount(num? value) {
    if (value == null) return '0.00';
    final formatter = intl.NumberFormat('#,##0.##', 'en');
    return formatter.format(value);
  }

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

  String _formatDateTime(DateTime dt) {
    final month = _arabicMonths[(dt.month - 1).clamp(0, 11)];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'م' : 'ص';
    return '${dt.day} $month ${dt.year} - $hour:$minute $period';
  }

  String _formatDueDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    try {
      final dt = DateTime.parse(raw);
      final month = _arabicMonths[(dt.month - 1).clamp(0, 11)];
      return '${dt.day} $month ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  /// حساب عدد أيام التأخير أو الأيام المتبقية
  int _overdueDays() {
    if (widget.installment.dueDate == null ||
        widget.installment.dueDate!.isEmpty) {
      return 0;
    }
    try {
      final due = DateTime.parse(widget.installment.dueDate!);
      final now = DateTime.now();
      final diff = DateTime(
        now.year,
        now.month,
        now.day,
      ).difference(DateTime(due.year, due.month, due.day)).inDays;
      return diff;
    } catch (_) {
      return 0;
    }
  }

  String _overdueLabel() {
    final days = _overdueDays();
    if (days < 0) {
      final remaining = -days;
      return 'مستحق خلال $remaining ${remaining == 1 ? 'يوم' : 'أيام'}';
    } else if (days == 0) {
      return 'مستحق اليوم';
    } else {
      return 'متأخر $days ${days == 1 ? 'يوم' : 'أيام'}';
    }
  }

  Color _overdueColor() {
    final days = _overdueDays();
    if (days <= 0) return ColorManager.primary;
    return ColorManager.error;
  }

  Color _overdueContainerColor() {
    final days = _overdueDays();
    if (days <= 0) return ColorManager.lightPrimary;
    return ColorManager.errorContainer;
  }

  String _getPartyLabel() {
    final t = widget.transactionType?.toLowerCase() ?? '';
    if (t == 'purchase' || t == 'شراء') {
      return 'المورد';
    }
    return 'العميل';
  }

  /// تأكيد السداد — إذا كان القسط مستقبلياً يظهر تنبيه للمستخدم
  void _handleConfirmPayment(BuildContext context) {
    final days = _overdueDays();
    if (days < 0) {
      final daysRemaining = -days;
      showDialog(
        context: context,
        builder: (dialogCtx) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: ColorManager.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r20.r),
            ),
            icon: Icon(
              Icons.info_outline_rounded,
              color: ColorManager.primary,
              size: 38.r,
            ),
            title: Text(
              'سداد مبكر للقسط',
              textAlign: TextAlign.center,
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s16,
              ),
            ),
            content: Text(
              'موعد استحقاق هذا القسط بعد $daysRemaining ${daysRemaining == 1 ? 'يوم' : 'أيام'} (${_formatDueDate(widget.installment.dueDate)}).\n\nهل أنت متأكد من رغبتك في سداد القسط الآن قبل موعد الاستحقاق؟',
              textAlign: TextAlign.center,
              style: getMediumStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s13,
                height: 1.5,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(
                  'تراجع',
                  style: getMediumStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 8.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r10.r),
                  ),
                ),
                onPressed: () {
                  Navigator.of(dialogCtx).pop();
                  HapticFeedback.mediumImpact();
                  context.read<PayInstallmentCubit>().pay(
                    widget.installment.id ?? '',
                  );
                },
                child: Text(
                  'نعم، سداد الآن',
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      HapticFeedback.mediumImpact();
      context.read<PayInstallmentCubit>().pay(widget.installment.id ?? '');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PayInstallmentCubit, PayInstallmentState>(
      listener: (ctx, state) {
        if (state.flowState is ErrorState) {
          state.flowState?.getScreenWidget(ctx, const SizedBox.shrink(), () {});
        }
        if (state.isSuccess) {
          Navigator.of(ctx).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: ColorManager.white,
                  ),
                  SizedBox(width: 8.w),
                  const Text('تم تسجيل سداد القسط بنجاح'),
                ],
              ),
              backgroundColor: ColorManager.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
          widget.onSuccess();
        }
      },
      builder: (ctx, state) {
        final isLoading = state.flowState is LoadingState;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            padding: EdgeInsets.fromLTRB(
              20.w,
              0,
              20.w,
              MediaQuery.of(context).viewInsets.bottom + 24.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Drag Handle ──
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 12.h, bottom: 18.h),
                    width: 44.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: ColorManager.border,
                      borderRadius: BorderRadius.circular(AppRadius.r999.r),
                    ),
                  ),
                ),

                // ── Header Icon ──
                Center(
                  child: Container(
                    width: 62.r,
                    height: 62.r,
                    decoration: BoxDecoration(
                      color: ColorManager.lightPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorManager.primary.withAlpha(45),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        size: 32.r,
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                // ── Title ──
                Text(
                  'تأكيد سداد القسط',
                  textAlign: TextAlign.center,
                  style: getExtraBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s20,
                  ),
                ),

                SizedBox(height: 6.h),

                Text(
                  'يرجى مراجعة تفاصيل القسط قبل تأكيد عملية السداد',
                  textAlign: TextAlign.center,
                  style: getMediumStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s13,
                    height: 1.4,
                  ),
                ),

                SizedBox(height: 10.h),

                // ── Details Card ──
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.background,
                    borderRadius: BorderRadius.circular(AppRadius.r16.r),
                    border: Border.all(color: ColorManager.border, width: 1),
                  ),
                  child: Column(
                    children: [
                      // الطرف (العميل / المورد)
                      _buildDetailRow(
                        label: _getPartyLabel(),
                        value: widget.contactName,
                        valueColor: ColorManager.primary,
                      ),

                      _buildDivider(),

                      // رقم الدفعة
                      _buildDetailRow(
                        label: 'رقم الدفعة',
                        valueWidget: Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8.w,
                          runSpacing: 4.h,
                          children: [
                            // حالة الاستحقاق
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: _overdueContainerColor(),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r100.r,
                                ),
                              ),
                              child: Text(
                                _overdueLabel(),
                                style: getBoldStyle(
                                  color: _overdueColor(),
                                  fontSize: FontSize.s10,
                                ),
                              ),
                            ),
                            Text(
                              widget.totalInstallments != null &&
                                      widget.totalInstallments! > 0
                                  ? 'قسط ${widget.installment.installmentNumber ?? 1} من ${widget.totalInstallments}'
                                  : 'قسط ${widget.installment.installmentNumber ?? 1}',
                              style: getSemiBoldStyle(
                                color: ColorManager.textPrimary,
                                fontSize: FontSize.s13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      _buildDivider(),

                      // مبلغ القسط
                      _buildDetailRow(
                        label: 'مبلغ القسط المستحق',
                        value:
                            '${_formatAmount(widget.installment.amount)} ج.م',
                        valueStyle: getBoldStyle(
                          color: ColorManager.primary,
                          fontSize: FontSize.s16,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 14.h),

                // ── تاريخ ووقت السداد الفعلي (تلقائي) ──
                Text(
                  'تاريخ السداد الفعلي',
                  style: getSemiBoldStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s13,
                  ),
                ),

                SizedBox(height: 8.h),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 13.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.background,
                    borderRadius: BorderRadius.circular(AppRadius.r14.r),
                    border: Border.all(color: ColorManager.border, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 18.r,
                        color: ColorManager.primary,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          _formatDateTime(DateTime.now()),
                          style: getSemiBoldStyle(
                            color: ColorManager.textPrimary,
                            fontSize: FontSize.s13,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.lightPrimary,
                          borderRadius: BorderRadius.circular(AppRadius.r8.r),
                        ),
                        child: Text(
                          'تلقائياً الآن',
                          style: getBoldStyle(
                            color: ColorManager.primary,
                            fontSize: FontSize.s10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),

                // ── CTA — تأكيد السداد ──
                SizedBox(
                  height: 68.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: isLoading ? null : ColorManager.primaryGradient,
                      color: isLoading ? ColorManager.surfaceVariant : null,
                      borderRadius: BorderRadius.circular(AppRadius.r14.r),
                      boxShadow: isLoading
                          ? null
                          : const [AppShadows.fabShadow],
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => _handleConfirmPayment(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r14.r),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 22.r,
                              height: 22.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: ColorManager.white,
                              ),
                            )
                          : Text(
                              'تأكيد السداد',
                              style: getBoldStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s16,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // ── إلغاء ──
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(
                    'إلغاء والعودة للدفتر',
                    style: getMediumStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Helper Widgets
  // ─────────────────────────────────────────────────────────────

  Widget _buildDetailRow({
    required String label,
    String? value,
    Widget? valueWidget,
    Color? valueColor,
    TextStyle? valueStyle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: getSemiBoldStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s12,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 7,
            child: Align(
              alignment: Alignment.centerLeft,
              child:
                  valueWidget ??
                  Text(
                    value ?? '—',
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        valueStyle ??
                        getSemiBoldStyle(
                          color: valueColor ?? ColorManager.textPrimary,
                          fontSize: FontSize.s13,
                        ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: ColorManager.border.withAlpha(150));
  }
}
