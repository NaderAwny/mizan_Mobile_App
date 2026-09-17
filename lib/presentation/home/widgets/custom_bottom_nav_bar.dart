import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r20.r),
          topRight: Radius.circular(AppRadius.r20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: ColorManager.border,
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NavBarItem(
                index: 0,
                currentIndex: currentIndex,
                label: AppStrings.home,
                icon: IconAssets.home,
                onTap: () => onTap(0),
              ),
              SizedBox(width: 4.w),
              _NavBarItem(
                index: 1,
                currentIndex: currentIndex,
                label: AppStrings.transactions,
                icon: IconAssets.receiptText,
                onTap: () => onTap(1),
              ),
              SizedBox(width: 4.w),
              _NavBarItem(
                index: 2,
                currentIndex: currentIndex,
                label: AppStrings.contacts,
                icon: IconAssets.users,
                onTap: () => onTap(2),
              ),
              SizedBox(width: 4.w),
              _NavBarItem(
                index: 3,
                currentIndex: currentIndex,
                label: AppStrings.installments,
                icon: IconAssets.walletCards,
                onTap: () => onTap(3),
              ),
              SizedBox(width: 4.w),
              _NavBarItem(
                index: 4,
                currentIndex: currentIndex,
                label: AppStrings.analytics,
                icon: IconAssets.chartNetwork,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final int index;
  final int currentIndex;
  final String label;
  final String icon;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _bounceController.forward();
    await _bounceController.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.index == widget.currentIndex;

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 12.w : 10.w,
            vertical: 5.h,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? ColorManager.lightPrimary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.r14.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: SvgPicture.asset(
                  widget.icon,
                  key: ValueKey<bool>(isSelected),
                  width: 20.r,
                  height: 20.r,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? ColorManager.primary
                        : ColorManager.textTertiary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                widget.label,
                style: isSelected
                    ? getBoldStyle(
                        color: ColorManager.primary,
                        fontSize: FontSize.s11,
                      )
                    : getMediumStyle(
                        color: ColorManager.textSecondary,
                        fontSize: FontSize.s11,
                      ),
              ),
              // Tiny animated indicator dot under active tab
              SizedBox(height: 2.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: isSelected ? 4.r : 0,
                height: isSelected ? 4.r : 0,
                decoration: const BoxDecoration(
                  color: ColorManager.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
