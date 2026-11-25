import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/domain/model/statistics_model/statistics_model.dart';
import 'package:mizan/presentation/home/services/insights_service.dart';
import 'package:mizan/presentation/home/widgets/sparkline_widget.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class HeroBalanceCard extends StatefulWidget {
  final double totalBalance;
  final double totalDebts;
  final double totalPayables;
  final String currency;
  final StatisticsPageModel? statistics;

  const HeroBalanceCard({
    super.key,
    this.totalBalance = 158420.50,
    this.totalDebts = 24500.00,
    this.totalPayables = 8200.00,
    this.currency = "ج.م",
    this.statistics,
  });

  @override
  State<HeroBalanceCard> createState() => _HeroBalanceCardState();
}

class _HeroBalanceCardState extends State<HeroBalanceCard>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _isBalanceVisible = true;
  bool _isPressed = false;

  // 1.1 Count-up Animation
  late final AnimationController _countUpController;
  late Animation<double> _countUpAnimation;
  double _currentCountedValue = 0.0;

  // 1.2 Sparkline Animation & Data
  late final AnimationController _sparklineController;
  final InsightsService _insightsService = InsightsService();
  List<double> _sparklinePoints = const <double>[];

  // 1.3 Glow Pulse (copper glow, 3 cycles only)
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;
  int _glowCycles = 0;
  DateTime? _lastPausedAt;

  // 1.4 Smart Insight Chip
  List<InsightItem> _insights = const <InsightItem>[];
  int _currentInsightIndex = 0;
  Timer? _insightTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 1.1 Count-up Controller (~900ms, easeOutCubic)
    _countUpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _countUpAnimation = Tween<double>(
      begin: 0.0,
      end: widget.totalBalance,
    ).animate(
      CurvedAnimation(
        parent: _countUpController,
        curve: Curves.easeOutCubic,
      ),
    )..addListener(() {
        setState(() {
          _currentCountedValue = _countUpAnimation.value;
        });
      });
    _countUpController.forward();

    // 1.2 Sparkline Controller (~1000ms)
    _sparklineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _loadSparklineAndInsights();
    _sparklineController.forward();

    // 1.3 Glow Pulse (~3200ms cycle, 3 cycles then stop)
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _glowAnimation = Tween<double>(begin: 0.10, end: 0.28).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _glowController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _glowController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _glowCycles++;
        if (_glowCycles < 3 && mounted) {
          _glowController.forward();
        }
      }
    });
    _glowController.forward();

    _startInsightTimer();
  }

  void _loadSparklineAndInsights() {
    _sparklinePoints =
        _insightsService.calculateDailyCumulativeNet(widget.statistics);
    _insights = _insightsService.generateInsights(widget.statistics);
  }

  void _startInsightTimer() {
    _insightTimer?.cancel();
    if (_insights.length > 1) {
      _insightTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (mounted && _insights.length > 1) {
          setState(() {
            _currentInsightIndex =
                (_currentInsightIndex + 1) % _insights.length;
          });
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant HeroBalanceCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.totalBalance != widget.totalBalance) {
      // Re-animate from current value to new value
      _countUpAnimation = Tween<double>(
        begin: _currentCountedValue,
        end: widget.totalBalance,
      ).animate(
        CurvedAnimation(
          parent: _countUpController,
          curve: Curves.easeOutCubic,
        ),
      );
      _countUpController.forward(from: 0.0);
    }

    if (oldWidget.statistics != widget.statistics) {
      _loadSparklineAndInsights();
      _sparklineController.forward(from: 0.0);
      _startInsightTimer();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _lastPausedAt = DateTime.now();
      _glowController.stop();
    } else if (state == AppLifecycleState.resumed) {
      // Re-trigger glow if user returned after > 30 seconds
      if (_lastPausedAt != null &&
          DateTime.now().difference(_lastPausedAt!).inSeconds >= 30) {
        _glowCycles = 0;
        _glowController.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _insightTimer?.cancel();
    _countUpController.dispose();
    _sparklineController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
      if (_isBalanceVisible) {
        _countUpAnimation = Tween<double>(
          begin: 0.0,
          end: widget.totalBalance,
        ).animate(
          CurvedAnimation(
            parent: _countUpController,
            curve: Curves.easeOutCubic,
          ),
        );
        _countUpController.forward(from: 0.0);
      }
    });
  }

  // Format amount with pure English digits (0-9) and comma separator
  String _formatAmount(double value) {
    final bool isNegative = value < 0;
    final double absVal = value.abs();
    final List<String> parts = absVal.toStringAsFixed(2).split('.');
    final String integerPart = parts[0];
    final String decimalPart = parts[1];

    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integerPart[i]);
    }
    final String formatted = "${buffer.toString()}.$decimalPart";
    return isNegative ? "- $formatted" : formatted;
  }

  void _handleCardTap() {
    HapticFeedback.lightImpact();
    final InsightItem? activeInsight =
        _insights.isNotEmpty && _currentInsightIndex < _insights.length
            ? _insights[_currentInsightIndex]
            : null;
    Navigator.pushNamed(
      context,
      activeInsight?.route ?? Routes.analyticsRoute,
      arguments: activeInsight?.arguments,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool disableAnimations = MediaQuery.disableAnimationsOf(context);

    final double displayedBalance = disableAnimations
        ? widget.totalBalance
        : _currentCountedValue;

    return Semantics(
      label: "بطاقة صافي إجمالي الرصيد هذا الشهر، انقر لعرض تقارير الحسابات",
      button: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: _handleCardTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: AnimatedBuilder(
            animation: _glowController,
            builder: (BuildContext context, Widget? child) {
              final double glowOpacity =
                  disableAnimations ? 0.18 : _glowAnimation.value;

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: ColorManager.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.r20.r),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFFC57B57)
                          .withValues(alpha: glowOpacity),
                      blurRadius: 18.0,
                      spreadRadius: 1.5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: Stack(
              children: <Widget>[
                // Subtle decorative background circles
                Positioned(
                  top: -30.r,
                  left: -20.r,
                  child: Container(
                    width: 100.r,
                    height: 100.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorManager.white.withAlpha(15),
                    ),
                  ),
                ),

                // 1.2 Sparkline Chart across the background
                if (_sparklinePoints.length >= 2)
                  Positioned(
                    right: 14.w,
                    left: 60.w,
                    top: 48.h,
                    height: 40.h,
                    child: IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _sparklineController,
                        builder: (BuildContext context, Widget? child) {
                          return SparklineWidget(
                            points: _sparklinePoints,
                            progress: disableAnimations
                                ? 1.0
                                : _sparklineController.value,
                          );
                        },
                      ),
                    ),
                  ),

                // Main Card Content - Compact & Responsive
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Top Row: "إجمالي الرصيد" Pill + Trend Pill + Eye Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // Label Pill - Flexible so it shrinks on large text scale
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 3.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.white.withAlpha(35),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: ColorManager.white.withAlpha(30),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      AppStrings.totalBalance,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: getBoldStyle(
                                        color: ColorManager.white,
                                        fontSize: FontSize.s10.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    AppStrings.egpSymbol,
                                    style: getMediumStyle(
                                      color: ColorManager.white.withAlpha(200),
                                      fontSize: FontSize.s9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 8.w),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Eye button (independent hit target)
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: _toggleBalanceVisibility,
                                child: Padding(
                                  padding: EdgeInsets.all(4.r),
                                  child: Icon(
                                    _isBalanceVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: ColorManager.white.withAlpha(220),
                                    size: 18.r,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 10.h),

                      // Balance Number (FittedBox ensures zero overflow on any screen)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              _isBalanceVisible
                                  ? _formatAmount(displayedBalance)
                                  : "••••••••",
                              style: getBlackStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s24,
                              ).copyWith(
                                fontFeatures: const <ui.FontFeature>[
                                  ui.FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              widget.currency,
                              style: getBoldStyle(
                                color: ColorManager.white.withAlpha(220),
                                fontSize: FontSize.s13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 1.4 Smart Insight Chip (glass pill)
                      if (_insights.isNotEmpty) ...<Widget>[
                        SizedBox(height: 8.h),
                        _buildInsightChip(disableAnimations),
                      ],

                      SizedBox(height: 10.h),

                      // Divider Line inside Card
                      Container(
                        width: double.infinity,
                        height: 1.0,
                        color: ColorManager.white.withAlpha(30),
                      ),

                      SizedBox(height: 10.h),

                      // Bottom Row: Debts (You receive) & Payables (You pay)
                      Row(
                        children: <Widget>[
                          // Debts
                          Expanded(
                            child: _HeroMetricItem(
                              icon: IconAssets.arrowDownLeft,
                              iconColor: const Color(0xFFE2FDE6),
                              iconBgColor: ColorManager.white.withAlpha(25),
                              title: AppStrings.totalDebts,
                              amount: _isBalanceVisible
                                  ? "${_formatAmount(widget.totalDebts)} ${widget.currency}"
                                  : "••••••",
                            ),
                          ),

                          // Vertical subtle separator
                          Container(
                            width: 1.0,
                            height: 30.h,
                            color: ColorManager.white.withAlpha(30),
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                          ),

                          // Payables
                          Expanded(
                            child: _HeroMetricItem(
                              icon: IconAssets.arrowUpRight,
                              iconColor: const Color(0xFFFFD4C8),
                              iconBgColor: ColorManager.white.withAlpha(25),
                              title: AppStrings.totalPayables,
                              amount: _isBalanceVisible
                                  ? "${_formatAmount(widget.totalPayables)} ${widget.currency}"
                                  : "••••••",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightChip(bool disableAnimations) {
    if (_insights.isEmpty) return const SizedBox.shrink();
    final InsightItem current = _insights[_currentInsightIndex % _insights.length];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorManager.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
        border: Border.all(
          color: ColorManager.white.withValues(alpha: 0.22),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: disableAnimations
                ? Text(
                    current.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getMediumStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s10,
                    ),
                  )
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      final Animation<Offset> inAnimation = Tween<Offset>(
                        begin: const Offset(0.08, 0.0),
                        end: Offset.zero,
                      ).animate(animation);
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: inAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      current.text,
                      key: ValueKey<int>(_currentInsightIndex),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getMediumStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s10,
                      ),
                    ),
                  ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.chevron_left_rounded,
            size: 14.r,
            color: ColorManager.white.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }
}

class _HeroMetricItem extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String amount;

  const _HeroMetricItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: 14.r,
              height: 14.r,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  color: ColorManager.white.withAlpha(210),
                  fontSize: FontSize.s10,
                ),
              ),
              SizedBox(height: 1.h),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  amount,
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
