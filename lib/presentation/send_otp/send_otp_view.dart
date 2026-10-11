import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/send_otp/cubit/send_otp_cubit/send_otp_cubit.dart';
import 'package:mizan/presentation/send_otp/cubit/send_otp_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SendOtp — Mizan design system compliant & Figma Node #2131:78
// ─────────────────────────────────────────────────────────────────────────────
class SendOtp extends StatelessWidget {
  final String? initialEmail;
  final bool autoStartTimer;
  final int initialTimerSeconds;

  const SendOtp({
    super.key,
    this.initialEmail,
    this.autoStartTimer = false,
    this.initialTimerSeconds = 120,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SendOtpCubit>(
      create: (_) {
        final SendOtpCubit cubit = getIt<SendOtpCubit>();
        if (initialEmail != null && initialEmail!.isNotEmpty) {
          cubit.setEmail(initialEmail!);
        }
        if (autoStartTimer) {
          cubit.startTimer(initialTimerSeconds);
        }
        return cubit;
      },
      child: _SendOtpScreen(initialEmail: initialEmail),
    );
  }
}

class _SendOtpScreen extends StatefulWidget {
  final String? initialEmail;

  const _SendOtpScreen({this.initialEmail});

  @override
  State<_SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<_SendOtpScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    if (widget.initialEmail != null && widget.initialEmail!.isNotEmpty) {
      _emailController.text = widget.initialEmail!;
    }

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendOtpCubit, SendOtpState>(
      listenWhen: (SendOtpState prev, SendOtpState curr) =>
          curr.sendOtpSuccess && !prev.sendOtpSuccess,
      listener: (BuildContext ctx, SendOtpState state) {
        // Start 120-second countdown via Cubit (no more _startTimer in view)
        ctx.read<SendOtpCubit>().startTimer(120);

        // Ensure loading popup is dismissed before showing success popup
        WidgetsBinding.instance.addPostFrameCallback((Duration _) {
          // Pop any loading dialog if currently showing
          Navigator.of(ctx, rootNavigator: true).popUntil((
            Route<dynamic> route,
          ) {
            return route is! PopupRoute;
          });

          // Show modern Lottie success popdialog
          _showSuccessPopDialog(ctx, state.email);
        });
      },
      // The outer builder only reacts to flowState (loading / error overlay).
      // Every widget that reads other state fields has its OWN BlocBuilder below.
      buildWhen: (SendOtpState p, SendOtpState c) => p.flowState != c.flowState,
      builder: (BuildContext ctx, SendOtpState state) {
        // Show loading/error overlay only when state is LoadingState or ErrorState
        final FlowState? flowState = state.flowState;
        if (flowState is LoadingState || flowState is ErrorState) {
          final Widget? overlay = flowState!.getScreenWidget(
            ctx,
            _buildBody(ctx, state),
            () => ctx.read<SendOtpCubit>().sendOtp(),
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

  Widget _buildBody(BuildContext context, SendOtpState state) {
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
                children: <Widget>[
                  SizedBox(height: 16.h),

                  // ── Header (Back button + Logo) ───────────────────────────
                  _HeaderSection(),

                  SizedBox(height: 28.h),

                  // ── Title Block ──────────────────────────────────────────
                  Text(
                    'تسجيل الدخول',
                    style: getExtraBoldStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s24,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'أدخل بريدك الإلكتروني لإرسال رمز التحقق',
                    style: getMediumStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s14,
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // ── Email Input Field ────────────────────────────────────
                  _buildLabel('البريد الإلكتروني'),
                  SizedBox(height: 8.h),
                  // FIX: own BlocBuilder, so showError/showSuccess update while typing
                  BlocBuilder<SendOtpCubit, SendOtpState>(
                    buildWhen: (SendOtpState p, SendOtpState c) =>
                        p.emailTouched != c.emailTouched ||
                        p.isEmailValid != c.isEmailValid,
                    builder: (BuildContext ctx, SendOtpState s) {
                      return _MizanEmailField(
                        controller: _emailController,
                        hintText: 'name@example.com',
                        showError: s.emailTouched && !s.isEmailValid,
                        errorText: _emailHint(s),
                        showSuccess: s.emailTouched && s.isEmailValid,
                        onChanged: (String val) {
                          ctx.read<SendOtpCubit>().touchEmail();
                          ctx.read<SendOtpCubit>().setEmail(val);
                        },
                      );
                    },
                  ),

                  SizedBox(height: 24.h),

                  // ── Important Notice Card (⚠️ تنبيه مهم) ─────────────────
                  _ImportantNoticeCard(),

                  SizedBox(height: 24.h),

                  // ── Countdown Timer Widget ────────────────────────────────
                  const _CountdownTimerWidget(),

                  SizedBox(height: 32.h),

                  // ── Send Button ("إرسال الرمز ←") ────────────────────────
                  // FIX: the button reads everything it needs from the Cubit itself
                  _SendButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      context.read<SendOtpCubit>().sendOtp();
                    },
                  ),

                  SizedBox(height: 16.h),

                  // ── Return to Registration ("العودة إلى التسجيل") ──────────
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.registerRoute);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                      ),
                      child: Text(
                        "العودة إلى إنشاء حساب ؟",
                        style: getBoldStyle(
                          color: ColorManager.primary,
                          fontSize: FontSize.s14,
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
      style: getBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s13,
      ),
    );
  }

  String? _emailHint(SendOtpState state) {
    if (!state.emailTouched) return null;
    final String v = _emailController.text.trim();
    if (v.isEmpty) return 'البريد الإلكتروني مطلوب';
    return 'يرجى إدخال بريد إلكتروني صالح (مثال: name@example.com)';
  }

  void _showSuccessPopDialog(BuildContext context, String email) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogCtx) {
        return Dialog(
          backgroundColor: ColorManager.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 26.h),
            decoration: BoxDecoration(
              color: ColorManager.surface,
              borderRadius: BorderRadius.circular(AppRadius.r20.r),
              border: Border.all(color: ColorManager.border),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: ColorManager.shadowDark,
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Lottie Success Animation
                SizedBox(
                  width: 130.w,
                  height: 130.w,
                  child: Lottie.asset(
                    JsonAssets.success,
                    fit: BoxFit.contain,
                    animate: true,
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          return Container(
                            width: 80.r,
                            height: 80.r,
                            decoration: const BoxDecoration(
                              color: ColorManager.successBg,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle_rounded,
                              color: ColorManager.success,
                              size: 54.r,
                            ),
                          );
                        },
                  ),
                ),
                SizedBox(height: 12.h),

                // Success Title
                Text(
                  'تم إرسال رمز التحقق',
                  style: getExtraBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),

                // Email & Notice description
                Text(
                  'تم إرسال رمز التحقق بنجاح إلى بريدك الإلكتروني:\n${email.isNotEmpty ? email : _emailController.text.trim()}\n\nيرجى مراجعة صندوق الوارد أو مجلد الرسائل غير المرغوب فيها (Spam).',
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Primary Action Button (Navigate to Auth Verification)
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: ColorManager.primaryGradient,
                      borderRadius: BorderRadius.circular(AppRadius.r14.r),
                      boxShadow: const <BoxShadow>[AppShadows.fabShadow],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogCtx).pop();
                        context.read<SendOtpCubit>().resetSuccess();
                        Navigator.of(context).pushNamed(
                          Routes.authVerificationRoute,
                          arguments: email.isNotEmpty
                              ? email
                              : _emailController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.transparent,
                        shadowColor: ColorManager.transparent,
                        foregroundColor: ColorManager.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r14.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'إدخال رمز التحقق',
                            style: getBoldStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s15,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.arrow_back_rounded,
                            color: ColorManager.white,
                            size: 18.r,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                // Secondary Close Action
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogCtx).pop();
                    context.read<SendOtpCubit>().resetSuccess();
                  },
                  child: Text(
                    'إغلاق',
                    style: getMediumStyle(
                      color: ColorManager.textTertiary,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header Section — matches Figma & Register screen
// ─────────────────────────────────────────────────────────────────────────────
class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // Back button (36x36 / 40x40 rounded)
        GestureDetector(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: ColorManager.surface,
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              border: Border.all(color: ColorManager.border),
            ),
            child: Center(
              child: SvgPicture.asset(
                IconAssets.arrowLeft,
                width: 18.r,
                height: 18.r,
                colorFilter: const ColorFilter.mode(
                  ColorManager.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        // Mizan Logo (Box icon + app name)
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerEnd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                ImageAssets.logoBoxFigmaPng,
                width: 76.w,
                height: 70.w,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 2.w),
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
// Email Input Field — Design-system compliant
// ─────────────────────────────────────────────────────────────────────────────
class _MizanEmailField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool showError;
  final bool showSuccess;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _MizanEmailField({
    required this.controller,
    required this.hintText,
    this.showError = false,
    this.showSuccess = false,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(AppRadius.r16.r);

    final Color activeBorderColor = showError
        ? ColorManager.error
        : (showSuccess ? ColorManager.success : ColorManager.border);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedContainer(
          duration: AppDuration.d200,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: showSuccess || showError
                ? <BoxShadow>[
                    BoxShadow(
                      color:
                          (showError
                                  ? ColorManager.error
                                  : ColorManager.success)
                              .withAlpha(20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
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
                  : (showSuccess
                        ? ColorManager.successContainer.withAlpha(70)
                        : ColorManager.surfaceVariant),
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
                  IconAssets.mailPlus,
                  width: 18.r,
                  height: 18.r,
                  colorFilter: ColorFilter.mode(
                    showError
                        ? ColorManager.error
                        : (showSuccess
                              ? ColorManager.success
                              : ColorManager.textSecondary),
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
                  : (showError
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
                        : null),
            ),
          ),
        ),
        // Real-time Error feedback
        AnimatedSize(
          duration: AppDuration.d200,
          curve: Curves.easeOut,
          child: showError && errorText != null
              ? Padding(
                  padding: EdgeInsets.only(top: 6.h, right: 4.w),
                  child: Row(
                    children: <Widget>[
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
// Important Notice Card — Figma Node #2131:101
// ─────────────────────────────────────────────────────────────────────────────
class _ImportantNoticeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorManager.warningBg,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.warningBorder, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '⚠️ تنبيه مهم',
                style: getExtraBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s14,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'رمز التحقق سيصل إلى بريدك الإلكتروني وقد يكون في مجلد الرسائل غير المرغوب فيها (Spam) في Gmail. يرجى التحقق من هذا المجلد إذا لم تجد الرسالة في البريد الوارد.',
            style: getMediumStyle(
              color: ColorManager.textSecondary,
              fontSize: 12.5.sp,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Countdown Timer Widget — reads secondsLeft from BlocBuilder
// ─────────────────────────────────────────────────────────────────────────────
class _CountdownTimerWidget extends StatelessWidget {
  const _CountdownTimerWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendOtpCubit, SendOtpState>(
      buildWhen: (SendOtpState p, SendOtpState c) =>
          p.secondsLeft != c.secondsLeft,
      builder: (BuildContext context, SendOtpState state) {
        final int seconds = state.secondsLeft;
        final bool isRunning = seconds > 0;
        final bool isUrgent = seconds <= 10 && isRunning;

        // Color shifts to red in the last 10 seconds!
        final Color activeColor = isUrgent
            ? ColorManager.errorRedVariant
            : (isRunning ? ColorManager.textTertiary : ColorManager.primary);

        final String minutes = (seconds ~/ 60).toString().padLeft(2, '0');
        final String secs = (seconds % 60).toString().padLeft(2, '0');
        final String formattedTime = '$minutes:$secs';

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: getBoldStyle(color: activeColor, fontSize: FontSize.s13),
              child: Text(
                isRunning
                    ? 'إعادة الإرسال خلال $formattedTime'
                    : 'يمكنك الآن إعادة إرسال الرمز',
              ),
            ),
            SizedBox(width: 8.w),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Icon(Icons.timer_outlined, size: 16.r, color: activeColor),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Send Button — reads EVERYTHING it needs from the Cubit state itself.
// buildWhen covers every field used: secondsLeft, isAllValid, loading flag.
// ─────────────────────────────────────────────────────────────────────────────
class _SendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SendButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendOtpCubit, SendOtpState>(
      buildWhen: (SendOtpState p, SendOtpState c) =>
          p.secondsLeft != c.secondsLeft ||
          p.isAllValid != c.isAllValid ||
          (p.flowState is LoadingState) != (c.flowState is LoadingState),
      builder: (BuildContext context, SendOtpState state) {
        final int seconds = state.secondsLeft;
        final bool isTimerActive = seconds > 0;
        final bool isLoading = state.flowState is LoadingState;
        // Button enabled ONLY if email valid, timer finished (0), and not loading
        final bool isEnabled = state.isAllValid && !isTimerActive && !isLoading;

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
                borderRadius: BorderRadius.circular(AppRadius.r16.r),
                boxShadow: isEnabled
                    ? const <BoxShadow>[AppShadows.fabShadow]
                    : null,
              ),
              child: ElevatedButton(
                onPressed: isEnabled ? onPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.transparent,
                  shadowColor: ColorManager.transparent,
                  foregroundColor: ColorManager.white,
                  disabledForegroundColor: ColorManager.textTertiary,
                  disabledBackgroundColor: ColorManager.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r16.r),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      isTimerActive
                          ? 'إرسال الرمز (${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')})'
                          : 'إرسال الرمز ←',
                      style: getExtraBoldStyle(
                        color: isEnabled
                            ? ColorManager.white
                            : ColorManager.textTertiary,
                        fontSize: FontSize.s16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
