import 'package:flutter/material.dart';
import 'package:mizan/app/app.dart';
import 'package:mizan/app/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(MyApp());
}
