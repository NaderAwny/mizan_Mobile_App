import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/app/data_refresh_manager.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/assistant_model.dart';
import 'package:mizan/domain/use_case/assistant/cancel_assistant_action_use_case.dart';
import 'package:mizan/domain/use_case/assistant/confirm_assistant_action_use_case.dart';
import 'package:mizan/domain/use_case/assistant/end_assistant_session_use_case.dart';
import 'package:mizan/domain/use_case/assistant/send_assistant_command_use_case.dart';
import 'package:mizan/domain/use_case/assistant/start_assistant_session_use_case.dart';
import 'package:mizan/presentation/assistant/assistant_chat_cubit/assistant_chat_state.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

@injectable
class AssistantChatCubit extends Cubit<AssistantChatState> {
  final StartAssistantSessionUseCase _startAssistantSessionUseCase;
  final SendAssistantCommandUseCase _sendAssistantCommandUseCase;
  final ConfirmAssistantActionUseCase _confirmAssistantActionUseCase;
  final CancelAssistantActionUseCase _cancelAssistantActionUseCase;
  final EndAssistantSessionUseCase _endAssistantSessionUseCase;
  final DataRefreshManager? _dataRefreshManager;

  Timer? _pendingExpirationTimer;
  Timer? _rateLimitTimer;

  AssistantChatCubit(
    this._startAssistantSessionUseCase,
    this._sendAssistantCommandUseCase,
    this._confirmAssistantActionUseCase,
    this._cancelAssistantActionUseCase,
    this._endAssistantSessionUseCase, [
    this._dataRefreshManager,
  ]) : super(const AssistantChatState());

  /// Ensures an active session exists and is not within 1 minute of expiring
  Future<String?> ensureSession() async {
    final String? currentSessionId = state.currentSessionId;
    final DateTime? expiresAt = state.sessionExpiresAt;

    final bool isExpiringSoon =
        expiresAt != null &&
        DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 1)));

    if (currentSessionId != null &&
        currentSessionId.isNotEmpty &&
        !isExpiringSoon) {
      return currentSessionId;
    }

    final result = await _startAssistantSessionUseCase.execute();
    return result.fold((failure) => currentSessionId, (session) {
      emit(
        state.copyWith(
          currentSessionId: session.sessionId,
          sessionExpiresAt: session.expiresAt,
        ),
      );
      return session.sessionId;
    });
  }

  /// Sends a text command to the assistant
  Future<void> sendText(String rawText) async {
    // 3. Ignore if already sending or executing
    final bool isSending =
        state.flowState is LoadingState || state.isExecutingAction;
    if (isSending) return;

    final String trimmed = rawText.trim();
    if (trimmed.isEmpty) {
      emit(
        state.copyWith(
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            AppStrings.assistantEmptyTextError,
          ),
        ),
      );
      return;
    }

    if (trimmed.length > 500) {
      emit(
        state.copyWith(
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            AppStrings.assistantMaxCharsError,
          ),
        ),
      );
      return;
    }

    final String? sessionId = await ensureSession();

    final ChatMessage userMsg = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      sender: ChatSender.user,
      text: trimmed,
      timestamp: DateTime.now(),
      isFailed: false,
    );

    final List<ChatMessage> updatedMessages = List<ChatMessage>.from(
      state.messages,
    )..add(userMsg);

    emit(
      state.copyWith(
        messages: updatedMessages,
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          message: AppStrings.assistantThinking,
        ),
        lastFailedText: null,
      ),
    );

    final result = await _sendAssistantCommandUseCase.execute(
      SendAssistantCommandParams(sessionId: sessionId, text: trimmed),
    );

    result.fold(
      (failure) {
        _handleCommandFailure(failure, trimmed);
      },
      (reply) {
        _handleCommandSuccess(reply);
      },
    );
  }

  /// Retries the last failed command without adding a duplicate user message
  Future<void> retryLast() async {
    final String? text = state.lastFailedText;
    if (text == null || text.isEmpty) return;

    final bool isSending =
        state.flowState is LoadingState || state.isExecutingAction;
    if (isSending) return;

    final String? sessionId = await ensureSession();

    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          message: AppStrings.assistantThinking,
        ),
      ),
    );

    final result = await _sendAssistantCommandUseCase.execute(
      SendAssistantCommandParams(sessionId: sessionId, text: text),
    );

    result.fold(
      (failure) {
        _handleCommandFailure(failure, text);
      },
      (reply) {
        _handleCommandSuccess(reply);
      },
    );
  }

  void _handleCommandSuccess(AssistantReply reply) {
    // 2. Clear rate-limit on first successful send
    _rateLimitTimer?.cancel();
    _rateLimitTimer = null;

    final ChatMessage assistantMsg = ChatMessage(
      id: '${DateTime.now().microsecondsSinceEpoch}_reply',
      sender: ChatSender.assistant,
      text: reply.message,
      type: reply.type,
      payload: reply.payload,
      options: reply.options,
      pendingAction: reply.pendingAction,
      timestamp: DateTime.now(),
    );

    // 4. Remove isFailed flag on success
    final List<ChatMessage> finalMessages = state.messages.map((ChatMessage m) {
      if (m.sender == ChatSender.user && m.isFailed) {
        return m.copyWith(isFailed: false);
      }
      return m;
    }).toList()..add(assistantMsg);

    final AssistantPendingAction? nextPending =
        reply.type == AssistantReplyType.confirmation
        ? reply.pendingAction
        : null;

    final bool isAlreadyExpired = nextPending?.isExpired ?? false;

    emit(
      state.copyWith(
        messages: finalMessages,
        currentSessionId: reply.sessionId.isNotEmpty
            ? reply.sessionId
            : state.currentSessionId,
        sessionResetNotice: reply.sessionReset,
        pendingAction: nextPending,
        isActionExpired: isAlreadyExpired,
        expiredActionId: isAlreadyExpired ? nextPending?.actionId : null,
        flowState: ContentState(),
        isRateLimited: false,
        rateLimitMessage: null,
        lastFailedText: null,
      ),
    );

    // 1. Manage pending expiration timer (scheduled only if remaining duration > 0)
    _updatePendingAction(nextPending);
  }

  void _handleCommandFailure(Failure failure, String originalText) {
    // 4. Mark last user message with failed flag
    final List<ChatMessage> updated = List<ChatMessage>.from(state.messages);
    final int lastUserIdx = updated.lastIndexWhere(
      (ChatMessage m) => m.sender == ChatSender.user,
    );
    if (lastUserIdx != -1) {
      updated[lastUserIdx] = updated[lastUserIdx].copyWith(isFailed: true);
    }

    final bool isRateLimit = failure.code == 429;
    if (isRateLimit) {
      _setRateLimit(originalText, updated);
    } else {
      emit(
        state.copyWith(
          messages: updated,
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            // ignore: avoid_dynamic_calls
            failure.message.toString(),
          ),
          lastFailedText: originalText,
        ),
      );
    }
  }

  void _setRateLimit(String lastText, List<ChatMessage> updatedMessages) {
    // 2. Reset rate-limit after 60 seconds
    _rateLimitTimer?.cancel();
    emit(
      state.copyWith(
        messages: updatedMessages,
        flowState: ErrorState(
          StateRendererType.popupErrorStatete,
          AppStrings.assistantErrorRateLimit,
        ),
        isRateLimited: true,
        rateLimitMessage: AppStrings.assistantErrorRateLimit,
        lastFailedText: lastText,
      ),
    );

    _rateLimitTimer = Timer(const Duration(seconds: 60), () {
      if (!isClosed && state.isRateLimited) {
        emit(state.copyWith(isRateLimited: false, rateLimitMessage: null));
      }
    });
  }

  void _updatePendingAction(AssistantPendingAction? action) {
    // 1. Single timer emitting on expiration and cancelling on change
    _pendingExpirationTimer?.cancel();
    _pendingExpirationTimer = null;

    if (action != null && action.expiresAt != null) {
      final Duration remaining = action.expiresAt!.difference(DateTime.now());
      if (remaining > Duration.zero) {
        _pendingExpirationTimer = Timer(remaining, () {
          if (!isClosed && state.pendingAction?.actionId == action.actionId) {
            emit(
              state.copyWith(
                isActionExpired: true,
                expiredActionId: action.actionId,
              ),
            );
          }
        });
      }
      // If remaining <= Duration.zero, the reply was already emitted as expired above
    }
  }

  /// Confirms the current pending action
  Future<void> confirm() async {
    final AssistantPendingAction? action = state.pendingAction;
    if (action == null || state.isExecutingAction) return;

    if (action.isExpired) {
      emit(
        state.copyWith(
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            AppStrings.assistantActionExpired,
          ),
        ),
      );
      return;
    }

    final String sessionId = state.currentSessionId ?? '';
    emit(
      state.copyWith(
        isExecutingAction: true,
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          message: AppStrings.assistantExecuting,
        ),
      ),
    );

    final result = await _confirmAssistantActionUseCase.execute(
      AssistantActionParams(sessionId: sessionId, actionId: action.actionId),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isExecutingAction: false,
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
            ),
          ),
        );
      },
      (reply) {
        _dataRefreshManager?.notifyTransactionsChanged();
        _updatePendingAction(null);

        final ChatMessage confirmMsg = ChatMessage(
          id: '${DateTime.now().microsecondsSinceEpoch}_confirm',
          sender: ChatSender.assistant,
          text: reply.message.isNotEmpty
              ? reply.message
              : AppStrings.assistantConfirmSuccess,
          type: reply.type,
          payload: reply.payload,
          timestamp: DateTime.now(),
        );

        final List<ChatMessage> finalMessages = List<ChatMessage>.from(
          state.messages,
        )..add(confirmMsg);

        emit(
          state.copyWith(
            isExecutingAction: false,
            messages: finalMessages,
            pendingAction: null,
            currentSessionId: reply.sessionId.isNotEmpty
                ? reply.sessionId
                : state.currentSessionId,
            flowState: ContentState(),
          ),
        );
      },
    );
  }

  /// Cancels the current pending action
  Future<void> cancel() async {
    final AssistantPendingAction? action = state.pendingAction;
    if (action == null || state.isExecutingAction) return;

    final String sessionId = state.currentSessionId ?? '';
    emit(
      state.copyWith(
        isExecutingAction: true,
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          message: AppStrings.assistantExecuting,
        ),
      ),
    );

    final result = await _cancelAssistantActionUseCase.execute(
      AssistantActionParams(sessionId: sessionId, actionId: action.actionId),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isExecutingAction: false,
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
            ),
          ),
        );
      },
      (reply) {
        _updatePendingAction(null);

        final ChatMessage cancelMsg = ChatMessage(
          id: '${DateTime.now().microsecondsSinceEpoch}_cancel',
          sender: ChatSender.assistant,
          text: reply.message.isNotEmpty
              ? reply.message
              : AppStrings.assistantConfirmCancelled,
          type: reply.type,
          payload: reply.payload,
          timestamp: DateTime.now(),
        );

        final List<ChatMessage> finalMessages = List<ChatMessage>.from(
          state.messages,
        )..add(cancelMsg);

        emit(
          state.copyWith(
            isExecutingAction: false,
            messages: finalMessages,
            pendingAction: null,
            currentSessionId: reply.sessionId.isNotEmpty
                ? reply.sessionId
                : state.currentSessionId,
            flowState: ContentState(),
          ),
        );
      },
    );
  }

  /// Selects an option from the latest clarification/question message
  Future<void> selectOption(int index) async {
    for (int i = state.messages.length - 1; i >= 0; i--) {
      final ChatMessage msg = state.messages[i];
      if (msg.sender == ChatSender.assistant && msg.options.isNotEmpty) {
        if (index >= 0 && index < msg.options.length) {
          final String selectedText = msg.options[index];
          await sendText(selectedText);
          return;
        }
      }
    }
  }

  /// Clears the sessionResetNotice flag after being consumed by the UI
  void clearSessionResetNotice() {
    if (state.sessionResetNotice) {
      emit(state.copyWith(sessionResetNotice: false));
    }
  }

  /// Ends the current session and clears state
  Future<void> endSession() async {
    _updatePendingAction(null);
    _rateLimitTimer?.cancel();
    _rateLimitTimer = null;

    final String? sessionId = state.currentSessionId;
    if (sessionId != null && sessionId.isNotEmpty) {
      await _endAssistantSessionUseCase.execute(sessionId);
    }
    emit(const AssistantChatState());
  }

  @override
  Future<void> close() {
    _pendingExpirationTimer?.cancel();
    _rateLimitTimer?.cancel();
    return super.close();
  }
}
