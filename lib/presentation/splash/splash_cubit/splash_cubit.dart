import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/app/app_logger.dart';
import 'package:mizan/data/local/onboarding_local_data_source.dart';
import 'package:mizan/data/local/token_local_data_source.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/get_profile/cubit/get_profile_cubit.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/splash/splash_cubit/splash_state.dart';
import 'package:mizan/presentation/statistics/cubit/statistics_cubit.dart';
import 'package:mizan/app/notification_service.dart';
import 'package:mizan/presentation/transactions/get_list_transaction/get_list_transaction_cubit.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  SplashCubit(
    this._tokenLocalDataSource,
    this._onboardingLocalDataSource,
    this._getProfileCubit,
    this._statisticsCubit,
    this._getListTransactionCubit,
    this._notificationService,
  ) : super(const SplashState());

  final TokenLocalDataSource _tokenLocalDataSource;
  final OnboardingLocalDataSource _onboardingLocalDataSource;
  final GetProfileCubit _getProfileCubit;
  final StatisticsCubit _statisticsCubit;
  final GetListTransactionCubit _getListTransactionCubit;
  final NotificationService _notificationService;

  Future<void> preload() async {
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
          title: AppStrings.loading,
          message: AppStrings.loading,
        ),
      ),
    );

    final Future<void> minDelay =
        Future<void>.delayed(AppDuration.splashMin);

    try {
      final SplashDestination destination =
          await _decideDestination().timeout(AppDuration.splashTimeout);
      await minDelay;
      if (isClosed) return;
      emit(state.copyWith(flowState: ContentState(), data: destination));
    } on TimeoutException {
      AppLogger.d('splash preload timed out — using cached fallback');
      await minDelay;
      if (isClosed) return;
      emit(
        state.copyWith(
          flowState: ContentState(),
          data: await _fallbackDestination(),
        ),
      );
    } on Object catch (e, s) {
      AppLogger.e('splash preload failed', error: e, stackTrace: s);
      if (isClosed) return;
      emit(
        state.copyWith(
          flowState: ErrorState(
            StateRendererType.fullScreenErrorState,
            'حدث خطأ، يرجى المحاولة مجدداً',
          ),
        ),
      );
    }
  }

  Future<SplashDestination> _decideDestination() async {
    final bool seenOnboarding =
        await _onboardingLocalDataSource.hasSeenOnboarding();
    if (!seenOnboarding) return SplashDestination.onboarding;

    final bool hasSession =
        await _tokenLocalDataSource.hasValidSession();
    if (!hasSession) return SplashDestination.login;

    unawaited(_notificationService.registerDeviceToken());

    // بيجيب الداتا بالتوازي — Home يحتاج: Profile + Statistics + Transactions
    final DateTime now = DateTime.now();
    await Future.wait<void>(<Future<void>>[
      _getProfileCubit.getProfile(),
      _statisticsCubit.getMonthlyStatistics(
        now.year.toString(),
        now.month.toString(),
      ),
      _getListTransactionCubit.getListTransactions(),
    ]);

    return SplashDestination.home;
  }

  Future<SplashDestination> _fallbackDestination() async {
    final bool seenOnboarding =
        await _onboardingLocalDataSource.hasSeenOnboarding();
    if (!seenOnboarding) return SplashDestination.onboarding;

    final bool hasSession =
        await _tokenLocalDataSource.hasValidSession();
    return hasSession ? SplashDestination.home : SplashDestination.login;
  }
}
