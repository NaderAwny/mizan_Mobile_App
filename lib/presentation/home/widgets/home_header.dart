import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class HomeHeader extends StatelessWidget {
  final String shopName;
  final String userName;

  const HomeHeader({
    super.key,
    this.shopName = "محل ميزان التجاري",
    this.userName = "مرحباً بك",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // User & Shop Profile Section (Right side in RTL)
        Expanded(
          child: Row(
            children: [
              // Store / Avatar Profile Box
              Container(
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  color: ColorManager.lightPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.primary.withAlpha(40),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primary.withAlpha(18),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    IconAssets.store,
                    width: 22.r,
                    height: 22.r,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // Greeting & Shop Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          userName,
                          style: getMediumStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s12,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          width: 7.r,
                          height: 7.r,
                          decoration: const BoxDecoration(
                            color: ColorManager.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      shopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getBoldStyle(
                        color: ColorManager.textPrimary,
                        fontSize: FontSize.s16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Action Icons: Search & Notifications Bell with Unread Badge
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Notifications Icon with Badge
            _HeaderIconButton(
              icon: IconAssets.bell,
              hasBadge: true,
              onTap: () {
                Navigator.pushNamed(context, Routes.notificationsRoute);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final String icon;
  final bool hasBadge;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    this.hasBadge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
        child: Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            color: ColorManager.surface,
            borderRadius: BorderRadius.circular(AppRadius.r12.r),
            border: Border.all(
              color: ColorManager.border,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withAlpha(8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: 20.r,
                height: 20.r,
                colorFilter: const ColorFilter.mode(
                  ColorManager.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
              if (hasBadge)
                Positioned(
                  top: 9.r,
                  left: 10.r,
                  child: Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: BoxDecoration(
                      color: ColorManager.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorManager.surface,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
