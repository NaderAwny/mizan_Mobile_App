import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'splash_state.freezed.dart';

enum SplashDestination { home, login, onboarding }

@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState({
    FlowState? flowState,
    SplashDestination? data,
  }) = _SplashState;
}
