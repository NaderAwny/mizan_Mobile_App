import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mizan/domain/model/onboarding_model.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'onboarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingState());

  void init() {
    emit(
      state.copyWith(
        sliders: [
          SliderObject(
            ImageAssets.onBoardingLogo1,
            AppStrings.onBoardingTitle1,
            AppStrings.onBoardingSubTitle1,
          ),
          SliderObject(
            ImageAssets.onBoardingLogo2,
            AppStrings.onBoardingTitle2,
            AppStrings.onBoardingSubTitle2,
          ),
          SliderObject(
            ImageAssets.onBoardingLogo3,
            AppStrings.onBoardingTitle3,
            AppStrings.onBoardingSubTitle3,
          ),
        ],
      ),
    );
  }

  int next() {
    if (isLastPage) return state.currentIndex;
    final nextIndex = state.currentIndex + 1;
    goToPage(nextIndex);
    return nextIndex;
  }

  int previous() {
    if (isFirstPage) return 0;
    final prevIndex = state.currentIndex - 1;
    goToPage(prevIndex);
    return prevIndex;
  }

  void goToPage(int index) {
    if (index < 0 || index >= state.sliders.length) return;
    emit(
      state.copyWith(
        currentIndex: index,
        isLast: index == state.sliders.length - 1,
      ),
    );
  }

  bool get isFirstPage => state.currentIndex == 0;
  bool get isLastPage => state.currentIndex == state.sliders.length - 1;

  void skip() {
    if (state.sliders.isEmpty) return;
    final lastIndex = state.sliders.length - 1;
    goToPage(lastIndex);
  }
}
