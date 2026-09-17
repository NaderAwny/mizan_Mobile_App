import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mizan/domain/model/onboarding_model.dart';
part 'onboarding_state.freezed.dart';

@freezed
abstract class OnBoardingState with _$OnBoardingState {
  const factory OnBoardingState({
    @Default(0) int currentIndex,
    @Default([]) List<SliderObject> sliders,
    @Default(false) bool isLast,
  }) = _OnBoardingState;
}
