import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/domain/use_case/get_voice_note_by_id_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/voice_note/get_voice_note_by_id_cubit/get_voice_note_by_id_state.dart';

@injectable
class GetVoiceNoteByIdCubit extends Cubit<GetVoiceNoteByIdState> {
  final GetVoiceNoteByIdUseCase _getVoiceNoteByIdUseCase;

  GetVoiceNoteByIdCubit(this._getVoiceNoteByIdUseCase)
    : super(const GetVoiceNoteByIdState());

  Future<void> getVoiceNoteById(String id) async {
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
          title: AppStrings.loading,
          message: "جاري تحميل المذكرة الصوتية...",
        ),
      ),
    );

    final result = await _getVoiceNoteByIdUseCase.execute(id);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.fullScreenErrorState,
              failure.message,
              title: "تعذر تحميل المذكرة الصوتية",
            ),
          ),
        );
      },
      (voiceNote) {
        if (isClosed) return;
        emit(state.copyWith(data: voiceNote, flowState: ContentState()));
      },
    );
  }
}
