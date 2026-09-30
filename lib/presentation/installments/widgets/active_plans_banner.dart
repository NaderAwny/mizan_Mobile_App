// ─────────────────────────────────────────────────────────────
// ActivePlansBanner — Active plans summary banner
// Mizan Design System — Figma Node #3:300 compliant
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class ActivePlansBanner extends StatelessWidget {
  final int totalDebtsCount;
  final int activeClientsCount;

  const ActivePlansBanner({
    super.key,
    required this.totalDebtsCount,
    required this.activeClientsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p16.w,
        vertical: AppPadding.p14.h,
      ),
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
            blurRadius: 10.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: ColorManager.lightPrimary,
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              border: Border.all(
                color: ColorManager.primary.withAlpha(40),
                width: 1.0,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                IconAssets.walletCards,
                width: 22.r,
                height: 22.r,
                colorFilter: const ColorFilter.mode(
                  ColorManager.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$totalDebtsCount ${AppStrings.activePlans}',
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s15,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$activeClientsCount ${AppStrings.clientsUnderActiveFollowUp}',
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
