import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/app/speech_recognition_service.dart';
import 'package:mizan/presentation/assistant/assistant_voice_cubit/assistant_voice_cubit.dart';
import 'package:mizan/presentation/assistant/assistant_voice_cubit/assistant_voice_state.dart';

class FakeSpeechRecognitionService implements SpeechRecognitionService {
  bool initialized = true;
  bool isListeningState = false;
  void Function(String partialText)? onResultCallback;
  void Function(double soundLevel)? onSoundLevelCallback;
  int stopCallCount = 0;
  int cancelCallCount = 0;
  int disposeCallCount = 0;

  @override
  bool get isListening => isListeningState;

  @override
  Future<void> preWarm() async {}

  @override
  Future<bool> initialize({
    void Function(String status)? onStatus,
    void Function(dynamic error)? onError,
  }) async {
    return initialized;
  }

  @override
  Future<List<String>> getSupportedLocales() async {
    return <String>['ar_EG', 'ar_SA', 'en_US'];
  }

  @override
  Future<String> selectBestArabicLocale() async {
    return 'ar_EG';
  }

  @override
  Future<bool> startListening({
    required void Function(String partialText) onResult,
    void Function(double soundLevel)? onSoundLevel,
    String? localeId,
  }) async {
    isListeningState = true;
    onResultCallback = onResult;
    onSoundLevelCallback = onSoundLevel;
    return true;
  }

  @override
  Future<void> stopListening() async {
    stopCallCount++;
    isListeningState = false;
  }

  @override
  Future<void> cancelListening() async {
    cancelCallCount++;
    isListeningState = false;
  }

  @override
  void dispose() {
    disposeCallCount++;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeSpeechRecognitionService fakeSpeech;
  late AssistantVoiceCubit cubit;

  setUp(() {
    fakeSpeech = FakeSpeechRecognitionService();
    cubit = AssistantVoiceCubit(fakeSpeech)
      ..autoSendDuration = const Duration(milliseconds: 100);
  });

  tearDown(() {
    cubit.close();
  });

  group('AssistantVoiceCubit Tests', () {
    test('Initial state is idle', () {
      expect(cubit.state, const AssistantVoiceState.idle());
    });

    test('Detects busy microphone and emits error', () async {
      await cubit.startListening(isMicBusyChecker: () => true);

      cubit.state.maybeWhen(
        error: (AssistantVoiceErrorKind kind, _) {
          expect(kind, AssistantVoiceErrorKind.microphoneBusy);
        },
        orElse: () => fail('Expected error state'),
      );
    });

    test('Updating review text cancels auto-send timer', () async {
      final List<AssistantVoiceState> emittedStates = <AssistantVoiceState>[];
      final StreamSubscription<AssistantVoiceState> subscription =
          cubit.stream.listen(emittedStates.add);

      // Simulate entering review state
      cubit.updateReviewText('نص معدل يدوياً');

      cubit.state.maybeWhen(
        reviewing: (String text, double countdown) {
          expect(text, 'نص معدل يدوياً');
          expect(countdown, 0.0);
        },
        orElse: () => fail('Expected reviewing state'),
      );

      // Wait longer than autoSendDuration
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Should NOT have emitted readyToSend because timer was cancelled by update
      expect(
        emittedStates.any((AssistantVoiceState s) =>
            s.maybeWhen(readyToSend: (_) => true, orElse: () => false)),
        false,
      );
      await subscription.cancel();
    });

    test('Cancel listening resets to idle and calls service cancel', () async {
      await cubit.cancelListening();
      expect(cubit.state, const AssistantVoiceState.idle());
      expect(fakeSpeech.cancelCallCount, 1);
    });

    test('sendReviewedText emits readyToSend then idle', () async {
      final List<AssistantVoiceState> emittedStates = <AssistantVoiceState>[];
      final StreamSubscription<AssistantVoiceState> subscription =
          cubit.stream.listen(emittedStates.add);

      cubit.updateReviewText('أمر نهائي');
      cubit.sendReviewedText();
      await Future<void>.delayed(Duration.zero);

      expect(
        emittedStates.any((AssistantVoiceState s) =>
            s == const AssistantVoiceState.readyToSend('أمر نهائي')),
        true,
      );
      expect(cubit.state, const AssistantVoiceState.idle());
      await subscription.cancel();
    });
  });
}
