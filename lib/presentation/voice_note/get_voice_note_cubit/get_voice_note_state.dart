import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'get_voice_note_state.freezed.dart';

@freezed
abstract class GetListVoiceNotesState with _$GetListVoiceNotesState {
  const factory GetListVoiceNotesState({
    FlowState? flowState,
    List<VoiceNoteModel>? data,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
  }) = _GetListVoiceNotesState;
}
