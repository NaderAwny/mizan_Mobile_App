import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String imagesPath = "assets/images";
const String iconsPath = "assets/icons";
const String jsonPath = "assets/json";

/// Type-safe asset constants for Mizan (ميزان)
class ImageAssets {
  // --- Logos & Branding ---
  static const String logoScalesPng = "$imagesPath/logo_scales.png";
  static const String logoScalesSvg = "$imagesPath/logo_scales_image.svg";
  static const String logoBox = "$imagesPath/logo_box.svg";
  static const String logoIcon = "$imagesPath/logo_icon.svg";
  static const String logoIconLarge = "$imagesPath/logo_icon_large.svg";
  static const String logoHeader = "$imagesPath/logo_header.svg";
  // --- Onboarding Screens ---
  static const String onBoardingLogo1 = "$imagesPath/onboarding1.svg";
  static const String onBoardingLogo2 = "$imagesPath/onboarding2.svg";
  static const String onBoardingLogo3 = "$imagesPath/onboarding3.svg";
  static const String appBarImage = "$imagesPath/app_bar_image.svg";

  // Compatibility aliases
  static const String appLogoSvg = logoIcon;
  static const String appLogoPng = logoScalesPng;
  static const String logoBoxFigmaPng = "$imagesPath/logo_box_figma.png";
  static const String logoScalesFigmaPng = "$imagesPath/logo_scales_figma.png";

  // --- Cards & Illustrations ---
  static const String heroBalanceCard = "$imagesPath/hero_balance_card.svg";
  static const String ringSummaryCard = "$imagesPath/ring_summary_card.svg";
  static const String illustrationEmpty = "$imagesPath/illustration_empty.svg";
  static const String checkmarkCircle = "$imagesPath/checkmark_circle.svg";
  static const String audioWave = "$imagesPath/audio_wave.svg";
  static const String bellIcon = "$imagesPath/bell_icon.svg";
}

class IconAssets {
  // --- Navigation & Core ---
  static const String home = "$iconsPath/home.svg";
  static const String receiptText =
      "$iconsPath/receipt_text.svg"; // Transactions
  static const String users = "$iconsPath/users.svg"; // Contacts
  static const String walletCards =
      "$iconsPath/wallet_cards.svg"; // Installments
  static const String plus = "$iconsPath/plus.svg"; // FAB / Add
  static const String chartNetwork =
      "$iconsPath/chart_network.svg"; // Analytics

  // --- Quick Actions & Financial Transactions ---
  static const String shoppingBag = "$iconsPath/shopping_bag.svg"; // Sale (بيع)
  static const String arrowDownLeft =
      "$iconsPath/arrow_down_left.svg"; // Collection (تحصيل)
  static const String arrowUpRight =
      "$iconsPath/arrow_up_right.svg"; // Payment / Expense (دفع)
  static const String arrowUpRightFromSquare =
      "$iconsPath/arrow_up_right_from_square.svg"; // Export
  static const String wallet2 = "$iconsPath/wallet_2.svg"; // Wallet / Balance
  static const String mailPlus =
      "$iconsPath/mail_plus.svg"; // Reminder / Invoice
  static const String building = "$iconsPath/building.svg"; // Business
  static const String store = "$iconsPath/store.svg"; // Shop
  static const String storeFrame = "$iconsPath/store_frame.svg";
  static const String user = "$iconsPath/user.svg"; // Contact / Profile
  static const String mapPin = "$iconsPath/map_pin.svg"; // Location
  static const String star = "$iconsPath/star.svg"; // VIP rating
  static const String bookmark = "$iconsPath/bookmark.svg";
  //onboarding icons
  static const String dot3 = "$iconsPath/dot-3.svg";
  static const String dot2 = "$iconsPath/dot-2.svg";

  // --- Controls, Search & Filters ---
  static const String bell = "$iconsPath/bell.svg"; // Notification
  static const String bellIcon = "$iconsPath/bell_icon.svg";
  static const String search = "$iconsPath/search.svg";
  static const String sliders = "$iconsPath/sliders.svg"; // Filter
  static const String sliderFrame = "$iconsPath/slider_frame.svg";
  static const String calendar = "$iconsPath/calendar.svg";
  static const String calendarCheck = "$iconsPath/calendar_check.svg";
  static const String calendarSync = "$iconsPath/calendar_sync.svg";
  static const String alarmClock = "$iconsPath/alarm_clock.svg";
  static const String hourglass =
      "$iconsPath/hourglass.svg"; // Rate limit / Pending
  static const String lock = "$iconsPath/lock.svg"; // Session security
  static const String wifiOff = "$iconsPath/wifi_off.svg"; // Offline mode
  static const String alertTriangle = "$iconsPath/alert_triangle.svg";

  // --- Audio & Voice Notes ---
  static const String mic = "$iconsPath/mic.svg";
  static const String play = "$iconsPath/play.svg";
  static const String playCircle = "$iconsPath/play_circle.svg";
  static const String pause = "$iconsPath/pause.svg";
  static const String rewind = "$iconsPath/rewind.svg";
  static const String forward = "$iconsPath/forward.svg";
  static const String waveform = "$iconsPath/waveform.svg";
  static const String waveformBars = "$iconsPath/waveform_bars.svg";
  static const String progressTrack = "$iconsPath/progress_track.svg";

  // --- Modifiers & CRUD ---
  static const String editPen = "$iconsPath/edit_pen.svg";
  static const String pencil = "$iconsPath/pencil.svg";
  static const String trash = "$iconsPath/trash.svg";
  static const String trash2 = "$iconsPath/trash_2.svg";
  static const String plusSquare = "$iconsPath/plus_square.svg";
  static const String minus = "$iconsPath/minus.svg";
  static const String checkCheck = "$iconsPath/check_check.svg";
  static const String checkCircle = "$iconsPath/check_circle.svg";
  static const String xCircle = "$iconsPath/x_circle.svg";
  static const String folderCheck = "$iconsPath/folder_check.svg";
  static const String shieldCheck = "$iconsPath/shield_check.svg";
  static const String cloudCheck = "$iconsPath/cloud_check.svg";
  static const String helpCircle = "$iconsPath/help_circle.svg";

  // --- Communication ---
  static const String phone = "$iconsPath/phone.svg";
  static const String messageCircle = "$iconsPath/message_circle.svg";

  // --- Chevrons & Arrows ---
  static const String chevronLeft = "$iconsPath/chevron_left.svg";
  static const String chevronDown = "$iconsPath/chevron_down.svg";
  static const String arrowLeft = "$iconsPath/arrow_left.svg";

  // --- System Status Bar ---
  static const String iosBatteryFull = "$iconsPath/ios_battery_full.svg";
  static const String iosWifiSignal = "$iconsPath/ios_wifi_signal.svg";
  static const String iosSignal = "$iconsPath/ios_signal.svg";
}

class JsonAssets {
  // static const String loading = "$jsonPath/loading.json";
  static const String loading = "$jsonPath/Wallet Animation.json";
  // static const String error = "$jsonPath/error.json";
  static const String error = "$jsonPath/Animated 404 Error .json";
  static const String empty = "$jsonPath/empty.json";
  static const String success = "$jsonPath/success.json";
}

/// ScreenUtil responsive image and SVG extension methods
extension ResponsiveAssetExtension on String {
  /// Render an SVG asset with responsive dimensions scaled via ScreenUtil (.w, .h)
  Widget svg({
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    ColorFilter? colorFilter,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return SvgPicture.asset(
      this,
      key: key,
      width: width?.w,
      height: height?.h,
      fit: fit,
      alignment: alignment,
      colorFilter:
          colorFilter ??
          (color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null),
    );
  }

  /// Render an SVG asset with uniform radius scaling (.r)
  Widget svgSquare({
    Key? key,
    required double size,
    BoxFit fit = BoxFit.contain,
    Color? color,
    ColorFilter? colorFilter,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    final double s = size.r;
    return SvgPicture.asset(
      this,
      key: key,
      width: s,
      height: s,
      fit: fit,
      alignment: alignment,
      colorFilter:
          colorFilter ??
          (color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null),
    );
  }

  /// Render a raster image (PNG) with responsive dimensions scaled via ScreenUtil
  Widget png({
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return Image.asset(
      this,
      key: key,
      width: width?.w,
      height: height?.h,
      fit: fit,
      color: color,
      alignment: alignment,
    );
  }
}
