import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class NotificationsFilterTabs extends StatelessWidget {
  final bool unreadOnly;
  final ValueChanged<bool> onFilterChanged;

  const NotificationsFilterTabs({
    super.key,
    required this.unreadOnly,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _FilterPill(
          label: AppStrings.notificationsFilterAll,
          isSelected: !unreadOnly,
          onTap: () => onFilterChanged(false),
        ),
        SizedBox(width: 8.w),
        _FilterPill(
          label: AppStrings.notificationsFilterUnread,
          isSelected: unreadOnly,
          onTap: () => onFilterChanged(true),
        ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorManager.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r999.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? ColorManager.primary : ColorManager.surface,
            borderRadius: BorderRadius.circular(AppRadius.r999.r),
            border: Border.all(
              color: isSelected ? ColorManager.primary : ColorManager.border,
              width: 1.0,
            ),
            boxShadow: isSelected
                ? const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x2AC57B57),
                      blurRadius: 8.0,
                      offset: Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: isSelected
                ? getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s13,
                    height: 1.2,
                  )
                : getMediumStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s13,
                    height: 1.2,
                  ),
          ),
        ),
      ),
    );
  }
}
