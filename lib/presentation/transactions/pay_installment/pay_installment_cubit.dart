import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/domain/use_case/pay_installment_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/transactions/pay_installment/pay_installment_state.dart';

@injectable
class PayInstallmentCubit extends Cubit<PayInstallmentState> {
  final PayInstallmentUseCase _payInstallmentUseCase;

  PayInstallmentCubit(this._payInstallmentUseCase)
      : super(PayInstallmentState(flowState: ContentState()));

  Future<void> pay(String installmentId) async {
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          message: 'جاري تسجيل سداد القسط...',
        ),
        isSuccess: false,
      ),
    );

    final result = await _payInstallmentUseCase.execute(installmentId);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: 'تعذر تسجيل السداد',
            ),
            isSuccess: false,
          ),
        );
      },
      (transactionModel) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ContentState(),
            isSuccess: true,
            updatedTransaction: transactionModel,
          ),
        );
      },
    );
  }
}
