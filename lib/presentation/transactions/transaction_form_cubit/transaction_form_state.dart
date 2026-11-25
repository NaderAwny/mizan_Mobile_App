import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/transaction_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'transaction_form_state.freezed.dart';

@freezed
abstract class TransactionFormState with _$TransactionFormState {
  const factory TransactionFormState({
    FlowState? flowState,
    Transaction? savedTransaction,
    @Default(false) bool isActionSuccess,
    String? selectedContactId,
    String? selectedPartyName,
    @Default(false) bool isPartyVip,
    DateTime? transactionDate,
    @Default(true) bool isCash,
    @Default(false) bool isInstallment,
    @Default("Automatic") String installmentPlanMode,
    @Default(3) int installmentCount,
    @Default("Monthly") String frequency,
    DateTime? firstInstallmentDate,
  }) = _TransactionFormState;
}
