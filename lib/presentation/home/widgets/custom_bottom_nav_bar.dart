import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/presentation/assistant/view/widgets/assistant_orb.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CustomBottomNavBar — Premium Floating Capsule Navigation Bar
// Recreates the floating pill concept with a raised circular center button
// for "المعاملات" (Transactions), perfectly integrated into a curved arch.
// ─────────────────────────────────────────────────────────────────────────────

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onAssistantTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onAssistantTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    // Responsive width calculation:
    // Approximately 84-88% on mobile phones, clamped at 420.0 on tablets
    // Ensuring clear, visible margins on left and right edges
    final double pillWidth = (screenWidth * 0.88).clamp(320.0, 420.0);

    final double pillHeight = 66.h;
    final double archRise = 20.h;
    final double totalHeight = pillHeight + archRise;
    final double centerReservedWidth = 70.w;

    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        height: totalHeight + 10.h,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 8.h),
        child: SizedBox(
          width: pillWidth,
          height: totalHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              // 1. Custom painted floating pill with raised center arch & shadow
              Positioned.fill(
                child: CustomPaint(
                  painter: FloatingPillPainter(
                    fillColor: ColorManager.surface,
                    borderColor: ColorManager.border.withOpacity(0.7),
                    cornerRadius: AppRadius.r28.r,
                    archRise: archRise,
                    archWidth: 84.w,
                  ),
                ),
              ),

              // 2. Regular 4 navigation destinations inside the pill body
              Positioned(
                top: archRise,
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Row(
                    children: <Widget>[
                      // Right side of center (in RTL):
                      // Destination 0: الرئيسية (Home)
                      Expanded(
                        child: _buildItem(
                          index: 0,
                          label: AppStrings.home,
                          icon: IconAssets.home,
                        ),
                      ),
                      // Destination 1: المعاملات (Transactions)
                      Expanded(
                        child: _buildItem(
                          index: 1,
                          label: AppStrings.transactions,
                          icon: IconAssets.receiptText,
                        ),
                      ),

                      // Reserved space for the center raised button & label
                      SizedBox(width: centerReservedWidth),

                      // Left side of center (in RTL):
                      // Destination 2: العملاء (Customers)
                      Expanded(
                        child: _buildItem(
                          index: 2,
                          label: AppStrings.contacts,
                          icon: IconAssets.users,
                        ),
                      ),
                      // Destination 3: الأقساط (Installments)
                      Expanded(
                        child: _buildItem(
                          index: 3,
                          label: AppStrings.installments,
                          icon: IconAssets.walletCards,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Center Destination: «يا ميزان» (Assistant Orb)
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 72.w,
                  child: _CenterAssistantOrbItem(
                    onTap: onAssistantTap ?? () => onTap(-1),
                  ),
                ),
              ),
            ],
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

// ─────────────────────────────────────────────────────────────────────────────
// FloatingPillPainter — Custom Painter for the Floating Capsule Silhouette
// Renders the pill body with an organic curved upward arch at the center top.
// ─────────────────────────────────────────────────────────────────────────────
class FloatingPillPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final double cornerRadius;
  final double archRise;
  final double archWidth;

  const FloatingPillPainter({
    required this.fillColor,
    required this.borderColor,
    required this.cornerRadius,
    required this.archRise,
    required this.archWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double flatTop = archRise;
    final double halfArch = archWidth / 2;
    final double r = cornerRadius;

    final Path path = Path();

    // 1. Start after top-left corner on the flat top edge
    path.moveTo(r, flatTop);

    // 2. Line to left side of the center arch
    path.lineTo(cx - halfArch, flatTop);

    // 3. Smooth curve up to the crest
    // Left shoulder: smoothly departs flatTop horizontally, rises up to peak (cx, 0)
    final double s1 = halfArch * 0.40;
    final double s2 = halfArch * 0.35;
    path.cubicTo(cx - halfArch + s1, flatTop, cx - s2, 0.0, cx, 0.0);

    // 4. Smooth curve down from the crest
    // Right shoulder: smoothly departs peak horizontally, arrives at flatTop horizontally
    path.cubicTo(
      cx + s2,
      0.0,
      cx + halfArch - s1,
      flatTop,
      cx + halfArch,
      flatTop,
    );

    // 5. Line to top-right corner
    path.lineTo(w - r, flatTop);

    // 6. Top-right corner
    path.arcToPoint(
      Offset(w, flatTop + r),
      radius: Radius.circular(r),
      clockwise: true,
    );

    // 7. Right edge
    path.lineTo(w, h - r);

    // 8. Bottom-right corner
    path.arcToPoint(
      Offset(w - r, h),
      radius: Radius.circular(r),
      clockwise: true,
    );

    // 9. Bottom edge
    path.lineTo(r, h);

    // 10. Bottom-left corner
    path.arcToPoint(
      Offset(0, h - r),
      radius: Radius.circular(r),
      clockwise: true,
    );

    // 11. Left edge
    path.lineTo(0, flatTop + r);

    // 12. Top-left corner
    path.arcToPoint(
      Offset(r, flatTop),
      radius: Radius.circular(r),
      clockwise: true,
    );

    path.close();

    // Soft multi-layered elevation shadow for floating appearance
    canvas.drawShadow(path, const Color(0x181C1816), 14.0, true);

    final Paint dropShadowPaint = Paint()
      ..color = const Color(0x0E000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.save();
    canvas.translate(0, 4);
    canvas.drawPath(path, dropShadowPaint);
    canvas.restore();

    // Fill the capsule body
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Refined subtle stroke outline
    final Paint strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant FloatingPillPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.archRise != archRise ||
        oldDelegate.archWidth != archWidth;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CenterAssistantOrbItem — Living Animated Sphere for "يا ميزان" in Capsule
// ─────────────────────────────────────────────────────────────────────────────
class _CenterAssistantOrbItem extends StatefulWidget {
  final VoidCallback onTap;

  const _CenterAssistantOrbItem({
    required this.onTap,
  });

  @override
  State<_CenterAssistantOrbItem> createState() =>
      _CenterAssistantOrbItemState();
}

class _CenterAssistantOrbItemState extends State<_CenterAssistantOrbItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
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
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 1.h),
          // Raised Living Celestial Orb with gentle spring on tap
          ScaleTransition(
            scale: _scaleAnim,
            child: AssistantOrb(
              size: OrbSize.small,
              heroTag: 'assistant_orb',
              diameter: 48.r,
            ),
          ),
          SizedBox(height: 5.h),
          // Label "يا ميزان"
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              AppStrings.assistantTitle,
              maxLines: 1,
              softWrap: false,
              style: getBoldStyle(
                color: ColorManager.primary,
                fontSize: FontSize.s11,
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _NavBarItem — Standard Navigation Destination inside the Capsule
// ─────────────────────────────────────────────────────────────────────────────
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
      duration: const Duration(milliseconds: 140),
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
            horizontal: isSelected ? 4.w : 2.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? ColorManager.lightPrimary.withOpacity(0.85)
                : ColorManager.transparent,
            borderRadius: BorderRadius.circular(AppRadius.r14.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(height: 3.h),
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
