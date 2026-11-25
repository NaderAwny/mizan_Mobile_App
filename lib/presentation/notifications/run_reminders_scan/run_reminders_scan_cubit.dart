import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/notification_model.dart';
import 'package:mizan/domain/use_case/run_reminders_scan_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/notifications/run_reminders_scan/run_reminders_scan_state.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

@injectable
class RunRemindersScanCubit extends Cubit<RunRemindersScanState> {
  final RunRemindersScanUseCase _runRemindersScanUseCase;

  RunRemindersScanCubit(this._runRemindersScanUseCase)
    : super(RunRemindersScanState(flowState: ContentState()));

  Future<void> run() async {
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          message: AppStrings.runRemindersLoading,
        ),
        isSuccess: false,
      ),
    );

    final Either<Failure, RemindersScanResult> result =
        await _runRemindersScanUseCase.execute(null);

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: AppStrings.runRemindersFailed,
            ),
            isSuccess: false,
          ),
        );
      },
      (RemindersScanResult scan) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ContentState(),
            isSuccess: true,
            result: scan,
          ),
        );
      },
    );
  }
}
