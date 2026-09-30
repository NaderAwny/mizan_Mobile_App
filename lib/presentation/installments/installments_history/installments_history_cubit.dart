import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/domain/use_case/get_installments_history_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/installments/installments_history/installments_history_state.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

@injectable
class InstallmentsHistoryCubit extends Cubit<InstallmentsHistoryState> {
  final GetInstallmentsHistoryUseCase _getInstallmentsHistoryUseCase;

  InstallmentsHistoryCubit(this._getInstallmentsHistoryUseCase)
    : super(const InstallmentsHistoryState());

  int currentPage = 1;
  final int pageSize = 20;

  Future<void> getInstallmentsHistory({String? status}) async {
    currentPage = 1;
    final isInitialLoad = state.data == null;
    final targetStatus = status ?? state.status;

    if (isInitialLoad) {
      emit(
        state.copyWith(
          flowState: LoadingState(
            stateRendererType: StateRendererType.fullScreenLoadingState,
            title: AppStrings.loading,
            message: "جاري جلب سجل الأقساط...",
          ),
          status: targetStatus,
          hasMore: true,
        ),
      );
    } else {
      emit(state.copyWith(status: targetStatus, hasMore: true));
    }

    final result = await _getInstallmentsHistoryUseCase.execute(
      GetInstallmentsHistoryParams(
        status: targetStatus,
        page: 1,
        pageSize: pageSize,
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
              title: "تعذر تحميل سجل الأقساط",
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
                ? EmptyState("لا توجد أقساط في هذه الحالة")
                : ContentState(),
            data: page.items,
            hasMore: page.hasNextPage,
            totalCount: page.totalCount,
            currentPage: page.page,
            totalPages: page.totalPages,
          ),
        );
      },
    );
  }

  /// تغيير فلتر الحالة (الكل / متأخرة / تستحق اليوم / القادمة / المدفوعة)
  void changeStatusFilter(String status) {
    if (status == state.status && state.data != null) return;
    getInstallmentsHistory(status: status);
  }

  /// زرار "تحميل المزيد"
  Future<void> loadMoreInstallments() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final int nextPage = currentPage + 1;

    final result = await _getInstallmentsHistoryUseCase.execute(
      GetInstallmentsHistoryParams(
        status: state.status,
        page: nextPage,
        pageSize: pageSize,
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
        emit(
          state.copyWith(
            data: [...currentItems, ...page.items],
            isLoadingMore: false,
            hasMore: page.hasNextPage,
            totalCount: page.totalCount,
            currentPage: page.page,
            totalPages: page.totalPages,
          ),
        );
      },
    );
  }
}
