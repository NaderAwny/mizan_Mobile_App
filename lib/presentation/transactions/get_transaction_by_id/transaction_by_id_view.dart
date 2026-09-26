// ─────────────────────────────────────────────────────────────
// TransactionDetailsView
// Responsive Production Layout & Figma Mizan Design System Compliant
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/transactions/get_transaction_by_id/get_transaction_by_id_cubit.dart';
import 'package:mizan/presentation/transactions/get_transaction_by_id/get_transaction_by_id_state.dart';
import 'package:mizan/presentation/transactions/pay_installment/pay_installment_sheet.dart';

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
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Amount Card
                _buildAmountCard(data),

                SizedBox(height: 12.h),

                // Details Table
                _buildDetailsTable(data),

                // Installments Tracking Section
                if (data.isInstallment == true ||
                    (data.installments != null &&
                        data.installments!.isNotEmpty)) ...[
                  SizedBox(height: 14.h),
                  _buildInstallmentTrackingSection(context, data),
                ],

                // Notes & Voice Note
                if ((data.noteText != null &&
                        data.noteText!.trim().isNotEmpty) ||
                    data.hasVoiceNote == true) ...[
                  SizedBox(height: 14.h),
                  _buildNotesCard(data),
                ],

                SizedBox(height: 16.h),

                // Delete Action
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
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
      child: SizedBox(
        height: 56.h,
        child: Row(
          children: [
            // Back Button
            SizedBox(
              width: 42.w,
              height: 42.w,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(21.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorManager.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorManager.border, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18.r,
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
                  fontSize: FontSize.s20.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r20.r),
        border: Border.all(color: ColorManager.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Amount & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getAmountSubtitle(data),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s12.sp,
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: _getBadgeBackgroundColor(data.type),
              borderRadius: BorderRadius.circular(AppRadius.r100.r),
            ),
            child: Text(
              _getBadgeText(data.type),
              textAlign: TextAlign.center,
              style: getBoldStyle(
                color: _getBadgeTextColor(data.type),
                fontSize: FontSize.s12.sp,
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
    final partyLabel = _getPartyLabel(data.type);
    final partyValue = data.contactName?.isNotEmpty == true
        ? data.contactName!
        : (data.partyName?.isNotEmpty == true ? data.partyName! : "—");

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r20.r),
        border: Border.all(color: ColorManager.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMetaRow(
            label: partyLabel,
            value: partyValue,
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
                ? "${_getInstallmentPlanModeLabel(data.installmentPlanMode)} (${data.installments?.length ?? 0} أقساط)"
                : AppStrings.txDetailsFullPayment,
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Meta Row
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
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ColorManager.border.withAlpha(150),
                  width: 1,
                ),
              ),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

  Widget _buildInstallmentTrackingSection(
    BuildContext context,
    TransactionbyidModel data,
  ) {
    final totalPaid = data.totalPaid ?? 0;
    final totalAmount = data.amount ?? 0;
    final totalRemaining =
        data.totalRemaining ?? (totalAmount - totalPaid);
    final double progressRatio = totalAmount > 0
        ? (totalPaid / totalAmount).clamp(0.0, 1.0)
        : 0.0;
    final installments = data.installments ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r20.r),
        border: Border.all(color: ColorManager.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Title
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
                width: 32.r,
                height: 32.r,
                decoration: const BoxDecoration(
                  color: ColorManager.lightPrimary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 18.r,
                  color: ColorManager.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Summary & Progress Bar
          _buildInstallmentsSummary(
            totalPaid: totalPaid,
            totalRemaining: totalRemaining,
            progressRatio: progressRatio,
          ),

          SizedBox(height: 14.h),

          // List of Installment Cards
          if (installments.isEmpty)
            _buildEmptyInstallments()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: installments.length,
              separatorBuilder: (_, _) => SizedBox(height: 10.h),
              itemBuilder: (ctx, index) {
                return _buildInstallmentItem(
                  context,
                  installments[index],
                  index,
                  data,
                );
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
    final percent = (progressRatio * 100).toInt();

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorManager.background,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryValue(
                  label: AppStrings.txDetailsRemaining,
                  value: totalRemaining,
                  valueColor: ColorManager.error,
                  alignment: CrossAxisAlignment.start,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: ColorManager.lightPrimary,
                  borderRadius: BorderRadius.circular(AppRadius.r100.r),
                ),
                child: Text(
                  '$percent%',
                  style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s11.sp,
                  ),
                ),
              ),
              Expanded(
                child: _buildSummaryValue(
                  label: AppStrings.txDetailsPaid,
                  value: totalPaid,
                  valueColor: ColorManager.success,
                  alignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: progressRatio,
              minHeight: 7.h,
              backgroundColor: ColorManager.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                ColorManager.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryValue({
    required String label,
    required num value,
    Color? valueColor,
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
            color: ColorManager.textSecondary,
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
            color: valueColor ?? ColorManager.textPrimary,
            fontSize: FontSize.s13.sp,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Installment Item
  // ─────────────────────────────────────────────────────────────

  Widget _buildInstallmentItem(
    BuildContext context,
    InstallmentbyidModel inst,
    int index,
    TransactionbyidModel txData,
  ) {
    final installmentNumber = inst.installmentNumber ?? (index + 1);
    final statusStr = inst.status?.toLowerCase() ?? '';
    final isPaid =
        inst.isPaid == true || statusStr == 'paid' || statusStr == 'مدفوع';

    final partyName = txData.contactName?.isNotEmpty == true
        ? txData.contactName!
        : (txData.partyName?.isNotEmpty == true ? txData.partyName! : '—');

    return GestureDetector(
      onTap: isPaid
          ? null
          : () => showPayInstallmentSheet(
                context: context,
                installment: inst,
                contactName: partyName,
                transactionType: txData.type,
                totalInstallments: txData.installments?.length,
                onSuccess: () {
                  // Reload transaction to update full UI
                  context
                      .read<GetTransactionByIdCubit>()
                      .getTransactionById(transactionId);
                },
              ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isPaid
              ? ColorManager.background
              : ColorManager.surface,
          borderRadius: BorderRadius.circular(AppRadius.r16.r),
          border: Border.all(
            color: isPaid
                ? ColorManager.border
                : ColorManager.primary.withAlpha(60),
            width: isPaid ? 1 : 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // First Row: Header + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'قسط $installmentNumber',
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
                if (!isPaid) ...[
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 13.r,
                    color: ColorManager.primary,
                  ),
                ],
              ],
            ),

            SizedBox(height: 10.h),

            // Divider
            Container(
              height: 1,
              color: ColorManager.border.withAlpha(120),
            ),

            SizedBox(height: 10.h),

            // Details Row: Due Date & Amount
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInstallmentInfo(
                    icon: Icons.calendar_today_outlined,
                    label: 'تاريخ الاستحقاق',
                    value: _formatDate(inst.dueDate),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildInstallmentInfo(
                    icon: Icons.payments_outlined,
                    label: 'قيمة القسط',
                    value:
                        '${_formatAmount(inst.amount)} ${AppStrings.egp}',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),

            // Paid Date if paid
            if (isPaid && inst.paidAt != null && inst.paidAt!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ColorManager.successContainer,
                  borderRadius: BorderRadius.circular(AppRadius.r8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 14.r,
                      color: ColorManager.success,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        'تم السداد في: ${_formatDateTime(inst.paidAt)}',
                        style: getSemiBoldStyle(
                          color: ColorManager.success,
                          fontSize: FontSize.s11.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Action hint for unpaid
            if (!isPaid) ...[
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.lightPrimary,
                  borderRadius: BorderRadius.circular(AppRadius.r8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app_outlined,
                      size: 14.r,
                      color: ColorManager.primary,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'اضغط لتسجيل السداد',
                      style: getBoldStyle(
                        color: ColorManager.primary,
                        fontSize: FontSize.s11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Installment Info Column
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
            Icon(icon, size: 14.r, color: ColorManager.textSecondary),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getMediumStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s11.sp,
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
  // Installment Status Badge
  // ─────────────────────────────────────────────────────────────

  Widget _buildInstallmentStatusBadge(InstallmentbyidModel inst) {
    final statusStr = inst.status?.toLowerCase() ?? "";
    final isPaid =
        inst.isPaid == true || statusStr == "paid" || statusStr == "مدفوع";

    bool isOverdue = statusStr == "overdue" || statusStr == "متأخر";

    if (!isPaid && !isOverdue && inst.dueDate != null && inst.dueDate!.isNotEmpty) {
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
      bgColor = ColorManager.lightPrimary;
      textColor = ColorManager.primary;
      label = AppStrings.txDetailsUpcoming;
    }

    return Container(
      constraints: BoxConstraints(minWidth: 52.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.r100.r),
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

  Widget _buildEmptyInstallments() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      alignment: Alignment.center,
      child: Text(
        "لا توجد أقساط مسجلة",
        style: getMediumStyle(
          color: ColorManager.textSecondary,
          fontSize: FontSize.s12.sp,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Notes Card
  // ─────────────────────────────────────────────────────────────

  Widget _buildNotesCard(TransactionbyidModel data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r20.r),
        border: Border.all(color: ColorManager.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                size: 18.r,
                color: ColorManager.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                AppStrings.txDetailsNotes,
                textAlign: TextAlign.right,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s14.sp,
                ),
              ),
            ],
          ),

          if (data.noteText != null && data.noteText!.trim().isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              data.noteText!,
              textAlign: TextAlign.right,
              style: getMediumStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s13.sp,
                height: 1.4,
              ),
            ),
          ],

          if (data.hasVoiceNote == true) ...[
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: ColorManager.lightPrimary,
                borderRadius: BorderRadius.circular(AppRadius.r10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.mic_rounded,
                    size: 18.r,
                    color: ColorManager.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'ملاحظة صوتية مسجلة',
                    style: getSemiBoldStyle(
                      color: ColorManager.primary,
                      fontSize: FontSize.s12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      height: 48.h,
      child: InkWell(
        onTap: () => _showDeleteConfirmDialog(context, data),
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.errorContainer,
            borderRadius: BorderRadius.circular(AppRadius.r14.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: 18.r,
                color: ColorManager.error,
              ),
              SizedBox(width: 8.w),
              Text(
                AppStrings.txDetailsDelete,
                style: getSemiBoldStyle(
                  color: ColorManager.error,
                  fontSize: FontSize.s14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            borderRadius: BorderRadius.circular(AppRadius.r20.r),
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
    if (type == null) return const Color(0xFFEEF2FF);
    final lower = type.toLowerCase();
    if (lower == "collect" || lower == "تحصيل" || lower == "sale" || lower == "بيع") {
      return ColorManager.successContainer;
    }
    if (lower == "pay" || lower == "دفع" || lower == "purchase" || lower == "شراء") {
      return ColorManager.errorContainer;
    }
    return const Color(0xFFEEF2FF);
  }

  Color _getBadgeTextColor(String? type) {
    if (type == null) return const Color(0xFF4F46E5);
    final lower = type.toLowerCase();
    if (lower == "collect" || lower == "تحصيل" || lower == "sale" || lower == "بيع") {
      return ColorManager.success;
    }
    if (lower == "pay" || lower == "دفع" || lower == "purchase" || lower == "شراء") {
      return ColorManager.error;
    }
    return const Color(0xFF4F46E5);
  }

  String _getBadgeText(String? type) {
    if (type == null || type.isEmpty) return "معاملة";
    final lower = type.toLowerCase();
    if (lower == "sale" || lower == "بيع") return "مبيعات";
    if (lower == "purchase" || lower == "شراء") return "مشتريات";
    if (lower == "collect" || lower == "تحصيل") return "تحصيل";
    if (lower == "pay" || lower == "دفع") return "دفع";
    return type;
  }

  String _getAmountSubtitle(TransactionbyidModel data) {
    final lower = data.type?.toLowerCase() ?? "";
    if (lower == "sale" || lower == "بيع") return "إجمالي قيمة المبيعات";
    if (lower == "purchase" || lower == "شراء") return "إجمالي قيمة المشتريات";
    if (lower == "collect" || lower == "تحصيل") return "المبلغ المحصل";
    if (lower == "pay" || lower == "دفع") return "المبلغ المدفوع";
    return "إجمالي قيمة المعاملة";
  }

  String _getPartyLabel(String? type) {
    final lower = type?.toLowerCase() ?? "";
    if (lower == "purchase" || lower == "شراء") return "اسم المورد";
    return "اسم العميل";
  }

  String _getTransactionTypeLabel(String? type) {
    if (type == null || type.isEmpty) return "—";
    final lower = type.toLowerCase();
    if (lower == "sale") return "بيع";
    if (lower == "purchase") return "شراء";
    if (lower == "collect") return "تحصيل";
    if (lower == "pay") return "دفع";
    return type;
  }

  String _getPaymentMethodLabel(String? method) {
    if (method == null || method.isEmpty) return "—";
    final lower = method.toLowerCase();
    if (lower == "cash") return "نقدي";
    if (lower == "bank") return "تحويل بنكي";
    if (lower == "wallet") return "محفظة إلكترونية";
    if (lower == "card") return "بطاقة بنكية";
    return method;
  }

  String _getInstallmentPlanModeLabel(String? mode) {
    if (mode == null || mode.isEmpty) return "أقساط";
    final lower = mode.toLowerCase();
    if (lower == "automatic") return "تقسيط تلقائي";
    if (lower == "custom") return "تقسيط مخصص";
    return mode;
  }

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

  DateTime _parseToLocal(String raw) {
    final trimmed = raw.trim();
    try {
      if (trimmed.endsWith('Z')) {
        return DateTime.parse(trimmed).toLocal();
      }
      if (trimmed.contains('+') ||
          (trimmed.length > 19 && trimmed.substring(19).contains('-'))) {
        return DateTime.parse(trimmed).toLocal();
      }
      return DateTime.parse('${trimmed}Z').toLocal();
    } catch (_) {
      try {
        return DateTime.parse(trimmed).toLocal();
      } catch (_) {
        return DateTime.now();
      }
    }
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return "—";
    try {
      final dt = DateTime.parse(raw);
      final month = _arabicMonths[(dt.month - 1).clamp(0, 11)];
      return '${dt.day} $month ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  String _formatDateTime(String? raw) {
    if (raw == null || raw.isEmpty) return "—";
    try {
      final dt = _parseToLocal(raw);
      final month = _arabicMonths[(dt.month - 1).clamp(0, 11)];
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'م' : 'ص';
      return '${dt.day} $month ${dt.year} - $hour:$minute $period';
    } catch (_) {
      return raw;
    }
  }
}
