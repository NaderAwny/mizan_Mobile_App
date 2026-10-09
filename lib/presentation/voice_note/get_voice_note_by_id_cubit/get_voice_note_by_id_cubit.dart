import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/domain/use_case/delete_voice_note_use_case.dart';
import 'package:mizan/domain/use_case/get_voice_note_by_id_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/voice_note/get_voice_note_by_id_cubit/get_voice_note_by_id_state.dart';

@injectable
class GetVoiceNoteByIdCubit extends Cubit<GetVoiceNoteByIdState> {
  final GetVoiceNoteByIdUseCase _getVoiceNoteByIdUseCase;
  final DeleteVoiceNoteUseCase _deleteVoiceNoteUseCase;

  GetVoiceNoteByIdCubit(
    this._getVoiceNoteByIdUseCase,
    this._deleteVoiceNoteUseCase,
  ) : super(const GetVoiceNoteByIdState());

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

    final Either<Failure, VoiceNoteModel> result =
        await _getVoiceNoteByIdUseCase.execute(id);

    result.fold(
      (Failure failure) {
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
      (VoiceNoteModel voiceNote) {
        if (isClosed) return;
        emit(state.copyWith(data: voiceNote, flowState: ContentState()));
      },
    );
  }

  void updatePlayback({
    bool? isPlaying,
    Duration? currentPosition,
    Duration? totalDuration,
  }) {
    emit(
      state.copyWith(
        isPlaying: isPlaying ?? state.isPlaying,
        currentPosition: currentPosition ?? state.currentPosition,
        totalDuration: totalDuration ?? state.totalDuration,
      ),
    );
  }

  Future<bool> deleteVoiceNote() async {
    final VoiceNoteModel? voiceNote = state.data;
    if (voiceNote == null) return false;
    if (isClosed) return true;

    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          title: "جاري الحذف",
          message: "جاري حذف العملية الصوتيه...",
        ),
      ),
    );

    final Either<Failure, void> result = await _deleteVoiceNoteUseCase.execute(
      voiceNote.id,
    );

    return result.fold(
      (Failure failure) {
        if (isClosed) return false;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: "فشل الحذف",
            ),
          ),
        );
        return false;
      },
      (_) {
        if (isClosed) return true;
        emit(state.copyWith(isDeleted: true, flowState: ContentState()));
        return true;
      },
    );
  }
}
