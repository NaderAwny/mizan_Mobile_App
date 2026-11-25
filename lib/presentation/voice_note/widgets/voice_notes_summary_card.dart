import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/voice_note/widgets/voice_notes_period_tabs.dart';

class VoiceNotesSummaryCard extends StatelessWidget {
  final VoiceNoteSummaryModel? summary;
  final String selectedPeriod;
  final bool isLoading;
  final String? errorMessage;
  final bool isBalanceVisible;
  final VoidCallback onToggleVisibility;
  final VoidCallback onRetry;

  const VoiceNotesSummaryCard({
    super.key,
    required this.summary,
    required this.selectedPeriod,
    required this.isLoading,
    required this.errorMessage,
    required this.isBalanceVisible,
    required this.onToggleVisibility,
    required this.onRetry,
  });

  static final NumberFormat _amountFormat = NumberFormat('#,##0.00', 'en_US');

  String _formatAmount(double value) {
    if (!isBalanceVisible) return '••••••';
    return _amountFormat.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final periodLabel = getVoiceNotePeriodLabel(selectedPeriod);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppMargin.m16.w),
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.r24.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -36.h,
            left: -24.w,
            child: Container(
              width: 118.w,
              height: 118.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppPadding.p16.w),
            child: _buildBody(periodLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(String periodLabel) {
    if (isLoading && summary == null) {
      return SizedBox(
        height: 132.h,
        child: const Center(
          child: CircularProgressIndicator(
            color: ColorManager.white,
            strokeWidth: 2.4,
          ),
        ),
      );
    }

    if (errorMessage != null && summary == null) {
      return SizedBox(
        height: 132.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getMediumStyle(
                fontSize: FontSize.s13,
                color: ColorManager.white,
              ),
            ),
            SizedBox(height: AppSize.s10.h),
            TextButton.icon(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                backgroundColor: ColorManager.white.withValues(alpha: 0.16),
                foregroundColor: ColorManager.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12.r),
                ),
              ),
              icon: Icon(Icons.refresh_rounded, size: 16.sp),
              label: Text(
                AppStrings.retry,
                style: getBoldStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final data = summary ??
        VoiceNoteSummaryModel(
          totalSales: 0,
          totalPurchases: 0,
          net: 0,
          count: 0,
          period: selectedPeriod,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Top Row: Period/Net Pill + Visibility Toggle ─────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.p12.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.r999.r),
                  border: Border.all(
                    color: ColorManager.white.withValues(alpha: 0.22),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        '${AppStrings.voiceSummaryNetTitle} $periodLabel ${AppStrings.voiceSummaryCurrencyEgp}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          fontSize: FontSize.s11,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.s8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(AppRadius.r999.r),
                      ),
                      child: Text(
                        '${data.count} ${AppStrings.voiceSummaryOperationsSuffix}',
                        style: getBoldStyle(
                          fontSize: FontSize.s10,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSize.s8.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  Padding(
                    padding: EdgeInsets.only(left: AppPadding.p8.w),
                    child: SizedBox(
                      width: AppSize.s14.w,
                      height: AppSize.s14.w,
                      child: const CircularProgressIndicator(
                        color: ColorManager.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                InkWell(
                  onTap: onToggleVisibility,
                  borderRadius: BorderRadius.circular(AppRadius.r999.r),
                  child: Padding(
                    padding: EdgeInsets.all(AppPadding.p4.w),
                    child: Icon(
                      isBalanceVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: ColorManager.white.withValues(alpha: 0.9),
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppSize.s12.h),

        // ── Main Net Balance ─────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: Text(
                _formatAmount(data.net),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBlackStyle(
                  fontSize: FontSize.s28,
                  color: ColorManager.white,
                ),
              ),
            ),
            SizedBox(width: AppSize.s6.w),
            Text(
              AppStrings.voiceSummaryCurrencyAr,
              style: getBoldStyle(
                fontSize: FontSize.s14,
                color: ColorManager.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.s12.h),

        // ── Divider ──────────────────────────────────────────────────────
        Container(
          height: AppSize.s1,
          color: ColorManager.white.withValues(alpha: 0.18),
        ),
        SizedBox(height: AppSize.s12.h),

        // ── Sales & Purchases Columns ────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _SummaryMetricTile(
                icon: Icons.south_west_rounded,
                label: '${AppStrings.voiceSummarySalesLabel} ($periodLabel)',
                amountText:
                    '${_formatAmount(data.totalSales)} ${AppStrings.voiceSummaryCurrencyAr}',
              ),
            ),
            Container(
              width: AppSize.s1,
              height: AppSize.s36.h,
              margin: EdgeInsets.symmetric(horizontal: AppMargin.m10.w),
              color: ColorManager.white.withValues(alpha: 0.18),
            ),
            Expanded(
              child: _SummaryMetricTile(
                icon: Icons.north_east_rounded,
                label:
                    '${AppStrings.voiceSummaryPurchasesLabel} ($periodLabel)',
                amountText:
                    '${_formatAmount(data.totalPurchases)} ${AppStrings.voiceSummaryCurrencyAr}',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryMetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amountText;

  const _SummaryMetricTile({
    required this.icon,
    required this.label,
    required this.amountText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: ColorManager.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(AppRadius.r8.r),
          ),
          child: Icon(
            icon,
            color: ColorManager.white,
            size: 16.sp,
          ),
        ),
        SizedBox(width: AppSize.s8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  fontSize: FontSize.s11,
                  color: ColorManager.white.withValues(alpha: 0.85),
                ),
              ),
              SizedBox(height: AppSize.s2.h),
              Text(
                amountText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontSize: FontSize.s13,
                  color: ColorManager.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
