import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppMargin {
  static const double m0 = 0.0;
  static const double m2 = 2.0;
  static const double m4 = 4.0;
  static const double m6 = 6.0;
  static const double m8 = 8.0;
  static const double m10 = 10.0;
  static const double m12 = 12.0;
  static const double m14 = 14.0;
  static const double m16 = 16.0;
  static const double m18 = 18.0;
  static const double m20 = 20.0;
  static const double m22 = 22.0;
  static const double m24 = 24.0;
  static const double m28 = 28.0;
  static const double m32 = 32.0;
  static const double m40 = 40.0;
}

// Backward compatibility typo alias
typedef AppMarign = AppMargin;

class AppPadding {
  static const double p0 = 0.0;
  static const double p2 = 2.0;
  static const double p4 = 4.0;
  static const double p6 = 6.0;
  static const double p8 = 8.0;
  static const double p10 = 10.0;
  static const double p12 = 12.0;
  static const double p14 = 14.0;
  static const double p16 = 16.0;
  static const double p18 = 18.0;
  static const double p20 = 20.0;
  static const double p22 = 22.0;
  static const double p24 = 24.0;
  static const double p28 = 28.0;
  static const double p32 = 32.0;
  static const double p40 = 40.0;
  static const double p60 = 60.0;
  static const double p100 = 100.0;
}

class AppSize {
  static const double s0 = 0.0;
  static const double s0_2 = 0.2;
  static const double s0_5 = 0.5;
  static const double s0_8 = 0.8;
  static const double s1 = 1.0;
  static const double s1_5 = 1.5;
  static const double s2 = 2.0;
  static const double s3 = 3.0;
  static const double s4 = 4.0;
  static const double s5 = 5.0;
  static const double s6 = 6.0;
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
  static const double s22 = 22.0;
  static const double s24 = 24.0;
  static const double s28 = 28.0;
  static const double s32 = 32.0;
  static const double s36 = 36.0;
  static const double s40 = 40.0;
  static const double s44 = 44.0;
  static const double s48 = 48.0;
  static const double s50 = 50.0;
  static const double s52 = 52.0;
  static const double s56 = 56.0;
  static const double s60 = 60.0;
  static const double s64 = 64.0;
  static const double s70 = 70.0;
  static const double s76 = 76.0;
  static const double s80 = 80.0;
  static const double s100 = 100.0;
  static const double s110 = 110.0;
  static const double s120 = 120.0;
  static const double s130 = 130.0;
  static const double s139 = 139.0;
  static const double s140 = 140.0;
  static const double s160 = 160.0;
  static const double s180 = 180.0;
  static const double s200 = 200.0;
  static const double s220 = 220.0;
  static const double s260 = 260.0;
  static const double s300 = 300.0;
  static const double s320 = 320.0;
  static const double s354 = 354.0;
  static const double s402 = 402.0;
  static const double s500 = 500.0;
  static const double s520 = 520.0;
}

class AppRadius {
  static const double r0 = 0.0;
  static const double r999 = 999.0;

  static const double r2 = 2.0;
  static const double r4 = 4.0;
  static const double r6 = 6.0;
  static const double r8 = 8.0;
  static const double r10 = 10.0;
  static const double r12 = 12.0;
  static const double r14 = 14.0;
  static const double r16 = 16.0;
  static const double r18 = 18.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;
  static const double r28 = 28.0;
  static const double r32 = 32.0;
  static const double r40 = 40.0;
  static const double r65 = 65.0;
  static const double r90 = 90.0;
  static const double r100 = 100.0;
}

class AppElevation {
  static const double e0 = 0.0;
  static const double e1 = 1.0;
  static const double e2 = 2.0;
  static const double e4 = 4.0;
  static const double e8 = 8.0;
  static const double e12 = 12.0;
  static const double e16 = 16.0;
}

/// Responsive EdgeInsets helpers for clean and responsive UI layouts
class AppPaddingInsets {
  static EdgeInsets get p8All => EdgeInsets.all(AppPadding.p8.r);
  static EdgeInsets get p12All => EdgeInsets.all(AppPadding.p12.r);
  static EdgeInsets get p16All => EdgeInsets.all(AppPadding.p16.r);
  static EdgeInsets get p20All => EdgeInsets.all(AppPadding.p20.r);
  static EdgeInsets get p24All => EdgeInsets.all(AppPadding.p24.r);
  static EdgeInsets get p32All => EdgeInsets.all(AppPadding.p32.r);

  static EdgeInsets symmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: h.w, vertical: v.h);
}

class AppMarginInsets {
  static EdgeInsets get m8All => EdgeInsets.all(AppMargin.m8.r);
  static EdgeInsets get m16All => EdgeInsets.all(AppMargin.m16.r);
  static EdgeInsets get m20All => EdgeInsets.all(AppMargin.m20.r);
  static EdgeInsets get m24All => EdgeInsets.all(AppMargin.m24.r);

  static EdgeInsets symmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: h.w, vertical: v.h);
}

/// Responsive BorderRadius helpers
class AppBorderRadius {
  static BorderRadius get r4 => BorderRadius.circular(AppRadius.r4.r);
  static BorderRadius get r8 => BorderRadius.circular(AppRadius.r8.r);
  static BorderRadius get r12 => BorderRadius.circular(AppRadius.r12.r);
  static BorderRadius get r16 => BorderRadius.circular(AppRadius.r16.r);
  static BorderRadius get r20 => BorderRadius.circular(AppRadius.r20.r);
  static BorderRadius get r24 => BorderRadius.circular(AppRadius.r24.r);
  static BorderRadius get r28 => BorderRadius.circular(AppRadius.r28.r);
  static BorderRadius get r100 => BorderRadius.circular(AppRadius.r100.r);
}

class AppShadows {
  /// Card elevation shadow from Figma (0px 8px 16px rgba(197, 123, 87, 0.1))
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x1AC57B57),
    blurRadius: 16.0,
    offset: Offset(0, 8),
  );

  /// Brand subtle elevation (0px 8px 24px rgba(28, 74, 56, 0.08))
  static const BoxShadow brandShadow = BoxShadow(
    color: Color(0x141C4A38),
    blurRadius: 24.0,
    offset: Offset(0, 8),
  );

  /// Floating Action Button soft glow
  static const BoxShadow fabShadow = BoxShadow(
    color: Color(0x33C57B57),
    blurRadius: 16.0,
    offset: Offset(0, 6),
  );
}

class AppDuration {
  static const Duration d100 = Duration(milliseconds: 100);
  static const Duration d200 = Duration(milliseconds: 200);
  static const Duration d300 = Duration(milliseconds: 300);
  static const Duration d400 = Duration(milliseconds: 400);
  static const Duration d500 = Duration(milliseconds: 500);
  static const Duration d800 = Duration(milliseconds: 800);
  static const Duration d1000 = Duration(milliseconds: 1000);
  static const Duration d2200 = Duration(milliseconds: 2200);
  static const Duration d3000 = Duration(milliseconds: 3000);
}
