import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_manager.dart';
import 'font_manager.dart';
import 'styles_manager.dart';
import 'values_manager.dart';

/// Light Application Theme for Mizan (ميزان) based on Figma Redesign
ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: FontConstants.fontFamily,
    scaffoldBackgroundColor: ColorManager.background,

    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: ColorManager.primary,
      onPrimary: ColorManager.white,
      primaryContainer: ColorManager.lightPrimary,
      onPrimaryContainer: ColorManager.darkPrimary,
      secondary: ColorManager.secondary,
      onSecondary: ColorManager.white,
      secondaryContainer: ColorManager.lightSecondary,
      onSecondaryContainer: ColorManager.darkSecondary,
      surface: ColorManager.surface,
      onSurface: ColorManager.textPrimary,
      surfaceContainerHighest: ColorManager.surfaceVariant,
      error: ColorManager.error,
      onError: ColorManager.white,
      errorContainer: ColorManager.errorContainer,
      outline: ColorManager.border,
      outlineVariant: ColorManager.borderDark,
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: ColorManager.background,
      foregroundColor: ColorManager.textPrimary,
      iconTheme: IconThemeData(
        color: ColorManager.textPrimary,
        size: AppSize.s24.r,
      ),
      titleTextStyle: getBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s18,
      ),
    ),

    // Card View Theme
    cardTheme: CardThemeData(
      color: ColorManager.surface,
      elevation: 0,
      shadowColor: ColorManager.black.withAlpha(12),
      margin: EdgeInsets.symmetric(
        horizontal: AppMargin.m16.w,
        vertical: AppMargin.m8.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        side: const BorderSide(color: ColorManager.border, width: 1),
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: ColorManager.primary,
        foregroundColor: ColorManager.white,
        disabledBackgroundColor: ColorManager.surfaceVariant,
        disabledForegroundColor: ColorManager.textTertiary,
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p24.w,
          vertical: AppPadding.p14.h,
        ),
        textStyle: getBoldStyle(
          color: ColorManager.white,
          fontSize: FontSize.s16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12.r),
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorManager.primary,
        disabledForegroundColor: ColorManager.textTertiary,
        side: const BorderSide(color: ColorManager.primary, width: 1.5),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p24.w,
          vertical: AppPadding.p14.h,
        ),
        textStyle: getSemiBoldStyle(
          color: ColorManager.primary,
          fontSize: FontSize.s16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12.r),
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorManager.primary,
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p12.w,
          vertical: AppPadding.p8.h,
        ),
        textStyle: getSemiBoldStyle(
          color: ColorManager.primary,
          fontSize: FontSize.s14,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.surfaceVariant,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppPadding.p16.w,
        vertical: AppPadding.p14.h,
      ),
      hintStyle: getRegularStyle(
        color: ColorManager.textTertiary,
        fontSize: FontSize.s14,
      ),
      labelStyle: getMediumStyle(
        color: ColorManager.textSecondary,
        fontSize: FontSize.s14,
      ),
      errorStyle: getRegularStyle(
        color: ColorManager.error,
        fontSize: FontSize.s12,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorManager.border, width: 1),
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorManager.primary, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorManager.error, width: 1),
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorManager.error, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorManager.primary,
      foregroundColor: ColorManager.white,
      elevation: AppElevation.e4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorManager.surface,
      elevation: AppElevation.e8,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: ColorManager.primary,
      unselectedItemColor: ColorManager.textSecondary,
      selectedLabelStyle: getBoldStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s12,
      ),
      unselectedLabelStyle: getRegularStyle(
        color: ColorManager.textSecondary,
        fontSize: FontSize.s12,
      ),
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      indicatorColor: ColorManager.primary,
      labelColor: ColorManager.primary,
      unselectedLabelColor: ColorManager.textSecondary,
      labelStyle: getBoldStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s14,
      ),
      unselectedLabelStyle: getRegularStyle(
        color: ColorManager.textSecondary,
        fontSize: FontSize.s14,
      ),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: ColorManager.divider,
      thickness: 1,
      space: 1,
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ColorManager.primary,
      linearTrackColor: ColorManager.surfaceVariant,
    ),

    // Text Theme (Cairo typography with .sp scaling)
    textTheme: TextTheme(
      displayLarge: getExtraBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s24,
      ),
      displayMedium: getBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s28,
      ),
      displaySmall: getBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s24,
      ),
      headlineLarge: getBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s22,
      ),
      headlineMedium: getSemiBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s20,
      ),
      headlineSmall: getSemiBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s18,
      ),
      titleLarge: getBoldStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s16,
      ),
      titleMedium: getMediumStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s14,
      ),
      titleSmall: getMediumStyle(
        color: ColorManager.textSecondary,
        fontSize: FontSize.s12,
      ),
      bodyLarge: getRegularStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s16,
      ),
      bodyMedium: getRegularStyle(
        color: ColorManager.textPrimary,
        fontSize: FontSize.s14,
      ),
      bodySmall: getMediumStyle(
        color: ColorManager.textSecondary,
        fontSize: FontSize.s15,
      ),
      labelLarge: getBoldStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s14,
      ),
      labelMedium: getSemiBoldStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s12,
      ),
      labelSmall: getMediumStyle(
        color: ColorManager.textTertiary,
        fontSize: FontSize.s10,
      ),
    ),
  );
}

/// Dark Application Theme for Mizan (ميزان)
ThemeData getDarkApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: FontConstants.fontFamily,
    scaffoldBackgroundColor: ColorManager.darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: ColorManager.primary,
      onPrimary: ColorManager.white,
      primaryContainer: ColorManager.darkPrimary,
      secondary: ColorManager.secondary,
      surface: ColorManager.darkSurface,
      onSurface: ColorManager.darkTextPrimary,
      surfaceContainerHighest: ColorManager.darkSurfaceVariant,
      error: ColorManager.error,
      outline: ColorManager.darkBorder,
    ),

    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: ColorManager.darkBackground,
      foregroundColor: ColorManager.darkTextPrimary,
      titleTextStyle: getBoldStyle(
        color: ColorManager.darkTextPrimary,
        fontSize: FontSize.s18,
      ),
    ),

    cardTheme: CardThemeData(
      color: ColorManager.darkSurface,
      elevation: 0,
      margin: EdgeInsets.symmetric(
        horizontal: AppMargin.m16.w,
        vertical: AppMargin.m8.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        side: const BorderSide(color: ColorManager.darkBorder, width: 1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.darkSurfaceVariant,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppPadding.p16.w,
        vertical: AppPadding.p14.h,
      ),
      hintStyle: getRegularStyle(
        color: ColorManager.darkTextSecondary,
        fontSize: FontSize.s14,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorManager.darkBorder, width: 1),
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorManager.primary, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.primary,
        foregroundColor: ColorManager.white,
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p24.w,
          vertical: AppPadding.p14.h,
        ),
        textStyle: getBoldStyle(
          color: ColorManager.white,
          fontSize: FontSize.s16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12.r),
        ),
      ),
    ),
  );
}
