import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'get_voice_note_by_id_state.freezed.dart';

@freezed
abstract class GetVoiceNoteByIdState with _$GetVoiceNoteByIdState {
  const factory GetVoiceNoteByIdState({
    FlowState? flowState,
    VoiceNoteModel? data,
  }) = _GetVoiceNoteByIdState;
}
