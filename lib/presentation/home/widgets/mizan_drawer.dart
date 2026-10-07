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
          children: <Widget>[
            // ── Header / Logo area ───────────────────────────────────────────
            _DrawerHeader(),

            const Divider(color: ColorManager.border, height: 1),

            // ── Navigation items ─────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                physics: const BouncingScrollPhysics(),
                itemCount: _getDrawerItems(context).length,
                separatorBuilder: (BuildContext context, int index) {
                  if (index == 5) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: const Divider(
                        color: ColorManager.border,
                        height: 1,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                itemBuilder: (BuildContext context, int index) {
                  final _DrawerItemModel item = _getDrawerItems(context)[index];
                  return _DrawerItem(
                    icon: item.icon,
                    label: item.label,
                    onTap: item.onTap,
                  );
                },
              ),
            ),

            // ── Footer branding ──────────────────────────────────────────────
            _DrawerFooter(),
          ],
        ),
      ),
    );
  }

  List<_DrawerItemModel> _getDrawerItems(BuildContext context) =>
      <_DrawerItemModel>[
        _DrawerItemModel(
          icon: IconAssets.home,
          label: AppStrings.home,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.homeRoute,
              (Route<dynamic> route) => false,
            );
          },
        ),
        _DrawerItemModel(
          icon: IconAssets.receiptText,
          label: AppStrings.transactions,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Routes.transactionsRoute);
          },
        ),
        _DrawerItemModel(
          icon: IconAssets.users,
          label: AppStrings.contacts,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Routes.customersRoute);
          },
        ),
        _DrawerItemModel(
          icon: IconAssets.walletCards,
          label: AppStrings.installments,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Routes.installmentsRoute);
          },
        ),
        _DrawerItemModel(
          icon: IconAssets.chartNetwork,
          label: AppStrings.analytics,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Routes.analyticsRoute);
          },
        ),
        _DrawerItemModel(
          icon: IconAssets.mic,
          label: AppStrings.voiceNotesTitle,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Routes.voiceNotesListRoute);
          },
        ),
        _DrawerItemModel(
          icon: IconAssets.user,
          label: AppStrings.profile,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Routes.profileRoute);
          },
        ),
        _DrawerItemModel(
          icon: IconAssets.bell,
          label: AppStrings.notifications,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Routes.notificationsRoute);
          },
        ),
      ];
}

class _DrawerItemModel {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItemModel({
    required this.icon,
    required this.label,
    required this.onTap,
  });
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
      decoration: const BoxDecoration(gradient: ColorManager.primaryGradient),
      child: Row(
        children: <Widget>[
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
            children: <Widget>[
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
      color: ColorManager.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
          child: Row(
            children: <Widget>[
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
