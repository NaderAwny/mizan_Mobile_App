import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class VoiceNotePeriodOption {
  final String key;
  final String label;

  const VoiceNotePeriodOption({
    required this.key,
    required this.label,
  });
}

const List<VoiceNotePeriodOption> voiceNotePeriodOptions = [
  VoiceNotePeriodOption(
    key: 'today',
    label: AppStrings.voiceSummaryPeriodToday,
  ),
  VoiceNotePeriodOption(
    key: 'yesterday',
    label: AppStrings.voiceSummaryPeriodYesterday,
  ),
  VoiceNotePeriodOption(
    key: 'this_week',
    label: AppStrings.voiceSummaryPeriodThisWeek,
  ),
  VoiceNotePeriodOption(
    key: 'last_week',
    label: AppStrings.voiceSummaryPeriodLastWeek,
  ),
  VoiceNotePeriodOption(
    key: 'this_month',
    label: AppStrings.voiceSummaryPeriodThisMonth,
  ),
  VoiceNotePeriodOption(
    key: 'last_month',
    label: AppStrings.voiceSummaryPeriodLastMonth,
  ),
  VoiceNotePeriodOption(
    key: 'custom',
    label: AppStrings.voiceSummaryPeriodCustom,
  ),
];

String getVoiceNotePeriodLabel(String periodKey) {
  for (final option in voiceNotePeriodOptions) {
    if (option.key == periodKey) {
      return option.label;
    }
  }
  return AppStrings.voiceSummaryPeriodToday;
}

class VoiceNotesPeriodTabs extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onPeriodSelected;

  const VoiceNotesPeriodTabs({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppMargin.m16.w),
      padding: EdgeInsets.all(AppPadding.p4.w),
      decoration: BoxDecoration(
        color: ColorManager.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: voiceNotePeriodOptions.map((option) {
            final isSelected = option.key == selectedPeriod;
            return GestureDetector(
              onTap: () => onPeriodSelected(option.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.p14.w,
                  vertical: AppPadding.p8.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ColorManager.surface
                      : ColorManager.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.r12.r),
                  boxShadow: isSelected
                      ? [
                          const BoxShadow(
                            color: ColorManager.shadowMedium,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  option.label,
                  style: isSelected
                      ? getBoldStyle(
                          fontSize: FontSize.s12,
                          color: ColorManager.brandGreen,
                        )
                      : getMediumStyle(
                          fontSize: FontSize.s12,
                          color: ColorManager.textSecondary,
                        ),
                ),
              ),
            );
          }).toList(growable: false),
        ),
      ),
    );
  }
}
