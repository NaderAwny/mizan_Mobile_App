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
  }) = _VoiceNoteFormState;
}
