import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class HeroBalanceCard extends StatefulWidget {
  final double totalBalance;
  final double totalDebts;
  final double totalPayables;
  final String currency;

  const HeroBalanceCard({
    super.key,
    this.totalBalance = 158420.50,
    this.totalDebts = 24500.00,
    this.totalPayables = 8200.00,
    this.currency = "ج.م",
  });

  @override
  State<HeroBalanceCard> createState() => _HeroBalanceCardState();
}

class _HeroBalanceCardState extends State<HeroBalanceCard> {
  bool _isBalanceVisible = true;

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  // Format amount with pure English digits (0-9) and comma separator
  String _formatAmount(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integerPart[i]);
    }
    return "${buffer.toString()}.$decimalPart";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.r20.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2EC57B57),
            blurRadius: 16.0,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle decorative background circles
          Positioned(
            top: -30.r,
            left: -20.r,
            child: Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(15),
              ),
            ),
          ),

          // Main Card Content - Compact & Responsive
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: "إجمالي الرصيد" Pill + Trend Pill + Eye Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Label Pill
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(35),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withAlpha(30),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppStrings.totalBalance,
                            style: getBoldStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s11,
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

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Trend pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x33E2FDE6),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.trending_up_rounded,
                                color: const Color(0xFFE2FDE6),
                                size: 12.r,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                "+12.5%",
                                style: getBoldStyle(
                                  color: const Color(0xFFE2FDE6),
                                  fontSize: FontSize.s10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Eye button
                        InkWell(
                          onTap: _toggleBalanceVisibility,
                          borderRadius: BorderRadius.circular(16.r),
                          child: Padding(
                            padding: EdgeInsets.all(2.r),
                            child: Icon(
                              _isBalanceVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white.withAlpha(220),
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
                    children: [
                      Text(
                        _isBalanceVisible
                            ? _formatAmount(widget.totalBalance)
                            : "••••••••",
                        style: getBlackStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s24,
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

                SizedBox(height: 12.h),

                // Divider Line inside Card
                Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.white.withAlpha(30),
                ),

                SizedBox(height: 10.h),

                // Bottom Row: Debts (You receive) & Payables (You pay)
                Row(
                  children: [
                    // Debts
                    Expanded(
                      child: _HeroMetricItem(
                        icon: IconAssets.arrowDownLeft,
                        iconColor: const Color(0xFFE2FDE6),
                        iconBgColor: Colors.white.withAlpha(25),
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
                      color: Colors.white.withAlpha(30),
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                    ),

                    // Payables
                    Expanded(
                      child: _HeroMetricItem(
                        icon: IconAssets.arrowUpRight,
                        iconColor: const Color(0xFFFFD4C8),
                        iconBgColor: Colors.white.withAlpha(25),
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
      children: [
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
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  color: Colors.white.withAlpha(210),
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
