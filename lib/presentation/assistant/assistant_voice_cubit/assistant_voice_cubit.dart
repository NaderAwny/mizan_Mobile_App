import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/app/assistant_audio_service.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/app/domain_text_normalizer.dart';
import 'package:mizan/app/speech_recognition_service.dart';
import 'package:mizan/presentation/assistant/assistant_voice_cubit/assistant_voice_state.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable
class AssistantVoiceCubit extends Cubit<AssistantVoiceState> {
  final SpeechRecognitionService _speechService;
  final AssistantAudioService? _audioService;
  final DomainTextNormalizer _normalizer;

  Timer? _autoSendTimer;
  Duration autoSendDuration;
  bool autoSendEnabled;

  String _latestRecognizedText = '';
  String _prefixText = '';

  bool _greetingPlayed = false;
  bool _micPermissionGranted = false;
  int _flowToken = 0;

  AssistantVoiceCubit(
    this._speechService, {
    AssistantAudioService? audioService,
    DomainTextNormalizer? normalizer,
  })  : _audioService = audioService ??
            (getIt.isRegistered<AssistantAudioService>()
                ? getIt<AssistantAudioService>()
                : null),
        _normalizer = normalizer ??
            (getIt.isRegistered<DomainTextNormalizer>()
                ? getIt<DomainTextNormalizer>()
                : DomainTextNormalizer()),
        autoSendDuration = const Duration(milliseconds: 1500),
        autoSendEnabled = false,
        super(const AssistantVoiceState.idle());

  DateTime _lastLevelAt = DateTime.fromMillisecondsSinceEpoch(0);

  /// Pre-warms STT engine (if mic permission already granted) and preloads welcome audio
  Future<void> preWarm() async {
    final Future<void>? audioFuture = _audioService?.preload();
    bool hasPerm = false;
    try {
      hasPerm = await Permission.microphone.isGranted;
    } catch (_) {
      hasPerm = false;
    }
    _micPermissionGranted = hasPerm;

    await Future.wait(<Future<void>>[
      if (hasPerm) _speechService.preWarm(),
      ?audioFuture,
    ]);
  }

  /// Main entry point when user taps the Mic or Orb.
  Future<void> onMicTap({bool Function()? isMicBusyChecker}) async {
    final Stopwatch tapSw = Stopwatch()..start();

    final bool isListening = state.maybeWhen(
      listening: (_, _) => true,
      orElse: () => false,
    );
    if (isListening) {
      await stopListening();
      return;
    }

    final bool isGreeting = state.maybeWhen(
      greeting: () => true,
      orElse: () => false,
    );
    if (isGreeting) {
      await interruptGreeting(isMicBusyChecker: isMicBusyChecker);
      return;
    }

    if (isMicBusyChecker != null && isMicBusyChecker()) {
      _audioService?.playError();
      emit(
        const AssistantVoiceState.error(
          kind: AssistantVoiceErrorKind.microphoneBusy,
          customMessage: AppStrings.assistantMicBusy,
        ),
      );
      return;
    }

    // Fast path: if mic permission already verified during preWarm, do NOT await Permission channel!
    if (!_micPermissionGranted) {
      final bool granted = await _ensurePermission();
      if (!granted) return;
      // Ensure STT initialized right after first-time permission grant
      await _speechService.preWarm();
    }

    if (!_greetingPlayed) {
      _greetingPlayed = true;
      final int token = ++_flowToken;
      emit(const AssistantVoiceState.greeting());

      debugPrint('[Perf] Tap -> playWelcome call: ${tapSw.elapsedMilliseconds}ms');
      await _audioService?.playWelcome(
        onComplete: () {
          final Stopwatch handoffSw = Stopwatch()..start();
          if (isClosed || _flowToken != token) return;
          debugPrint('[Perf] Welcome onComplete -> starting STT (handoff ${handoffSw.elapsedMilliseconds}ms)');
          _startActualListening(isMicBusyChecker: isMicBusyChecker);
        },
      );
    } else {
      await _startActualListening(isMicBusyChecker: isMicBusyChecker);
    }
  }

  /// Interrupts ongoing welcome audio immediately and starts listening.
  Future<void> interruptGreeting({bool Function()? isMicBusyChecker}) async {
    final bool isGreeting = state.maybeWhen(
      greeting: () => true,
      orElse: () => false,
    );
    if (!isGreeting) return;
    _flowToken++;
    await _audioService?.stopWelcome();
    await _startActualListening(isMicBusyChecker: isMicBusyChecker);
  }

  /// Starts speech recognition directly (no greeting, no beep)
  Future<void> startListening({
    bool Function()? isMicBusyChecker,
    bool isAppend = false,
  }) async {
    if (isMicBusyChecker != null && isMicBusyChecker()) {
      _audioService?.playError();
      emit(
        const AssistantVoiceState.error(
          kind: AssistantVoiceErrorKind.microphoneBusy,
          customMessage: AppStrings.assistantMicBusy,
        ),
      );
      return;
    }
    if (!_micPermissionGranted) {
      final bool granted = await _ensurePermission();
      if (!granted) return;
    }
    await _startActualListening(
      isMicBusyChecker: isMicBusyChecker,
      isAppend: isAppend,
    );
  }

  Future<void> _startActualListening({
    bool Function()? isMicBusyChecker,
    bool isAppend = false,
  }) async {
    if (isClosed) return;
    _cancelTimer();

    if (!isAppend) {
      _prefixText = '';
      _latestRecognizedText = '';
    }

    if (isMicBusyChecker != null && isMicBusyChecker()) {
      _audioService?.playError();
      emit(
        const AssistantVoiceState.error(
          kind: AssistantVoiceErrorKind.microphoneBusy,
          customMessage: AppStrings.assistantMicBusy,
        ),
      );
      return;
    }

    final bool initialized = await _speechService.initialize(
      onStatus: (String status) {
        if (isClosed) return;
        if (status == 'done' || status == 'notListening') {
          final bool stillListening = state.maybeWhen(
            listening: (_, _) => true,
            orElse: () => false,
          );
          if (stillListening) {
            stopListening();
          }
        }
      },
      onError: (dynamic error) {
        if (isClosed) return;
        final String msg = error?.toString() ?? '';
        if (msg.contains('error_no_match') || msg.contains('error_speech_timeout')) {
          final bool stillListening = state.maybeWhen(
            listening: (_, _) => true,
            orElse: () => false,
          );
          if (stillListening) {
            if (_latestRecognizedText.trim().isNotEmpty) {
              stopListening();
            } else {
              emit(
                const AssistantVoiceState.error(
                  kind: AssistantVoiceErrorKind.generic,
                  customMessage: 'مسمعتش حاجة، جرّب تاني',
                ),
              );
            }
          }
          return;
        }
        _audioService?.playError();
        emit(
          AssistantVoiceState.error(
            kind: AssistantVoiceErrorKind.generic,
            customMessage: msg.isNotEmpty ? msg : null,
          ),
        );
      },
    );

    if (!initialized) {
      _audioService?.playError();
      if (!isClosed) {
        emit(
          const AssistantVoiceState.error(
            kind: AssistantVoiceErrorKind.initFailed,
            customMessage: AppStrings.assistantSpeechInitError,
          ),
        );
      }
      return;
    }

    if (isClosed) return;
    emit(AssistantVoiceState.listening(partialText: _prefixText));

    final bool started = await _speechService.startListening(
      onResult: (String partialText) {
        if (isClosed) return;
        final String processed = _normalizer.process(partialText);
        final String combined = _prefixText.isEmpty
            ? processed
            : '$_prefixText $processed'.trim();
        _latestRecognizedText = combined;
        emit(
          AssistantVoiceState.listening(
            partialText: combined,
          ),
        );
      },
      onSoundLevel: (double level) {
        if (isClosed) return;
        final DateTime now = DateTime.now();
        if (now.difference(_lastLevelAt).inMilliseconds < 33) return;
        _lastLevelAt = now;
        state.maybeWhen(
          listening: (String text, _) {
            emit(
              AssistantVoiceState.listening(
                partialText: text,
                soundLevel: level,
              ),
            );
          },
          orElse: () {},
        );
      },
    );

    if (!started && !isClosed) {
      _audioService?.playError();
      emit(
        const AssistantVoiceState.error(
          kind: AssistantVoiceErrorKind.notAvailable,
        ),
      );
    }
  }

  Future<bool> _ensurePermission() async {
    emit(const AssistantVoiceState.requestingPermission());
    final PermissionStatus status = await Permission.microphone.status;
    if (status.isPermanentlyDenied) {
      _audioService?.playError();
      emit(const AssistantVoiceState.permissionDenied(isPermanent: true));
      return false;
    }

    if (!status.isGranted) {
      final PermissionStatus requestResult =
          await Permission.microphone.request();
      if (requestResult.isPermanentlyDenied) {
        _audioService?.playError();
        emit(const AssistantVoiceState.permissionDenied(isPermanent: true));
        return false;
      }
      if (!requestResult.isGranted) {
        _audioService?.playError();
        emit(const AssistantVoiceState.permissionDenied(isPermanent: false));
        return false;
      }
    }

    _micPermissionGranted = true;
    return true;
  }

  /// Appends to current text instead of clearing
  Future<void> appendSpeech({bool Function()? isMicBusyChecker}) async {
    _prefixText = _latestRecognizedText.trim();
    await startListening(
      isMicBusyChecker: isMicBusyChecker,
      isAppend: true,
    );
  }

  /// Clears text and re-records from scratch
  Future<void> reRecord({bool Function()? isMicBusyChecker}) async {
    _prefixText = '';
    _latestRecognizedText = '';
    await startListening(
      isMicBusyChecker: isMicBusyChecker,
      isAppend: false,
    );
  }

  /// Stops speech listening and enters reviewing
  Future<void> stopListening() async {
    _cancelTimer();
    await _speechService.stopListening();
    _audioService?.playListeningEnd();

    if (isClosed) return;
    final String finalSnippet = _latestRecognizedText.trim();
    if (finalSnippet.isEmpty) {
      emit(const AssistantVoiceState.idle());
      return;
    }

    emit(AssistantVoiceState.reviewing(recognizedText: finalSnippet));

    if (autoSendEnabled) {
      _autoSendTimer = Timer(autoSendDuration, () {
        sendReviewedText();
      });
    }
  }

  /// Toggles between listening and stopping/reviewing
  Future<void> toggleListening({
    bool Function()? isMicBusyChecker,
  }) async {
    state.maybeWhen(
      listening: (_, _) => stopListening(),
      orElse: () => onMicTap(
        isMicBusyChecker: isMicBusyChecker,
      ),
    );
  }

  /// Updates the reviewed text manually (cancels auto-send timer)
  void updateReviewText(String newText) {
    _cancelTimer();
    _latestRecognizedText = newText;
    emit(
      AssistantVoiceState.reviewing(
        recognizedText: newText,
        autoSendCountdown: 0.0,
      ),
    );
  }

  /// Cancels reviewing and returns to idle without sending
  void cancelReview() {
    _cancelTimer();
    _latestRecognizedText = '';
    _prefixText = '';
    emit(const AssistantVoiceState.idle());
  }

  /// Cancels active listening or greeting immediately without sending
  Future<void> cancelListening() async {
    _cancelTimer();
    _flowToken++;
    await _audioService?.stopWelcome();
    _latestRecognizedText = '';
    _prefixText = '';
    await _speechService.cancelListening();
    if (!isClosed) emit(const AssistantVoiceState.idle());
  }

  /// Emits readyToSend state with the recognized text, then resets to idle
  void sendReviewedText() {
    _cancelTimer();
    final String textToSend = _latestRecognizedText.trim();
    _latestRecognizedText = '';
    _prefixText = '';

    if (textToSend.isNotEmpty && !isClosed) {
      emit(AssistantVoiceState.readyToSend(textToSend));
    }
    if (!isClosed) emit(const AssistantVoiceState.idle());
  }

  void _cancelTimer() {
    _autoSendTimer?.cancel();
    _autoSendTimer = null;
  }

  @override
  Future<void> close() {
    _cancelTimer();
    _flowToken++;
    _audioService?.stopWelcome();
    _speechService.dispose();
    return super.close();
  }
}
