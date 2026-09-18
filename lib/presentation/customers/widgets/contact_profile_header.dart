import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// Top profile header banner for Contact Details (Figma Node #3:1234)
class ContactProfileHeader extends StatelessWidget {
  final ContactProfile profile;

  const ContactProfileHeader({
    super.key,
    required this.profile,
  });

  String _getInitialLetter(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return "ط";
    return trimmed.substring(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: 30.h,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFA8623B),
            Color(0xFFD1A153),
            Color(0xFFC57B57),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.r32.r),
          bottomRight: Radius.circular(AppRadius.r32.r),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28A8623B),
            offset: Offset(0, 8),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular White Avatar Container
          Container(
            width: 80.r,
            height: 80.r,
            decoration: const BoxDecoration(
              color: ColorManager.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x18000000),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getInitialLetter(profile.contactName),
                style: getBoldStyle(
                  color: ColorManager.darkPrimary,
                  fontSize: FontSize.s32,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Name and VIP Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (profile.isVip) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: ColorManager.white.withAlpha(220),
                    borderRadius: BorderRadius.circular(AppRadius.r8.r),
                  ),
                  child: Text(
                    AppStrings.vipClientBadge,
                    style: getBoldStyle(
                      color: ColorManager.darkSecondary,
                      fontSize: FontSize.s11,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Flexible(
                child: Text(
                  profile.contactName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s20,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Phone Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profile.phoneNumber,
                textDirection: TextDirection.ltr,
                style: getMediumStyle(
                  color: ColorManager.white.withAlpha(240),
                  fontSize: FontSize.s13,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.phone_outlined,
                color: ColorManager.white.withAlpha(240),
                size: 16.r,
              ),
            ],
          ),

          if (profile.contactEmail.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile.contactEmail,
                  style: getRegularStyle(
                    color: ColorManager.white.withAlpha(220),
                    fontSize: FontSize.s12,
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  Icons.mail_outline_rounded,
                  color: ColorManager.white.withAlpha(220),
                  size: 15.r,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
