import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/get_list_transactions_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'get_list_transaction_state.freezed.dart';

@freezed
abstract class GetListTransactionState with _$GetListTransactionState {
  const factory GetListTransactionState({
    FlowState? flowState,
    List<GetListTransactionsModel>? data,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default('') String searchQuery,
    String? contactId,
    String? type,
    String? dateFrom,
    String? dateTo,
  }) = _GetListTransactionState;
}
