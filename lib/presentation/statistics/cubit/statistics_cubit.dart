import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/domain/use_case/get_statistics_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/statistics/cubit/statistics_state.dart';

@injectable
class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsUseCase _statisticsUseCase;
  final DailyStatisticsUseCase _dailyStatisticsUseCase;
  final MonthlyStatisticsUseCase _monthlyStatisticsUseCase;

  StatisticsCubit(
    this._statisticsUseCase,
    this._dailyStatisticsUseCase,
    this._monthlyStatisticsUseCase,
  ) : super(const StatisticsState());

  // Selected filter mode: 'summary' | 'daily' | 'monthly'
  String selectedMode = 'summary';

  /// Load overall summary statistics (no date filter)
  Future<void> getSummaryStatistics() async {
    selectedMode = 'summary';
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
          title: AppStrings.loading,
          message: 'جاري جلب الإحصائيات العامة...',
        ),
        selectedDate: null,
        selectedMonthYear: null,
        isMonthlyMode: false,
      ),
    );

    final result = await _statisticsUseCase.execute(null);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.fullScreenErrorState,
              failure.message,
              title: 'تعذر تحميل الإحصائيات',
            ),
          ),
        );
      },
      (data) {
        if (isClosed) return;
        emit(state.copyWith(flowState: ContentState(), data: data));
      },
    );
  }

  /// Load daily statistics for a specific date (format: YYYY-MM-DD)
  Future<void> getDailyStatistics(String date) async {
    selectedMode = 'daily';
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
          title: AppStrings.loading,
          message: 'جاري جلب إحصائيات يوم $date...',
        ),
        selectedDate: date,
        selectedMonthYear: null,
        isMonthlyMode: false,
      ),
    );

    final result = await _dailyStatisticsUseCase.execute(date);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.fullScreenErrorState,
              failure.message,
              title: 'تعذر تحميل إحصائيات اليوم',
            ),
          ),
        );
      },
      (data) {
        if (isClosed) return;
        emit(state.copyWith(flowState: ContentState(), data: data));
      },
    );
  }

  /// Load monthly statistics for a specific month and year
  Future<void> getMonthlyStatistics(String year, String month) async {
    final yearStr = year;
    final monthStr = month.padLeft(2, '0');
    selectedMode = 'monthly';
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
          title: AppStrings.loading,
          message: 'جاري جلب إحصائيات الشهر...',
        ),
        isMonthlyMode: true,
        selectedMonthYear: '$yearStr-$monthStr',
        selectedDate: null,
      ),
    );

    final result = await _monthlyStatisticsUseCase.execute(
      MonthlyStatisticsInput(year: yearStr, month: monthStr),
    );

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.fullScreenErrorState,
              failure.message,
              title: 'تعذر تحميل إحصائيات الشهر',
            ),
          ),
        );
      },
      (data) {
        if (isClosed) return;
        emit(state.copyWith(flowState: ContentState(), data: data));
      },
    );
  }

  void changeMonthMode(bool isMonthly) {
    if (isMonthly) {
      final now = DateTime.now();
      getMonthlyStatistics(now.year.toString(), now.month.toString());
    } else {
      getSummaryStatistics();
    }
  }

  void changeSelectedDate(String date) {
    getDailyStatistics(date);
  }

  /// Handle retry logic after error
  void retry() {
    if (state.selectedDate != null) {
      getDailyStatistics(state.selectedDate!);
    } else if (state.isMonthlyMode && state.selectedMonthYear != null) {
      final parts = state.selectedMonthYear!.split('-');
      if (parts.length == 2) {
        getMonthlyStatistics(parts[0], parts[1]);
      } else {
        getSummaryStatistics();
      }
    } else {
      getSummaryStatistics();
    }
  }
}
