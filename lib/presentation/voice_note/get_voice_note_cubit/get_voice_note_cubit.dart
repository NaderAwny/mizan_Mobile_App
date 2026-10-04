import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/voice_note_model/voice_note_model.dart';
import 'package:mizan/domain/use_case/get_list_voice_notes_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/voice_note/get_voice_note_cubit/get_voice_note_state.dart';

@injectable
class GetListVoiceNotesCubit extends Cubit<GetListVoiceNotesState> {
  final GetListVoiceNotesUseCase _getListVoiceNotesUseCase;

  GetListVoiceNotesCubit(this._getListVoiceNotesUseCase)
    : super(const GetListVoiceNotesState());

  int currentPage = 1;
  final int pageSize = 20;

  Future<void> getListVoiceNotes() async {
    currentPage = 1;
    final bool isInitialLoad = state.data == null;

    if (isInitialLoad) {
      emit(
        state.copyWith(
          flowState: LoadingState(
            stateRendererType: StateRendererType.fullScreenLoadingState,
            title: AppStrings.loading,
            message: "جاري جلب المذكرات الصوتية...",
          ),
          hasMore: true,
        ),
      );
    } else {
      emit(state.copyWith(hasMore: true));
    }

    final Either<Failure, VoiceNotesPage> result =
        await _getListVoiceNotesUseCase.execute(
          GetListVoiceNotesParams(page: 1, pageSize: pageSize),
        );

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.fullScreenErrorState,
              failure.message,
              title: "تعذر تحميل المذكرات الصوتية",
            ),
          ),
        );
      },
      (VoiceNotesPage page) {
        if (isClosed) return;
        currentPage = page.page;
        emit(
          state.copyWith(
            flowState: page.items.isEmpty
                ? EmptyState("لا توجد مذكرات صوتية بعد")
                : ContentState(),
            data: page.items,
            hasMore: page.hasNextPage,
          ),
        );
      },
    );
  }

  Future<void> loadMoreVoiceNotes() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final int nextPage = currentPage + 1;

    final Either<Failure, VoiceNotesPage> result =
        await _getListVoiceNotesUseCase.execute(
          GetListVoiceNotesParams(page: nextPage, pageSize: pageSize),
        );

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        emit(state.copyWith(isLoadingMore: false));
      },
      (VoiceNotesPage page) {
        if (isClosed) return;
        currentPage = nextPage;
        final List<VoiceNoteModel> currentItems =
            state.data ?? <VoiceNoteModel>[];
        emit(
          state.copyWith(
            data: <VoiceNoteModel>[...currentItems, ...page.items],
            isLoadingMore: false,
            hasMore: page.hasNextPage,
          ),
        );
      },
    );
  }
}
