import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/local/onboarding_local_data_source.dart';
import 'package:mizan/data/local/token_local_data_source.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/splash/splash_cubit/splash_state.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  final TokenLocalDataSource _tokenLocalDataSource;
  final OnboardingLocalDataSource _onboardingLocalDataSource;

  SplashCubit(
    this._tokenLocalDataSource,
    this._onboardingLocalDataSource,
  ) : super(const SplashState());

  Future<void> decide() async {
    emit(state.copyWith(
      flowState: LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
      ),
    ));

    final hasSession = await _tokenLocalDataSource.hasValidSession();
    if (hasSession) {
      emit(state.copyWith(
        data: SplashDestination.home,
        flowState: ContentState(),
      ));
      return;
    }

    final seenOnboarding = await _onboardingLocalDataSource.hasSeenOnboarding();
    emit(state.copyWith(
      data: seenOnboarding ? SplashDestination.login : SplashDestination.onboarding,
      flowState: ContentState(),
    ));
  }
}
