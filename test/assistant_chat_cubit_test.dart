import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/assistant_model.dart';
import 'package:mizan/domain/repository/assistant_repository.dart';
import 'package:mizan/domain/use_case/assistant/cancel_assistant_action_use_case.dart';
import 'package:mizan/domain/use_case/assistant/confirm_assistant_action_use_case.dart';
import 'package:mizan/domain/use_case/assistant/end_assistant_session_use_case.dart';
import 'package:mizan/domain/use_case/assistant/send_assistant_command_use_case.dart';
import 'package:mizan/domain/use_case/assistant/start_assistant_session_use_case.dart';
import 'package:mizan/presentation/assistant/assistant_chat_cubit/assistant_chat_cubit.dart';
import 'package:mizan/presentation/assistant/assistant_chat_cubit/assistant_chat_state.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

class FakeAssistantRepository implements AssistantRepository {
  int startSessionCallCount = 0;
  int sendCommandCallCount = 0;
  int confirmActionCallCount = 0;
  int cancelActionCallCount = 0;
  int endSessionCallCount = 0;

  Either<Failure, AssistantSession>? startSessionResult;
  Either<Failure, AssistantReply>? sendCommandResult;
  Either<Failure, AssistantReply>? confirmActionResult;
  Either<Failure, AssistantReply>? cancelActionResult;
  Either<Failure, void>? endSessionResult;

  @override
  Future<Either<Failure, AssistantSession>> startSession() async {
    startSessionCallCount++;
    return startSessionResult ??
        Right<Failure, AssistantSession>(
          AssistantSession(
            sessionId: 'sess-100',
            expiresAt: DateTime.now().add(const Duration(minutes: 15)),
          ),
        );
  }

  @override
  Future<Either<Failure, AssistantReply>> sendCommand(
    String? sessionId,
    String text,
  ) async {
    sendCommandCallCount++;
    return sendCommandResult ??
        Right<Failure, AssistantReply>(
          AssistantReply(
            sessionId: sessionId ?? 'sess-100',
            sessionReset: false,
            type: AssistantReplyType.answer,
            message: 'تم استلام: $text',
          ),
        );
  }

  @override
  Future<Either<Failure, AssistantReply>> confirmAction(
    String sessionId,
    String actionId,
  ) async {
    confirmActionCallCount++;
    return confirmActionResult ??
        Right<Failure, AssistantReply>(
          AssistantReply(
            sessionId: sessionId,
            sessionReset: false,
            type: AssistantReplyType.success,
            message: 'تم تأكيد العملية',
          ),
        );
  }

  @override
  Future<Either<Failure, AssistantReply>> cancelAction(
    String sessionId,
    String actionId,
  ) async {
    cancelActionCallCount++;
    return cancelActionResult ??
        Right<Failure, AssistantReply>(
          AssistantReply(
            sessionId: sessionId,
            sessionReset: false,
            type: AssistantReplyType.cancelled,
            message: 'تم إلغاء العملية',
          ),
        );
  }

  @override
  Future<Either<Failure, void>> endSession(String sessionId) async {
    endSessionCallCount++;
    return endSessionResult ?? const Right<Failure, void>(null);
  }
}

void main() {
  late FakeAssistantRepository fakeRepo;
  late AssistantChatCubit cubit;

  setUp(() {
    fakeRepo = FakeAssistantRepository();
    cubit = AssistantChatCubit(
      StartAssistantSessionUseCase(fakeRepo),
      SendAssistantCommandUseCase(fakeRepo),
      ConfirmAssistantActionUseCase(fakeRepo),
      CancelAssistantActionUseCase(fakeRepo),
      EndAssistantSessionUseCase(fakeRepo),
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AssistantChatCubit Tests', () {
    test('Validates empty text locally without calling API', () async {
      await cubit.sendText('   ');
      expect(fakeRepo.sendCommandCallCount, 0);
      expect(cubit.state.flowState, isA<ErrorState>());
    });

    test('Validates text > 500 characters locally without calling API', () async {
      final String longText = 'أ' * 501;
      await cubit.sendText(longText);
      expect(fakeRepo.sendCommandCallCount, 0);
      expect(cubit.state.flowState, isA<ErrorState>());
    });

    test('Flow: ensureSession -> send command -> confirmation -> confirm -> success', () async {
      // Step 1: Send command returning confirmation
      fakeRepo.sendCommandResult = Right<Failure, AssistantReply>(
        AssistantReply(
          sessionId: 'sess-100',
          sessionReset: false,
          type: AssistantReplyType.confirmation,
          message: 'هل أنت متأكد من تسجيل بيع بمبلغ 500؟',
          pendingAction: AssistantPendingAction(
            actionId: 'act-1',
            intent: 'create_sale',
            summary: 'تسجيل بيع 500',
            expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          ),
        ),
      );

      await cubit.sendText('سجل بيع 500 ج');

      expect(cubit.state.messages.length, 2); // user + assistant
      expect(cubit.state.pendingAction, isNotNull);
      expect(cubit.state.pendingAction?.actionId, 'act-1');
      expect(cubit.state.currentSessionId, 'sess-100');

      // Step 2: Confirm
      await cubit.confirm();

      expect(fakeRepo.confirmActionCallCount, 1);
      expect(cubit.state.pendingAction, isNull);
      expect(cubit.state.messages.length, 3);
      expect(cubit.state.messages.last.type, AssistantReplyType.success);
    });

    test('Prevents double-calling confirm when already executing', () async {
      fakeRepo.sendCommandResult = Right<Failure, AssistantReply>(
        AssistantReply(
          sessionId: 'sess-100',
          sessionReset: false,
          type: AssistantReplyType.confirmation,
          message: 'تأكيد؟',
          pendingAction: AssistantPendingAction(
            actionId: 'act-2',
            intent: 'create_sale',
            summary: 'ملخص',
            expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          ),
        ),
      );

      await cubit.sendText('أمر');

      // Simulate simultaneous confirm calls
      final Future<void> first = cubit.confirm();
      final Future<void> second = cubit.confirm();
      await Future.wait(<Future<void>>[first, second]);

      expect(fakeRepo.confirmActionCallCount, 1);
    });

    test('Does not send confirm if action is already expired locally', () async {
      fakeRepo.sendCommandResult = Right<Failure, AssistantReply>(
        AssistantReply(
          sessionId: 'sess-100',
          sessionReset: false,
          type: AssistantReplyType.confirmation,
          message: 'تأكيد منتهي؟',
          pendingAction: AssistantPendingAction(
            actionId: 'act-expired',
            intent: 'sale',
            summary: 'ملخص',
            expiresAt: DateTime.now().subtract(const Duration(seconds: 10)),
          ),
        ),
      );

      await cubit.sendText('أمر');
      await cubit.confirm();

      expect(fakeRepo.confirmActionCallCount, 0);
      expect(cubit.state.flowState, isA<ErrorState>());
    });

    test('Handles 429 rate limit correctly', () async {
      fakeRepo.sendCommandResult = Left<Failure, AssistantReply>(
        Failure(429, 'Too many requests'),
      );

      await cubit.sendText('أمر متكرر');

      expect(cubit.state.isRateLimited, true);
      expect(cubit.state.lastFailedText, 'أمر متكرر');
    });

    test('Network failure in confirm does not auto-retry', () async {
      fakeRepo.sendCommandResult = Right<Failure, AssistantReply>(
        AssistantReply(
          sessionId: 'sess-100',
          sessionReset: false,
          type: AssistantReplyType.confirmation,
          message: 'تأكيد؟',
          pendingAction: AssistantPendingAction(
            actionId: 'act-3',
            intent: 'sale',
            summary: 'ملخص',
            expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          ),
        ),
      );

      await cubit.sendText('أمر');

      fakeRepo.confirmActionResult = Left<Failure, AssistantReply>(
        Failure(503, 'Network unavailable'),
      );

      await cubit.confirm();

      expect(fakeRepo.confirmActionCallCount, 1);
      expect(cubit.state.isExecutingAction, false);
      expect(cubit.state.flowState, isA<ErrorState>());
    });

    test('Session reset in response raises sessionResetNotice flag', () async {
      fakeRepo.sendCommandResult = const Right<Failure, AssistantReply>(
        AssistantReply(
          sessionId: 'sess-new',
          sessionReset: true,
          type: AssistantReplyType.answer,
          message: 'بدأنا محادثة جديدة',
        ),
      );

      await cubit.sendText('ابدأ من جديد');

      expect(cubit.state.sessionResetNotice, true);
      expect(cubit.state.currentSessionId, 'sess-new');

      cubit.clearSessionResetNotice();
      expect(cubit.state.sessionResetNotice, false);
    });

    test('Cancel action cancels pending action and adds cancelled message', () async {
      fakeRepo.sendCommandResult = Right<Failure, AssistantReply>(
        AssistantReply(
          sessionId: 'sess-100',
          sessionReset: false,
          type: AssistantReplyType.confirmation,
          message: 'تأكيد؟',
          pendingAction: AssistantPendingAction(
            actionId: 'act-4',
            intent: 'sale',
            summary: 'ملخص',
            expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          ),
        ),
      );

      await cubit.sendText('أمر');
      await cubit.cancel();

      expect(fakeRepo.cancelActionCallCount, 1);
      expect(cubit.state.pendingAction, isNull);
      expect(cubit.state.messages.last.type, AssistantReplyType.cancelled);
    });

    test('sendText ignores if already sending', () async {
      // Simulate sending state
      cubit.emit(
        cubit.state.copyWith(
          flowState: LoadingState(
            stateRendererType: StateRendererType.popupLoadingState,
          ),
        ),
      );

      await cubit.sendText('أمر أثناء الإرسال');
      expect(fakeRepo.sendCommandCallCount, 0);
    });

    test('retryLast does not duplicate user message and clears isFailed flag on success', () async {
      // 1. Initial send that fails
      fakeRepo.sendCommandResult = Left<Failure, AssistantReply>(
        Failure(500, 'Server down'),
      );

      await cubit.sendText('أمر تجريبي للـ retry');
      expect(cubit.state.messages.length, 1);
      expect(cubit.state.messages.first.isFailed, true);
      expect(cubit.state.lastFailedText, 'أمر تجريبي للـ retry');

      // 2. Retry with success
      fakeRepo.sendCommandResult = const Right<Failure, AssistantReply>(
        AssistantReply(
          sessionId: 'sess-100',
          sessionReset: false,
          type: AssistantReplyType.answer,
          message: 'تم بنجاح بعد المحاولة',
        ),
      );

      await cubit.retryLast();

      // Total messages should be 2 (1 user message not duplicated + 1 assistant reply)
      expect(cubit.state.messages.length, 2);
      expect(cubit.state.messages.first.isFailed, false);
      expect(cubit.state.lastFailedText, isNull);
    });

    test('isRateLimited resets on next successful send', () async {
      // 1. Send triggers 429
      fakeRepo.sendCommandResult = Left<Failure, AssistantReply>(
        Failure(429, 'Rate limit'),
      );
      await cubit.sendText('أمر 1');
      expect(cubit.state.isRateLimited, true);

      // 2. Next send succeeds -> rate limit cleared
      fakeRepo.sendCommandResult = const Right<Failure, AssistantReply>(
        AssistantReply(
          sessionId: 'sess-100',
          sessionReset: false,
          type: AssistantReplyType.answer,
          message: 'نجح',
        ),
      );
      await cubit.retryLast();
      expect(cubit.state.isRateLimited, false);
      expect(cubit.state.rateLimitMessage, isNull);
    });

    test('pendingAction expiration timer fires and emits state received by listener', () async {
      final List<AssistantChatState> emitted = <AssistantChatState>[];
      final subscription = cubit.stream.listen(emitted.add);

      // Send command returning confirmation that expires in 50ms
      fakeRepo.sendCommandResult = Right<Failure, AssistantReply>(
        AssistantReply(
          sessionId: 'sess-100',
          sessionReset: false,
          type: AssistantReplyType.confirmation,
          message: 'تأكيد سريع؟',
          pendingAction: AssistantPendingAction(
            actionId: 'act-fast-expire',
            intent: 'test',
            summary: 'سريع',
            expiresAt: DateTime.now().add(const Duration(milliseconds: 50)),
          ),
        ),
      );

      await cubit.sendText('أمر تأكيد سريع');
      expect(cubit.state.isActionExpired, false);
      expect(cubit.state.isPendingExpired, false);

      // Wait 100ms for expiration timer to fire
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(cubit.state.isActionExpired, true);
      expect(cubit.state.expiredActionId, 'act-fast-expire');
      expect(cubit.state.isPendingExpired, true);
      // Verify that the listener actually received the state with isActionExpired and expiredActionId
      expect(
        emitted.any(
          (AssistantChatState s) =>
              s.isActionExpired == true &&
              s.expiredActionId == 'act-fast-expire',
        ),
        true,
      );

      await subscription.cancel();
    });

    test('copyWith(rateLimitMessage: null) clears rateLimitMessage value', () {
      AssistantChatState state = const AssistantChatState(rateLimitMessage: 'تم التجاوز');
      expect(state.rateLimitMessage, 'تم التجاوز');

      state = state.copyWith(rateLimitMessage: null);
      expect(state.rateLimitMessage, isNull);
    });
  });
}
