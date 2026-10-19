import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/app/app_badge_service.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/domain/use_case/get_notifications_use_case.dart';
import 'package:mizan/domain/use_case/mark_all_notifications_read_use_case.dart';
import 'package:mizan/domain/use_case/mark_notification_read_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/notifications/notifications_cubit/notifications_state.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

@injectable
class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase _markAllNotificationsReadUseCase;

  NotificationsCubit(
    this._getNotificationsUseCase,
    this._markNotificationReadUseCase,
    this._markAllNotificationsReadUseCase,
  ) : super(const NotificationsState());

  int currentPage = 1;
  final int pageSize = 20;

  // ── Badge helper ─────────────────────────────────────────────────────────
  void _syncBadge(int count) => AppBadgeService.updateCount(count);

  /// جلب عدد الإشعارات غير المقروءة لتحديث الـ Badge
  Future<void> fetchUnreadCount() async {
    final Either<Failure, NotificationsPage> result =
        await _getNotificationsUseCase.execute(
          GetNotificationsParams(page: 1, pageSize: 1, unreadOnly: true),
        );
    result.fold((_) {}, (NotificationsPage page) {
      if (!isClosed) {
        emit(state.copyWith(unreadCount: page.totalCount));
        _syncBadge(page.totalCount);
      }
    });
  }

  // ── 7.1 first load / refresh / change filter ─────────────────────────────
  Future<void> getNotifications({bool? unreadOnly}) async {
    currentPage = 1;
    final bool isInitialLoad = state.data == null;
    final bool targetUnreadOnly = unreadOnly ?? state.unreadOnly;

    if (isInitialLoad) {
      emit(
        state.copyWith(
          flowState: LoadingState(
            stateRendererType: StateRendererType.fullScreenLoadingState,
            title: AppStrings.loading,
            message: AppStrings.notificationsLoading,
          ),
          unreadOnly: targetUnreadOnly,
          hasMore: true,
        ),
      );
    } else {
      emit(state.copyWith(unreadOnly: targetUnreadOnly, hasMore: true));
    }

    final Either<Failure, NotificationsPage> result =
        await _getNotificationsUseCase.execute(
          GetNotificationsParams(
            page: 1,
            pageSize: pageSize,
            unreadOnly: targetUnreadOnly,
          ),
        );

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.fullScreenErrorState,
              failure.message,
              title: AppStrings.notificationsLoadError,
            ),
          ),
        );
      },
      (NotificationsPage page) {
        if (isClosed) return;
        currentPage = page.page;
        final int calculatedUnread = targetUnreadOnly
            ? page.totalCount
            : page.items.where((NotificationModel n) => !n.isRead).length;

        final int newUnread =
            targetUnreadOnly ? page.totalCount : calculatedUnread;
        emit(
          state.copyWith(
            flowState: page.items.isEmpty
                ? EmptyState(
                    targetUnreadOnly
                        ? AppStrings.notificationsUnreadEmpty
                        : AppStrings.notificationsEmpty,
                  )
                : ContentState(),
            data: page.items,
            hasMore: page.hasNextPage,
            totalCount: page.totalCount,
            unreadCount: newUnread,
            currentPage: page.page,
            totalPages: page.totalPages,
          ),
        );
        _syncBadge(newUnread);

        if (!targetUnreadOnly) {
          fetchUnreadCount();
        }
      },
    );
  }

  /// فلتر: الكل / غير مقروءة
  void changeUnreadFilter(bool unreadOnly) {
    if (unreadOnly == state.unreadOnly && state.data != null) return;
    getNotifications(unreadOnly: unreadOnly);
  }

  // ── load more (same shape as loadMoreInstallments) ───────────────────────
  Future<void> loadMoreNotifications() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final int nextPage = currentPage + 1;

    final Either<Failure, NotificationsPage> result =
        await _getNotificationsUseCase.execute(
          GetNotificationsParams(
            page: nextPage,
            pageSize: pageSize,
            unreadOnly: state.unreadOnly,
          ),
        );

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        emit(state.copyWith(isLoadingMore: false));
      },
      (NotificationsPage page) {
        if (isClosed) return;
        currentPage = nextPage;
        final List<NotificationModel> currentItems =
            state.data ?? <NotificationModel>[];
        emit(
          state.copyWith(
            data: <NotificationModel>[...currentItems, ...page.items],
            isLoadingMore: false,
            hasMore: page.hasNextPage,
            totalCount: page.totalCount,
            currentPage: page.page,
            totalPages: page.totalPages,
          ),
        );
      },
    );
  }

  // ── 7.2 mark one as read — optimistic + revert (mirror ContactsCubit.toggleVip) ──
  Future<void> markAsRead(String notificationId) async {
    final List<NotificationModel>? currentList = state.data;
    if (currentList == null || currentList.isEmpty) return;

    final int index = currentList.indexWhere(
      (NotificationModel n) => n.id == notificationId,
    );
    if (index == -1) return;

    final NotificationModel original = currentList[index];
    if (original.isRead) return; // already read → no API call

    final List<NotificationModel> optimisticList = List<NotificationModel>.from(
      currentList,
    );
    optimisticList[index] = _withReadFlag(original, true);
    final int newUnread = state.unreadCount > 0 ? state.unreadCount - 1 : 0;
    emit(state.copyWith(data: optimisticList, unreadCount: newUnread));
    _syncBadge(newUnread);

    final Either<Failure, NotificationReadStatus> result =
        await _markNotificationReadUseCase.execute(notificationId);

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        final List<NotificationModel> revertedList =
            List<NotificationModel>.from(state.data ?? optimisticList);
        final int revIndex = revertedList.indexWhere(
          (NotificationModel n) => n.id == notificationId,
        );
        if (revIndex != -1) revertedList[revIndex] = original;
        emit(
          state.copyWith(
            data: revertedList,
            unreadCount: state.unreadCount + 1,
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: AppStrings.markReadFailed,
            ),
          ),
        );
      },
      (NotificationReadStatus status) {
        if (isClosed) return;
        final List<NotificationModel> confirmedList =
            List<NotificationModel>.from(state.data ?? optimisticList);
        final int confirmedIndex = confirmedList.indexWhere(
          (NotificationModel n) => n.id == notificationId,
        );
        if (confirmedIndex != -1) {
          confirmedList[confirmedIndex] = _withReadFlag(
            original,
            status.isRead,
          );
        }
        emit(state.copyWith(data: confirmedList));
      },
    );
  }

  // ── 7.3 mark all as read — popup states (action), then refresh from server ──
  Future<void> markAllAsRead() async {
    final List<NotificationModel>? currentList = state.data;
    final int previousUnreadCount = state.unreadCount;

    // Optimistically mark all current items as read and set unreadCount to 0
    if (currentList != null && currentList.isNotEmpty) {
      final List<NotificationModel> updatedList = currentList
          .map((NotificationModel n) => _withReadFlag(n, true))
          .toList();
      emit(
        state.copyWith(
          data: updatedList,
          unreadCount: 0,
          flowState: LoadingState(
            stateRendererType: StateRendererType.popupLoadingState,
            message: AppStrings.markAllLoading,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          unreadCount: 0,
          flowState: LoadingState(
            stateRendererType: StateRendererType.popupLoadingState,
            message: AppStrings.markAllLoading,
          ),
        ),
      );
    }

    final Either<Failure, void> result = await _markAllNotificationsReadUseCase
        .execute(null);

    await result.fold(
      (Failure failure) async {
        if (isClosed) return;
        emit(
          state.copyWith(
            data: currentList,
            unreadCount: previousUnreadCount,
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: AppStrings.markAllFailed,
            ),
          ),
        );
      },
      (void _) async {
        if (isClosed) return;
        emit(state.copyWith(unreadCount: 0));
        _syncBadge(0);
        await getNotifications(); // silent refresh (data != null) → sets Content/Empty → closes popup
      },
    );
  }

  NotificationModel _withReadFlag(NotificationModel n, bool isRead) {
    return NotificationModel(
      id: n.id,
      type: n.type,
      title: n.title,
      message: n.message,
      transactionId: n.transactionId,
      installmentId: n.installmentId,
      isRead: isRead,
      createdAt: n.createdAt,
    );
  }
}
