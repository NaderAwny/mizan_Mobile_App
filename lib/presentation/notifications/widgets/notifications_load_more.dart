import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class NotificationsLoadMore extends StatelessWidget {
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final int totalPages;
  final VoidCallback onLoadMore;

  const NotificationsLoadMore({
    super.key,
    required this.isLoadingMore,
    required this.hasMore,
    required this.currentPage,
    required this.totalPages,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasMore && totalPages <= 1) {
      return SizedBox(height: 24.h);
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
      child: Column(
        children: <Widget>[
          if (hasMore)
            SizedBox(
              width: double.infinity,
              height: 60.h,
              child: OutlinedButton(
                onPressed: isLoadingMore ? null : onLoadMore,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: ColorManager.primary,
                    width: 1.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r12.r),
                  ),
                ),
                child: isLoadingMore
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorManager.primary,
                        ),
                      )
                    : Text(
                        AppStrings.loadMore,
                        style: getBoldStyle(
                          color: ColorManager.primary,
                          fontSize: FontSize.s13,
                        ),
                      ),
              ),
            ),
          if (totalPages > 1) ...<Widget>[
            SizedBox(height: 8.h),
            Text(
              '${AppStrings.pagePrefix} $currentPage ${AppStrings.ofPages} $totalPages',
              style: getRegularStyle(
                color: ColorManager.textTertiary,
                fontSize: FontSize.s11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
