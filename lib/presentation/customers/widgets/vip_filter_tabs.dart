import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// Filter tabs capsule bar for Contacts / VIP list (Figma Node #2025:647)
class VipFilterTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const VipFilterTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTabSelected(index),
                borderRadius: BorderRadius.circular(AppRadius.r20.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? ColorManager.primary : ColorManager.surface,
                    borderRadius: BorderRadius.circular(AppRadius.r20.r),
                    border: Border.all(
                      color: isSelected ? ColorManager.primary : ColorManager.border,
                      width: 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: ColorManager.primary.withAlpha(40),
                              offset: const Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    tabs[index],
                    style: getMediumStyle(
                      color: isSelected ? ColorManager.white : ColorManager.textSecondary,
                      fontSize: FontSize.s13,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
