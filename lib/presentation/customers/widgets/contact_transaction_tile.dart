import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/constants_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// Transaction Tile in Contact Details (Figma Node #3:1234)
class ContactTransactionTile extends StatelessWidget {
  final ContactTransaction transaction;
  final VoidCallback? onTap;

  const ContactTransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  bool get _isSale =>
      transaction.type.toLowerCase() == 'sale' ||
      transaction.type == 'بيع' ||
      transaction.type.toLowerCase() == 'income';

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return "—";
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSale = _isSale;
    final amountPrefix = isSale ? "+" : "-";
    final amountColor = isSale ? ColorManager.success : ColorManager.error;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.border, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x061C1816),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.r16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                // Left Column: Amount & Badges
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$amountPrefix${transaction.amount} ${AppConstants.defaultCurrency}",
                      textDirection: TextDirection.ltr,
                      style: getBoldStyle(
                        color: amountColor,
                        fontSize: FontSize.s14,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        // Payment Method Badge
                        if (transaction.paymentMethod.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            margin: EdgeInsets.only(left: 4.w),
                            decoration: BoxDecoration(
                              color: ColorManager.surfaceVariant,
                              borderRadius: BorderRadius.circular(AppRadius.r6.r),
                            ),
                            child: Text(
                              transaction.paymentMethod == "Cash"
                                  ? AppStrings.cash
                                  : transaction.paymentMethod,
                              style: getMediumStyle(
                                color: ColorManager.textSecondary,
                                fontSize: FontSize.s10,
                              ),
                            ),
                          ),

                        // Type Badge
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: isSale
                                ? ColorManager.successContainer
                                : ColorManager.errorContainer,
                            borderRadius: BorderRadius.circular(AppRadius.r6.r),
                          ),
                          child: Text(
                            isSale ? AppStrings.clientCollection : AppStrings.purchaseSupplier,
                            style: getBoldStyle(
                              color: isSale
                                  ? ColorManager.success
                                  : ColorManager.error,
                              fontSize: FontSize.s10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Spacer(),

                // Right Column: Title & Date
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        transaction.partyName.isNotEmpty
                            ? transaction.partyName
                            : (isSale ? AppStrings.accountPayment : AppStrings.purchaseSupplier),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: getBoldStyle(
                          color: ColorManager.textPrimary,
                          fontSize: FontSize.s14,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _formatDate(transaction.transactionDate),
                        style: getRegularStyle(
                          color: ColorManager.textTertiary,
                          fontSize: FontSize.s11,
                        ),
                      ),
                    ],
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
