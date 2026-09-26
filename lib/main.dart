import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mizan/app/app.dart';
import 'package:mizan/app/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await configureDependencies();
  runApp(MyApp());
}
