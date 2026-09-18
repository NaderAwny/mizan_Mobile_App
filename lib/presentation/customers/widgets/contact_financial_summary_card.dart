import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/constants_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// Financial Summary Card for Contact Details (Figma Node #3:1234)
class ContactFinancialSummaryCard extends StatelessWidget {
  final int totalTransactions;
  final num totalAmount;

  const ContactFinancialSummaryCard({
    super.key,
    required this.totalTransactions,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r20.r),
        border: Border.all(color: ColorManager.border, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x081C1816),
            offset: Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Column: Total Account Balance
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppStrings.totalAccountBalance,
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s12,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "$totalAmount ${AppConstants.defaultCurrency}",
                  textDirection: TextDirection.ltr,
                  style: getBoldStyle(
                    color: ColorManager.darkPrimary,
                    fontSize: FontSize.s17,
                  ),
                ),
              ],
            ),
          ),

          // Middle Vertical Divider
          Container(
            height: 38.h,
            width: 1.2,
            color: ColorManager.divider,
          ),

          // Right Column: Total Transactions
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppStrings.totalTransactions,
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s12,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "$totalTransactions ${AppStrings.transactionUnit}",
                  style: getBoldStyle(
                    color: ColorManager.success,
                    fontSize: FontSize.s17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
