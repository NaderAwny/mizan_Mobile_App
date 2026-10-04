import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/onboarding_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';

part 'onboarding_state.freezed.dart';

@freezed
abstract class OnBoardingState with _$OnBoardingState {
  const factory OnBoardingState({
    FlowState? flowState,
    @Default(0) int currentIndex,
    @Default(<SliderObject>[]) List<SliderObject> sliders,
    @Default(false) bool isLast,
    @Default(false) bool completed,
  }) = _OnBoardingState;
}
