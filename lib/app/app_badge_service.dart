import 'dart:developer' as developer;

import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service responsible for updating the native app-icon badge
/// (the red number shown on the app launcher icon — like Facebook).
class AppBadgeService {
  AppBadgeService._();

  static bool? _supported;
  static const String _badgeCountKey = 'app_badge_count';

  /// Returns true if the current platform supports app-icon badges.
  static Future<bool> get isSupported async {
    _supported ??= await AppBadgePlus.isSupported();
    return _supported!;
  }

  /// Updates the badge count. Pass 0 to clear the badge.
  static Future<void> updateCount(int count) async {
    try {
      if (!await isSupported) return;
      final int safeCount = count < 0 ? 0 : count;
      await AppBadgePlus.updateBadge(safeCount);
      // احفظ العدد محلياً لاستخدامه في الـ background handler
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_badgeCountKey, safeCount);
    } catch (e) {
      developer.log('[AppBadgeService] Failed to update badge: $e');
    }
  }

  /// يزيد العدد الحالي بمقدار 1 — يُستخدم من الـ background handler
  /// حيث لا يكون الـ cubit متاحاً.
  static Future<void> incrementBadge() async {
    try {
      if (!await isSupported) return;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int current = prefs.getInt(_badgeCountKey) ?? 0;
      final int newCount = current + 1;
      await AppBadgePlus.updateBadge(newCount);
      await prefs.setInt(_badgeCountKey, newCount);
    } catch (e) {
      developer.log('[AppBadgeService] Failed to increment badge: $e');
    }
  }

  /// Clears the badge (sets it to 0).
  static Future<void> clearBadge() => updateCount(0);
}

