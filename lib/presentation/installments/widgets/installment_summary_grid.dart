// ─────────────────────────────────────────────────────────────
// InstallmentSummaryGrid — 2x2 Performance-Optimized Grid
// Mizan Design System — Figma Node #3:300 compliant
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/domain/model/installments_dashboard_model.dart';
import 'package:mizan/presentation/installments/widgets/installment_status_style.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class InstallmentSummaryGrid extends StatelessWidget {
  final InstallmentsDashboardModel data;

  const InstallmentSummaryGrid({
    super.key,
    required this.data,
  });

  String _getUpcomingSubtitle() {
    // Find earliest nextDueDate among plans that are not overdue and not due today
    final upcomingPlans = data.plans
        .where((p) => !p.isOverdue && !p.isDueToday && p.nextDueDate.isNotEmpty)
        .toList();

    if (upcomingPlans.isNotEmpty) {
      final earliest = upcomingPlans.first.nextDueDate;
      return '${AppStrings.earliestDueDatePrefix} ${InstallmentFormatters.formatArabicDate(earliest)}';
    }
    return AppStrings.upcomingInstallmentsPeriod;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // 1. Overdue Card (متأخر)
            Expanded(
              child: _SummaryCard(
                title: AppStrings.overdueStatus,
                amount: data.totalOverdueAmount,
                subtitle: AppStrings.mustPayToday,
                iconPath: IconAssets.alertTriangle,
                accentColor: ColorManager.error,
                containerColor: ColorManager.errorContainer,
              ),
            ),
            SizedBox(width: 12.w),
            // 2. Due Today Card (مستحق اليوم)
            Expanded(
              child: _SummaryCard(
                title: AppStrings.dueTodayStatus,
                amount: data.totalDueTodayAmount,
                subtitle: AppStrings.mustPayBeforeEndOfDay,
                iconPath: IconAssets.alarmClock,
                accentColor: ColorManager.secondary,
                containerColor: ColorManager.lightSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            // 3. Upcoming Card (قادم)
            Expanded(
              child: _SummaryCard(
                title: AppStrings.upcomingStatus,
                amount: data.totalUpcomingAmount,
                subtitle: _getUpcomingSubtitle(),
                iconPath: IconAssets.calendarSync,
                accentColor: ColorManager.primary,
                containerColor: ColorManager.lightPrimary,
              ),
            ),
            SizedBox(width: 12.w),
            // 4. Paid Card (تم تحصيله)
            Expanded(
              child: _SummaryCard(
                title: AppStrings.paidStatus,
                amount: data.totalPaidAmount,
                subtitle: AppStrings.duringCurrentMonth,
                iconPath: IconAssets.checkCheck,
                accentColor: ColorManager.success,
                containerColor: ColorManager.successContainer,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final num amount;
  final String subtitle;
  final String iconPath;
  final Color accentColor;
  final Color containerColor;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.iconPath,
    required this.accentColor,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p14.r),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(
          color: ColorManager.border,
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x081C1816),
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon badge & Title
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(AppRadius.r8.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    width: 16.r,
                    height: 16.r,
                    colorFilter: ColorFilter.mode(
                      accentColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: getBoldStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  InstallmentFormatters.formatAmount(amount),
                  style: getExtraBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                AppStrings.egp,
                style: getRegularStyle(
                  color: ColorManager.textTertiary,
                  fontSize: FontSize.s10,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // Subtitle / context info
          Text(
            subtitle,
            style: getRegularStyle(
              color: ColorManager.textTertiary,
              fontSize: FontSize.s10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
