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

class QuickActionsBar extends StatelessWidget {
  const QuickActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1. بيع (Sale)
        Expanded(
          child: _QuickActionButton(
            label: AppStrings.quickSale,
            icon: IconAssets.shoppingBag,
            bgColor: ColorManager.successContainer,
            accentColor: ColorManager.success,
            onTap: () {
              Navigator.pushNamed(context, Routes.quickSaleRoute);
            },
          ),
        ),

        // 2. شراء (Purchase)
        Expanded(
          child: _QuickActionButton(
            label: AppStrings.quickPurchase,
            icon: IconAssets.arrowUpRight,
            bgColor: ColorManager.errorContainer,
            accentColor: ColorManager.error,
            onTap: () {
              Navigator.pushNamed(context, Routes.quickPurchaseRoute);
            },
          ),
        ),

        // 3. التسجيلات الصوتيه
        Expanded(
          child: _QuickActionButton(
            label: AppStrings.voiceNotesTitle,
            icon: IconAssets.mic2,
            bgColor: ColorManager.lightSecondary,
            accentColor: ColorManager.secondary,
            onTap: () {
              Navigator.of(context).pushNamed(Routes.voiceNotesListRoute);
            },
          ),
        ),

        // 4. تحصيل الاقساط
        Expanded(
          child: _QuickActionButton(
            label: AppStrings.installmentsHistory,
            icon: IconAssets.receipt,
            bgColor: ColorManager.lightPrimary,
            accentColor: ColorManager.primary,
            onTap: () {
              Navigator.pushNamed(context, Routes.installmentsHistoryRoute);
            },
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final String label;
  final String icon;
  final Color bgColor;
  final Color accentColor;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 64.h,
                decoration: BoxDecoration(
                  color: widget.bgColor,
                  borderRadius: BorderRadius.circular(AppRadius.r18.r),
                  border: Border.all(
                    color: widget.accentColor.withAlpha(35),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withAlpha(20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    widget.icon,
                    width: 26.r,
                    height: 26.r,
                    colorFilter: ColorFilter.mode(
                      widget.accentColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
