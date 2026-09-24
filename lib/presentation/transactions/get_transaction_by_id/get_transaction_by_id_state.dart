import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/transaction_by_id_mode/transaction_by_id_mode.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'get_transaction_by_id_state.freezed.dart';

@freezed
abstract class GetTransactionByIdState with _$GetTransactionByIdState {
  const factory GetTransactionByIdState({
    FlowState? flowState,
    TransactionbyidModel? data,
  }) = _GetTransactionByIdState;
}
