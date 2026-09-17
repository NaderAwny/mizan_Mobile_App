// استدعاء مكتبة Flutter الأساسية الخاصة بواجهة المستخدم (UI)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// مكتبة ScreenUtil لضبط وتكييف جميع المقاسات والأبعاد مع جميع مقاسات الشاشات (Responsive)
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mizan/app/di.dart';
// ملف الصور والأصول الخاصة بالتطبيق
import 'package:mizan/presentation/resources/assets_manager.dart';

// ملف الألوان المعتمدة في تصميم ميزان
import 'package:mizan/presentation/resources/color_manager.dart';

// ملف الثوابت الزمنية والأبعاد التخطيطية
import 'package:mizan/presentation/resources/constants_manager.dart';

// ملف الخطوط وأحجامها
import 'package:mizan/presentation/resources/font_manager.dart';

// ملف مسارات التنقل بين الشاشات
import 'package:mizan/presentation/resources/routes_manager.dart';

// ملف النصوص المترجمة والمسميات
import 'package:mizan/presentation/resources/strings_manager.dart';

// ملف أنماط النصوص الجاهزة
import 'package:mizan/presentation/resources/styles_manager.dart';

// ملف المقاسات والأبعاد والـ Paddings والظلال والمدد الزمنية
import 'package:mizan/presentation/resources/values_manager.dart';

import 'package:mizan/presentation/splash/splash_cubit/splash_cubit.dart';
import 'package:mizan/presentation/splash/splash_cubit/splash_state.dart';

// StatefulWidget لأن الشاشة تحتوي على حالات حركة (Animations) متزامنة وديناميكية
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

// استخدام TickerProviderStateMixin لإدارة أكثر من AnimationController بكفاءة عالية
class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final SplashCubit _splashCubit;
  bool _animationFinished = false;
  SplashDestination? _destination;
  // متحكم حركة ظهور وتكبير الشعار في المنتصف
  late final AnimationController _logoController;

  // حركة التكبير التدريجي للشعار (Scale)
  late final Animation<double> _logoScaleAnimation;

  // حركة الشفافية للشعار (Fade In)
  late final Animation<double> _logoFadeAnimation;

  // حركة انزلاق العنوان والنص الإنجليزي للأعلى بنعومة
  late final Animation<Offset> _titleSlideAnimation;

  // حركة ظهور العنوان والنص الإنجليزي (Fade In)
  late final Animation<double> _titleFadeAnimation;

  // متحكم حركة ظهور قسم التحميل السفلي (Loading Section Fade)
  late final AnimationController _loadingFadeController;
  late final Animation<double> _loadingFadeAnimation;

  // متحكم حركة شريط التقدم الديناميكي (Dynamic Progress Bar)
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  // متحكم دوران الـ Spinner المخصص (Custom Spinner Rotation)
  late final AnimationController _spinnerController;

  // Getters لأغراض الاختبار والتأكد من حالات الأنيميشن
  @visibleForTesting
  AnimationController get logoController => _logoController;
  @visibleForTesting
  AnimationController get progressController => _progressController;

  @override
  void initState() {
    super.initState();

    // تهيئة SplashCubit والبدء في تقرير وجهة المستخدم فوراً
    _splashCubit = getIt<SplashCubit>()..decide();

    // تهيئة متحكمات وأنيميشن الشاشة
    _initAnimations();

    // بدء سيناريو الحركة والتحميل الديناميكي
    _startSplashFlow();
  }

  // دالة تهيئة الحركات الرياضية والمنحنيات (Curves & Tweens)
  void _initAnimations() {
    // 1. إعداد أنيميشن الشعار (مدة AppDuration.d800 لانتقال ناعم وفخم)
    _logoController = AnimationController(
      vsync: this,
      duration: AppDuration.d800,
    );

    // تكبير ناعم للشعار من 0.75 إلى 1.0 مع ارتداد طفيف (EaseOutBack)
    _logoScaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );

    // ظهور شفافية الشعار
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    // انزلاق العنوان "ميزان" والنص الإنجليزي للأعلى
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.25, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // شفافية ظهور العنوان
    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.25, 1.0, curve: Curves.easeIn),
      ),
    );

    // 2. إعداد أنيميشن ظهور قسم التحميل السفلي (AppDuration.d400)
    _loadingFadeController = AnimationController(
      vsync: this,
      duration: AppDuration.d400,
    );
    _loadingFadeAnimation = CurvedAnimation(
      parent: _loadingFadeController,
      curve: Curves.easeIn,
    );

    // 3. إعداد أنيميشن دوران الـ Spinner بشكل مستمر (AppDuration.d1000)
    _spinnerController = AnimationController(
      vsync: this,
      duration: AppDuration.d1000,
    );

    // 4. إعداد أنيميشن شريط التحميل المتدرج (ديناميكي وواقعي يستغرق AppDuration.d2200)
    _progressController = AnimationController(
      vsync: this,
      duration: AppDuration.d2200,
    );

    // استخدام منحنى Cubic يعطي إحساساً واقعياً بالتحميل (انطلاق سريع ثم تثاقل ذكي ثم إكمال سريع)
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // عند اكتمال حركة دخول الشعار، نبدأ مباشرة تشغيل قسم التحميل والـ Spinner والتقدم
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _loadingFadeController.forward();
        _spinnerController.repeat();
        _progressController.forward();
      }
    });

    // مراقبة انتهاء شريط التحميل للانتقال التلقائي للوجهة المقررة في عقد التنقل
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _animationFinished = true;
        if (_destination != null) {
          _navigate();
        }
      }
    });
  }

  // تسلسل تشغيل الحركات
  void _startSplashFlow() {
    // تشغيل أنيميشن دخول الشعار
    _logoController.forward();
  }

  // دالة الانتقال للوجهة المقررة حسب حالة الحساب والـ Onboarding
  void _navigate() {
    if (!mounted) return;
    switch (_destination) {
      case SplashDestination.home:
        Navigator.pushReplacementNamed(context, Routes.homeRoute);
        break;
      case SplashDestination.login:
        Navigator.pushReplacementNamed(context, Routes.sendOtpRoute);
        break;
      case SplashDestination.onboarding:
      default:
        Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
        break;
    }
  }

  @override
  void dispose() {
    // تحرير جميع المتحكمات والـ Cubit من الذاكرة للحفاظ على أعلى أداء (Memory Management)
    _splashCubit.close();
    _logoController.dispose();
    _loadingFadeController.dispose();
    _progressController.dispose();
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تصميم الشاشة كاملة بالاعتماد حصرياً على Tokens المستخرجة من مجلد resources
    return BlocProvider.value(
      value: _splashCubit,
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state.data != null) {
            _destination = state.data;
            if (_animationFinished) {
              _navigate();
            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            // تدرج الخلفية الكريمي المعتمد في ColorManager
            decoration: const BoxDecoration(
              gradient: ColorManager.splashGradient,
            ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // أمواج الخلفية التزيينية السفلية كما تم تعريفها في Figma
            // الموجة السفلية الأولى (Ellipse 1)
            Positioned(
              left: AppConstants.splashWave1Left.w,
              bottom: AppConstants.splashWave1Bottom.h,
              width: AppSize.s500.w,
              height: AppSize.s300.h,
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorManager.splashWave1,
                  ),
                ),
              ),
            ),

            // الموجة السفلية الثانية (Ellipse 2)
            Positioned(
              left: AppConstants.splashWave2Left.w,
              bottom: AppConstants.splashWave2Bottom.h,
              width: AppSize.s520.w,
              height: AppSize.s320.h,
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorManager.splashWave2,
                  ),
                ),
              ),
            ),

            // محتوى الشعار والعناوين في منتصف الشاشة بدقة متناهية
            Center(
              child: RepaintBoundary(
                // عزل إعادة رسم الشعار أثناء حركة شريط التحميل لضمان 60/120 FPS
                child: AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 1. حاوية الشعار (Logo Box) مع أنيميشن التكبير
                          ScaleTransition(
                            scale: _logoScaleAnimation,
                            child: Container(
                              width: AppSize.s110.w,
                              height: AppSize.s110.w,
                              decoration: BoxDecoration(
                                color: ColorManager.surface,
                                borderRadius: BorderRadius.circular(AppRadius.r28.r),
                                border: Border.all(
                                  color: ColorManager.darkSecondary, // اللون الذهبي المحدد في Figma
                                  width: AppSize.s1_5.w,
                                ),
                                boxShadow: const [
                                  AppShadows.brandShadow, // ظل ميزان المعتمد
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppRadius.r28.r),
                                child: Center(
                                  child: Image.asset(
                                    ImageAssets.logoScalesFigmaPng,
                                    width: AppSize.s76.w,
                                    height: AppSize.s76.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // مسافة رأسية بين الشعار والعنوان
                          SizedBox(height: AppSize.s24.h),

                          // 2. مجموعة العناوين مع أنيميشن الانزلاق الرأسي الناعم
                          SlideTransition(
                            position: _titleSlideAnimation,
                            child: FadeTransition(
                              opacity: _titleFadeAnimation,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // الاسم العربي "ميزان" باستخدام StylesManager
                                  Text(
                                    AppStrings.appName,
                                    style: getBlackStyle(
                                      fontSize: FontSize.s38,
                                      color: ColorManager.brandGreen,
                                      height: AppConstants.splashTitleHeight,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  // مسافة رأسية بين الاسمين
                                  SizedBox(height: AppSize.s8.h),

                                  // الاسم باللغة الإنجليزية "MIZAN" باستخدام StylesManager
                                  Text(
                                    AppStrings.appNameEn,
                                    style: getExtraBoldStyle(
                                      fontSize: FontSize.s14,
                                      color: ColorManager.darkSecondary,
                                      letterSpacing: AppConstants.splashLetterSpacing.w,
                                      height: AppConstants.splashSubTitleHeight,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // قسم التحميل السفلي المخصص (Dynamic Loader + Progress Bar)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: FadeTransition(
                  opacity: _loadingFadeAnimation,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppPadding.p24.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // صف التحميل: Custom Spinner + نص "جاري التحميل..."
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Spinner مخصص يدور بنعومة
                            RotationTransition(
                              turns: _spinnerController,
                              child: SizedBox(
                                width: AppSize.s20.w,
                                height: AppSize.s20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: AppSize.s2.w,
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    ColorManager.brandGreen,
                                  ),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            ),

                            // مسافة بين الـ Spinner والنص
                            SizedBox(width: AppSize.s8.w),

                            // نص "جاري التحميل..." باستخدام StylesManager
                            Text(
                              AppStrings.loading,
                              style: getSemiBoldStyle(
                                fontSize: FontSize.s14,
                                color: ColorManager.textSubtle,
                              ),
                            ),
                          ],
                        ),

                        // مسافة رأسية بين صف الـ Spinner وشريط التقدم
                        SizedBox(height: AppSize.s16.h),

                        // شريط التقدم الديناميكي المتدرج (Gradient Progress Bar)
                        // نستخدم AnimatedBuilder فقط حول هذا العنصر لعزل الرسم وتوفير أقصى أداء
                        Container(
                          width: AppSize.s220.w,
                          height: AppSize.s5.h,
                          decoration: BoxDecoration(
                            color: ColorManager.splashTrack, // خلفية المسار من ColorManager
                            borderRadius: BorderRadius.circular(AppRadius.r100.r),
                          ),
                          alignment: Alignment.centerLeft,
                          child: AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return Container(
                                width: AppSize.s220.w * _progressAnimation.value,
                                height: AppSize.s5.h,
                                decoration: BoxDecoration(
                                  // تدرج لوني ممتد من الزيتي الداكن إلى الذهبي من ColorManager
                                  gradient: ColorManager.brandGradient,
                                  borderRadius: BorderRadius.circular(AppRadius.r100.r),
                                ),
                              );
                            },
                          ),
                        ),

                        // مسافة إضافية قبل مؤشر الشاشة السفلي
                        SizedBox(height: AppSize.s16.h),

                        // مؤشر الشاشة السفلي (iOS Home Indicator)
                        Container(
                          width: AppSize.s139.w,
                          height: AppSize.s5.h,
                          decoration: BoxDecoration(
                            color: ColorManager.homeIndicator,
                            borderRadius: BorderRadius.circular(AppRadius.r100.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
        ),
      ),
    );
  }
}
