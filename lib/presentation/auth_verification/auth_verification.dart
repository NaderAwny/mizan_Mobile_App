import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/auth_session_model/auth_session_model.dart';
import 'package:mizan/presentation/auth_verification/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:mizan/presentation/auth_verification/verify_otp_cubit/verify_otp_state.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AuthVerification — Mizan design system & Figma Node #3:1001 compliant
// 6 Digits OTP Verification Screen with real-time border animations & timer
// ─────────────────────────────────────────────────────────────────────────────
class AuthVerification extends StatelessWidget {
  final String? initialEmail;
  // True when navigated here from the Registration flow.
  // False (default) when navigated from the Login (SendOtp) flow.
  final bool isFromRegistration;

  const AuthVerification({
    super.key,
    this.initialEmail,
    this.isFromRegistration = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VerifyOtpCubit>(
      create: (_) => getIt<VerifyOtpCubit>(),
      child: _AuthVerificationScreen(
        initialEmail: initialEmail,
        isFromRegistration: isFromRegistration,
      ),
    );
  }
}

class _AuthVerificationScreen extends StatefulWidget {
  final String? initialEmail;
  final bool isFromRegistration;

  const _AuthVerificationScreen({
    this.initialEmail,
    this.isFromRegistration = false,
  });

  @override
  State<_AuthVerificationScreen> createState() =>
      _AuthVerificationScreenState();
}

class _AuthVerificationScreenState extends State<_AuthVerificationScreen>
    with TickerProviderStateMixin {
  static const int _otpLength = 6;

  // Controllers and FocusNodes for each of the 6 digits
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  // Track validity / state for each box
  // true = digit, false = non-digit (character/letter), null = empty
  late final List<bool?> _boxStatus;

  // Screen entrance animations
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  // Shake animation for non-digit/error feedback
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnim;

  String? _inlineError;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _userEmail = widget.initialEmail?.trim() ?? '';

    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _boxStatus = List.generate(_otpLength, (_) => null);

    for (int i = 0; i < _otpLength; i++) {
      _focusNodes[i].addListener(() {
        if (mounted) setState(() {});
      });
    }

    // Screen entrance animation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();

    // Shake animation setup
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _animController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  String get _currentOtpCode {
    return _controllers.map((c) => c.text).join();
  }

  bool get _isCodeComplete {
    final code = _currentOtpCode;
    return code.length == _otpLength && RegExp(r'^\d+$').hasMatch(code);
  }

  void _handleBoxChanged(int index, String value) {
    setState(() {
      _inlineError = null;

      if (value.isEmpty) {
        _boxStatus[index] = null;
        return;
      }

      // Handle multi-character paste
      if (value.length > 1) {
        _handlePastedCode(value);
        return;
      }

      final char = value;
      final isDigit = RegExp(r'^[0-9]$').hasMatch(char);

      if (isDigit) {
        _boxStatus[index] = true;
        // Move to next field automatically
        if (index < _otpLength - 1) {
          _focusNodes[index + 1].requestFocus();
        } else {
          _focusNodes[index].unfocus();
          // If code is completely 6 digits, auto trigger verification
          if (_isCodeComplete) {
            _onVerify();
          }
        }
      } else {
        // Non-digit: character/letter entered -> Turn border RED and trigger shake!
        _boxStatus[index] = false;
        _inlineError = 'يرجى إدخال أرقام فقط (0-9). الحروف غير مقبولة';
        _triggerShake();
      }
    });
  }

  void _handlePastedCode(String pasted) {
    // Clean spaces and take up to 6 characters
    final clean = pasted.replaceAll(RegExp(r'\s+'), '');
    final chars = clean.split('');

    bool hadInvalidChar = false;

    for (int i = 0; i < _otpLength; i++) {
      if (i < chars.length) {
        final char = chars[i];
        _controllers[i].text = char;
        final isDigit = RegExp(r'^[0-9]$').hasMatch(char);
        _boxStatus[i] = isDigit;
        if (!isDigit) hadInvalidChar = true;
      } else {
        _controllers[i].clear();
        _boxStatus[i] = null;
      }
    }

    if (hadInvalidChar) {
      _inlineError = 'الرمز الملصق يحتوي على حروف أو رموز غير رقمية';
      _triggerShake();
    } else {
      _inlineError = null;
      final targetIndex = (chars.length < _otpLength)
          ? chars.length
          : _otpLength - 1;
      _focusNodes[targetIndex].requestFocus();

      if (_isCodeComplete) {
        _onVerify();
      }
    }
  }

  void _triggerShake() {
    _shakeController.reset();
    _shakeController.forward();
    HapticFeedback.heavyImpact();
  }

  void _onVerify() {
    FocusScope.of(context).unfocus();
    if (!_isCodeComplete) {
      setState(() {
        _inlineError = 'يرجى إدخال جميع أرقام رمز التحقق الـ 6';
      });
      _triggerShake();
      return;
    }

    if (_userEmail.isEmpty) {
      setState(() {
        _inlineError = 'يرجى التأكد من البريد الإلكتروني';
      });
      return;
    }

    context.read<VerifyOtpCubit>().verify(
      email: _userEmail,
      code: _currentOtpCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
      listenWhen: (prev, curr) => curr.data != null && prev.data == null,
      listener: (ctx, state) {
        // Dismiss any loading dialogs
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(ctx, rootNavigator: true).popUntil((route) {
            return route is! PopupRoute;
          });

          // Show Mizan Lottie Success Dialog
          _showSuccessPopDialog(ctx, state.data);
        });
      },
      builder: (ctx, state) {
        final flowState = state.flowState;
        if (flowState is LoadingState || flowState is ErrorState) {
          final overlay = flowState!.getScreenWidget(
            ctx,
            _buildBody(ctx, state),
            () => _onVerify(),
          );
          if (overlay != null) return _withScaffold(ctx, overlay);
        }
        return _withScaffold(ctx, _buildBody(ctx, state));
      },
    );
  }

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      if (widget.isFromRegistration) {
        Navigator.of(context).pushReplacementNamed(Routes.registerRoute);
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.sendOtpRoute);
      }
    }
  }

  Widget _withScaffold(BuildContext context, Widget body) {
    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack(context);
      },
      child: Scaffold(backgroundColor: ColorManager.background, body: body),
    );
  }

  Widget _buildBody(BuildContext context, VerifyOtpState state) {
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // ── Header Section (Back button + Logo) ──────────────────────
                _HeaderSection(onBack: () => _handleBack(context)),

                SizedBox(height: 28.h),

                // ── Title Block ──────────────────────────────────────────────
                Text(
                  AppStrings.verificationCode,
                  style: getExtraBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s24,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'أدخل رمز التحقق المكون من 6 أرقام المرسل إلى:',
                  style: getMediumStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s14,
                  ),
                ),

                SizedBox(height: 12.h),

                // ── Email Chip with Edit option ──────────────────────────────
                _buildEmailInfoBadge(),

                SizedBox(height: 32.h),

                // ── 6-Digits Animated OTP Input Field ────────────────────────
                Center(
                  child: AnimatedBuilder(
                    animation: _shakeAnim,
                    builder: (context, child) {
                      final offset =
                          (_shakeAnim.value > 0 && _shakeAnim.value < 1)
                          ? (5 *
                                (1 - _shakeAnim.value) *
                                (1 - 2 * (_shakeAnim.value * 5 % 2)))
                          : 0.0;
                      return Transform.translate(
                        offset: Offset(offset, 0),
                        child: child,
                      );
                    },
                    child: _buildSixDigitBoxes(),
                  ),
                ),

                // ── Real-time Inline Feedback (Green / Red indicator) ────────
                SizedBox(height: 10.h),
                _buildInlineStatusFeedback(),

                SizedBox(height: 20.h),

                // ── Important Notice Card (⚠️ تنبيه مهم) ─────────────────────
                _ImportantNoticeCard(),

                SizedBox(height: 36.h),

                // ── Primary Action Button ("تأكيد ومتابعة ←") ───────────────────
                _VerifyButton(
                  isComplete: _isCodeComplete,
                  isLoading: state.flowState is LoadingState,
                  onPressed: _onVerify,
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInfoBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: ColorManager.lightPrimary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                IconAssets.mailPlus,
                width: 16.r,
                height: 16.r,
                colorFilter: const ColorFilter.mode(
                  ColorManager.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              _userEmail.isNotEmpty ? _userEmail : 'بريدك الإلكتروني',
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSixDigitBoxes() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_otpLength, (index) {
          return _buildSingleOtpBox(index);
        }),
      ),
    );
  }

  Widget _buildSingleOtpBox(int index) {
    final status = _boxStatus[index];
    final isFocused = _focusNodes[index].hasFocus;
    final hasValue = _controllers[index].text.isNotEmpty;

    // Dynamic border and shadow color based on character type:
    // Digit => Green, Non-digit => Red, Focused empty => Primary terracotta, Unfocused empty => Border
    Color borderColor;
    Color fillColor;
    List<BoxShadow>? shadows;
    double borderWidth = 1.2;

    if (hasValue) {
      if (status == true) {
        // Digit -> Green!
        borderColor = ColorManager.brandGreen;
        fillColor = ColorManager.surface;
        borderWidth = 2.0;
        shadows = [
          BoxShadow(
            color: ColorManager.success.withAlpha(35),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
      } else {
        // Non-digit -> Red!
        borderColor = ColorManager.error;
        fillColor = ColorManager.errorContainer;
        borderWidth = 2.0;
        shadows = [
          BoxShadow(
            color: ColorManager.error.withAlpha(45),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
      }
    } else if (isFocused) {
      borderColor = ColorManager.primary;
      fillColor = ColorManager.surface;
      borderWidth = 1.8;
      shadows = [
        BoxShadow(
          color: ColorManager.primary.withAlpha(30),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    } else {
      borderColor = ColorManager.border;
      fillColor = ColorManager.surfaceVariant;
    }

    return AnimatedContainer(
      duration: AppDuration.d200,
      width: 46.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: shadows,
      ),
      alignment: Alignment.center,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              _controllers[index].text.isEmpty &&
              index > 0) {
            _focusNodes[index - 1].requestFocus();
            _controllers[index - 1].clear();
            _boxStatus[index - 1] = null;
            setState(() {});
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Center(
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            inputFormatters: [LengthLimitingTextInputFormatter(1)],
            strutStyle: StrutStyle(
              fontFamily: FontConstants.montserratFontFamily,
              fontSize: 24.sp,
              height: 1.0,
              forceStrutHeight: true,
            ),
            style: TextStyle(
              fontFamily: FontConstants.montserratFontFamily,
              fontSize: 24.sp,
              fontWeight: FontWeightManager.extraBold,
              color: (status == false)
                  ? ColorManager.error
                  : ColorManager.textPrimary,
              height: 1.0,
            ),
            showCursor: true,
            cursorColor: ColorManager.primary,
            cursorWidth: 2.2,
            cursorHeight: 24.h,
            cursorRadius: const Radius.circular(2.0),
            decoration: const InputDecoration(
              isDense: true,
              isCollapsed: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              filled: false,
            ),
            onChanged: (val) {
              _handleBoxChanged(index, val);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInlineStatusFeedback() {
    if (_inlineError != null) {
      return Row(
        children: [
          SvgPicture.asset(
            IconAssets.alertTriangle,
            width: 14.r,
            height: 14.r,
            colorFilter: const ColorFilter.mode(
              ColorManager.error,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              _inlineError!,
              style: getMediumStyle(
                color: ColorManager.error,
                fontSize: FontSize.s12,
              ),
            ),
          ),
        ],
      );
    }

    if (_isCodeComplete) {
      return Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 15.r,
            color: ColorManager.brandGreen,
          ),
          SizedBox(width: 6.w),
          Text(
            'تم إدخال الرمز بنجاح بالكامل',
            style: getBoldStyle(
              color: ColorManager.brandGreen,
              fontSize: FontSize.s12,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _showSuccessPopDialog(BuildContext context, AuthSession? session) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 26.h),
            decoration: BoxDecoration(
              color: ColorManager.surface,
              borderRadius: BorderRadius.circular(AppRadius.r20.r),
              border: Border.all(color: ColorManager.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie Success Animation
                SizedBox(
                  width: 130.w,
                  height: 130.w,
                  child: Lottie.asset(
                    JsonAssets.success,
                    fit: BoxFit.contain,
                    animate: true,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80.r,
                        height: 80.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEBF3EC),
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
                  'تم تأكيد الحساب بنجاح',
                  style: getExtraBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),

                // Description
                Text(
                  'مرحباً بك في ميزان!\nتم التحقق من بريدك الإلكتروني بنجاح وتسجيل دخولك إلى التطبيق.',
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Primary Action Button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: ColorManager.primaryGradient,
                      borderRadius: BorderRadius.circular(AppRadius.r14.r),
                      boxShadow: const [AppShadows.fabShadow],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogCtx).pop();

                        // ── Navigation Contract based on session.isNewUser ───
                        // Server is the single source of truth:
                        // isNewUser == true  → Select-User-Type screen
                        // isNewUser == false → Home screen directly
                        final isNewUser = session?.isNewUser ?? false;

                        if (isNewUser) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.selectUserRoute,
                            (route) => false,
                          );
                          return;
                        }

                        Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.homeRoute,
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: ColorManager.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r14.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'المتابعة إلى التطبيق',
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
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header Section — matches Figma & Register/SendOtp screens
// ─────────────────────────────────────────────────────────────────────────────
class _HeaderSection extends StatelessWidget {
  final VoidCallback? onBack;

  const _HeaderSection({this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Back button (36x36 rounded)
        GestureDetector(
          onTap: () {
            if (onBack != null) {
              onBack!();
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed(Routes.registerRoute);
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
        // Mizan Logo Box + App Name
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerEnd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
// Important Notice Card — matches Figma & SendOtp screen
// ─────────────────────────────────────────────────────────────────────────────
class _ImportantNoticeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EE),
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: const Color(0xFFE8D8B7), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
            'رمز التحقق قد يصل إلى مجلد الرسائل غير المرغوب فيها (Spam) في بريدك الإلكتروني. يرجى مراجعة هذا المجلد إذا لم تجد الرسالة في البريد الوارد خلال دقيقة.',
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
// Verify Primary Button ("تأكيد ومتابعة ←")
// ─────────────────────────────────────────────────────────────────────────────
class _VerifyButton extends StatelessWidget {
  final bool isComplete;
  final bool isLoading;
  final VoidCallback onPressed;

  const _VerifyButton({
    required this.isComplete,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = isComplete && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: AnimatedContainer(
        duration: AppDuration.d300,
        decoration: BoxDecoration(
          gradient: isEnabled ? ColorManager.primaryGradient : null,
          color: isEnabled ? null : ColorManager.border,
          borderRadius: BorderRadius.circular(AppRadius.r14.r),
          boxShadow: isEnabled ? const [AppShadows.fabShadow] : null,
        ),
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: ColorManager.white,
            disabledForegroundColor: ColorManager.textTertiary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r14.r),
            ),
            padding: EdgeInsets.zero,
          ),
          child: isLoading
              ? SizedBox(
                  width: 22.r,
                  height: 22.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorManager.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'تأكيد ومتابعة',
                      style: getBoldStyle(
                        color: isEnabled
                            ? ColorManager.white
                            : ColorManager.textTertiary,
                        fontSize: FontSize.s15,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_back_rounded,
                      color: isEnabled
                          ? ColorManager.white
                          : ColorManager.textTertiary,
                      size: 18.r,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
