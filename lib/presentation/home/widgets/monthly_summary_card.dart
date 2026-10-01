// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:mizan/presentation/resources/color_manager.dart';
// import 'package:mizan/presentation/resources/font_manager.dart';
// import 'package:mizan/presentation/resources/routes_manager.dart';
// import 'package:mizan/presentation/resources/styles_manager.dart';
// import 'package:mizan/presentation/resources/values_manager.dart';

// class MonthlySummaryCard extends StatelessWidget {
//   final double collectedAmount;
//   final double targetAmount;
//   final double percentage;

//   const MonthlySummaryCard({
//     super.key,
//     this.collectedAmount = 42500,
//     this.targetAmount = 50000,
//     this.percentage = 0.85,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final clampedPct = percentage.clamp(0.0, 1.0);
//     final pctInt = (clampedPct * 100).toInt();
//     final numberFormat = NumberFormat('#,##0.##');
//     final formattedCollected = numberFormat.format(collectedAmount);
//     final formattedTarget = numberFormat.format(targetAmount);
//     final remaining = (targetAmount - collectedAmount) > 0
//         ? (targetAmount - collectedAmount)
//         : 0.0;
//     final formattedRemaining = numberFormat.format(remaining);

//     final String badgeText;
//     if (clampedPct >= 0.8) {
//       badgeText = "أداء ممتاز • تبقى $formattedRemaining ج.م";
//     } else if (clampedPct >= 0.5) {
//       badgeText = "أداء جيد • تبقى $formattedRemaining ج.م";
//     } else {
//       badgeText = "تبقى $formattedRemaining ج.م للهدف";
//     }

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () {
//           Navigator.pushNamed(context, Routes.analyticsRoute);
//         },
//         borderRadius: BorderRadius.circular(AppRadius.r16.r),
//         child: Container(
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
//           decoration: BoxDecoration(
//             color: ColorManager.surfaceVariant,
//             borderRadius: BorderRadius.circular(AppRadius.r16.r),
//             border: Border.all(color: ColorManager.border, width: 1.0),
//             boxShadow: [
//               BoxShadow(
//                 color: ColorManager.black.withAlpha(5),
//                 blurRadius: 10,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Circular Progress Ring Indicator
//               SizedBox(
//                 width: 52.r,
//                 height: 52.r,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Background track
//                     CircularProgressIndicator(
//                       value: 1.0,
//                       strokeWidth: 5.5,
//                       color: ColorManager.borderDark.withAlpha(120),
//                     ),
//                     // Progress arc
//                     CircularProgressIndicator(
//                       value: clampedPct,
//                       strokeWidth: 5.5,
//                       strokeCap: StrokeCap.round,
//                       valueColor: const AlwaysStoppedAnimation<Color>(
//                         ColorManager.primary,
//                       ),
//                     ),
//                     // Percentage text in center
//                     Center(
//                       child: Text(
//                         "$pctInt%",
//                         style: getBoldStyle(
//                           color: ColorManager.textPrimary,
//                           fontSize: FontSize.s10,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(width: 14.w),

//               // Title, amounts & badge
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           "ملخص تحصيلات الشهر",
//                           style: getBoldStyle(
//                             color: ColorManager.textPrimary,
//                             fontSize: FontSize.s13,
//                           ),
//                         ),
//                         const Spacer(),
//                         Icon(
//                           Icons.arrow_back_ios_new_rounded,
//                           size: 11.r,
//                           color: ColorManager.textTertiary,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 3.h),
//                     FittedBox(
//                       fit: BoxFit.scaleDown,
//                       alignment: Alignment.centerRight,
//                       child: Text(
//                         "تم تحصيل $formattedCollected ج.م من $formattedTarget ج.م",
//                         style: getRegularStyle(
//                           color: ColorManager.textSecondary,
//                           fontSize: FontSize.s12,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 5.h),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 8.w,
//                         vertical: 2.h,
//                       ),
//                       decoration: BoxDecoration(
//                         color: ColorManager.lightPrimary,
//                         borderRadius: BorderRadius.circular(6.r),
//                       ),
//                       child: Text(
//                         badgeText,
//                         style: getSemiBoldStyle(
//                           color: ColorManager.primary,
//                           fontSize: FontSize.s10,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
