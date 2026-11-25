import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'voice_notes_summary_state.freezed.dart';

@freezed
abstract class VoiceNotesSummaryState with _$VoiceNotesSummaryState {
  const factory VoiceNotesSummaryState({
    FlowState? flowState,
    VoiceNoteSummaryModel? summary,
    @Default('today') String selectedPeriod,
    String? customFrom,
    String? customTo,
    @Default(true) bool isBalanceVisible,
  }) = _VoiceNotesSummaryState;
}
