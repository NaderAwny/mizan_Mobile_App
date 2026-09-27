import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mizan/domain/model/get_list_transactions_model.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';
import 'package:mizan/presentation/transactions/get_transaction_by_id/transaction_by_id_view.dart';

class RecentTransactionsSection extends StatelessWidget {
  final List<GetListTransactionsModel>? transactions;
  final bool isLoading;

  const RecentTransactionsSection({
    super.key,
    this.transactions,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final list = transactions ?? [];

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

        if (isLoading && list.isEmpty)
          _buildLoadingState()
        else if (list.isEmpty)
          _buildEmptyState(context)
        else
          Column(
            children: list
                .take(5)
                .map((tx) => _TransactionItemTile(transaction: tx))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        color: ColorManager.primary,
        strokeWidth: 2.5,
      ),
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
  final GetListTransactionsModel transaction;

  const _TransactionItemTile({required this.transaction});

  bool get _isIncome {
    final t = transaction.type.toLowerCase();
    return t == 'sale' ||
        t == 'بيع' ||
        t == 'collect' ||
        t == 'تحصيل' ||
        t == 'income';
  }

  String _getSubtitle() {
    final t = transaction.type.toLowerCase();
    final isCash =
        transaction.paymentMethod.toLowerCase() == 'cash' ||
        transaction.paymentMethod == 'كاش';

    if (t == 'sale' || t == 'بيع') {
      return isCash ? "فاتورة مبيعات نقدية" : "فاتورة مبيعات آجل";
    } else if (t == 'purchase' || t == 'شراء') {
      return isCash ? "شراء بضاعة (نقدي)" : "شراء بضاعة (آجل)";
    } else if (t == 'collect' || t == 'تحصيل') {
      return "تحصيل دفعة مالية";
    } else if (t == 'pay' || t == 'دفع') {
      return "سداد دفعة للمورد";
    }
    return transaction.type;
  }

  String _formatDate(String rawDate) {
    if (rawDate.isEmpty) return "";
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final txDay = DateTime(dt.year, dt.month, dt.day);

      final hour = dt.hour > 12
          ? dt.hour - 12
          : dt.hour == 0
          ? 12
          : dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? "م" : "ص";
      final timeStr = "$hour:$minute $period";

      if (txDay == today) {
        return "اليوم، $timeStr";
      } else if (txDay == today.subtract(const Duration(days: 1))) {
        return "أمس، $timeStr";
      } else {
        const monthsArabic = [
          "يناير",
          "فبراير",
          "مارس",
          "أبريل",
          "مايو",
          "يونيو",
          "يوليو",
          "أغسطس",
          "سبتمبر",
          "أكتوبر",
          "نوفمبر",
          "ديسمبر",
        ];
        return "${dt.day} ${monthsArabic[dt.month - 1]}، $timeStr";
      }
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = _isIncome;
    final amountColor = isIncome ? ColorManager.success : ColorManager.error;
    final iconColor = isIncome ? ColorManager.success : ColorManager.error;
    final iconBgColor = isIncome
        ? ColorManager.successContainer
        : ColorManager.errorContainer;
    final icon = isIncome ? IconAssets.arrowDownLeft : IconAssets.arrowUpRight;
    final amountPrefix = isIncome ? "+ " : "- ";
    final formattedAmount =
        "$amountPrefix${NumberFormat('#,##0.##').format(transaction.amount)} ج.م";

    final title = transaction.contactName.trim().isNotEmpty
        ? transaction.contactName.trim()
        : "معاملة بدون اسم";

    final dateStr = _formatDate(
      transaction.transactionDate.isNotEmpty
          ? transaction.transactionDate
          : transaction.createdAt,
    );

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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionDetailsView(
                  transactionId: transaction.id,
                  id: transaction.id,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppRadius.r14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                // Icon
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

                // Content
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getBoldStyle(
                                color: ColorManager.textPrimary,
                                fontSize: FontSize.s12,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              _getSubtitle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getRegularStyle(
                                color: ColorManager.textSecondary,
                                fontSize: FontSize.s10,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // Amount & Date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formattedAmount,
                            style: getBoldStyle(
                              color: amountColor,
                              fontSize: FontSize.s12,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            dateStr,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

