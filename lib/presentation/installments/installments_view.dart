import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class InstallmentsView extends StatelessWidget {
  const InstallmentsView({super.key});

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
          AppStrings.installments,
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
                width: 90.r,
                height: 90.r,
                decoration: BoxDecoration(
                  color: ColorManager.lightPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.primary.withAlpha(50),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    IconAssets.walletCards,
                    width: 44.r,
                    height: 44.r,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                AppStrings.noInstallmentsTitle,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s18,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "هذه الشاشة مخصصة لإدارة خطط الأقساط وجداول الدفعات وتواريخ الاستحقاق. جاهزة لربط الـ Cubit والـ API.",
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s14,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: ColorManager.primaryGradient,
                    borderRadius: BorderRadius.circular(AppRadius.r14.r),
                    boxShadow: const [AppShadows.fabShadow],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r14.r),
                      ),
                    ),
                    icon: Icon(Icons.add_rounded, color: ColorManager.white, size: 20.r),
                    label: Text(
                      AppStrings.newInstallment,
                      style: getBoldStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
