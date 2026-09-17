import 'package:flutter/material.dart';

class AppConstants {
  static const int splashDelay = 3;
  static const int sliderAnimationTime = 300;
  static const String empty = "";
  static const int zero = 0;

  // Design Canvas Dimensions from Figma (iPhone 16 / 15 Pro)
  static const double designWidth = 402.0;
  static const double designHeight = 874.0;
  static const Size designSize = Size(designWidth, designHeight);

  // Backward compatibility alias
  static const double canvasWidth = designWidth;

  static const String defaultCurrency = "EGP";
  static const String defaultCountryCode = "+20";
  static const int otpLength = 4;

  // Splash Screen Layout & Positioning Constants from Figma
  static const double splashWave1Left = -79.0;
  static const double splashWave1Bottom = -150.0;
  static const double splashWave2Left = -9.0;
  static const double splashWave2Bottom = -170.0;
  static const double splashLetterSpacing = 2.5;
  static const double splashTitleHeight = 1.1;
  static const double splashSubTitleHeight = 1.0;
}
