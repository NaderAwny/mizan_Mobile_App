import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';

class NotificationDateHeader extends StatelessWidget {
  final String title;

  const NotificationDateHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 14.h, bottom: 8.h),
      child: Text(
        title,
        style: getBoldStyle(
          color: ColorManager.textSecondary,
          fontSize: FontSize.s13,
        ),
      ),
    );
  }
}
