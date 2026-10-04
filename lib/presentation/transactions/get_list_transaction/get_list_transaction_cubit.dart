import 'package:dartz/dartz.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/get_list_transactions_model.dart';
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
    final bool isInitialLoad = state.data == null;

    final String? targetType = type ?? state.type;
    final String? targetContactId = contactId ?? state.contactId;
    final String? targetDateFrom = dateFrom ?? state.dateFrom;
    final String? targetDateTo = dateTo ?? state.dateTo;

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

    final Either<Failure, GetListTransactionsPage> result =
        await _getListTransactionsUseCase.execute(
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
      (Failure failure) {
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
      (GetListTransactionsPage page) {
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

  void selectFilter(int index, String? type) {
    emit(state.copyWith(selectedFilterIndex: index, type: type));
    getListTransactions(type: type);
  }

  void changeFilterType(String? type) {
    emit(state.copyWith(type: type));
    getListTransactions(type: type);
  }

  Future<void> loadMoreTransactions() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final int nextPage = currentPage + 1;

    final Either<Failure, GetListTransactionsPage> result =
        await _getListTransactionsUseCase.execute(
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
      (Failure failure) {
        if (isClosed) return;
        emit(state.copyWith(isLoadingMore: false));
      },
      (GetListTransactionsPage page) {
        if (isClosed) return;
        currentPage = nextPage;
        final List<GetListTransactionsModel> currentItems =
            state.data ?? <GetListTransactionsModel>[];
        final List<GetListTransactionsModel> updatedItems =
            <GetListTransactionsModel>[...currentItems, ...page.items];
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
