import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/installments_history_model.dart';
import 'package:mizan/domain/use_case/get_installments_history_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'installments_history_state.freezed.dart';

@freezed
abstract class InstallmentsHistoryState with _$InstallmentsHistoryState {
  const factory InstallmentsHistoryState({
    FlowState? flowState,
    List<InstallmentHistoryItemModel>? data,
    @Default(InstallmentHistoryStatus.all) String status,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default(0) int totalCount,
    @Default(1) int currentPage,
    @Default(1) int totalPages,
  }) = _InstallmentsHistoryState;
}
