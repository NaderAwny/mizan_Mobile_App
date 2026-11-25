import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mizan/domain/model/assistant_model.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// UserBubble — Chat bubble for user messages (Right-aligned in RTL)
/// ─────────────────────────────────────────────────────────────────────────────
class UserBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onRetry;

  const UserBubble({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final String timeStr = intl.DateFormat('hh:mm a', 'ar').format(message.timestamp);

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        margin: EdgeInsets.only(
          top: 6.h,
          bottom: 6.h,
          right: 16.w,
          left: 60.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: message.isFailed
                    ? ColorManager.lightError
                    : ColorManager.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.r18.r),
                  topRight: Radius.circular(AppRadius.r4.r),
                  bottomLeft: Radius.circular(AppRadius.r18.r),
                  bottomRight: Radius.circular(AppRadius.r18.r),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: ColorManager.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: getMediumStyle(
                  color: message.isFailed
                      ? ColorManager.error
                      : ColorManager.white,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (message.isFailed) ...<Widget>[
                  GestureDetector(
                    onTap: onRetry,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.refresh_rounded,
                          size: 13.r,
                          color: ColorManager.error,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          "فشل الإرسال • إعادة المحاولة",
                          style: getBoldStyle(
                            color: ColorManager.error,
                            fontSize: FontSize.s10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
                Text(
                  timeStr,
                  style: getRegularStyle(
                    color: ColorManager.textTertiary,
                    fontSize: FontSize.s10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
