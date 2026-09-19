// ─────────────────────────────────────────────────────────────────────────────
// GetProfileView — Mizan Profile Screen (Figma Node 2025-905)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/get_profile/cubit/get_profile_cubit.dart';
import 'package:mizan/presentation/get_profile/cubit/get_profile_state.dart';
import 'package:mizan/presentation/logout/logout_cubit/logout_cubit.dart';
import 'package:mizan/presentation/logout/logout_cubit/logout_state.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class GetProfileView extends StatelessWidget {
  const GetProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<GetProfileCubit>()..getProfile(),
        ),
        BlocProvider(create: (_) => getIt<LogoutCubit>()),
      ],
      child: const _GetProfileScreen(),
    );
  }
}

class _GetProfileScreen extends StatelessWidget {
  const _GetProfileScreen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (ctx, state) {
        if (state.isLoggedOut == true) {
          Navigator.of(ctx, rootNavigator: true).popUntil((route) => route is! PopupRoute);
          Navigator.of(ctx).pushNamedAndRemoveUntil(
            Routes.sendOtpRoute,
            (route) => false,
          );
          return;
        }
        final flowState = state.flowState;
        if (flowState != null && (flowState is ErrorState || flowState is LoadingState)) {
          flowState.getScreenWidget(ctx, const SizedBox.shrink(), () {});
        }
      },
      child: BlocBuilder<GetProfileCubit, GetProfileState>(
        builder: (ctx, state) {
          final flowState = state.flowState;

          if (flowState is LoadingState) {
            return Scaffold(
              backgroundColor: ColorManager.background,
              body: flowState.getScreenWidget(
                    ctx,
                    const SizedBox.shrink(),
                    () => ctx.read<GetProfileCubit>().getProfile(),
                  ) ??
                  const SizedBox.shrink(),
            );
          }

          if (flowState is ErrorState) {
            return Scaffold(
              backgroundColor: ColorManager.background,
              body: flowState.getScreenWidget(
                    ctx,
                    const SizedBox.shrink(),
                    () => ctx.read<GetProfileCubit>().getProfile(),
                  ) ??
                  const SizedBox.shrink(),
            );
          }

          return Scaffold(
            backgroundColor: ColorManager.background,
            body: _ProfileContent(state: state),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Content
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileContent extends StatelessWidget {
  final GetProfileState state;
  const _ProfileContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final profile = state.data;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Hero Header ─────────────────────────────────────────────────
            _ProfileHeroHeader(
              firstName: profile?.firstName ?? '',
              lastName: profile?.lastName ?? '',
              email: profile?.email ?? '',
              userType: profile?.userType ?? '',
              isActive: profile?.isActive ?? false,
            ),

            SizedBox(height: 20.h),

            // ── Info Cards ───────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Info Section
                  _SectionTitle(title: AppStrings.profileAccountInfo),
                  SizedBox(height: 12.h),
                  _ProfileInfoCard(
                    children: [
                      _InfoRow(
                        icon: IconAssets.user,
                        label: AppStrings.profileFullName,
                        value:
                            '${profile?.firstName ?? ''} ${profile?.lastName ?? ''}'.trim(),
                      ),
                      _divider(),
                      _InfoRow(
                        icon: IconAssets.mailPlus,
                        label: AppStrings.profileEmail,
                        value: profile?.email ?? '—',
                        isLtr: true,
                      ),
                      _divider(),
                      _InfoRow(
                        icon: IconAssets.shieldCheck,
                        label: AppStrings.profileAccountStatus,
                        valueWidget: _StatusChip(
                          isActive: profile?.isActive ?? false,
                        ),
                      ),
                      _divider(),
                      _InfoRow(
                        icon: IconAssets.users,
                        label: AppStrings.profileUserType,
                        value: _mapUserType(profile?.userType ?? ''),
                      ),
                    ],
                  ),

                  // Shop Info Section (only if shop exists)
                  if (profile?.shop != null) ...[
                    SizedBox(height: 20.h),
                    _SectionTitle(title: AppStrings.profileShopInfo),
                    SizedBox(height: 12.h),
                    _ProfileInfoCard(
                      children: [
                        _InfoRow(
                          icon: IconAssets.store,
                          label: AppStrings.shopNameLabel,
                          value: profile?.shop?.shopName ?? '—',
                        ),
                        if ((profile?.shop?.address ?? '').isNotEmpty) ...[
                          _divider(),
                          _InfoRow(
                            icon: IconAssets.mapPin,
                            label: AppStrings.addressLabel,
                            value: profile?.shop?.address ?? '—',
                          ),
                        ],
                      ],
                    ),
                  ],

                  SizedBox(height: 24.h),

                  // ── Logout Button ────────────────────────────────────────
                  _LogoutButton(),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Divider(color: ColorManager.border, height: 1),
      );

  String _mapUserType(String type) {
    switch (type.toLowerCase()) {
      case 'merchant':
        return 'صاحب محل / تاجر';
      case 'customer':
        return 'عميل / مندوب';
      default:
        return type.isEmpty ? '—' : type;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Header — Avatar + Name + Email + Badge
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileHeroHeader extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String userType;
  final bool isActive;

  const _ProfileHeroHeader({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userType,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.r28.r),
          bottomRight: Radius.circular(AppRadius.r28.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
        child: Column(
          children: [
            // ── AppBar row ──────────────────────────────────────────────────
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: ColorManager.white.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorManager.white,
                      size: 16.r,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  AppStrings.profile,
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s17,
                  ),
                ),
                const Spacer(),
                SizedBox(width: 36.r),
              ],
            ),

            SizedBox(height: 20.h),

            // ── Avatar circle ──────────────────────────────────────────────
            Container(
              width: 84.r,
              height: 84.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.white.withAlpha(25),
                border: Border.all(
                  color: ColorManager.white.withAlpha(80),
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: getExtraBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s28,
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // ── Name ────────────────────────────────────────────────────────
            Text(
              '$firstName $lastName'.trim().isEmpty
                  ? AppStrings.profileNoName
                  : '$firstName $lastName'.trim(),
              style: getBoldStyle(
                color: ColorManager.white,
                fontSize: FontSize.s20,
              ),
            ),

            SizedBox(height: 4.h),

            // ── Email ────────────────────────────────────────────────────────
            if (email.isNotEmpty)
              Text(
                email,
                style: getRegularStyle(
                  color: ColorManager.white.withAlpha(200),
                  fontSize: FontSize.s13,
                ),
              ),

            SizedBox(height: 10.h),

            // ── Active badge ─────────────────────────────────────────────────
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isActive
                    ? ColorManager.white.withAlpha(30)
                    : ColorManager.error.withAlpha(60),
                borderRadius: BorderRadius.circular(AppRadius.r100.r),
                border: Border.all(
                  color: ColorManager.white.withAlpha(60),
                  width: 1,
                ),
              ),
              child: Text(
                isActive ? AppStrings.profileActive : AppStrings.profileInactive,
                style: getMediumStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials() {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$f$l'.isEmpty ? '?' : '$f$l';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Title
// ─────────────────────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: getSemiBoldStyle(
        color: ColorManager.textSecondary,
        fontSize: FontSize.s13,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info Card Container
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileInfoCard extends StatelessWidget {
  final List<Widget> children;
  const _ProfileInfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.border),
        boxShadow: const [AppShadows.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info Row
// ─────────────────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String icon;
  final String label;
  final String? value;
  final Widget? valueWidget;
  final bool isLtr;

  const _InfoRow({
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
    this.isLtr = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          // Icon
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: ColorManager.lightPrimary,
              borderRadius: BorderRadius.circular(AppRadius.r10.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 18.r,
                height: 18.r,
                colorFilter: const ColorFilter.mode(
                  ColorManager.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Label
          Expanded(
            child: Text(
              label,
              style: getMediumStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s14,
              ),
            ),
          ),
          // Value
          ?valueWidget,
          if (value != null)
            Flexible(
              child: Text(
                value!,
                textDirection: isLtr ? TextDirection.ltr : null,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getMediumStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status Chip
// ─────────────────────────────────────────────────────────────────────────────
class _StatusChip extends StatelessWidget {
  final bool isActive;
  const _StatusChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive ? ColorManager.successContainer : ColorManager.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.r100.r),
      ),
      child: Text(
        isActive ? AppStrings.profileActive : AppStrings.profileInactive,
        style: getMediumStyle(
          color: isActive ? ColorManager.success : ColorManager.error,
          fontSize: FontSize.s12,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logout Button
// ─────────────────────────────────────────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogoutCubit, LogoutState>(
      builder: (ctx, state) {
        final isLoading = state.flowState is LoadingState;
        return SizedBox(
          width: double.infinity,
          height: 52.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ColorManager.errorContainer,
              borderRadius: BorderRadius.circular(AppRadius.r14.r),
              border: Border.all(
                color: ColorManager.error.withAlpha(80),
              ),
            ),
            child: TextButton(
              onPressed: isLoading
                  ? null
                  : () => _showLogoutDialog(ctx),
              style: TextButton.styleFrom(
                foregroundColor: ColorManager.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r14.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ColorManager.error,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          IconAssets.lock,
                          width: 18.r,
                          height: 18.r,
                          colorFilter: const ColorFilter.mode(
                            ColorManager.error,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          AppStrings.profileLogout,
                          style: getBoldStyle(
                            color: ColorManager.error,
                            fontSize: FontSize.s15,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: ColorManager.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r20.r),
        ),
        title: Text(
          AppStrings.profileLogoutConfirmTitle,
          textAlign: TextAlign.center,
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s17,
          ),
        ),
        content: Text(
          AppStrings.profileLogoutConfirmMsg,
          textAlign: TextAlign.center,
          style: getRegularStyle(
            color: ColorManager.textSecondary,
            fontSize: FontSize.s14,
            height: 1.5,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorManager.textSecondary,
                    side: const BorderSide(color: ColorManager.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(AppStrings.cancel),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogCtx).pop();
                    context.read<LogoutCubit>().logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.error,
                    foregroundColor: ColorManager.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.profileLogout,
                    style: getBoldStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
