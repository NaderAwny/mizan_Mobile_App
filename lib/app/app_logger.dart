import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void d(String message, {String tag = 'Mizan'}) {
    if (kDebugMode) {
      developer.log(message, name: tag);
    }
  }

  static void e(String message, {Object? error, StackTrace? stackTrace, String tag = 'Mizan'}) {
    if (kDebugMode) {
      developer.log(message, name: tag, error: error, stackTrace: stackTrace);
    }
  }
}
