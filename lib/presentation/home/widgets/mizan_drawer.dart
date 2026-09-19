// ─────────────────────────────────────────────────────────────────────────────
// MizanDrawer — App navigation drawer (Figma Node 2218-9)
// Simple, fast, no cubit — pure navigation widget
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class MizanDrawer extends StatelessWidget {
  const MizanDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorManager.surface,
      width: 0.75.sw,
      child: SafeArea(
        child: Column(
          children: [
            // ── Header / Logo area ───────────────────────────────────────────
            _DrawerHeader(),

            Divider(color: ColorManager.border, height: 1),

            // ── Navigation items ─────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                physics: const BouncingScrollPhysics(),
                children: [
                  _DrawerItem(
                    icon: IconAssets.home,
                    label: AppStrings.home,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.homeRoute,
                        (route) => false,
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: IconAssets.receiptText,
                    label: AppStrings.transactions,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(Routes.transactionsRoute);
                    },
                  ),
                  _DrawerItem(
                    icon: IconAssets.users,
                    label: AppStrings.contacts,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(Routes.customersRoute);
                    },
                  ),
                  _DrawerItem(
                    icon: IconAssets.walletCards,
                    label: AppStrings.installments,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(Routes.installmentsRoute);
                    },
                  ),
                  _DrawerItem(
                    icon: IconAssets.chartNetwork,
                    label: AppStrings.analytics,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(Routes.analyticsRoute);
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: Divider(color: ColorManager.border, height: 1),
                  ),

                  _DrawerItem(
                    icon: IconAssets.user,
                    label: AppStrings.profile,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(Routes.profileRoute);
                    },
                  ),
                  _DrawerItem(
                    icon: IconAssets.bell,
                    label: AppStrings.notifications,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(Routes.notificationsRoute);
                    },
                  ),
                ],
              ),
            ),

            // ── Footer branding ──────────────────────────────────────────────
            _DrawerFooter(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────
class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
      ),
      child: Row(
        children: [
          // Logo
          Image.asset(
            ImageAssets.logoBoxFigmaPng,
            width: 48.r,
            height: 48.r,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.appName,
                style: getExtraBoldStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s22,
                ),
              ),
              Text(
                AppStrings.appTagline,
                style: getRegularStyle(
                  color: ColorManager.white.withAlpha(200),
                  fontSize: FontSize.s12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Drawer Item
// ─────────────────────────────────────────────────────────────────────────────
class _DrawerItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
          child: Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
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
              SizedBox(width: 14.w),
              Text(
                label,
                style: getMediumStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s15,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                IconAssets.chevronLeft,
                width: 16.r,
                height: 16.r,
                colorFilter: const ColorFilter.mode(
                  ColorManager.textTertiary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Footer
// ─────────────────────────────────────────────────────────────────────────────
class _DrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Text(
        '© ${DateTime.now().year} ${AppStrings.appName}',
        style: getRegularStyle(
          color: ColorManager.textTertiary,
          fontSize: FontSize.s11,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
