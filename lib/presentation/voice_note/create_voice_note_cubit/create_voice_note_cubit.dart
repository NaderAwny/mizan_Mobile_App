import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/request/voice_note_request.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/domain/use_case/create_voice_note_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/voice_note/create_voice_note_cubit/create_voice_note_state.dart';

@injectable
class VoiceNoteFormCubit extends Cubit<VoiceNoteFormState> {
  final CreateVoiceNoteUseCase _createVoiceNoteUseCase;

  VoiceNoteFormCubit(this._createVoiceNoteUseCase)
    : super(const VoiceNoteFormState());

  Timer? _recordTimer;

  void startRecordingTimer() {
    _recordTimer?.cancel();
    emit(state.copyWith(isRecording: true, recordSeconds: 0));
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      emit(state.copyWith(recordSeconds: state.recordSeconds + 1));
    });
  }

  void stopRecordingTimer(String? audioPath) {
    _recordTimer?.cancel();
    emit(state.copyWith(isRecording: false, recordedAudioPath: audioPath));
  }

  void resetRecording() {
    _recordTimer?.cancel();
    emit(
      state.copyWith(
        isRecording: false,
        recordSeconds: 0,
        recordedAudioPath: null,
        isPlayingPreview: false,
        previewProgress: 0.0,
        totalAudioDuration: Duration.zero,
      ),
    );
  }

  void setOperationType(String type) {
    emit(state.copyWith(operationType: type));
  }

  void setContact({String? contactId, String? partyName, bool isVip = false}) {
    emit(
      state.copyWith(
        contactId: contactId,
        partyName: partyName,
        isPartyVip: isVip,
      ),
    );
  }

  void setOperationDate(DateTime date) {
    emit(state.copyWith(operationDate: date));
  }

  void updatePlayback({bool? isPlaying, double? progress, Duration? duration}) {
    emit(
      state.copyWith(
        isPlayingPreview: isPlaying ?? state.isPlayingPreview,
        previewProgress: progress ?? state.previewProgress,
        totalAudioDuration: duration ?? state.totalAudioDuration,
      ),
    );
  }

  /// بترجع أول رسالة خطأ لو فيه، أو null لو البيانات سليمة.
  Future<String?> _validate(CreateVoiceNoteRequest request) async {
    if (!await request.audioFile.exists()) {
      return "ملف التسجيل الصوتي غير موجود";
    }
    if (request.amount <= 0) {
      return "المبلغ يجب أن يكون أكبر من صفر";
    }
    final bool hasContact =
        request.contactId != null && request.contactId!.isNotEmpty;
    final bool hasPartyName =
        request.partyName != null && request.partyName!.trim().isNotEmpty;
    if (!hasContact && !hasPartyName) {
      return "يجب تحديد الطرف الثاني أو كتابة اسمه";
    }
    return null;
  }

  Future<void> submit(CreateVoiceNoteRequest request) async {
    final String? validationError = await _validate(request);

    if (validationError != null) {
      if (isClosed) return;
      emit(
        state.copyWith(
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            validationError,
            title: "تعذر حفظ الملاحظة الصوتية",
          ),
        ),
      );
      return;
    }
    if (isClosed) return;

    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          message: "جاري رفع الملاحظة الصوتية...",
        ),
        isActionSuccess: false,
      ),
    );

    final Either<Failure, VoiceNoteModel> result = await _createVoiceNoteUseCase
        .execute(request);

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: "تعذر حفظ الملاحظة الصوتية",
            ),
          ),
        );
      },
      (VoiceNoteModel voiceNote) {
        if (isClosed) return;
        emit(
          state.copyWith(
            savedVoiceNote: voiceNote,
            isActionSuccess: true,
            flowState: ContentState(),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _recordTimer?.cancel();
    return super.close();
  }
}
