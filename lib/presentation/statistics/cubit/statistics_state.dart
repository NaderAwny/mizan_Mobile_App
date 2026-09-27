import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/statistics_model/statistics_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'statistics_state.freezed.dart';

@freezed
abstract class StatisticsState with _$StatisticsState {
  const factory StatisticsState({
    FlowState? flowState,
    StatisticsPageModel? data,
    String? selectedDate, // null = summary mode, non-null = daily mode

    @Default(false) bool isMonthlyMode,
    String? selectedMonthYear, // Format: "YYYY-MM"
  }) = _StatisticsState;
}
