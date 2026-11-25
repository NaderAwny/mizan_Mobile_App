import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'create_voice_note_state.freezed.dart';

@freezed
abstract class VoiceNoteFormState with _$VoiceNoteFormState {
  const factory VoiceNoteFormState({
    FlowState? flowState,

    VoiceNoteModel? savedVoiceNote,
    @Default(false) bool isActionSuccess,
    @Default('sale') String operationType,
    String? contactId,
    String? partyName,
    @Default(false) bool isPartyVip,
    DateTime? operationDate,
    @Default(false) bool isRecording,
    @Default(0) int recordSeconds,
    String? recordedAudioPath,
    @Default(false) bool isPlayingPreview,
    @Default(0.0) double previewProgress,
    @Default(Duration.zero) Duration totalAudioDuration,
  }) = _VoiceNoteFormState;
}
