import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(
  double fontSize,
  FontWeight fontWeight,
  Color color, {
  String? fontFamily,
  double? height,
  double? letterSpacing,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    color: color,
    fontFamily: fontFamily ?? FontConstants.fontFamily,
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );
}

// Light style (300)
TextStyle getLightStyle({
  double fontSize = FontSize.s12,
  required Color color,
  String? fontFamily,
  double? height,
  double? letterSpacing,
  TextDecoration? decoration,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.light,
    color,
    fontFamily: fontFamily,
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );
}

// Regular style (400)
TextStyle getRegularStyle({
  double fontSize = FontSize.s14,
  required Color color,
  String? fontFamily,
  double? height,
  double? letterSpacing,
  TextDecoration? decoration,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.regular,
    color,
    fontFamily: fontFamily,
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );
}

// Medium style (500)
TextStyle getMediumStyle({
  double fontSize = FontSize.s14,
  required Color color,
  String? fontFamily,
  double? height,
  double? letterSpacing,
  TextDecoration? decoration,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.medium,
    color,
    fontFamily: fontFamily,
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );
}

// SemiBold style (600)
TextStyle getSemiBoldStyle({
  double fontSize = FontSize.s14,
  required Color color,
  String? fontFamily,
  double? height,
  double? letterSpacing,
  TextDecoration? decoration,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.semiBold,
    color,
    fontFamily: fontFamily,
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );
}

// SemiBold style alias for compatibility
TextStyle getSemiboldStyle({
  double fontSize = FontSize.s14,
  required Color color,
  String? fontFamily,
  double? height,
  double? letterSpacing,
  TextDecoration? decoration,
}) {
  return getSemiBoldStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: fontFamily,
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );
}

// Bold style (700)
TextStyle getBoldStyle({
  double fontSize = FontSize.s16,
  required Color color,
  String? fontFamily,
  double? height,
  double? letterSpacing,
  TextDecoration? decoration,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.bold,
    color,
    fontFamily: fontFamily,
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );
}

// ExtraBold style (800)
TextStyle getExtraBoldStyle({
  double fontSize = FontSize.s18,
  required Color color,
  String? fontFamily,
  double? height,
  double? letterSpacing,
  TextDecoration? decoration,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.extraBold,
    color,
    fontFamily: fontFamily,
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );
}

// Black style (900)
TextStyle getBlackStyle({
  double fontSize = FontSize.s24,
  required Color color,
  String? fontFamily,
  double? height,
  double? letterSpacing,
  TextDecoration? decoration,
}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.black,
    color,
    fontFamily: fontFamily,
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );
}
