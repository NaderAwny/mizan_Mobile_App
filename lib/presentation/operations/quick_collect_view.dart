import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class QuickCollectView extends StatelessWidget {
  const QuickCollectView({super.key});

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
          "تسجيل عملية تحصيل مالي",
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
                  color: ColorManager.successContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.success.withAlpha(60),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    IconAssets.arrowDownLeft,
                    width: 40.r,
                    height: 40.r,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.success,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                AppStrings.quickCollect,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s20,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "شاشة توثيق سندات القبض والتحصيلات النقدية من العملاء. جاهزة للربط مع الـ Cubit والـ API.",
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
