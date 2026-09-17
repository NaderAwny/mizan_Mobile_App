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

class RecentTransactionsSection extends StatelessWidget {
  final bool isEmpty;

  const RecentTransactionsSection({super.key, this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header: "آخر العمليات" + "عرض الكل"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "آخر العمليات",
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s15,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.transactionsRoute);
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.viewAll,
                      style: getBoldStyle(
                        color: ColorManager.primary,
                        fontSize: FontSize.s12,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 11.r,
                      color: ColorManager.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 10.h),

        if (isEmpty)
          _buildEmptyState(context)
        else
          Column(
            children: const [
              _TransactionItemTile(
                title: "مؤسسة الأمل التجارية",
                subtitle: "فاتورة مبيعات #1042",
                date: "اليوم، 02:30 م",
                amount: "+ 4,500 ج.م",
                isPositive: true,
                icon: IconAssets.arrowDownLeft,
                iconColor: ColorManager.success,
                iconBgColor: ColorManager.successContainer,
              ),
              _TransactionItemTile(
                title: "شركة التوريدات الحديثة",
                subtitle: "شراء بضاعة #883",
                date: "أمس، 11:15 ص",
                amount: "- 2,100 ج.م",
                isPositive: false,
                icon: IconAssets.arrowUpRight,
                iconColor: ColorManager.error,
                iconBgColor: ColorManager.errorContainer,
              ),
              _TransactionItemTile(
                title: "محمود حسن علي",
                subtitle: "قسط مستحق #3",
                date: "12 سبتمبر، 04:00 م",
                amount: "1,250 ج.م",
                isPositive: null,
                icon: IconAssets.walletCards,
                iconColor: ColorManager.secondary,
                iconBgColor: ColorManager.lightSecondary,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            ImageAssets.illustrationEmpty,
            width: 70.r,
            height: 70.r,
          ),
          SizedBox(height: 12.h),
          Text(
            AppStrings.noTransactionsTitle,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s13,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            AppStrings.noTransactionsSubtitle,
            textAlign: TextAlign.center,
            style: getMediumStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String amount;
  final bool? isPositive;
  final String icon;
  final Color iconColor;
  final Color iconBgColor;

  const _TransactionItemTile({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.isPositive,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final amountColor = isPositive == true
        ? ColorManager.success
        : isPositive == false
        ? ColorManager.error
        : ColorManager.textPrimary;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha(4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.transactionsRoute);
          },
          borderRadius: BorderRadius.circular(AppRadius.r14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                // ==========================================
                // ICON - ثابت لا يتحرك
                // ==========================================
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(AppRadius.r10.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      icon,
                      width: 18.r,
                      height: 18.r,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                  ),
                ),

                SizedBox(width: 10.w),

                // ==========================================
                // CONTENT - Horizontal Scroll
                // ==========================================
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ==================================
                        // TITLE + SUBTITLE
                        // ==================================
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: getBoldStyle(
                                color: ColorManager.textPrimary,
                                fontSize: FontSize.s12,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              subtitle,
                              style: getRegularStyle(
                                color: ColorManager.textSecondary,
                                fontSize: FontSize.s10,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 30.w),

                        // ==================================
                        // AMOUNT + DATE
                        // ==================================
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              amount,
                              style: getBoldStyle(
                                color: amountColor,
                                fontSize: FontSize.s12,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              date,
                              style: getRegularStyle(
                                color: ColorManager.textTertiary,
                                fontSize: FontSize.s9,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
