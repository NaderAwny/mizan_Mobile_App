import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mizan/app/app.dart';
import 'package:mizan/app/constants.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/app/notification_service.dart';

Future<void> _wakeServer() async {
  try {
    await Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (_) => true,
      ),
    ).head(Constants.baseUrl);
  } catch (_) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(_wakeServer());
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await configureDependencies();
  await getIt<NotificationService>().initialize();
  runApp(MyApp());
}
