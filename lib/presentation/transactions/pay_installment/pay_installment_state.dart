import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'pay_installment_state.freezed.dart';

@freezed
abstract class PayInstallmentState with _$PayInstallmentState {
  const factory PayInstallmentState({
    FlowState? flowState,
    @Default(false) bool isSuccess,
    TransactionbyidModel? updatedTransaction,
  }) = _PayInstallmentState;
}
