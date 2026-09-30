import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/installments_dashboard_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'installments_dashboard_state.freezed.dart';

@freezed
abstract class InstallmentsDashboardState with _$InstallmentsDashboardState {
  const factory InstallmentsDashboardState({
    FlowState? flowState,
    InstallmentsDashboardModel? data,
  }) = _InstallmentsDashboardState;
}
