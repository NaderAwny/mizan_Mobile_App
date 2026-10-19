import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'run_reminders_scan_state.freezed.dart';

@freezed
abstract class RunRemindersScanState with _$RunRemindersScanState {
  const factory RunRemindersScanState({
    FlowState? flowState,
    @Default(false) bool isSuccess,
    RemindersScanResult? result,
  }) = _RunRemindersScanState;
}
