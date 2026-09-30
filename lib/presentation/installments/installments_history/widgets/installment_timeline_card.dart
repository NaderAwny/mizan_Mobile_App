// ─────────────────────────────────────────────────────────────
// InstallmentTimelineCard — Timeline Row Item & Card
// Mizan Design System — Responsive & Clickable to Transaction Details
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/domain/model/installments_history_model.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/presentation/installments/installments_history/installments_history_cubit.dart';
import 'package:mizan/presentation/installments/widgets/installment_status_style.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/transactions/pay_installment/pay_installment_sheet.dart';

class InstallmentTimelineCard extends StatelessWidget {
  final InstallmentHistoryItemModel item;
  final bool isFirst;
  final bool isLast;

  const InstallmentTimelineCard({
    super.key,
    required this.item,
    this.isFirst = false,
    this.isLast = false,
  });

  void _onCardTap(BuildContext context) {
    if (item.transactionId.isNotEmpty) {
      Navigator.pushNamed(
        context,
        Routes.transactionDetailsRoute,
        arguments: item.transactionId,
      ).then((_) {
        if (context.mounted) {
          context.read<InstallmentsHistoryCubit>().getInstallmentsHistory();
        }
      });
    }
  }

  void _onPayItem(BuildContext context) {
    showPayInstallmentSheet(
      context: context,
      installment: InstallmentbyidModel(
        id: item.installmentId,
        amount: item.amount,
        dueDate: item.dueDate,
        isPaid: item.isPaid,
        status: item.status,
        paidAt: item.paidAt,
        installmentNumber: null,
      ),
      contactName: item.contactName,
      onSuccess: () {
        if (context.mounted) {
          context.read<InstallmentsHistoryCubit>().getInstallmentsHistory();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusStyle = InstallmentStatusHelper.getHistoryItemStyle(
      isPaid: item.isPaid,
      daysOverdue: item.daysOverdue,
      status: item.status,
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Timeline Vertical Line & Indicator Dot ──
          SizedBox(
            width: 24.w,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Connecting line
                Positioned(
                  top: isFirst ? 18.h : 0,
                  bottom: isLast ? null : 0,
                  height: isLast ? 18.h : null,
                  child: Container(
                    width: 2.w,
                    color: ColorManager.border,
                  ),
                ),

                // Dot
                Positioned(
                  top: 14.h,
                  child: Container(
                    width: 14.r,
                    height: 14.r,
                    decoration: BoxDecoration(
                      color: statusStyle.dotColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorManager.surface,
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: statusStyle.dotColor.withAlpha(50),
                          blurRadius: 4.0,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // ── Responsive Clickable Item Card ──
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: ColorManager.surface,
                borderRadius: BorderRadius.circular(AppRadius.r16.r),
                border: Border.all(
                  color: ColorManager.border,
                  width: 1.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x061C1816),
                    blurRadius: 8.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onCardTap(context),
                  borderRadius: BorderRadius.circular(AppRadius.r16.r),
                  child: Padding(
                    padding: EdgeInsets.all(AppPadding.p14.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── 1. Top Row: Contact Name + Status Badge + Details Arrow ──
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Initials Avatar
                            Container(
                              width: 34.r,
                              height: 34.r,
                              decoration: BoxDecoration(
                                color: ColorManager.lightPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  InstallmentFormatters.getInitials(item.contactName),
                                  style: getBoldStyle(
                                    color: ColorManager.primary,
                                    fontSize: FontSize.s12,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            // Name & Phone
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.contactName,
                                    style: getBoldStyle(
                                      color: ColorManager.textPrimary,
                                      fontSize: FontSize.s14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (item.phoneNumber.isNotEmpty) ...[
                                    SizedBox(height: 1.h),
                                    Text(
                                      item.phoneNumber,
                                      style: getRegularStyle(
                                        color: ColorManager.textTertiary,
                                        fontSize: FontSize.s11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Status Badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
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
                                  fontSize: FontSize.s10,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            // Chevron indicator
                            SvgPicture.asset(
                              IconAssets.chevronLeft,
                              width: 12.r,
                              height: 12.r,
                              colorFilter: const ColorFilter.mode(
                                ColorManager.textTertiary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),
                        Divider(color: ColorManager.border, height: 1.h),
                        SizedBox(height: 10.h),

                        // ── 2. Middle Row: Amount & Date Info ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Amount (Large & Bold)
                            Flexible(
                              flex: 4,
                              child: Text(
                                '${InstallmentFormatters.formatAmount(item.amount)} ${AppStrings.egp}',
                                style: getExtraBoldStyle(
                                  color: statusStyle.textColor,
                                  fontSize: FontSize.s16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Date / Status context info
                            Flexible(
                              flex: 5,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: _buildDateInfo(statusStyle),
                              ),
                            ),
                          ],
                        ),

                        // ── 3. Bottom Action Button (for unpaid installments) ──
                        if (!item.isPaid) ...[
                          SizedBox(height: 12.h),
                          SizedBox(
                            height: 38.h,
                            child: ElevatedButton.icon(
                              onPressed: () => _onPayItem(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.r10.r),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                              ),
                              icon: SvgPicture.asset(
                                IconAssets.checkCircle,
                                width: 15.r,
                                height: 15.r,
                                colorFilter: const ColorFilter.mode(
                                  ColorManager.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              label: Text(
                                AppStrings.recordPayment,
                                style: getBoldStyle(
                                  color: ColorManager.white,
                                  fontSize: FontSize.s12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(InstallmentStatusStyle statusStyle) {
    if (item.isPaid) {
      final dateToShow = item.paidAt.isNotEmpty ? item.paidAt : item.dueDate;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            IconAssets.checkCheck,
            width: 13.r,
            height: 13.r,
            colorFilter: const ColorFilter.mode(
              ColorManager.success,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              '${AppStrings.paidOnDate} ${InstallmentFormatters.formatShortDate(dateToShow)}',
              style: getMediumStyle(
                color: ColorManager.success,
                fontSize: FontSize.s11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    if (item.daysOverdue > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            IconAssets.alertTriangle,
            width: 12.r,
            height: 12.r,
            colorFilter: const ColorFilter.mode(
              ColorManager.error,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              '${AppStrings.overdueDaysCount} ${item.daysOverdue} ${item.daysOverdue == 1 ? AppStrings.dayUnit : AppStrings.daysUnit}',
              style: getBoldStyle(
                color: ColorManager.error,
                fontSize: FontSize.s11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    final lower = item.status.toLowerCase();
    if (lower == 'duetoday' || lower == 'due_today') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            IconAssets.alarmClock,
            width: 12.r,
            height: 12.r,
            colorFilter: const ColorFilter.mode(
              ColorManager.secondary,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              AppStrings.dueTodayStatus,
              style: getBoldStyle(
                color: ColorManager.secondary,
                fontSize: FontSize.s11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          IconAssets.calendar,
          width: 12.r,
          height: 12.r,
          colorFilter: const ColorFilter.mode(
            ColorManager.textTertiary,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            InstallmentFormatters.formatShortDate(item.dueDate),
            style: getRegularStyle(
              color: ColorManager.textTertiary,
              fontSize: FontSize.s11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
