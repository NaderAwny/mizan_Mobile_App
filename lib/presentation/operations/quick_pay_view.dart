import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class QuickPayView extends StatelessWidget {
  const QuickPayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_forward_ios_rounded,
            color: ColorManager.textPrimary,
            size: 18.r,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          "تسجيل عملية دفع / مصروفات",
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s16,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 88.r,
                height: 88.r,
                decoration: BoxDecoration(
                  color: ColorManager.errorContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.error.withAlpha(60),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    IconAssets.wallet2,
                    width: 40.r,
                    height: 40.r,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.error,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                AppStrings.quickPay,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s20,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "شاشة توثيق سندات الصرف وسداد الالتزامات والمصروفات. جاهزة للربط مع الـ Cubit والـ API.",
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
