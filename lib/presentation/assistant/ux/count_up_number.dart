import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mizan/presentation/assistant/ux/comparison.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// CountUpNumber — Smoothly counts up from 0 to [value] in 400..900ms using tabular figures.
/// Strict performance: RepaintBoundary, no parent rebuilds, disables animation on reduce motion
/// or when message was already animated.
class CountUpNumber extends StatelessWidget {
  const CountUpNumber({
    super.key,
    required this.value,
    required this.animate,
    required this.onDone,
    required this.style,
    this.suffix = ' جنيه',
  });

  final num value;
  final bool animate;
  final VoidCallback onDone;
  final TextStyle style;
  final String suffix;

  static final NumberFormat _fmt = NumberFormat.decimalPattern('en');

  static Duration _duration(num v) {
    final double digits =
        v.abs() < 10 ? 1.0 : (math.log(v.abs()) / math.ln10);
    return Duration(
      milliseconds: (400 + 120 * digits).clamp(400.0, 900.0).round(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle s =
        style.copyWith(fontFeatures: const <FontFeature>[FontFeature.tabularFigures()]);
    final bool reduce = MediaQuery.disableAnimationsOf(context);

    if (!animate || reduce) {
      return RepaintBoundary(
        child: Text('${_fmt.format(value.round())}$suffix', style: s),
      );
    }

    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: value.toDouble()),
        duration: _duration(value),
        curve: Curves.easeOutCubic,
        onEnd: onDone,
        builder: (BuildContext context, double v, Widget? child) =>
            Text('${_fmt.format(v.round())}$suffix', style: s),
      ),
    );
  }
}

/// ComparisonChipWidget — Displays comparison data with 200ms fade + 6px slide entry
class ComparisonChipWidget extends StatefulWidget {
  final ComparisonChipData data;
  final bool visible;

  const ComparisonChipWidget({
    super.key,
    required this.data,
    required this.visible,
  });

  @override
  State<ComparisonChipWidget> createState() => _ComparisonChipWidgetState();
}

class _ComparisonChipWidgetState extends State<ComparisonChipWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    if (widget.visible) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant ComparisonChipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !oldWidget.visible) {
      if (MediaQuery.disableAnimationsOf(context)) {
        _controller.value = 1.0;
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    BorderSide borderSide;

    switch (widget.data.tone) {
      case ComparisonTone.up:
        textColor = ColorManager.success;
        bgColor = ColorManager.successContainer;
        borderSide = BorderSide(color: ColorManager.success.withValues(alpha: 0.3));
        break;
      case ComparisonTone.down:
        // Amber / warm warning (not harsh red)
        textColor = const Color(0xFFD97706);
        bgColor = const Color(0xFFFEF3C7);
        borderSide = const BorderSide(color: Color(0xFFFDE68A));
        break;
      case ComparisonTone.neutral:
        textColor = ColorManager.textSecondary;
        bgColor = ColorManager.surfaceVariant;
        borderSide = const BorderSide(color: ColorManager.border);
        break;
    }

    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.25), // 6px translation
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic)),
        child: Container(
          margin: EdgeInsets.only(top: 4.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.r12.r),
            border: Border.fromBorderSide(borderSide),
          ),
          child: Text(
            widget.data.text,
            style: getMediumStyle(
              color: textColor,
              fontSize: FontSize.s11,
            ),
          ),
        ),
      ),
    );
  }
}
