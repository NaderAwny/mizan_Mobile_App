import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// Modal Bottom Sheet for confirming contact deletion (Figma Node #2175:84)
class DeleteContactBottomSheet extends StatelessWidget {
  final String contactName;
  final VoidCallback onConfirmDelete;

  const DeleteContactBottomSheet({
    super.key,
    required this.contactName,
    required this.onConfirmDelete,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String contactName,
    required VoidCallback onConfirmDelete,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeleteContactBottomSheet(
        contactName: contactName,
        onConfirmDelete: onConfirmDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 12.h,
        bottom: 24.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r32.r),
          topRight: Radius.circular(AppRadius.r32.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Drag Handle
            Container(
              width: 44.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ColorManager.borderDark,
                borderRadius: BorderRadius.circular(AppRadius.r2.r),
              ),
            ),

            SizedBox(height: 24.h),

            // Warning Icon Container
            Container(
              width: 68.r,
              height: 68.r,
              decoration: const BoxDecoration(
                color: ColorManager.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: ColorManager.error,
                  size: 34.r,
                ),
              ),
            ),

            SizedBox(height: 18.h),

            // Title
            Text(
              AppStrings.deleteContactQuestion,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s18,
              ),
            ),

            SizedBox(height: 10.h),

            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "سيتم حذف \"$contactName\" وجميع بيانات المعاملات والأقساط الخاصة به نهائياً. لا يمكن التراجع عن هذا الإجراء بعد إتمامه.",
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s13,
                  height: 1.6,
                ),
              ),
            ),

            SizedBox(height: 28.h),

            // Delete Final Button
            SizedBox(
              width: double.infinity,
              height: 80.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.error,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r14.r),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirmDelete();
                },
                child: Text(
                  AppStrings.finalDelete,
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s15,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ColorManager.surfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r14.r),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  AppStrings.cancel,
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
