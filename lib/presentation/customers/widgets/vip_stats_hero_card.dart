import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// Hero Stats Banner for VIP Clients List (Figma Node #2025:647)
class VipStatsHeroCard extends StatelessWidget {
  final int totalVipCount;
  final int totalPages;

  const VipStatsHeroCard({
    super.key,
    required this.totalVipCount,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFBA704F),
            Color(0xFFD6A75D),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.r20.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28C57B57),
            offset: Offset(0, 6),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge: كبار العملاء
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(AppRadius.r10.r),
                  border: Border.all(
                    color: Colors.white.withAlpha(40),
                    width: 1,
                  ),
                ),
                child: Text(
                  AppStrings.vipTopClients,
                  style: getBoldStyle(
                    color: const Color(0xFF1C1816),
                    fontSize: FontSize.s12,
                  ),
                ),
              ),

              // Title: إحصائيات عملاء VIP
              Flexible(
                child: Text(
                  AppStrings.vipStatsTitle,
                  style: getBoldStyle(
                    color: const Color(0xFF1C1816),
                    fontSize: FontSize.s15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          // Bottom Stats Row: 2 Balanced Expanded Columns
          Row(
            children: [
              // Right Column (in RTL): Total Pages
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$totalPages ${AppStrings.pages}",
                      style: getBoldStyle(
                        color: const Color(0xFF1C1816),
                        fontSize: FontSize.s20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      AppStrings.totalPagesTitle,
                      style: getMediumStyle(
                        color: const Color(0xFF4A3E36),
                        fontSize: FontSize.s11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              SizedBox(width: 12.w),

              // Left Column (in RTL): VIP Clients Count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "$totalVipCount ${AppStrings.client}",
                      style: getBoldStyle(
                        color: const Color(0xFF1C1816),
                        fontSize: FontSize.s20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      AppStrings.totalVipClients,
                      style: getMediumStyle(
                        color: const Color(0xFF4A3E36),
                        fontSize: FontSize.s11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
