import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/notifications/notifications_cubit/notifications_cubit.dart';
import 'package:mizan/presentation/notifications/notifications_cubit/notifications_state.dart';
import 'package:mizan/presentation/notifications/widgets/notification_card.dart';
import 'package:mizan/presentation/notifications/widgets/notification_date_header.dart';
import 'package:mizan/presentation/notifications/widgets/notification_formatters.dart';
import 'package:mizan/presentation/notifications/widgets/notifications_filter_tabs.dart';
import 'package:mizan/presentation/notifications/widgets/notifications_load_more.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>.value(
      value: getIt<NotificationsCubit>()..getNotifications(),
      child: const _NotificationsScreen(),
    );
  }
}

class _NotificationsScreen extends StatelessWidget {
  const _NotificationsScreen();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: AppBar(
          backgroundColor: ColorManager.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.all(8.r),
            child: Container(
              decoration: BoxDecoration(
                color: ColorManager.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(color: ColorManager.border, width: 1),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ColorManager.textPrimary,
                  size: 16.r,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
          ),
          title: Column(
            children: <Widget>[
              Text(
                AppStrings.notifications,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s16,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                AppStrings.notificationsSubtitle,
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s11,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (BuildContext context, NotificationsState state) {
                final bool hasItems =
                    state.data != null && state.data!.isNotEmpty;
                return Row(
                  children: <Widget>[
                    if (hasItems)
                      Tooltip(
                        message: AppStrings.markAllAsRead,
                        child: GestureDetector(
                          onTap: () => context
                              .read<NotificationsCubit>()
                              .markAllAsRead(),
                          child: Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color(0xFFD4865E),
                                  ColorManager.primary,
                                  ColorManager.darkPrimary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: ColorManager.primary.withValues(
                                    alpha: 0.40,
                                  ),
                                  blurRadius: 10.r,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.done_all_rounded,
                                color: Colors.white,
                                size: 20.r,
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(width: 12.w),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (BuildContext context, NotificationsState state) {
            return Column(
              children: <Widget>[
                // ── Pinned Horizontal Filters ──
                Container(
                  color: ColorManager.surface,
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                  child: Column(
                    children: <Widget>[
                      NotificationsFilterTabs(
                        unreadOnly: state.unreadOnly,
                        onFilterChanged: (bool unreadOnly) {
                          context.read<NotificationsCubit>().changeUnreadFilter(
                            unreadOnly,
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${state.totalCount} ${AppStrings.notifications}',
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s12,
                            ),
                          ),
                          Text(
                            state.unreadOnly
                                ? AppStrings.notificationsFilterUnread
                                : AppStrings.notificationsFilterAll,
                            style: getRegularStyle(
                              color: ColorManager.textTertiary,
                              fontSize: FontSize.s11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Divider(color: ColorManager.border, height: 1.h),

                // ── Notifications List with State Renderer ──
                Expanded(
                  child:
                      state.flowState?.getScreenWidget(
                        context,
                        _buildNotificationsList(context, state),
                        () => context
                            .read<NotificationsCubit>()
                            .getNotifications(),
                      ) ??
                      _buildNotificationsList(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationsList(
    BuildContext context,
    NotificationsState state,
  ) {
    final List<NotificationModel> items =
        state.data ?? const <NotificationModel>[];

    // Group items by date label (اليوم / أمس / أقدم)
    final Map<String, List<NotificationModel>> grouped =
        <String, List<NotificationModel>>{};

    for (final NotificationModel item in items) {
      final String groupLabel = NotificationFormatters.getGroupLabel(
        item.createdAt,
      );
      grouped.putIfAbsent(groupLabel, () => <NotificationModel>[]).add(item);
    }

    final List<Widget> listItems = <Widget>[];

    grouped.forEach((String groupTitle, List<NotificationModel> groupList) {
      listItems.add(NotificationDateHeader(title: groupTitle));
      for (final NotificationModel item in groupList) {
        listItems.add(NotificationCard(item: item));
      }
    });

    listItems.add(
      NotificationsLoadMore(
        isLoadingMore: state.isLoadingMore,
        hasMore: state.hasMore,
        currentPage: state.currentPage,
        totalPages: state.totalPages,
        onLoadMore: () =>
            context.read<NotificationsCubit>().loadMoreNotifications(),
      ),
    );

    return RefreshIndicator(
      onRefresh: () => context.read<NotificationsCubit>().getNotifications(),
      color: ColorManager.primary,
      backgroundColor: ColorManager.surface,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: listItems.length,
        itemBuilder: (BuildContext context, int index) => listItems[index],
      ),
    );
  }
}
