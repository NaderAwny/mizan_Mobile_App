import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistant_voice_state.freezed.dart';

enum AssistantVoiceErrorKind {
  microphoneBusy,
  permissionDenied,
  permissionPermanentlyDenied,
  initFailed,
  notAvailable,
  generic,
}

@freezed
abstract class AssistantVoiceState with _$AssistantVoiceState {
  const factory AssistantVoiceState.idle() = _Idle;
  const factory AssistantVoiceState.requestingPermission() = _RequestingPermission;
  const factory AssistantVoiceState.permissionDenied({
    @Default(false) bool isPermanent,
  }) = _PermissionDenied;
  const factory AssistantVoiceState.greeting() = _Greeting;
  const factory AssistantVoiceState.listening({
    @Default('') String partialText,
    @Default(0.0) double soundLevel,
  }) = _Listening;
  const factory AssistantVoiceState.reviewing({
    required String recognizedText,
    @Default(1.5) double autoSendCountdown,
  }) = _Reviewing;
  const factory AssistantVoiceState.readyToSend(String text) = _ReadyToSend;
  const factory AssistantVoiceState.error({
    required AssistantVoiceErrorKind kind,
    String? customMessage,
  }) = _VoiceError;
}
