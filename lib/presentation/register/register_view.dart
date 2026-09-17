import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/register/cubit/register_cubit.dart';
import 'package:mizan/presentation/register/cubit/register_state.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RegisterView — Mizan design system compliant
// ─────────────────────────────────────────────────────────────────────────────
class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: const _RegisterScreen(),
    );
  }
}

class _RegisterScreen extends StatefulWidget {
  const _RegisterScreen();

  @override
  State<_RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<_RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _firstNameTouched = false;
  bool _lastNameTouched = false;
  bool _emailTouched = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listenWhen: (prev, curr) => curr.registerSuccess && !prev.registerSuccess,
      listener: (ctx, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // 1. Dismiss any open loading dialog safely
          Navigator.of(ctx, rootNavigator: true).popUntil((route) {
            return route is! PopupRoute;
          });

          // 2. Reset success flag
          ctx.read<RegisterCubit>().resetSuccess();

          // 3. Navigate to AuthVerification screen, signalling Registration flow
          //    so that on OTP success the user is routed to SelectUser, not Home.
          Navigator.of(ctx).pushNamed(
            Routes.authVerificationRoute,
            arguments: AuthVerificationArgs(
              email: state.email,
              isFromRegistration: true,
            ),
          );
        });
      },
      builder: (ctx, state) {
        // Show loading/error overlay only when state is LoadingState or ErrorState
        final flowState = state.flowState;
        if (flowState is LoadingState || flowState is ErrorState) {
          final overlay = flowState!.getScreenWidget(
            ctx,
            _buildBody(ctx, state),
            () => ctx.read<RegisterCubit>().register(),
          );
          if (overlay != null) return _withScaffold(overlay);
        }
        return _withScaffold(_buildBody(ctx, state));
      },
    );
  }

  Widget _withScaffold(Widget body) {
    return Scaffold(backgroundColor: ColorManager.background, body: body);
  }

  Widget _buildBody(BuildContext context, RegisterState state) {
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),

                  // ── Header ──────────────────────────────────────────────
                  _HeaderSection(),

                  SizedBox(height: 32.h),

                  // ── Progress indicator ───────────────────────────────────
                  _StepIndicator(currentStep: 1, totalSteps: 3),

                  SizedBox(height: 28.h),

                  // ── Title ────────────────────────────────────────────────
                  Text(
                    'إنشاء حساب جديد',
                    style: getExtraBoldStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s26,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'أدخل بياناتك لإنشاء حسابك في ميزان',
                    style: getRegularStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s14,
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // ── First Name ────────────────────────────────────────────
                  _buildLabel('الاسم الأول'),
                  SizedBox(height: 6.h),
                  _MizanTextField(
                    controller: _firstNameController,
                    hintText: 'مثال: Ahmed',
                    keyboardType: TextInputType.name,
                    textDirection: TextDirection.ltr,
                    prefixIcon: IconAssets.user,
                    showError: _firstNameTouched && !state.isFirstNameValid,
                    errorText: _firstNameHint(state),
                    onChanged: (val) {
                      setState(() => _firstNameTouched = true);
                      context.read<RegisterCubit>().setFirstName(val);
                    },
                    showSuccess: _firstNameTouched && state.isFirstNameValid,
                  ),

                  SizedBox(height: 16.h),

                  // ── Last Name ─────────────────────────────────────────────
                  _buildLabel('الاسم الأخير'),
                  SizedBox(height: 6.h),
                  _MizanTextField(
                    controller: _lastNameController,
                    hintText: 'مثال: Mostafa',
                    keyboardType: TextInputType.name,
                    textDirection: TextDirection.ltr,
                    prefixIcon: IconAssets.user,
                    showError: _lastNameTouched && !state.isLastNameValid,
                    errorText: _lastNameHint(state),
                    onChanged: (val) {
                      setState(() => _lastNameTouched = true);
                      context.read<RegisterCubit>().setLastName(val);
                    },
                    showSuccess: _lastNameTouched && state.isLastNameValid,
                  ),

                  SizedBox(height: 16.h),

                  // ── Email ─────────────────────────────────────────────────
                  _buildLabel('البريد الإلكتروني'),
                  SizedBox(height: 6.h),
                  _MizanTextField(
                    controller: _emailController,
                    hintText: 'example@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    prefixIcon: IconAssets.mailPlus,
                    showError: _emailTouched && !state.isEmailValid,
                    errorText: _emailHint(state),
                    onChanged: (val) {
                      setState(() => _emailTouched = true);
                      context.read<RegisterCubit>().setEmail(val);
                    },
                    showSuccess: _emailTouched && state.isEmailValid,
                  ),

                  SizedBox(height: 12.h),

                  // ── Validation info card ──────────────────────────────────
                  _ValidationHintCard(),

                  SizedBox(height: 32.h),

                  // ── Register Button ───────────────────────────────────────
                  _RegisterButton(
                    isEnabled: state.isAllValid && state.flowState is! LoadingState,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      context.read<RegisterCubit>().register();
                    },
                  ),

                  SizedBox(height: 20.h),

                  // ── Already have account ──────────────────────────────────
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: RichText(
                        text: TextSpan(
                          text: 'لديك حساب بالفعل؟ ',
                          style: getRegularStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s14,
                          ),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.sendOtpRoute,
                                    arguments: _emailController.text,
                                  );
                                },
                              text: 'تسجيل الدخول',
                              style: getBoldStyle(
                                color: ColorManager.primary,
                                fontSize: FontSize.s14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: getMediumStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s14,
      ),
    );
  }

  String? _firstNameHint(RegisterState state) {
    if (!_firstNameTouched) return null;
    final v = _firstNameController.text;
    if (v.isEmpty) return 'الاسم الأول مطلوب';
    if (v[0] != v[0].toUpperCase()) {
      return 'يجب أن يبدأ الاسم بحرف كبير (Capital)';
    }
    return 'الاسم غير صالح — يقبل أحرف إنجليزية فقط ويبدأ بـ Capital';
  }

  String? _lastNameHint(RegisterState state) {
    if (!_lastNameTouched) return null;
    final v = _lastNameController.text;
    if (v.isEmpty) return 'الاسم الأخير مطلوب';
    if (v[0] != v[0].toUpperCase()) {
      return 'يجب أن يبدأ الاسم بحرف كبير (Capital)';
    }
    return 'الاسم غير صالح — يقبل أحرف إنجليزية فقط ويبدأ بـ Capital';
  }

  String? _emailHint(RegisterState state) {
    if (!_emailTouched) return null;
    final v = _emailController.text;
    if (v.isEmpty) return 'البريد الإلكتروني مطلوب';
    return 'يرجى إدخال بريد إلكتروني صالح (مثال: user@gmail.com)';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header Section
// ─────────────────────────────────────────────────────────────────────────────
class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Back button
        // GestureDetector(
        //   onTap: () => Navigator.of(context).pop(),
        //   child: Container(
        //     width: 40.r,
        //     height: 40.r,
        //     decoration: BoxDecoration(
        //       color: ColorManager.surface,
        //       borderRadius: BorderRadius.circular(AppRadius.r12.r),
        //       border: Border.all(color: ColorManager.border),
        //     ),
        //     child: Center(
        //       child: SvgPicture.asset(
        //         IconAssets.arrowLeft,
        //         width: 20.r,
        //         height: 20.r,
        //         colorFilter: const ColorFilter.mode(
        //           ColorManager.textPrimary,
        //           BlendMode.srcIn,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        const Spacer(),
        // Logo
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerEnd,
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
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step Indicator
// ─────────────────────────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index < currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(left: index > 0 ? 6.w : 0),
            height: 4.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.r),
              gradient: isActive ? ColorManager.primaryGradient : null,
              color: isActive ? null : ColorManager.border,
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mizan Text Field — reusable, design-system compliant
// ─────────────────────────────────────────────────────────────────────────────
class _MizanTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final TextDirection textDirection;
  final String prefixIcon;
  final bool showError;
  final bool showSuccess;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _MizanTextField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.textDirection,
    required this.prefixIcon,
    this.showError = false,
    this.showSuccess = false,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.r14.r);

    Color activeBorderColor = showError
        ? ColorManager.error
        : showSuccess
        ? ColorManager.success
        : ColorManager.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: AppDuration.d200,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: showSuccess || showError
                ? [
                    BoxShadow(
                      color:
                          (showError
                                  ? ColorManager.error
                                  : ColorManager.success)
                              .withAlpha(25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textDirection: textDirection,
            style: getMediumStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s15,
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: getRegularStyle(
                color: ColorManager.textTertiary,
                fontSize: FontSize.s14,
              ),
              filled: true,
              fillColor: showError
                  ? ColorManager.errorContainer
                  : showSuccess
                  ? ColorManager.successContainer.withAlpha(80)
                  : ColorManager.surfaceVariant,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: activeBorderColor,
                  width: showError || showSuccess ? 1.5 : 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: showError ? ColorManager.error : ColorManager.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  color: ColorManager.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  color: ColorManager.error,
                  width: 1.5,
                ),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.r),
                child: SvgPicture.asset(
                  prefixIcon,
                  width: 18.r,
                  height: 18.r,
                  colorFilter: ColorFilter.mode(
                    showError
                        ? ColorManager.error
                        : showSuccess
                        ? ColorManager.success
                        : ColorManager.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon: showSuccess
                  ? Padding(
                      padding: EdgeInsets.all(12.r),
                      child: SvgPicture.asset(
                        IconAssets.checkCircle,
                        width: 18.r,
                        height: 18.r,
                        colorFilter: const ColorFilter.mode(
                          ColorManager.success,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : showError
                  ? Padding(
                      padding: EdgeInsets.all(12.r),
                      child: SvgPicture.asset(
                        IconAssets.xCircle,
                        width: 18.r,
                        height: 18.r,
                        colorFilter: const ColorFilter.mode(
                          ColorManager.error,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
        // Error message
        AnimatedSize(
          duration: AppDuration.d200,
          curve: Curves.easeOut,
          child: showError && errorText != null
              ? Padding(
                  padding: EdgeInsets.only(top: 6.h, right: 4.w),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        IconAssets.alertTriangle,
                        width: 12.r,
                        height: 12.r,
                        colorFilter: const ColorFilter.mode(
                          ColorManager.error,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          errorText!,
                          style: getRegularStyle(
                            color: ColorManager.error,
                            fontSize: FontSize.s12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Validation Hint Card
// ─────────────────────────────────────────────────────────────────────────────
class _ValidationHintCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorManager.lightSecondary,
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
        border: Border.all(color: ColorManager.secondary.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                IconAssets.helpCircle,
                width: 16.r,
                height: 16.r,
                colorFilter: const ColorFilter.mode(
                  ColorManager.darkSecondary,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'متطلبات البيانات',
                style: getSemiBoldStyle(
                  color: ColorManager.darkSecondary,
                  fontSize: FontSize.s13,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _HintRow(
            icon: IconAssets.checkCircle,
            text:
                'البريد الإلكتروني يجب أن يكون بصيغة صحيحة (مثال: user@gmail.com)',
          ),
          SizedBox(height: 6.h),
          _HintRow(
            icon: IconAssets.checkCircle,
            text:
                'الاسم الأول والأخير يجب أن يبدأ بـ حرف كبير (Capital) — مثال: Ahmed',
          ),
          SizedBox(height: 6.h),
          _HintRow(
            icon: IconAssets.checkCircle,
            text: 'الاسم يقبل أحرف إنجليزية فقط بدون أرقام أو رموز',
          ),
        ],
      ),
    );
  }
}

class _HintRow extends StatelessWidget {
  final String icon;
  final String text;
  const _HintRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: SvgPicture.asset(
            icon,
            width: 13.r,
            height: 13.r,
            colorFilter: const ColorFilter.mode(
              ColorManager.success,
              BlendMode.srcIn,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: getRegularStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s12,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Register Button
// ─────────────────────────────────────────────────────────────────────────────
class _RegisterButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;
  const _RegisterButton({required this.isEnabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: AppDuration.d300,
      opacity: isEnabled ? 1.0 : 0.5,
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isEnabled ? ColorManager.primaryGradient : null,
            color: isEnabled ? null : ColorManager.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.r14.r),
            boxShadow: isEnabled ? [AppShadows.fabShadow] : null,
          ),
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: ColorManager.white,
              disabledForegroundColor: ColorManager.textTertiary,
              disabledBackgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r14.r),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'إنشاء الحساب',
                  style: getBoldStyle(
                    color: isEnabled
                        ? ColorManager.white
                        : ColorManager.textTertiary,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_back_rounded,
                  color: isEnabled
                      ? ColorManager.white
                      : ColorManager.textTertiary,
                  size: 20.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
