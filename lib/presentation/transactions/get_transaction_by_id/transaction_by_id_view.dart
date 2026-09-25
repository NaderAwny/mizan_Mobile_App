// ─────────────────────────────────────────────────────────────
// TransactionDetailsView
// Responsive Production Layout
// Mizan Design System
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';

import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

import 'package:mizan/presentation/transactions/get_transaction_by_id/get_transaction_by_id_cubit.dart';
import 'package:mizan/presentation/transactions/get_transaction_by_id/get_transaction_by_id_state.dart';

class TransactionDetailsView extends StatelessWidget {
  final String transactionId;

  const TransactionDetailsView({
    super.key,
    required this.transactionId,
    required String id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetTransactionByIdCubit>(
      create: (_) =>
          getIt<GetTransactionByIdCubit>()..getTransactionById(transactionId),
      child: _TransactionDetailsScreen(transactionId: transactionId),
    );
  }
}

class _TransactionDetailsScreen extends StatelessWidget {
  final String transactionId;

  const _TransactionDetailsScreen({required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        body: SafeArea(
          child: BlocBuilder<GetTransactionByIdCubit, GetTransactionByIdState>(
            builder: (context, state) {
              return state.flowState?.getScreenWidget(
                    context,
                    _buildContent(context, state.data),
                    () => context
                        .read<GetTransactionByIdCubit>()
                        .getTransactionById(transactionId),
                  ) ??
                  _buildContent(context, state.data);
            },
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Main Content
  // ─────────────────────────────────────────────────────────────

  Widget _buildContent(BuildContext context, TransactionbyidModel? data) {
    if (data == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        _buildHeader(context, data),

        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Amount
                _buildAmountCard(data),

                SizedBox(height: 12.h),

                // Transaction details
                _buildDetailsTable(data),

                // Installments
                if (data.isInstallment == true ||
                    (data.installments != null &&
                        data.installments!.isNotEmpty)) ...[
                  SizedBox(height: 12.h),
                  _buildInstallmentTrackingSection(data),
                ],

                // Notes
                if (data.noteText != null &&
                    data.noteText!.trim().isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _buildNotesCard(data.noteText!),
                ],

                SizedBox(height: 14.h),

                // Delete
                _buildActionsRow(context, data),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Header
  // ─────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, TransactionbyidModel data) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 6.h),
      child: SizedBox(
        height: 64.h,
        child: Row(
          children: [
            // Back Button
            SizedBox(
              width: 44.w,
              height: 44.w,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(22.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorManager.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorManager.border, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: IconAssets.arrowLeft.svg(
                    width: 20.w,
                    height: 20.h,
                    color: ColorManager.textPrimary,
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Title
            Expanded(
              child: Text(
                AppStrings.txDetailsTitle,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getExtraBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s22.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Amount Card
  // ─────────────────────────────────────────────────────────────

  Widget _buildAmountCard(TransactionbyidModel data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorManager.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Amount
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getAmountSubtitle(data),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    color: ColorManager.textTertiary,
                    fontSize: FontSize.s11.sp,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  "${_formatAmount(data.amount)} ${AppStrings.egp}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getExtraBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s24.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Type badge
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: _getBadgeBackgroundColor(data.type),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                _getBadgeText(data.type),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  color: _getBadgeTextColor(data.type),
                  fontSize: FontSize.s12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Details Table
  // ─────────────────────────────────────────────────────────────

  Widget _buildDetailsTable(TransactionbyidModel data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorManager.border, width: 1),
      ),
      child: Column(
        children: [
          _buildMetaRow(
            label: AppStrings.txDetailsContactLabel,
            value: data.contactName ?? data.partyName ?? "—",
            valueColor: ColorManager.primary,
          ),

          _buildMetaRow(
            label: AppStrings.txDetailsTypeLabel,
            value: _getTransactionTypeLabel(data.type),
          ),

          _buildMetaRow(
            label: AppStrings.txDetailsDateLabel,
            value: _formatDateTime(data.transactionDate ?? data.createdAt),
          ),

          _buildMetaRow(
            label: AppStrings.txDetailsPaymentMethodLabel,
            value: _getPaymentMethodLabel(data.paymentMethod),
          ),

          _buildMetaRow(
            label: AppStrings.txDetailsPaymentPlan,
            value: data.isInstallment == true
                ? "${_getInstallmentPlanModeLabel(data.installmentPlanMode)} - "
                      "${data.installments?.length ?? 0} أشهر"
                : AppStrings.txDetailsFullPayment,
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Responsive Meta Row
  // ─────────────────────────────────────────────────────────────

  Widget _buildMetaRow({
    required String label,
    required String value,
    Color valueColor = ColorManager.textPrimary,
    bool isLast = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: isLast
          ? null
          : const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ColorManager.border, width: 1),
              ),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Expanded(
            flex: 4,
            child: Text(
              label,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s13.sp,
              ),
            ),
          ),

          SizedBox(width: 14.w),

          // Value
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.left,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                color: valueColor,
                fontSize: FontSize.s13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Installments Section
  // ─────────────────────────────────────────────────────────────

  Widget _buildInstallmentTrackingSection(TransactionbyidModel data) {
    final totalPaid = data.totalPaid ?? 0;

    final totalAmount = data.amount ?? 0;

    final totalRemaining = data.totalRemaining ?? (totalAmount - totalPaid);

    final double progressRatio = totalAmount > 0
        ? (totalPaid / totalAmount).clamp(0.0, 1.0)
        : 0.0;

    final installments = data.installments ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorManager.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.txDetailsInstallmentsTitle,
                  textAlign: TextAlign.right,
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s16.sp,
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: ColorManager.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: IconAssets.receiptText.svg(
                  width: 15.w,
                  height: 15.h,
                  color: ColorManager.textSecondary,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Summary
          _buildInstallmentsSummary(
            totalPaid: totalPaid,
            totalRemaining: totalRemaining,
            progressRatio: progressRatio,
          ),

          SizedBox(height: 12.h),

          // List
          if (installments.isEmpty)
            _buildEmptyInstallments()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: installments.length,
              separatorBuilder: (_, __) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                return _buildInstallmentItem(installments[index], index);
              },
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Installments Summary
  // ─────────────────────────────────────────────────────────────

  Widget _buildInstallmentsSummary({
    required num totalPaid,
    required num totalRemaining,
    required double progressRatio,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryValue(
                label: AppStrings.txDetailsRemaining,
                value: totalRemaining,
                alignment: CrossAxisAlignment.start,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: _buildSummaryValue(
                label: AppStrings.txDetailsPaid,
                value: totalPaid,
                alignment: CrossAxisAlignment.end,
              ),
            ),
          ],
        ),

        SizedBox(height: 9.h),

        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: LinearProgressIndicator(
            value: progressRatio,
            minHeight: 6.h,
            backgroundColor: ColorManager.surfaceVariant,
            color: ColorManager.primary,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Summary Value
  // ─────────────────────────────────────────────────────────────

  Widget _buildSummaryValue({
    required String label,
    required num value,
    required CrossAxisAlignment alignment,
  }) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getMediumStyle(
            color: ColorManager.textTertiary,
            fontSize: FontSize.s11.sp,
          ),
        ),

        SizedBox(height: 2.h),

        Text(
          "${_formatAmount(value)} ${AppStrings.egp}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignment == CrossAxisAlignment.end
              ? TextAlign.right
              : TextAlign.left,
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s13.sp,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Installment Item
  // ─────────────────────────────────────────────────────────────

  Widget _buildInstallmentItem(InstallmentbyidModel inst, int index) {
    final installmentNumber = inst.installmentNumber ?? (index + 1);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorManager.surfaceVariant,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // First Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "قسط $installmentNumber",
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s14.sp,
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              _buildInstallmentStatusBadge(inst),
            ],
          ),

          SizedBox(height: 10.h),

          // Divider
          Container(height: 1, color: ColorManager.border.withOpacity(0.65)),

          SizedBox(height: 10.h),

          // Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInstallmentInfo(
                  icon: Icons.calendar_today_outlined,
                  label: "تاريخ الاستحقاق",
                  value: _formatDate(inst.dueDate),
                  textAlign: TextAlign.right,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: _buildInstallmentInfo(
                  icon: Icons.payments_outlined,
                  label: "قيمة القسط",
                  value: "${_formatAmount(inst.amount)} ${AppStrings.egp}",
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Installment Information
  // ─────────────────────────────────────────────────────────────

  Widget _buildInstallmentInfo({
    required IconData icon,
    required String label,
    required String value,
    required TextAlign textAlign,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, size: 14.sp, color: ColorManager.textTertiary),

            SizedBox(width: 5.w),

            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getMediumStyle(
                  color: ColorManager.textTertiary,
                  fontSize: FontSize.s10.sp,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        Text(
          value,
          textAlign: textAlign,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s12.sp,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Installment Status
  // ─────────────────────────────────────────────────────────────

  Widget _buildInstallmentStatusBadge(InstallmentbyidModel inst) {
    final statusStr = inst.status?.toLowerCase() ?? "";

    final isPaid =
        inst.isPaid == true || statusStr == "paid" || statusStr == "مدفوع";

    bool isOverdue = statusStr == "overdue" || statusStr == "متأخر";

    if (!isPaid && !isOverdue && inst.dueDate != null) {
      try {
        final due = DateTime.parse(inst.dueDate!);

        if (due.isBefore(DateTime.now())) {
          isOverdue = true;
        }
      } catch (_) {}
    }

    final Color bgColor;
    final Color textColor;
    final String label;

    if (isPaid) {
      bgColor = ColorManager.successContainer;
      textColor = ColorManager.success;
      label = AppStrings.txDetailsStatusPaid;
    } else if (isOverdue) {
      bgColor = ColorManager.errorContainer;
      textColor = ColorManager.error;
      label = AppStrings.txDetailsOverdue;
    } else {
      bgColor = ColorManager.surface;
      textColor = ColorManager.textTertiary;
      label = AppStrings.txDetailsUpcoming;
    }

    return Container(
      constraints: BoxConstraints(minWidth: 48.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: getBoldStyle(color: textColor, fontSize: FontSize.s10.sp),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Empty Installments
  // ─────────────────────────────────────────────────────────────

  Widget _buildEmptyInstallments() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      alignment: Alignment.center,
      child: Text(
        "لا توجد أقساط مسجلة",
        style: getMediumStyle(
          color: ColorManager.textTertiary,
          fontSize: FontSize.s12.sp,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Notes
  // ─────────────────────────────────────────────────────────────

  Widget _buildNotesCard(String notes) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorManager.surfaceVariant,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.txDetailsNotes,
            textAlign: TextAlign.right,
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s14.sp,
            ),
          ),

          SizedBox(height: 7.h),

          Text(
            notes,
            textAlign: TextAlign.right,
            style: getMediumStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s12.sp,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────────────────────

  Widget _buildActionsRow(BuildContext context, TransactionbyidModel data) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: InkWell(
        onTap: () => _showDeleteConfirmDialog(context, data),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.errorContainer,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.txDetailsDelete,
                style: getSemiBoldStyle(
                  color: ColorManager.error,
                  fontSize: FontSize.s14.sp,
                ),
              ),

              SizedBox(width: 8.w),

              IconAssets.trash2.svg(
                width: 17.w,
                height: 17.h,
                color: ColorManager.error,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Delete Dialog
  // ─────────────────────────────────────────────────────────────

  void _showDeleteConfirmDialog(
    BuildContext context,
    TransactionbyidModel data,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: ColorManager.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            AppStrings.delete,
            textAlign: TextAlign.right,
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s16.sp,
            ),
          ),
          content: Text(
            "هل أنت متأكد من رغبتك في حذف هذه المعاملة؟",
            textAlign: TextAlign.right,
            style: getMediumStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppStrings.cancel,
                style: getMediumStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s14.sp,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                // TODO:
                // Perform deletion logic here.
              },
              child: Text(
                AppStrings.delete,
                style: getBoldStyle(
                  color: ColorManager.error,
                  fontSize: FontSize.s14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Badge Helpers
  // ─────────────────────────────────────────────────────────────

  Color _getBadgeBackgroundColor(String? type) {
    if (type == null) {
      return const Color(0xFFEEF2FF);
    }

    final lower = type.toLowerCase();

    if (lower == "collect" || lower == "تحصيل") {
      return ColorManager.successContainer;
    }

    if (lower == "pay" || lower == "دفع") {
      return ColorManager.errorContainer;
    }

    return const Color(0xFFEEF2FF);
  }

  Color _getBadgeTextColor(String? type) {
    if (type == null) {
      return const Color(0xFF4F46E5);
    }

    final lower = type.toLowerCase();

    if (lower == "collect" || lower == "تحصيل") {
      return ColorManager.success;
    }

    if (lower == "pay" || lower == "دفع") {
      return ColorManager.error;
    }

    return const Color(0xFF4F46E5);
  }

  String _getBadgeText(String? type) {
    if (type == null) return "";

    final lower = type.toLowerCase();

    if (lower == "purchase" || lower == "شراء") {
      return AppStrings.txDetailsPurchaseSupplier;
    }

    if (lower == "sale" || lower == "بيع") {
      return AppStrings.txDetailsSaleCustomer;
    }

    if (lower == "collect" || lower == "تحصيل") {
      return AppStrings.quickCollect;
    }

    if (lower == "pay" || lower == "دفع") {
      return AppStrings.quickPay;
    }

    return type;
  }

  // ─────────────────────────────────────────────────────────────
  // Transaction Helpers
  // ─────────────────────────────────────────────────────────────

  String _getAmountSubtitle(TransactionbyidModel data) {
    if (data.isInstallment == true) {
      final typeLower = data.type?.toLowerCase() ?? "";

      if (typeLower == "purchase" || typeLower == "شراء") {
        return AppStrings.txDetailsInstallmentPurchase;
      }

      return AppStrings.txDetailsInstallmentSale;
    }

    return AppStrings.txDetailsCashTransaction;
  }

  String _getTransactionTypeLabel(String? type) {
    if (type == null) return "—";

    final lower = type.toLowerCase();

    if (lower == "purchase" || lower == "شراء") {
      return AppStrings.txDetailsPurchaseType;
    }

    if (lower == "sale" || lower == "بيع") {
      return AppStrings.txDetailsSaleType;
    }

    if (lower == "collect" || lower == "تحصيل") {
      return AppStrings.quickCollect;
    }

    if (lower == "pay" || lower == "دفع") {
      return AppStrings.quickPay;
    }

    return type;
  }

  String _getPaymentMethodLabel(String? method) {
    if (method == null || method.trim().isEmpty) {
      return AppStrings.txDetailsCashPayment;
    }

    final lower = method.toLowerCase();

    if (lower == "cash" || lower == "نقدي" || lower == "كاش") {
      return "نقدي";
    }

    if (lower == "credit" || lower == "آجل") {
      return "آجل";
    }

    if (lower == "bank" || lower == "تحويل بنكي") {
      return "تحويل بنكي";
    }

    return method;
  }

  String _getInstallmentPlanModeLabel(String? mode) {
    if (mode == null || mode.trim().isEmpty) {
      return AppStrings.txDetailsAutomaticInstallment;
    }

    final lower = mode.toLowerCase();

    if (lower == "automatic" || lower == "تلقائي") {
      return AppStrings.txDetailsAutomaticInstallment;
    }

    if (lower == "custom" || lower == "مخصص") {
      return AppStrings.txDetailsCustomInstallment;
    }

    return mode;
  }

  // ─────────────────────────────────────────────────────────────
  // Amount Formatting
  // ─────────────────────────────────────────────────────────────

  String _formatAmount(num? amount) {
    if (amount == null) {
      return "0.00";
    }

    final parts = amount.toStringAsFixed(2).split('.');

    final integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return '$integerPart.${parts[1]}';
  }

  // ─────────────────────────────────────────────────────────────
  // Date + Time
  // ─────────────────────────────────────────────────────────────

  String _formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) {
      return "—";
    }

    try {
      final dateTime = DateTime.parse(dateStr).toLocal();

      const months = [
        "يناير",
        "فبراير",
        "مارس",
        "أبريل",
        "مايو",
        "يونيو",
        "يوليو",
        "أغسطس",
        "سبتمبر",
        "أكتوبر",
        "نوفمبر",
        "ديسمبر",
      ];

      final monthName = months[dateTime.month - 1];

      final hour12 = dateTime.hour == 0
          ? 12
          : dateTime.hour > 12
          ? dateTime.hour - 12
          : dateTime.hour;

      final period = dateTime.hour >= 12 ? "م" : "ص";

      final minuteStr = dateTime.minute.toString().padLeft(2, '0');

      return "${dateTime.day} "
          "$monthName "
          "${dateTime.year}\n"
          "$hour12:$minuteStr $period";
    } catch (_) {
      return dateStr;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Date Only
  // ─────────────────────────────────────────────────────────────

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) {
      return "—";
    }

    try {
      final dateTime = DateTime.parse(dateStr).toLocal();

      const months = [
        "يناير",
        "فبراير",
        "مارس",
        "أبريل",
        "مايو",
        "يونيو",
        "يوليو",
        "أغسطس",
        "سبتمبر",
        "أكتوبر",
        "نوفمبر",
        "ديسمبر",
      ];

      final monthName = months[dateTime.month - 1];

      return "${dateTime.day} "
          "$monthName "
          "${dateTime.year}";
    } catch (_) {
      return dateStr;
    }
  }
}
