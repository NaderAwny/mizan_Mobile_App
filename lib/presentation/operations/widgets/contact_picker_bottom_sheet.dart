import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/customers/contacts_cubit/contacts_cubit.dart';
import 'package:mizan/presentation/customers/contacts_cubit/contacts_state.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class ContactPickerResult {
  final String? contactId;
  final String name;
  final bool isVip;

  const ContactPickerResult({
    this.contactId,
    required this.name,
    this.isVip = false,
  });

  bool get isFromDirectory => contactId != null && contactId!.isNotEmpty;
}

class ContactPickerBottomSheet extends StatefulWidget {
  final String? selectedContactId;
  final String? selectedName;

  const ContactPickerBottomSheet({
    super.key,
    this.selectedContactId,
    this.selectedName,
  });

  static Future<ContactPickerResult?> show(
    BuildContext context, {
    String? selectedContactId,
    String? selectedName,
  }) {
    return showModalBottomSheet<ContactPickerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ContactPickerBottomSheet(
        selectedContactId: selectedContactId,
        selectedName: selectedName,
      ),
    );
  }

  @override
  State<ContactPickerBottomSheet> createState() =>
      _ContactPickerBottomSheetState();
}

class _ContactPickerBottomSheetState extends State<ContactPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _manualNameController = TextEditingController();
  bool _isManualEntryOpen = false;

  @override
  void dispose() {
    _searchController.dispose();
    _manualNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsCubit>(
      create: (_) => getIt<ContactsCubit>()..getContacts(),
      child: Builder(
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
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
              children: [
                // Top drag handle
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: ColorManager.borderDark,
                    borderRadius: BorderRadius.circular(AppRadius.r10.r),
                  ),
                ),

                // Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "تحديد الطرف الثاني",
                            style: getBoldStyle(
                              color: ColorManager.textPrimary,
                              fontSize: FontSize.s17,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "اختر من الدليل أو اكتب اسماً يدوياً للعملية",
                            style: getRegularStyle(
                              color: ColorManager.textSecondary,
                              fontSize: FontSize.s10.sp,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: ColorManager.surfaceVariant,
                          shape: const CircleBorder(),
                        ),
                        icon: Icon(
                          Icons.close_rounded,
                          color: ColorManager.textPrimary,
                          size: 18.r,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(color: ColorManager.border, height: 1),

                // Manual Name Card / Toggle
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: ColorManager.surface,
                      borderRadius: BorderRadius.circular(AppRadius.r14.r),
                      border: Border.all(
                        color: _isManualEntryOpen
                            ? ColorManager.primary
                            : ColorManager.border,
                        width: _isManualEntryOpen ? 1.5 : 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isManualEntryOpen = !_isManualEntryOpen;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: ColorManager.lightPrimary,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.r10.r,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  IconAssets.user,
                                  width: 16.r,
                                  height: 16.r,
                                  colorFilter: const ColorFilter.mode(
                                    ColorManager.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "كتابة اسم الطرف يدوياً",
                                      style: getBoldStyle(
                                        color: ColorManager.textPrimary,
                                        fontSize: FontSize.s13,
                                      ),
                                    ),
                                    Text(
                                      "للتعاملات السريعة دون حفظ الطرف في الدليل",
                                      style: getRegularStyle(
                                        color: ColorManager.textSecondary,
                                        fontSize: FontSize.s11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                _isManualEntryOpen
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: ColorManager.textSecondary,
                                size: 20.r,
                              ),
                            ],
                          ),
                        ),
                        if (_isManualEntryOpen) ...[
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _manualNameController,
                                  decoration: InputDecoration(
                                    hintText: "اكتب اسم العميل أو المورد...",
                                    hintStyle: getRegularStyle(
                                      color: ColorManager.textTertiary,
                                      fontSize: FontSize.s13,
                                    ),
                                    filled: true,
                                    fillColor: ColorManager.surfaceVariant,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 10.h,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.r10.r,
                                      ),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              ElevatedButton(
                                onPressed: () {
                                  final name = _manualNameController.text
                                      .trim();
                                  if (name.isNotEmpty) {
                                    Navigator.pop(
                                      context,
                                      ContactPickerResult(name: name),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.primary,
                                  foregroundColor: ColorManager.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.r10.r,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "استخدام",
                                  style: getBoldStyle(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Search & Filter Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      // Search Field
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorManager.surface,
                            borderRadius: BorderRadius.circular(
                              AppRadius.r12.r,
                            ),
                            border: Border.all(color: ColorManager.border),
                          ),
                          child: TextField(
                            style: getRegularStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s13,
                            ),
                            controller: _searchController,
                            onChanged: (val) {
                              context.read<ContactsCubit>().searchContacts(val);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: ColorManager.surface,

                              hintText: "ابحث في دليل الأطراف...",
                              hintStyle: getRegularStyle(
                                color: ColorManager.textTertiary,
                                fontSize: FontSize.s13,
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12.r),
                                child: SvgPicture.asset(
                                  IconAssets.search,
                                  width: 16.r,
                                  height: 16.r,
                                  colorFilter: const ColorFilter.mode(
                                    ColorManager.textSecondary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear_rounded,
                                        size: 16.r,
                                        color: ColorManager.textSecondary,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        context
                                            .read<ContactsCubit>()
                                            .searchContacts("");
                                        setState(() {});
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // VIP Filter toggle
                      BlocBuilder<ContactsCubit, ContactsState>(
                        builder: (ctx, state) {
                          final isVip = state.isVipOnly;
                          return GestureDetector(
                            onTap: () {
                              context.read<ContactsCubit>().setVipFilter(
                                !isVip,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: isVip
                                    ? ColorManager.lightSecondary
                                    : ColorManager.surface,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r12.r,
                                ),
                                border: Border.all(
                                  color: isVip
                                      ? ColorManager.secondary
                                      : ColorManager.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    IconAssets.star,
                                    width: 14.r,
                                    height: 14.r,
                                    colorFilter: ColorFilter.mode(
                                      isVip
                                          ? ColorManager.secondary
                                          : ColorManager.textSecondary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "VIP",
                                    style: getBoldStyle(
                                      color: isVip
                                          ? ColorManager.darkSecondary
                                          : ColorManager.textSecondary,
                                      fontSize: FontSize.s11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Contacts List
                Expanded(
                  child: BlocBuilder<ContactsCubit, ContactsState>(
                    builder: (ctx, state) {
                      if (state.flowState is LoadingState &&
                          (state.data == null || state.data!.isEmpty)) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: ColorManager.primary,
                          ),
                        );
                      }

                      final contacts = state.data ?? [];

                      if (contacts.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  IconAssets.users,
                                  width: 42.r,
                                  height: 42.r,
                                  colorFilter: const ColorFilter.mode(
                                    ColorManager.textTertiary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  "لا توجد جهات اتصال مطابقة",
                                  style: getBoldStyle(
                                    color: ColorManager.textPrimary,
                                    fontSize: FontSize.s14,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "يمكنك كتابة اسم الطرف يدوياً بالأعلى",
                                  style: getRegularStyle(
                                    color: ColorManager.textSecondary,
                                    fontSize: FontSize.s12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        itemCount: contacts.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 6.h),
                        itemBuilder: (ctx, index) {
                          final contact = contacts[index];
                          final isSelected =
                              widget.selectedContactId == contact.id;

                          return _ContactTile(
                            contact: contact,
                            isSelected: isSelected,
                            onTap: () {
                              Navigator.pop(
                                context,
                                ContactPickerResult(
                                  contactId: contact.id,
                                  name: contact.name,
                                  isVip: contact.isVip,
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final Contact contact;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContactTile({
    required this.contact,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? ColorManager.lightPrimary : ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
        border: Border.all(
          color: isSelected ? ColorManager.primary : ColorManager.border,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.r12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
              children: [
                // Avatar circle
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: contact.isVip
                        ? ColorManager.lightSecondary
                        : ColorManager.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      contact.name.isNotEmpty
                          ? contact.name.trim().characters.first
                          : "?",
                      style: getBoldStyle(
                        color: contact.isVip
                            ? ColorManager.darkSecondary
                            : ColorManager.primary,
                        fontSize: FontSize.s16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Name & phone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              contact.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getBoldStyle(
                                color: ColorManager.textPrimary,
                                fontSize: FontSize.s14,
                              ),
                            ),
                          ),
                          if (contact.isVip) ...[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.lightSecondary,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r4.r,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    IconAssets.star,
                                    width: 10.r,
                                    height: 10.r,
                                    colorFilter: const ColorFilter.mode(
                                      ColorManager.secondary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    "VIP",
                                    style: getBoldStyle(
                                      color: ColorManager.darkSecondary,
                                      fontSize: FontSize.s9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (contact.phoneNumber.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          contact.phoneNumber,
                          textDirection: TextDirection.ltr,
                          style: getRegularStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Selected indicator
                if (isSelected)
                  Container(
                    width: 22.r,
                    height: 22.r,
                    decoration: const BoxDecoration(
                      color: ColorManager.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: ColorManager.white,
                        size: 14.r,
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
