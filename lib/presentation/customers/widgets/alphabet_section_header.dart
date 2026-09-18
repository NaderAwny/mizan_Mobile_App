import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// Section header for alphabetical grouping in Contacts Directory (Figma Node #3:206)
class AlphabetSectionHeader extends StatelessWidget {
  final String letter;

  const AlphabetSectionHeader({
    super.key,
    required this.letter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      margin: EdgeInsets.only(top: 14.h, bottom: 8.h),
      decoration: BoxDecoration(
        color: ColorManager.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.r10.r),
      ),
      child: Text(
        letter,
        style: getBoldStyle(
          color: ColorManager.primary,
          fontSize: FontSize.s15,
        ),
      ),
    );
  }
}
