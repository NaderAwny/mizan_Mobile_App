import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// VIP Contact Card with signature Gold border and quick actions (Figma Node #2025:647)
class VipContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onSendReminder;
  final VoidCallback? onDelete;

  const VipContactCard({
    super.key,
    required this.contact,
    required this.onTap,
    required this.onCall,
    required this.onSendReminder,
    this.onDelete,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return "ط";
    if (parts.length == 1) return parts[0].substring(0, 1);
    return "${parts[0].substring(0, 1)} ${parts[1].substring(0, 1)}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r20.r),
        border: Border.all(
          color: ColorManager.secondary,
          width: 1.4,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C1C1816),
            offset: Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onDelete,
          borderRadius: BorderRadius.circular(AppRadius.r20.r),
          child: Padding(
            padding: EdgeInsets.all(AppPadding.p16.r),
            child: Column(
              children: [
                // Top Row: Avatar, Name, Subtitle, and VIP Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // VIP Badge on Left
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: ColorManager.lightSecondary,
                        borderRadius: BorderRadius.circular(AppRadius.r8.r),
                        border: Border.all(
                          color: ColorManager.secondary.withAlpha(150),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "VIP",
                        style: getBoldStyle(
                          color: ColorManager.secondary,
                          fontSize: FontSize.s11,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Name & Subtitle on Right
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            contact.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s15,
                            ),
                          ),
                          if (contact.notes.isNotEmpty) ...[
                            SizedBox(height: 3.h),
                            Text(
                              contact.notes,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: getRegularStyle(
                                color: ColorManager.textSecondary,
                                fontSize: FontSize.s12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Avatar Circle
                    Container(
                      width: 46.r,
                      height: 46.r,
                      decoration: BoxDecoration(
                        color: ColorManager.surfaceMuted,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorManager.secondary.withAlpha(100),
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(contact.name),
                          style: getBoldStyle(
                            color: ColorManager.textPrimary,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Divider line
                const Divider(color: ColorManager.divider, height: 1),

                SizedBox(height: 10.h),

                // Phone Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      contact.phoneNumber,
                      textDirection: TextDirection.ltr,
                      style: getBoldStyle(
                        color: ColorManager.brandGreen,
                        fontSize: FontSize.s13,
                      ),
                    ),
                    Text(
                      AppStrings.phoneNumber,
                      style: getRegularStyle(
                        color: ColorManager.textTertiary,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                // Action Buttons Row: Call & Send Reminder
                Row(
                  children: [
                    // Reminder Button
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onSendReminder,
                          borderRadius: BorderRadius.circular(AppRadius.r12.r),
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: ColorManager.lightSecondary,
                              borderRadius: BorderRadius.circular(AppRadius.r12.r),
                            ),
                            child: Center(
                              child: Text(
                                AppStrings.sendReminder,
                                style: getBoldStyle(
                                  color: ColorManager.darkSecondary,
                                  fontSize: FontSize.s13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10.w),

                    // Call Button
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onCall,
                          borderRadius: BorderRadius.circular(AppRadius.r12.r),
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: ColorManager.successContainer,
                              borderRadius: BorderRadius.circular(AppRadius.r12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.phoneCall,
                                  style: getBoldStyle(
                                    color: ColorManager.success,
                                    fontSize: FontSize.s13,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Icon(
                                  Icons.phone_in_talk_rounded,
                                  size: 16.r,
                                  color: ColorManager.success,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
