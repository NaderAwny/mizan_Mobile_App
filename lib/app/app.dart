import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/app/session_manager.dart';
import 'package:mizan/presentation/resources/constants_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/them_manager.dart';

class MyApp extends StatefulWidget {
  // Private named constructor for singleton pattern
  const MyApp._internal();

  // Static instance of the class
  static const MyApp _instance = MyApp._internal();

  // Factory constructor
  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<void>? _sessionSubscription;

  @override
  void initState() {
    super.initState();
    if (getIt.isRegistered<SessionManager>()) {
      _sessionSubscription = getIt<SessionManager>().onSessionExpired.listen((_) {
        Routes.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.sendOtpRoute,
          (route) => false,
        );
      });
    }
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppConstants.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: Routes.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          theme: getApplicationTheme(),
          darkTheme: getDarkApplicationTheme(),
          themeMode: ThemeMode.system,
          onGenerateRoute: RouteGenerator.getRoute,
          initialRoute: Routes.splashRoute,
        );
      },
    );
  }
}

