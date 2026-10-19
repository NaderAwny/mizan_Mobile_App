import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/presentation/notifications/notifications_cubit/notifications_cubit.dart';
import 'package:mizan/presentation/notifications/widgets/notification_formatters.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel item;

  const NotificationCard({super.key, required this.item});

  void _onTap(BuildContext context) {
    if (!item.isRead) {
      context.read<NotificationsCubit>().markAsRead(item.id);
    }
    if (item.transactionId.isNotEmpty) {
      Navigator.pushNamed(
        context,
        Routes.transactionDetailsRoute,
        arguments: item.transactionId,
      ).then((_) {
        if (context.mounted) {
          context.read<NotificationsCubit>().getNotifications();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !item.isRead;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: ColorManager.transparent,
        child: InkWell(
          onTap: () => _onTap(context),
          borderRadius: BorderRadius.circular(AppRadius.r14.r),
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: isUnread
                  ? ColorManager.lightPrimary.withAlpha(45)
                  : ColorManager.surface,
              borderRadius: BorderRadius.circular(AppRadius.r14.r),
              border: Border.all(
                color: isUnread
                    ? ColorManager.primary.withAlpha(80)
                    : ColorManager.border,
                width: 1.0,
              ),
              boxShadow: isUnread
                  ? const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x0DC57B57),
                        blurRadius: 6.0,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Notification Icon
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: isUnread
                        ? ColorManager.lightPrimary
                        : ColorManager.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      IconAssets.bell,
                      width: 18.r,
                      height: 18.r,
                      colorFilter: ColorFilter.mode(
                        isUnread
                            ? ColorManager.primary
                            : ColorManager.textTertiary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Title & Time & Unread Dot
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              item.title,
                              style: getBoldStyle(
                                color: ColorManager.textPrimary,
                                fontSize: FontSize.s14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            NotificationFormatters.formatRelativeTime(
                              item.createdAt,
                            ),
                            style: getRegularStyle(
                              color: ColorManager.textTertiary,
                              fontSize: FontSize.s11,
                            ),
                          ),
                          if (isUnread) ...<Widget>[
                            SizedBox(width: 6.w),
                            Container(
                              width: 8.r,
                              height: 8.r,
                              decoration: const BoxDecoration(
                                color: ColorManager.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 6.h),
                      // Message
                      Text(
                        item.message,
                        style: getMediumStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
