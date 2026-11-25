import 'package:flutter/foundation.dart';

/// Available UI states for voice interaction in "يا ميزان"
enum VoiceUiState {
  idle,
  listening,
  silenceCountdown,
  thinking,
  speaking,
  editing,
  error;

  /// User-facing descriptive Arabic status text
  String get arabicLabel {
    switch (this) {
      case VoiceUiState.listening:
        return 'بسمعك… تكلّم الآن';
      case VoiceUiState.silenceCountdown:
      case VoiceUiState.thinking:
        return 'ثانية واحدة...';
      case VoiceUiState.speaking:
        return 'بتكلم…';
      case VoiceUiState.editing:
        return 'راجع الكلام وعدّل لو عايز';
      case VoiceUiState.error:
        return 'حصلت مشكلة، جرّب تاني';
      case VoiceUiState.idle:
        return 'مساعدك الذكي في حسابات المحل';
    }
  }
}

/// AssistantUiSignals — Lightweight ValueNotifier bridge between voice/chat layers and the UI
class AssistantUiSignals {
  final ValueNotifier<VoiceUiState> voiceState =
      ValueNotifier<VoiceUiState>(VoiceUiState.idle);

  /// Normalized sound level 0.0 .. 1.0 (throttled to <= 30 updates/sec)
  final ValueNotifier<double> soundLevel = ValueNotifier<double>(0.0);

  /// Auto-send countdown progress 0.0 .. 1.0
  final ValueNotifier<double> countdown = ValueNotifier<double>(0.0);

  void dispose() {
    voiceState.dispose();
    soundLevel.dispose();
    countdown.dispose();
  }
}
