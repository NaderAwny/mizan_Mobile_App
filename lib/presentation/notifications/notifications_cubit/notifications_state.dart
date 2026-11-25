import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'notifications_state.freezed.dart';

@freezed
abstract class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    FlowState? flowState,
    List<NotificationModel>? data,
    @Default(false) bool unreadOnly, // الفلتر: false = الكل / true = غير مقروءة
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default(0) int totalCount,
    @Default(0) int unreadCount,
    @Default(1) int currentPage,
    @Default(1) int totalPages,
  }) = _NotificationsState;
}
