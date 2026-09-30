// ─────────────────────────────────────────────────────────────
// InstallmentPlanCard — Plan Card with Progress & Sub-Installments
// Mizan Design System — Figma Node #3:300 compliant
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/domain/model/installments_dashboard_model.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/presentation/installments/installments_dashboard/installments_dashboard_cubit.dart';
import 'package:mizan/presentation/installments/widgets/installment_status_style.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/transactions/pay_installment/pay_installment_sheet.dart';

class InstallmentPlanCard extends StatelessWidget {
  final InstallmentPlanModel plan;
  final VoidCallback? onCall;

  const InstallmentPlanCard({super.key, required this.plan, this.onCall});

  void _onCardTap(BuildContext context) {
    if (plan.transactionId.isNotEmpty) {
      Navigator.pushNamed(
        context,
        Routes.transactionDetailsRoute,
        arguments: plan.transactionId,
      ).then((_) {
        if (context.mounted) {
          context.read<InstallmentsDashboardCubit>().getInstallmentsDashboard();
        }
      });
    }
  }

  void _onPayFirstUnpaid(BuildContext context) {
    final unpaidIndex = plan.installments.indexWhere((inst) => !inst.isPaid);
    if (unpaidIndex == -1) return;

    final unpaid = plan.installments[unpaidIndex];
    showPayInstallmentSheet(
      context: context,
      installment: InstallmentbyidModel(
        id: unpaid.installmentId,
        installmentNumber: unpaidIndex + 1,
        amount: unpaid.amount,
        dueDate: unpaid.dueDate,
        isPaid: unpaid.isPaid,
        status: unpaid.status,
        paidAt: unpaid.paidAt,
      ),
      contactName: plan.contactName,
      totalInstallments: plan.totalInstallmentsCount,
      onSuccess: () {
        if (context.mounted) {
          context.read<InstallmentsDashboardCubit>().getInstallmentsDashboard();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusStyle = InstallmentStatusHelper.getPlanStatusStyle(
      isOverdue: plan.isOverdue,
      isDueToday: plan.isDueToday,
      status: plan.status,
    );

    final hasUnpaid = plan.installments.any((inst) => !inst.isPaid);

    return Container(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r18.r),
        border: Border.all(
          color: plan.isOverdue
              ? ColorManager.error.withAlpha(120)
              : ColorManager.border,
          width: plan.isOverdue ? 1.5 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1C1816),
            blurRadius: 12.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onCardTap(context),
          borderRadius: BorderRadius.circular(AppRadius.r18.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 1. Header: Avatar + Contact Info + Status Badge ──
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                child: Row(
                  children: [
                    // Initials Avatar
                    Container(
                      width: 42.r,
                      height: 42.r,
                      decoration: BoxDecoration(
                        color: ColorManager.lightPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorManager.primary.withAlpha(40),
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          InstallmentFormatters.getInitials(plan.contactName),
                          style: getBoldStyle(
                            color: ColorManager.primary,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Contact Name & Phone
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            plan.contactName,
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (plan.phoneNumber.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(
                              plan.phoneNumber,
                              style: getRegularStyle(
                                color: ColorManager.textSecondary,
                                fontSize: FontSize.s12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Status Badge Chip
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusStyle.backgroundColor,
                        borderRadius: BorderRadius.circular(AppRadius.r999.r),
                        border: Border.all(
                          color: statusStyle.borderColor,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        statusStyle.label,
                        style: getBoldStyle(
                          color: statusStyle.textColor,
                          fontSize: FontSize.s11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Divider ──
              Divider(color: ColorManager.border, height: 1.h),

              // ── 2. Amounts Summary & Progress Bar ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    // 3 Financial metrics
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadius.r12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _PlanAmountMetric(
                            label: AppStrings.totalLabel,
                            amount: plan.totalAmount,
                            color: ColorManager.textPrimary,
                          ),
                          Container(
                            width: 1.w,
                            height: 26.h,
                            color: ColorManager.border,
                          ),
                          _PlanAmountMetric(
                            label: AppStrings.paidLabel,
                            amount: plan.paidAmount.round(),
                            color: ColorManager.success,
                          ),
                          Container(
                            width: 1.w,
                            height: 26.h,
                            color: ColorManager.border,
                          ),
                          _PlanAmountMetric(
                            label: AppStrings.remainingLabel,
                            amount: plan.remainingAmount,
                            color: ColorManager.primary,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),
                    // Progress Label & Track
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${plan.paidInstallmentsCount} ${AppStrings.ofPayments} ${plan.totalInstallmentsCount} ${AppStrings.paymentsCountSuffix}',
                          style: getMediumStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s11,
                          ),
                        ),
                        Text(
                          '${(plan.progress * 100).toInt()}%',
                          style: getBoldStyle(
                            color: ColorManager.primary,
                            fontSize: FontSize.s12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    // Custom Lightweight Progress Bar
                    Container(
                      width: double.infinity,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: ColorManager.border,
                        borderRadius: BorderRadius.circular(AppRadius.r999.r),
                      ),
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: plan.progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: ColorManager.primaryGradient,
                            borderRadius: BorderRadius.circular(
                              AppRadius.r999.r,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── 3. Next Due Date Section (if exists) ──
              if (plan.nextDueDate.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: plan.isOverdue
                          ? ColorManager.errorContainer
                          : plan.isDueToday
                          ? ColorManager.lightSecondary
                          : ColorManager.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.r10.r),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          IconAssets.calendar,
                          width: 14.r,
                          height: 14.r,
                          colorFilter: ColorFilter.mode(
                            plan.isOverdue
                                ? ColorManager.error
                                : plan.isDueToday
                                ? ColorManager.secondary
                                : ColorManager.textSecondary,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${AppStrings.nextInstallmentDueDate}: ',
                          style: getRegularStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s11,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            plan.isOverdue
                                ? '${InstallmentFormatters.formatArabicDate(plan.nextDueDate)} (${AppStrings.overdueStatus})'
                                : plan.isDueToday
                                ? '${InstallmentFormatters.formatArabicDate(plan.nextDueDate)} (${AppStrings.dueTodayStatus})'
                                : InstallmentFormatters.formatArabicDate(
                                    plan.nextDueDate,
                                  ),
                            style: getBoldStyle(
                              color: plan.isOverdue
                                  ? ColorManager.error
                                  : plan.isDueToday
                                  ? ColorManager.secondary
                                  : ColorManager.textPrimary,
                              fontSize: FontSize.s11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
              ],

              // ── 4. Nested Installments List ──
              if (plan.installments.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.installmentsSchedule,
                        style: getBoldStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s12,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        decoration: BoxDecoration(
                          color: ColorManager.surfaceVariant.withAlpha(120),
                          borderRadius: BorderRadius.circular(AppRadius.r12.r),
                          border: Border.all(
                            color: ColorManager.border,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: List.generate(plan.installments.length, (
                            index,
                          ) {
                            final inst = plan.installments[index];
                            final isLast =
                                index == plan.installments.length - 1;
                            return Column(
                              children: [
                                _InstallmentRow(
                                  ordinal: InstallmentFormatters.getOrdinal(
                                    index,
                                  ),
                                  installment: inst,
                                ),
                                if (!isLast)
                                  Divider(
                                    color: ColorManager.border,
                                    height: 1.h,
                                    indent: 12.w,
                                    endIndent: 12.w,
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
              ],

              // ── 5. Action Buttons ──
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                child: Row(
                  children: [
                    // Record Payment Button
                    if (hasUnpaid) ...[
                      Expanded(
                        child: SizedBox(
                          height: 42.h,
                          child: ElevatedButton.icon(
                            onPressed: () => _onPayFirstUnpaid(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r12.r,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                            ),
                            icon: SvgPicture.asset(
                              IconAssets.checkCircle,
                              width: 16.r,
                              height: 16.r,
                              colorFilter: const ColorFilter.mode(
                                ColorManager.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            label: Text(
                              AppStrings.recordPayment,
                              style: getBoldStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                    ],
                    // Call Button (No-op with TODO)
                    SizedBox(
                      height: 42.h,
                      child: OutlinedButton.icon(
                        onPressed:
                            onCall ??
                            () {
                              // TODO: url_launcher is not installed. When added, invoke launchUrlString('tel:${plan.phoneNumber}')
                            },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: ColorManager.borderDark,
                            width: 1.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppRadius.r12.r,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                        ),
                        icon: SvgPicture.asset(
                          IconAssets.phone,
                          width: 16.r,
                          height: 16.r,
                          colorFilter: const ColorFilter.mode(
                            ColorManager.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        label: Text(
                          AppStrings.phoneCallAction,
                          style: getSemiBoldStyle(
                            color: ColorManager.textPrimary,
                            fontSize: FontSize.s13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanAmountMetric extends StatelessWidget {
  final String label;
  final num amount;
  final Color color;

  const _PlanAmountMetric({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: getRegularStyle(
            color: ColorManager.textSecondary,
            fontSize: FontSize.s10,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          '${InstallmentFormatters.formatAmount(amount)} ${AppStrings.egp}',
          style: getBoldStyle(color: color, fontSize: FontSize.s12),
        ),
      ],
    );
  }
}

class _InstallmentRow extends StatelessWidget {
  final String ordinal;
  final DashboardInstallmentModel installment;

  const _InstallmentRow({required this.ordinal, required this.installment});

  @override
  Widget build(BuildContext context) {
    final itemStyle = InstallmentStatusHelper.getDashboardInstallmentStyle(
      isPaid: installment.isPaid,
      daysOverdue: installment.daysOverdue,
      status: installment.status,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          // Ordinal & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ordinal,
                  style: getSemiBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s12,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  InstallmentFormatters.formatShortDate(installment.dueDate),
                  style: getRegularStyle(
                    color: ColorManager.textTertiary,
                    fontSize: FontSize.s10,
                  ),
                ),
              ],
            ),
          ),
          // Amount (+ / -)
          Text(
            installment.isPaid
                ? '+${InstallmentFormatters.formatAmount(installment.amount)} ${AppStrings.egp}'
                : '-${InstallmentFormatters.formatAmount(installment.amount)} ${AppStrings.egp}',
            style: getBoldStyle(
              color: installment.isPaid
                  ? ColorManager.success
                  : ColorManager.textPrimary,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(width: 10.w),
          // Status Chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: itemStyle.backgroundColor,
              borderRadius: BorderRadius.circular(AppRadius.r999.r),
            ),
            child: Text(
              itemStyle.label,
              style: getBoldStyle(
                color: itemStyle.textColor,
                fontSize: FontSize.s9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
