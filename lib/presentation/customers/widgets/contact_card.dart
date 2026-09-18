import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// Contact Card for Contacts Directory (Figma Node #3:206)
class ContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final VoidCallback onToggleVip;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ContactCard({
    super.key,
    required this.contact,
    required this.onTap,
    required this.onToggleVip,
    this.onEdit,
    this.onDelete,
  });

  Color _getAvatarBg(String name) {
    if (name.isEmpty) return ColorManager.lightPrimary;
    final int code = name.codeUnitAt(0);
    const colors = [
      Color(0xFFEAE2F8), // Lavender
      Color(0xFFFAF0EC), // Peach / Light Terracotta
      Color(0xFFEBF3EC), // Mint Green
      Color(0xFFFAF3E3), // Soft Gold
      Color(0xFFE6EEF8), // Soft Blue
    ];
    return colors[code % colors.length];
  }

  Color _getAvatarTextColor(String name) {
    if (name.isEmpty) return ColorManager.primary;
    final int code = name.codeUnitAt(0);
    const textColors = [
      Color(0xFF5B3F8A),
      Color(0xFFA8623B),
      Color(0xFF2D5C43),
      Color(0xFF9E7226),
      Color(0xFF2B5B84),
    ];
    return textColors[code % textColors.length];
  }

  String _getInitialLetter(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return "ط";
    return trimmed.substring(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final initial = _getInitialLetter(contact.name);
    final avatarBg = _getAvatarBg(contact.name);
    final avatarTextColor = _getAvatarTextColor(contact.name);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(
          color: contact.isVip
              ? ColorManager.secondary.withAlpha(120)
              : ColorManager.border,
          width: contact.isVip ? 1.4 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x061C1816),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onDelete,
          borderRadius: BorderRadius.circular(AppRadius.r16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                // Left Column: Email info & VIP Badge
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (contact.isVip)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          margin: EdgeInsets.only(bottom: 6.h),
                          decoration: BoxDecoration(
                            color: ColorManager.lightSecondary,
                            borderRadius: BorderRadius.circular(AppRadius.r6.r),
                            border: Border.all(
                              color: ColorManager.secondary.withAlpha(180),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            AppStrings.vipClientBadge,
                            style: getBoldStyle(
                              color: ColorManager.secondary,
                              fontSize: FontSize.s10,
                            ),
                          ),
                        )
                      else
                        Text(
                          AppStrings.contactEmail,
                          style: getRegularStyle(
                            color: ColorManager.textTertiary,
                            fontSize: FontSize.s10,
                          ),
                        ),
                      SizedBox(height: 2.h),
                      Text(
                        contact.contactEmail.isNotEmpty
                            ? contact.contactEmail
                            : "—",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          color: contact.contactEmail.isNotEmpty
                              ? ColorManager.brandGreen
                              : ColorManager.textTertiary,
                          fontSize: FontSize.s11,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                // Middle Column: Contact Name & Phone Number
                Expanded(
                  flex: 6,
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
                          fontSize: FontSize.s14,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        contact.phoneNumber,
                        textDirection: TextDirection.ltr,
                        style: getRegularStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12.w),

                // Right: Circular Avatar with initial letter
                GestureDetector(
                  onTap: onToggleVip,
                  child: Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: avatarBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: contact.isVip
                            ? ColorManager.secondary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: getBoldStyle(
                          color: avatarTextColor,
                          fontSize: FontSize.s18,
                        ),
                      ),
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
