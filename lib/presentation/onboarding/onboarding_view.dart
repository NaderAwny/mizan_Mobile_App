import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/domain/model/onboarding_model.dart';
import 'package:mizan/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:mizan/presentation/onboarding/cubit/onboarding_state.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController();
  late final OnBoardingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OnBoardingCubit()..init();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnBoardingCubit>.value(
      value: _cubit,
      child: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        listenWhen: (OnBoardingState p, OnBoardingState c) =>
            p.completed != c.completed,
        listener: (BuildContext context, OnBoardingState state) {
          if (state.completed) {
            Navigator.pushReplacementNamed(context, Routes.registerRoute);
          }
        },
        buildWhen: (OnBoardingState p, OnBoardingState c) =>
            p.flowState != c.flowState ||
            p.currentIndex != c.currentIndex ||
            p.sliders != c.sliders,
        builder: (BuildContext context, OnBoardingState state) {
          return _getContentWidget(context, state);
        },
      ),
    );
  }

  Widget _getContentWidget(BuildContext context, OnBoardingState state) {
    final List<SliderObject> sliders = state.sliders;
    if (sliders.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool isLast = state.currentIndex == sliders.length - 1;

    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: ColorManager.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leadingWidth: isLast ? 160.w : 110.w,
        leading: isLast
            ? Padding(
                padding: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
                child: const OnBoardingAppBarLogo(isLeading: true),
              )
            : Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: AppPadding.p16.w),
                  child: TextButton(
                    onPressed: () => _skipToLastPage(sliders.length - 1),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        AppStrings.skip,
                        maxLines: 1,
                        softWrap: false,
                        style: getBoldStyle(
                          color: ColorManager.primary,
                          fontSize: FontSize.s12.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        actions: isLast
            ? const <Widget>[]
            : <Widget>[
                Padding(
                  padding: EdgeInsetsDirectional.only(end: AppPadding.p20.w),
                  child: const OnBoardingAppBarLogo(isLeading: false),
                ),
              ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: sliders.length,
                onPageChanged: (int index) {
                  _cubit.goToPage(index);
                },
                itemBuilder: (BuildContext context, int index) {
                  return OnBoardingPage(sliders[index]);
                },
              ),
            ),
            OnboardingFooter(
              currentIndex: state.currentIndex,
              count: sliders.length,
              onActionPressed: () =>
                  _onActionButtonPressed(state, sliders.length),
            ),
          ],
        ),
      ),
    );
  }

  void _skipToLastPage(int lastIndex) {
    _cubit.skip();
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        lastIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onActionButtonPressed(OnBoardingState state, int totalPages) {
    if (state.currentIndex < totalPages - 1) {
      final int nextIndex = _cubit.next();
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _cubit.complete();
    }
  }
}

class OnBoardingAppBarLogo extends StatelessWidget {
  const OnBoardingAppBarLogo({super.key, required this.isLeading});
  final bool isLeading;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: isLeading
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            ImageAssets.logoBoxFigmaPng,
            width: 80.w,
            height: 75.w,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 1.w),
          Text(
            AppStrings.appName,
            maxLines: 1,
            softWrap: false,
            style: getBlackStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s17,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    super.key,
    required this.currentIndex,
    required this.count,
    required this.onActionPressed,
  });

  final int currentIndex;
  final int count;
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    final bool isLast = currentIndex == count - 1;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppPadding.p24.w,
          AppPadding.p12.h,
          AppPadding.p24.w,
          AppPadding.p16.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                count,
                (int index) => OnboardingIndicatorDot(
                  isActive: index == currentIndex,
                ),
              ),
            ),
            SizedBox(height: AppSize.s20.h),
            Container(
              width: double.infinity,
              height: AppSize.s52.h,
              decoration: BoxDecoration(
                gradient: ColorManager.primaryGradient,
                borderRadius: BorderRadius.circular(AppRadius.r16.r),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x1FC57B57),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: ColorManager.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.r16.r),
                  onTap: onActionPressed,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          isLast ? AppStrings.startNow : AppStrings.next,
                          maxLines: 1,
                          softWrap: false,
                          style: getExtraBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSize.s8.h),
          ],
        ),
      ),
    );
  }
}

class OnboardingIndicatorDot extends StatelessWidget {
  const OnboardingIndicatorDot({super.key, required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      width: isActive ? 24.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: isActive ? ColorManager.primary : ColorManager.border,
        borderRadius: BorderRadius.circular(100.r),
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  final SliderObject sliderObject;
  const OnBoardingPage(this.sliderObject, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxH = constraints.maxHeight;
        final double illustrationHeight = maxH.isFinite
            ? (maxH * 0.45).clamp(170.0, 280.0.h)
            : 260.0.h;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p24.w),
            child: Column(
              children: <Widget>[
                SizedBox(height: AppSize.s12.h),
                SizedBox(
                  height: illustrationHeight,
                  width: double.infinity,
                  child: OnBoardingIllustration(
                    image: sliderObject.image,
                    height: illustrationHeight,
                  ),
                ),
                SizedBox(height: AppSize.s28.h),
                Text(
                  sliderObject.title,
                  textAlign: TextAlign.center,
                  style: getExtraBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s24,
                  ),
                ),
                SizedBox(height: AppSize.s12.h),
                Text(
                  sliderObject.subTitle,
                  textAlign: TextAlign.center,
                  style: getMediumStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s15,
                  ).copyWith(height: 26 / 15),
                ),
                SizedBox(height: AppSize.s16.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OnBoardingIllustration extends StatelessWidget {
  const OnBoardingIllustration({
    super.key,
    required this.image,
    required this.height,
  });

  final String image;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SvgPicture.asset(image),
    );
  }
}
