import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/domain/use_case/get_voice_notes_summary_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/voice_note/voice_notes_summary_cubit/voice_notes_summary_state.dart';

@injectable
class VoiceNotesSummaryCubit extends Cubit<VoiceNotesSummaryState> {
  final GetVoiceNotesSummaryUseCase _getVoiceNotesSummaryUseCase;

  VoiceNotesSummaryCubit(this._getVoiceNotesSummaryUseCase)
      : super(const VoiceNotesSummaryState());

  Future<void> getSummary({
    String? period,
    String? from,
    String? to,
  }) async {
    final targetPeriod = period ?? state.selectedPeriod;
    final targetFrom =
        targetPeriod == 'custom' ? (from ?? state.customFrom) : null;
    final targetTo = targetPeriod == 'custom' ? (to ?? state.customTo) : null;

    if (isClosed) return;
    emit(
      state.copyWith(
        selectedPeriod: targetPeriod,
        customFrom: targetFrom,
        customTo: targetTo,
        flowState: LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
        ),
      ),
    );

    final result = await _getVoiceNotesSummaryUseCase.execute(
      GetVoiceNotesSummaryParams(
        period: targetPeriod,
        from: targetFrom,
        to: targetTo,
      ),
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          flowState: ErrorState(
            StateRendererType.fullScreenErrorState,
            failure.message,
          ),
        ),
      ),
      (summary) => emit(
        state.copyWith(
          flowState: ContentState(),
          summary: summary,
        ),
      ),
    );
  }

  void toggleBalanceVisibility() {
    if (isClosed) return;
    emit(state.copyWith(isBalanceVisible: !state.isBalanceVisible));
  }
}
