import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/request/voice_note_request.dart';
import 'package:mizan/domain/use_case/create_voice_note_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/voice_note/create_voice_note_cubit/create_voice_note_state.dart';

@injectable
class VoiceNoteFormCubit extends Cubit<VoiceNoteFormState> {
  final CreateVoiceNoteUseCase _createVoiceNoteUseCase;

  VoiceNoteFormCubit(this._createVoiceNoteUseCase)
    : super(const VoiceNoteFormState());

  /// بترجع أول رسالة خطأ لو فيه، أو null لو البيانات سليمة.
  Future<String?> _validate(CreateVoiceNoteRequest request) async {
    if (!await request.audioFile.exists()) {
      return "ملف التسجيل الصوتي غير موجود";
    }
    if (request.amount <= 0) {
      return "المبلغ يجب أن يكون أكبر من صفر";
    }
    final hasContact =
        request.contactId != null && request.contactId!.isNotEmpty;
    final hasPartyName =
        request.partyName != null && request.partyName!.trim().isNotEmpty;
    if (!hasContact && !hasPartyName) {
      return "يجب تحديد الطرف الثاني أو كتابة اسمه";
    }
    return null;
  }

  Future<void> submit(CreateVoiceNoteRequest request) async {
    final validationError = await _validate(request);

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

    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          message: "جاري رفع الملاحظة الصوتية...",
        ),
        isActionSuccess: false,
      ),
    );

    final result = await _createVoiceNoteUseCase.execute(request);

    result.fold(
      (failure) {
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
      (voiceNote) {
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
}
