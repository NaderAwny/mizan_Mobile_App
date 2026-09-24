import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/domain/use_case/get_list_transaction_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/transactions/get_list_transaction/get_list_transaction_state.dart';

@injectable
class GetListTransactionCubit extends Cubit<GetListTransactionState> {
  final GetListTransactionsUseCase _getListTransactionsUseCase;

  GetListTransactionCubit(this._getListTransactionsUseCase)
    : super(const GetListTransactionState());

  int currentPage = 1;
  final int pageSize = 20;
  Timer? _debounceTimer;

  Future<void> getListTransactions({
    String? type,
    String? contactId,
    String? dateFrom,
    String? dateTo,
  }) async {
    currentPage = 1;
    final isInitialLoad = state.data == null;

    final targetType = type ?? state.type;
    final targetContactId = contactId ?? state.contactId;
    final targetDateFrom = dateFrom ?? state.dateFrom;
    final targetDateTo = dateTo ?? state.dateTo;

    if (isInitialLoad) {
      emit(
        state.copyWith(
          flowState: LoadingState(
            stateRendererType: StateRendererType.fullScreenLoadingState,
            title: AppStrings.loading,
            message: "جاري جلب قائمة المعاملات...",
          ),
          type: targetType,
          contactId: targetContactId,
          dateFrom: targetDateFrom,
          dateTo: targetDateTo,
          hasMore: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: targetType,
          contactId: targetContactId,
          dateFrom: targetDateFrom,
          dateTo: targetDateTo,
          hasMore: true,
        ),
      );
    }

    final result = await _getListTransactionsUseCase.execute(
      GetListTransactionsParams(
        page: 1,
        pageSize: pageSize,
        contactId: targetContactId,
        type: targetType,
        dateFrom: targetDateFrom,
        dateTo: targetDateTo,
      ),
    );

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.fullScreenErrorState,
              failure.message,
              title: "تعذر تحميل قائمة المعاملات",
            ),
          ),
        );
      },
      (page) {
        if (isClosed) return;
        currentPage = page.page;
        emit(
          state.copyWith(
            flowState: page.items.isEmpty
                ? EmptyState(AppStrings.noTransactionsTitle)
                : ContentState(),
            data: page.items,
            hasMore: page.hasNextPage,
          ),
        );
      },
    );
  }

  void searchTransactions(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!isClosed) {
        emit(state.copyWith(searchQuery: query.trim()));
      }
    });
  }

  void changeFilterType(String? type) {
    emit(state.copyWith(type: type));
    getListTransactions(type: type);
  }

  Future<void> loadMoreTransactions() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final int nextPage = currentPage + 1;

    final result = await _getListTransactionsUseCase.execute(
      GetListTransactionsParams(
        page: nextPage,
        pageSize: pageSize,
        contactId: state.contactId,
        type: state.type,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
      ),
    );

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(state.copyWith(isLoadingMore: false));
      },
      (page) {
        if (isClosed) return;
        currentPage = nextPage;
        final currentItems = state.data ?? [];
        final updatedItems = [...currentItems, ...page.items];
        emit(
          state.copyWith(
            data: updatedItems,
            isLoadingMore: false,
            hasMore: page.hasNextPage,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
