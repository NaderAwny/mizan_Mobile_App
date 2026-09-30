// ─────────────────────────────────────────────────────────────
// InstallmentHistoryFilterTabs — Responsive Horizontal Filter Tabs
// Mizan Design System — Figma Node #2303:4184 compliant
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/domain/use_case/get_installments_history_use_case.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class InstallmentFilterItem {
  final String statusKey;
  final String label;

  const InstallmentFilterItem({
    required this.statusKey,
    required this.label,
  });
}

class InstallmentHistoryFilterTabs extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onStatusSelected;

  const InstallmentHistoryFilterTabs({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  static const List<InstallmentFilterItem> _filters = [
    InstallmentFilterItem(
      statusKey: InstallmentHistoryStatus.all,
      label: AppStrings.allHistoryFilter,
    ),
    InstallmentFilterItem(
      statusKey: InstallmentHistoryStatus.overdue,
      label: AppStrings.overdueHistoryFilter,
    ),
    InstallmentFilterItem(
      statusKey: InstallmentHistoryStatus.dueToday,
      label: AppStrings.dueTodayHistoryFilter,
    ),
    InstallmentFilterItem(
      statusKey: InstallmentHistoryStatus.upcoming,
      label: AppStrings.upcomingHistoryFilter,
    ),
    InstallmentFilterItem(
      statusKey: InstallmentHistoryStatus.paid,
      label: AppStrings.paidHistoryFilter,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_filters.length, (index) {
          final filter = _filters[index];
          final isSelected =
              filter.statusKey.toLowerCase() == selectedStatus.toLowerCase();

          return Padding(
            padding: EdgeInsets.only(
              left: index == _filters.length - 1 ? 0 : 8.w,
            ),
            child: _FilterPill(
              label: filter.label,
              isSelected: isSelected,
              onTap: () => onStatusSelected(filter.statusKey),
            ),
          );
        }),
      ),
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r999.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: 18.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: isSelected ? ColorManager.primary : ColorManager.surface,
            borderRadius: BorderRadius.circular(AppRadius.r999.r),
            border: Border.all(
              color: isSelected ? ColorManager.primary : ColorManager.border,
              width: 1.0,
            ),
            boxShadow: isSelected
                ? const [
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
