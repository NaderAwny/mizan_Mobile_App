import 'package:flutter/material.dart';

/// Design tokens for Mizan (ميزان) based on Figma Design System
class ColorManager {
  // --- Brand & Primary Colors ---
  /// Primary Terracotta color (#C57B57)
  static const Color primary = Color(0xFFC57B57);

  /// Dark Terracotta (#A8623B)
  static const Color darkPrimary = Color(0xFFA8623B);

  /// Light Terracotta / Chip background (#FAF0EC)
  static const Color lightPrimary = Color(0xFFFAF0EC);

  /// Secondary Accent - Warm Gold / Amber (#D1A153)
  static const Color secondary = Color(0xFFD1A153);

  /// Dark Gold (#C29A4E)
  static const Color darkSecondary = Color(0xFFC29A4E);

  /// Light Gold / Warning container (#FAF3E3)
  static const Color lightSecondary = Color(0xFFFAF3E3);

  /// Deep Heritage Green from branding & splash (#1C4A38)
  static const Color brandGreen = Color(0xFF1C4A38);

  // --- Background & Surface Colors ---
  /// Main app background - Warm Cream White (#FCFAF7)
  static const Color background = Color(0xFFFCFAF7);

  /// Card & Sheet background (#FFFFFF)
  static const Color surface = Color(0xFFFFFFFF);

  /// Surface Variant / Field fill (#F6F2EB)
  static const Color surfaceVariant = Color(0xFFF6F2EB);

  /// Secondary warm background (#F0EAE1)
  static const Color surfaceMuted = Color(0xFFF0EAE1);

  // --- Neutral & Borders ---
  /// Neutral light border / divider (#EBE6DF)
  static const Color border = Color(0xFFEBE6DF);

  /// Neutral border darker / input stroke (#E5DCD0)
  static const Color borderDark = Color(0xFFE5DCD0);

  /// Divider color (#EBE6DF)
  static const Color divider = Color(0xFFEBE6DF);

  // --- Text Colors ---
  /// Primary text - Deep Charcoal Umber (#1C1816)
  static const Color textPrimary = Color(0xFF1C1816);

  /// Secondary text - Muted Brownish Grey (#6C6360)
  static const Color textSecondary = Color(0xFF6C6360);

  /// Tertiary / Hint text (#9C938E)
  static const Color textTertiary = Color(0xFF9C938E);

  /// Subtle text / timestamp (#7D6E65)
  static const Color textSubtle = Color(0xFF7D6E65);

  /// White text (#FFFFFF)
  static const Color white = Color(0xFFFFFFFF);

  /// Pure Black (#000000)
  static const Color black = Color(0xFF000000);

  // --- Semantic & Status Colors ---
  /// Success / Income / In-flow (#2D5C43)
  static const Color success = Color(0xFF2D5C43);

  /// Success Light container (#EBF3EC)
  static const Color successContainer = Color(0xFFEBF3EC);

  /// Error / Expense / Out-flow (#9B3A2C)
  static const Color error = Color(0xFF9B3A2C);

  /// Error Light container (#F7ECE9)
  static const Color errorContainer = Color(0xFFF7ECE9);

  /// Warning color (#D1A153)
  static const Color warning = Color(0xFFD1A153);

  /// Warning Light container (#FAF3E3)
  static const Color warningContainer = Color(0xFFFAF3E3);

  /// Info / Tag background (#EAE2F8)
  static const Color infoContainer = Color(0xFFEAE2F8);

  // --- Dark Theme Palette ---
  static const Color darkBackground = Color(0xFF161312);
  static const Color darkSurface = Color(0xFF25201E);
  static const Color darkSurfaceVariant = Color(0xFF332D2A);
  static const Color darkBorder = Color(0xFF3E3632);
  static const Color darkTextPrimary = Color(0xFFFAF7F5);
  static const Color darkTextSecondary = Color(0xFFB8ADA8);

  // --- Compatibility Aliases ---
  static const Color grey = textSecondary;
  static const Color darkGrey = textPrimary;
  static const Color lightGrey = textTertiary;
  static const Color grey1 = Color(0xFF707070);
  static const Color grey2 = Color(0xFF797979);

  // --- Gradients from Figma ---
  /// Signature Mizan Terracotta-to-Gold linear gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      Color(0xFFA8623B),
      Color(0xFFD1A153),
      Color(0xFFC57B57),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Splash screen warm cream gradient
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF9F5EC),
      Color(0xFFF3EBDA),
      Color(0xFFEEE1C2),
    ],
  );

  /// Brand Dark Green to Gold gradient
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF1C4A38),
      Color(0xFFC29A4E),
    ],
  );

  /// Radial glow for onboarding illustrations
  static const RadialGradient heroRadialGlow = RadialGradient(
    center: Alignment.center,
    radius: 0.8,
    colors: [
      Color(0x26D1A153), // 15% opacity Gold
      Color(0x00FCFAF7),
    ],
  );

  // --- Splash Screen Specific Tokens ---
  /// Splash background wave 1 - 50% opacity (#E8DEC5)
  static const Color splashWave1 = Color(0x80E8DEC5);

  /// Splash background wave 2 - 60% opacity (#DFD2B4)
  static const Color splashWave2 = Color(0x99DFD2B4);

  /// Splash progress track background - 10% opacity Brand Green
  static const Color splashTrack = Color(0x1A1C4A38);

  /// Home indicator bar color - 20% opacity
  static const Color homeIndicator = Color(0x331C1816);
}
