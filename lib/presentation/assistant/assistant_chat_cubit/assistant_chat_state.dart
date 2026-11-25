import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/assistant_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'assistant_chat_state.freezed.dart';

@freezed
abstract class AssistantChatState with _$AssistantChatState {
  const factory AssistantChatState({
    FlowState? flowState,
    @Default(<ChatMessage>[]) List<ChatMessage> messages,
    String? currentSessionId,
    DateTime? sessionExpiresAt,
    AssistantPendingAction? pendingAction,
    @Default(false) bool isActionExpired,
    String? expiredActionId,
    @Default(false) bool isExecutingAction,
    @Default(false) bool sessionResetNotice,
    @Default(false) bool isRateLimited,
    String? rateLimitMessage,
    String? lastFailedText,
  }) = _AssistantChatState;
}

extension AssistantChatStateX on AssistantChatState {
  bool get isPendingExpired =>
      isActionExpired || (pendingAction?.isExpired ?? false);
}
