import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  void _showTransactionTypePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: ColorManager.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.r24.r),
            topRight: Radius.circular(AppRadius.r24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: ColorManager.borderDark,
                  borderRadius: BorderRadius.circular(AppRadius.r10.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "تسجيل عملية مالية جديدة",
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              "اختر نوع العملية التي تريد توثيقها في ميزان",
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s12,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            // Quick Sale Option
            _TransactionTypeOption(
              icon: IconAssets.shoppingBag,
              title: "عملية بيع جديدة",
              subtitle: "تسجيل فاتورة مبيعات لعميل (كاش أو تقسيط)",
              color: ColorManager.primary,
              bgColor: ColorManager.lightPrimary,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, Routes.quickSaleRoute);
              },
            ),
            SizedBox(height: 10.h),
            // Quick Purchase Option
            _TransactionTypeOption(
              icon: IconAssets.arrowUpRight,
              title: "عملية شراء جديدة",
              subtitle: "تسجيل فاتورة مشتريات من مورد (كاش أو تقسيط)",
              color: ColorManager.secondary,
              bgColor: ColorManager.lightSecondary,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, Routes.quickPurchaseRoute);
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

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
          AppStrings.transactions,
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s16,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_rounded,
              color: ColorManager.primary,
              size: 24.r,
            ),
            onPressed: () => _showTransactionTypePicker(context),
          ),
          SizedBox(width: 8.w),
        ],
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
                  color: ColorManager.lightSecondary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.secondary.withAlpha(60),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    IconAssets.receiptText,
                    width: 44.r,
                    height: 44.r,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.secondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                AppStrings.noTransactionsTitle,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s18,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                AppStrings.noTransactionsSubtitle,
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
                height: 52.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: ColorManager.primaryGradient,
                    borderRadius: BorderRadius.circular(AppRadius.r14.r),
                    boxShadow: const [AppShadows.fabShadow],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _showTransactionTypePicker(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r14.r),
                      ),
                    ),
                    icon: Icon(
                      Icons.add_rounded,
                      color: ColorManager.white,
                      size: 20.r,
                    ),
                    label: Text(
                      AppStrings.recordFirstTransaction,
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

class _TransactionTypeOption extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _TransactionTypeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.r14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(AppRadius.r12.r),
                  ),
                  child: SvgPicture.asset(
                    icon,
                    width: 22.r,
                    height: 22.r,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s14,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: getRegularStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ColorManager.textTertiary,
                  size: 14.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
