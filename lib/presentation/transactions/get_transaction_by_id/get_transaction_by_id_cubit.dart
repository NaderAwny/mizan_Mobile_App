import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/domain/use_case/get_transaction_by_id_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/transactions/get_transaction_by_id/get_transaction_by_id_state.dart';

@injectable
class GetTransactionByIdCubit extends Cubit<GetTransactionByIdState> {
  final GetTransactionByIdUseCase _getTransactionByIdUseCase;

  GetTransactionByIdCubit(this._getTransactionByIdUseCase)
    : super(const GetTransactionByIdState());

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

    final result = await _getTransactionByIdUseCase.execute(id);

    result.fold(
      (failure) {
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
      (transaction) {
        if (isClosed) return;
        emit(state.copyWith(data: transaction, flowState: ContentState()));
      },
    );
  }
}
