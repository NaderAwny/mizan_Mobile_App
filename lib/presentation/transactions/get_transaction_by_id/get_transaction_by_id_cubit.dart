import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/domain/use_case/delete_transaction_use_case.dart';
import 'package:mizan/domain/use_case/get_transaction_by_id_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/transactions/get_transaction_by_id/get_transaction_by_id_state.dart';

@injectable
class GetTransactionByIdCubit extends Cubit<GetTransactionByIdState> {
  final GetTransactionByIdUseCase _getTransactionByIdUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;

  GetTransactionByIdCubit(
    this._getTransactionByIdUseCase,
    this._deleteTransactionUseCase,
  ) : super(const GetTransactionByIdState());

  Future<void> getTransactionById(String id) async {
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
          title: AppStrings.loading,
          message: AppStrings.txDetailsLoading,
        ),
      ),
    );

    final Either<Failure, TransactionbyidModel> result =
        await _getTransactionByIdUseCase.execute(id);

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.fullScreenErrorState,
              failure.message,
              title: AppStrings.txDetailsErrorTitle,
            ),
          ),
        );
      },
      (TransactionbyidModel transaction) {
        if (isClosed) return;
        emit(state.copyWith(data: transaction, flowState: ContentState()));
      },
    );
  }

  Future<bool> deleteTransaction() async {
    final TransactionbyidModel? transaction = state.data;
    if (transaction == null) return false;
    if (isClosed) return true;

    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          title: "جاري الحذف",
          message: "جاري حذف العملية...",
        ),
      ),
    );

    final Either<Failure, void> result = await _deleteTransactionUseCase
        .execute(transaction.id!);

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
