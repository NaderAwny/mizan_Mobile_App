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
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: ColorManager.black.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
        border: const Border(
          top: BorderSide(color: ColorManager.border, width: 1.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const int itemCount = 5;

              // Minimum width required for each navigation item.
              final double minItemWidth = 88.w;

              // Determine whether horizontal scrolling is necessary.
              final bool shouldScroll =
                  constraints.maxWidth < itemCount * minItemWidth;

              final List<Widget> items = <Widget>[
                _buildItem(
                  index: 0,
                  label: AppStrings.home,
                  icon: IconAssets.home,
                ),
                _buildItem(
                  index: 1,
                  label: AppStrings.transactions,
                  icon: IconAssets.receiptText,
                ),
                _buildItem(
                  index: 2,
                  label: AppStrings.contacts,
                  icon: IconAssets.users,
                ),
                _buildItem(
                  index: 3,
                  label: AppStrings.installments,
                  icon: IconAssets.walletCards,
                ),
                _buildItem(
                  index: 4,
                  label: AppStrings.analytics,
                  icon: IconAssets.chartNetwork,
                ),
              ];

              // Small screen: allow horizontal scrolling.
              if (shouldScroll) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: items
                        .map(
                          (Widget item) =>
                              SizedBox(width: minItemWidth, child: item),
                        )
                        .toList(),
                  ),
                );
              }

              // Large screen: distribute items equally.
              return Row(
                children: items
                    .map((Widget item) => Expanded(child: item))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required String label,
    required String icon,
  }) {
    return _NavBarItem(
      index: index,
      currentIndex: currentIndex,
      label: label,
      icon: icon,
      onTap: () => onTap(index),
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

  Future<void> _handleTap() async {
    await _bounceController.forward();
    await _bounceController.reverse();

    if (!mounted) return;

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.index == widget.currentIndex;

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 8.w : 4.w,
            vertical: 5.h,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? ColorManager.lightPrimary
                : ColorManager.transparent,
            borderRadius: BorderRadius.circular(AppRadius.r14.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
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

              // Keep the complete label visible.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.label,
                  maxLines: 1,
                  softWrap: false,
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
              ),

              SizedBox(height: 2.h),

              // Animated indicator under the selected item.
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
