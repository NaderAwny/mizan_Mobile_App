import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/data/local/onboarding_local_data_source.dart';
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
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<OnBoardingCubit, OnBoardingState>(
        builder: (context, state) {
          return _getContentWidget(context, state);
        },
      ),
    );
  }

  Widget _getContentWidget(BuildContext context, OnBoardingState state) {
    final sliders = state.sliders;
    if (sliders.isEmpty) {
      return const SizedBox.shrink();
    }

    final isLast = state.currentIndex == sliders.length - 1;

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
        // في آخر شاشة: تظهر صورة الشعار مكان الـ leading، ويختفي زر التخطي
        // في الشاشات الأولى: يظهر زر التخطي كـ leading والشعار في الـ actions
        leadingWidth: isLast ? 160.w : 110.w,
        leading: isLast
            ? Padding(
                padding: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
                child: _buildAppBarLogo(isLeading: true),
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
            ? const []
            : [
                Padding(
                  padding: EdgeInsetsDirectional.only(end: AppPadding.p20.w),
                  child: _buildAppBarLogo(isLeading: false),
                ),
              ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: sliders.length,
                onPageChanged: (index) {
                  _cubit.goToPage(index);
                },
                itemBuilder: (context, index) {
                  return OnBoardingPage(sliders[index]);
                },
              ),
            ),
            _getFooterWidget(state, sliders.length),
          ],
        ),
      ),
    );
  }

  /// شعار ميزان متجاوب يجمع بين أيقونة الشعار وكلمة "ميزان" بجودة عالية
  Widget _buildAppBarLogo({required bool isLeading}) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: isLeading
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. حاوية لوجو ميزان (Logo Box Icon)
          Image.asset(
            ImageAssets.logoBoxFigmaPng,
            width: 80.w,
            height: 75.w,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 1.w),
          // 2. كلمة ميزان
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
      final nextIndex = _cubit.next();
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    } else {
      // حفظ أن المستخدم شاهد الـ Onboarding
      if (getIt.isRegistered<OnboardingLocalDataSource>()) {
        getIt<OnboardingLocalDataSource>().markOnboardingAsSeen();
      }
      // الانتقال إلى الشاشة التالية بعد انتهاء Onboarding
      Navigator.pushReplacementNamed(context, Routes.registerRoute);
    }
  }

  Widget _getFooterWidget(OnBoardingState state, int count) {
    final isLast = state.currentIndex == count - 1;

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
          children: [
            // شريط المؤشرات (Progress Dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                count,
                (index) => _buildIndicatorDot(index == state.currentIndex),
              ),
            ),
            SizedBox(height: AppSize.s20.h),
            // زر الإجراء الرئيسي المتدرج (Action Button)
            Container(
              width: double.infinity,
              height: AppSize.s52.h,
              decoration: BoxDecoration(
                gradient: ColorManager.primaryGradient,
                borderRadius: BorderRadius.circular(AppRadius.r16.r),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1FC57B57),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.r16.r),
                  onTap: () => _onActionButtonPressed(state, count),
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

  Widget _buildIndicatorDot(bool isActive) {
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
      builder: (context, constraints) {
        final maxH = constraints.maxHeight;
        // ارتفاع متجاوب للرسم التوضيحي يتكيف بسلاسة مع الشاشات المختلفة
        final illustrationHeight = maxH.isFinite
            ? (maxH * 0.45).clamp(170.0, 280.0.h)
            : 260.0.h;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p24.w),
            child: Column(
              children: [
                SizedBox(height: AppSize.s12.h),
                // كارت الرسم التوضيحي المطابق لتصميم Figma
                SizedBox(
                  height: illustrationHeight,
                  width: double.infinity,
                  child: _buildIllustration(context, illustrationHeight),
                ),
                SizedBox(height: AppSize.s28.h),
                // عنوان الشاشة
                Text(
                  sliderObject.title,
                  textAlign: TextAlign.center,
                  style: getExtraBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s24,
                  ),
                ),
                SizedBox(height: AppSize.s12.h),
                // النص الفرعي التوضيحي
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

  Widget _buildIllustration(BuildContext context, double illustrationHeight) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SvgPicture.asset(sliderObject.image),
    );
  }
}
