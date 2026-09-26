import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/presentation/resources/constants_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/them_manager.dart';

class MyApp extends StatefulWidget {
  // Named constructor
  const MyApp._internal();

  // Singleton instance
  static const MyApp _instance = MyApp._internal();

  // Factory constructor
  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppConstants.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Mizan',
          debugShowCheckedModeBanner: false,
          theme: getApplicationTheme(),
          initialRoute: Routes.splashRoute,
          onGenerateRoute: RouteGenerator.getRoute,
          navigatorKey: Routes.navigatorKey,
        );
      },
    );
  }
}
