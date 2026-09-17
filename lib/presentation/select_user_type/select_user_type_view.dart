import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/select_user_type/select_user_type_cubit/select_user_type_cubit.dart';
import 'package:mizan/presentation/select_user_type/select_user_type_cubit/select_user_type_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SelectUserTypeView — Account Setup / تحديد نوع الحساب
// Matches Figma Design System: Node #2025:10 to the letter
// Supports dynamic merchant fields (Shop Name & Address) with interactive map pin
// ─────────────────────────────────────────────────────────────────────────────
class SelectUserTypeView extends StatelessWidget {
  const SelectUserTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SelectUserTypeCubit>(
      create: (_) => getIt<SelectUserTypeCubit>(),
      child: const _SelectUserTypeScreen(),
    );
  }
}

class _SelectUserTypeScreen extends StatefulWidget {
  const _SelectUserTypeScreen();

  @override
  State<_SelectUserTypeScreen> createState() => _SelectUserTypeScreenState();
}

class _SelectUserTypeScreenState extends State<_SelectUserTypeScreen>
    with SingleTickerProviderStateMixin {
  // Selected user type: 'shop_owner' | 'customer'
  String? _selectedType;

  // Controllers for shop owner details
  final _shopNameController = TextEditingController();
  final _addressController = TextEditingController();

  bool _shopNameTouched = false;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _addressController.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool get _isShopNameValid {
    if (_selectedType != 'shop_owner') return true;
    final name = _shopNameController.text.trim();
    return name.isNotEmpty && name.length <= 100;
  }

  bool get _canProceed {
    if (_selectedType == null) return false;
    if (_selectedType == 'shop_owner') {
      return _isShopNameValid;
    }
    return true;
  }

  void _onConfirm(BuildContext context) {
    if (!_canProceed) {
      if (_selectedType == 'shop_owner') {
        setState(() => _shopNameTouched = true);
      }
      return;
    }

    FocusScope.of(context).unfocus();
    final cubit = context.read<SelectUserTypeCubit>();

    final shopName = _selectedType == 'shop_owner'
        ? _shopNameController.text.trim()
        : null;

    final address =
        (_selectedType == 'shop_owner' &&
            _addressController.text.trim().isNotEmpty)
        ? _addressController.text.trim()
        : null;

    cubit.selectUserType(
      userType: _selectedType!,
      shopName: shopName,
      address: address,
    );
  }

  void _onSkip(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(Routes.onBoardingRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectUserTypeCubit, SelectUserTypeState>(
      listenWhen: (prev, curr) => curr.data != null && prev.data == null,
      listener: (ctx, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Dismiss any open loading dialog
          Navigator.of(ctx, rootNavigator: true).popUntil((route) {
            return route is! PopupRoute;
          });

          // Navigate to Onboarding, clearing auth stack
          Navigator.of(
            ctx,
          ).pushNamedAndRemoveUntil(Routes.homeRoute, (route) => false);
        });
      },
      builder: (ctx, state) {
        final flowState = state.flowState;
        if (flowState is LoadingState || flowState is ErrorState) {
          final overlay = flowState!.getScreenWidget(
            ctx,
            _buildBody(ctx, state),
            () => _onConfirm(ctx),
          );
          if (overlay != null) {
            return Scaffold(
              backgroundColor: ColorManager.background,
              body: overlay,
            );
          }
        }

        return Scaffold(
          backgroundColor: ColorManager.background,
          body: _buildBody(ctx, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SelectUserTypeState state) {
    final isLoading = state.flowState is LoadingState;

    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p24.w,
              vertical: AppPadding.p12.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header Bar (Figma Node #2025:20) ────────────────────────
                _buildHeaderBar(context),

                SizedBox(height: 28.h),

                // ── Title Block (Figma Node #2025:29) ───────────────────────
                _buildTitleBlock(),

                SizedBox(height: 28.h),

                // ── Account Types Selection (Figma Node #2025:32) ───────────
                _buildAccountTypesSection(),

                // ── Dynamic Business Form for Shop Owner (Figma Node #2025:50)
                AnimatedSize(
                  duration: AppDuration.d300,
                  curve: Curves.easeInOut,
                  child: _selectedType == 'shop_owner'
                      ? _buildShopOwnerForm()
                      : const SizedBox.shrink(),
                ),

                SizedBox(height: 32.h),

                // ── Primary Action Button ("تأكيد ومتابعة") ──────────────────
                _buildActionButton(context, isLoading),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header Bar with Step Indicator ("الخطوة ٣ من ٣") and Skip Action ("تخطي")
  Widget _buildHeaderBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Skip Button (تخطي)
        GestureDetector(
          onTap: () => _onSkip(context),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
            child: Text(
              AppStrings.skip,
              style: getBoldStyle(
                color: ColorManager.primary,
                fontSize: FontSize.s14,
              ),
            ),
          ),
        ),

        // Step Indicator (الخطوة ٣ من ٣ + 3 Dots)
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.step3Of3,
              style: getBoldStyle(
                color: ColorManager.textTertiary,
                fontSize: FontSize.s12,
              ),
            ),
            SizedBox(width: 8.w),
            // Dots: 2 dots + 1 active pill
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(isPill: false),
                SizedBox(width: 4.w),
                _buildDot(isPill: false),
                SizedBox(width: 4.w),
                _buildDot(isPill: true),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDot({required bool isPill}) {
    if (isPill) {
      return Container(
        width: 16.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: ColorManager.primary,
          borderRadius: BorderRadius.circular(3.r),
        ),
      );
    }
    return Container(
      width: 6.r,
      height: 6.r,
      decoration: const BoxDecoration(
        color: ColorManager.primary,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Title Block ("إعداد الحساب" + Subtitle)
  Widget _buildTitleBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.accountSetupTitle,
          style: getBlackStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s24,
            height: 1.35,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          AppStrings.accountSetupSubtitle,
          style: getMediumStyle(
            color: ColorManager.textSecondary,
            fontSize: FontSize.s14,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  /// Account Types Section ("نوع الحساب" + Merchant & Customer Cards)
  Widget _buildAccountTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.accountType,
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s14,
          ),
        ),
        SizedBox(height: 12.h),

        // Merchant / Shop Owner Card (Figma Node #2025:34)
        _UserTypeSelectionCard(
          title: AppStrings.merchantTypeTitle,
          subtitle: AppStrings.merchantTypeSubtitle,
          icon: IconAssets.store,
          isSelected: _selectedType == 'shop_owner',
          onTap: () {
            setState(() {
              _selectedType = 'shop_owner';
            });
          },
        ),

        SizedBox(height: 12.h),

        // Customer / Agent Card (Figma Node #2025:42)
        _UserTypeSelectionCard(
          title: AppStrings.customerTypeTitle,
          subtitle: AppStrings.customerTypeSubtitle,
          icon: IconAssets.user,
          isSelected: _selectedType == 'customer',
          onTap: () {
            setState(() {
              _selectedType = 'customer';
            });
          },
        ),
      ],
    );
  }

  /// Dynamic Business Form: Divider line + Shop Name + Address with Map Pin
  Widget _buildShopOwnerForm() {
    final hasShopNameError =
        _shopNameTouched && _shopNameController.text.trim().isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider Line (Figma Node #2025:49)
        Container(
          width: double.infinity,
          height: 1.0,
          color: ColorManager.divider,
          margin: EdgeInsets.symmetric(vertical: 24.h),
        ),

        // Section Title: بيانات النشاط التجاري (Figma Node #2025:51)
        Text(
          AppStrings.businessInfo,
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s14,
          ),
        ),

        SizedBox(height: 16.h),

        // Field 1: اسم المحل / النشاط (Figma Node #2025:52)
        Text(
          AppStrings.shopNameLabel,
          style: getBoldStyle(
            color: ColorManager.textSecondary,
            fontSize: FontSize.s12,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _shopNameController,
          maxLength: 100,
          textDirection: TextDirection.rtl,
          style: getMediumStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s14,
          ),
          onChanged: (val) {
            setState(() {
              _shopNameTouched = true;
            });
          },
          decoration: InputDecoration(
            counterText: "",
            hintText: AppStrings.shopNameHint,
            hintStyle: getMediumStyle(
              color: ColorManager.textTertiary,
              fontSize: FontSize.s14,
            ),
            filled: true,
            fillColor: ColorManager.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: BorderSide(
                color: hasShopNameError
                    ? ColorManager.error
                    : ColorManager.border,
                width: hasShopNameError ? 1.5 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: BorderSide(
                color: hasShopNameError
                    ? ColorManager.error
                    : ColorManager.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: const BorderSide(
                color: ColorManager.error,
                width: 1.5,
              ),
            ),
          ),
        ),

        if (hasShopNameError) ...[
          SizedBox(height: 6.h),
          Row(
            children: [
              SvgPicture.asset(
                IconAssets.alertTriangle,
                width: 13.r,
                height: 13.r,
                colorFilter: const ColorFilter.mode(
                  ColorManager.error,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                AppStrings.shopNameRequired,
                style: getRegularStyle(
                  color: ColorManager.error,
                  fontSize: FontSize.s12,
                ),
              ),
            ],
          ),
        ],

        SizedBox(height: 16.h),

        // Field 2: العنوان مع زر تحديد الموقع (Figma Node #2025:56 & #2025:58)
        Text(
          AppStrings.addressLabel,
          style: getBoldStyle(
            color: ColorManager.textSecondary,
            fontSize: FontSize.s12,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _addressController,
          textDirection: TextDirection.rtl,
          style: getMediumStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s14,
          ),
          decoration: InputDecoration(
            hintText: AppStrings.addressHint,
            hintStyle: getMediumStyle(
              color: ColorManager.textTertiary,
              fontSize: FontSize.s14,
            ),
            filled: true,
            fillColor: ColorManager.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: const BorderSide(
                color: ColorManager.border,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: const BorderSide(
                color: ColorManager.primary,
                width: 1.5,
              ),
            ),
            // Map Location Link Button (Figma Node #2025:59)
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: InkWell(
                onTap: () {
                  if (_addressController.text.trim().isEmpty) {
                    setState(() {
                      _addressController.text = "القاهرة، مصر";
                    });
                  }
                },
                borderRadius: BorderRadius.circular(AppRadius.r8.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ColorManager.lightPrimary,
                    borderRadius: BorderRadius.circular(AppRadius.r8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        IconAssets.mapPin,
                        width: 14.r,
                        height: 14.r,
                        colorFilter: const ColorFilter.mode(
                          ColorManager.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        AppStrings.setLocation,
                        style: getBoldStyle(
                          color: ColorManager.primary,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Primary Action Button ("تأكيد ومتابعة")
  Widget _buildActionButton(BuildContext context, bool isLoading) {
    final isEnabled = _canProceed && !isLoading;

    return AnimatedOpacity(
      duration: AppDuration.d300,
      opacity: isEnabled ? 1.0 : 0.5,
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isEnabled ? ColorManager.primaryGradient : null,
            color: isEnabled ? null : ColorManager.border,
            borderRadius: BorderRadius.circular(AppRadius.r14.r),
            boxShadow: isEnabled ? const [AppShadows.fabShadow] : null,
          ),
          child: ElevatedButton(
            onPressed: isEnabled ? () => _onConfirm(context) : null,
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
                        AppStrings.confirmAndContinue,
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// User Type Selection Card Widget
// Matches Figma: Node #2025:34 & Node #2025:42
// ─────────────────────────────────────────────────────────────────────────────
class _UserTypeSelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _UserTypeSelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDuration.d200,
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(
          color: isSelected ? ColorManager.primary : ColorManager.border,
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: ColorManager.primary.withAlpha(25),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.r16.r),
          child: Padding(
            padding: EdgeInsets.all(AppPadding.p16.r),
            child: Row(
              children: [
                // Radio Indicator (Figma Node #2025:35 & #2025:43)
                AnimatedContainer(
                  duration: AppDuration.d200,
                  width: 22.r,
                  height: 22.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorManager.surface,
                    border: Border.all(
                      color: isSelected
                          ? ColorManager.primary
                          : ColorManager.border,
                      width: 2.0,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12.r,
                            height: 12.r,
                            decoration: const BoxDecoration(
                              color: ColorManager.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),

                SizedBox(width: 16.w),

                // Text Content: Title & Subtitle (Figma Node #2025:37)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s14,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: getMediumStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12.w),

                // Icon Background Container (Figma Node #2025:40 & #2025:47)
                AnimatedContainer(
                  duration: AppDuration.d200,
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorManager.lightSecondary
                        : ColorManager.background,
                    borderRadius: BorderRadius.circular(AppRadius.r12.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      icon,
                      width: 22.r,
                      height: 22.r,
                      colorFilter: ColorFilter.mode(
                        isSelected
                            ? ColorManager.primary
                            : ColorManager.textSecondary,
                        BlendMode.srcIn,
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
