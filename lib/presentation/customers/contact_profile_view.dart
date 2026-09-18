// ─────────────────────────────────────────────────────────────
// ContactProfileView — Mizan design system & Figma Node #3:1234 compliant
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/customers/contact_profile_cubit/contact_profile_cubit.dart';
import 'package:mizan/presentation/customers/contact_profile_cubit/contact_profile_state.dart';
import 'package:mizan/presentation/customers/widgets/contact_financial_summary_card.dart';
import 'package:mizan/presentation/customers/widgets/contact_profile_header.dart';
import 'package:mizan/presentation/customers/widgets/contact_transaction_tile.dart';
import 'package:mizan/presentation/customers/widgets/delete_contact_bottom_sheet.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class ContactProfileView extends StatelessWidget {
  final String contactId;

  const ContactProfileView({super.key, required this.contactId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactProfileCubit>(
      create: (_) => getIt<ContactProfileCubit>()..getProfile(contactId),
      child: _ContactProfileScreen(contactId: contactId),
    );
  }
}

class _ContactProfileScreen extends StatelessWidget {
  final String contactId;

  const _ContactProfileScreen({required this.contactId});

  void _onEdit(BuildContext context, ContactProfile profile) async {
    final contact = Contact(
      id: profile.contactId,
      name: profile.contactName,
      phoneNumber: profile.phoneNumber,
      notes: '',
      isVip: profile.isVip,
      contactEmail: profile.contactEmail,
      createdAt: '',
      updatedAt: '',
    );
    final result = await Navigator.pushNamed(
      context,
      Routes.contactFormRoute,
      arguments: contact,
    );
    if (result == true && context.mounted) {
      context.read<ContactProfileCubit>().getProfile(contactId);
    }
  }

  void _onDelete(BuildContext context, ContactProfile profile) {
    DeleteContactBottomSheet.show(
      context,
      contactName: profile.contactName,
      onConfirmDelete: () {
        context.read<ContactProfileCubit>().deleteContact();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactProfileCubit, ContactProfileState>(
      listenWhen: (prev, curr) => curr.isDeleted && !prev.isDeleted,
      listener: (context, state) {
        Navigator.of(context).pop(true);
      },
      builder: (context, state) {
        final profile = state.data;

        return Scaffold(
          backgroundColor: ColorManager.background,
          appBar: AppBar(
            backgroundColor: ColorManager.surface,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: Padding(
              padding: EdgeInsets.all(8.r),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorManager.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorManager.border, width: 1),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ColorManager.textPrimary,
                    size: 16.r,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            title: Column(
              children: [
                Text(
                  AppStrings.clientDetails,
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.financialProfile,
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s11,
                  ),
                ),
              ],
            ),
            actions: [
              if (profile != null) ...[
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: ColorManager.textPrimary,
                    size: 20.r,
                  ),
                  onPressed: () => _onEdit(context, profile),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: ColorManager.error,
                    size: 20.r,
                  ),
                  onPressed: () => _onDelete(context, profile),
                ),
              ],
              SizedBox(width: 6.w),
            ],
          ),
          body: state.flowState?.getScreenWidget(
                context,
                profile == null
                    ? const SizedBox.shrink()
                    : _buildProfileContent(context, profile),
                () => context.read<ContactProfileCubit>().getProfile(contactId),
              ) ??
              (profile == null
                  ? const SizedBox.shrink()
                  : _buildProfileContent(context, profile)),
        );
      },
    );
  }

  Widget _buildProfileContent(BuildContext context, ContactProfile profile) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner (Figma Node #3:1234)
          ContactProfileHeader(profile: profile),

          SizedBox(height: 16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Financial Summary Card (2 columns: عدد العمليات / إجمالي الحساب)
                ContactFinancialSummaryCard(
                  totalTransactions: profile.totalTransactions,
                  totalAmount: profile.totalAmount,
                ),

                SizedBox(height: 16.h),

                // Quick Action Buttons Row: Call & WhatsApp
                Row(
                  children: [
                    // WhatsApp Button
                    Expanded(
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: ColorManager.successContainer,
                          borderRadius: BorderRadius.circular(AppRadius.r14.r),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(AppRadius.r14.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.whatsapp,
                                  style: getBoldStyle(
                                    color: ColorManager.success,
                                    fontSize: FontSize.s13,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.chat_outlined,
                                  color: ColorManager.success,
                                  size: 18.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Call Button
                    Expanded(
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: ColorManager.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppRadius.r14.r),
                          border: Border.all(color: ColorManager.border, width: 1),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(AppRadius.r14.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.call,
                                  style: getBoldStyle(
                                    color: ColorManager.textPrimary,
                                    fontSize: FontSize.s13,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.phone_outlined,
                                  color: ColorManager.textPrimary,
                                  size: 18.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Notes Card (If available)
                if (profile.notes.trim().isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: ColorManager.surface,
                      borderRadius: BorderRadius.circular(AppRadius.r16.r),
                      border: Border.all(color: ColorManager.border, width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x061C1816),
                          offset: Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: ColorManager.lightPrimary,
                                borderRadius: BorderRadius.circular(AppRadius.r8.r),
                              ),
                              child: Icon(
                                Icons.sticky_note_2_outlined,
                                color: ColorManager.primary,
                                size: 16.r,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "ملاحظات",
                              style: getBoldStyle(
                                color: ColorManager.textPrimary,
                                fontSize: FontSize.s13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          profile.notes.trim(),
                          style: getRegularStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s13,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 24.h),

                // Recent Transactions Title
                Text(
                  AppStrings.recentTransactions,
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s16,
                  ),
                ),

                SizedBox(height: 12.h),

                // Transactions List
                if (profile.transactions.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: ColorManager.surface,
                      borderRadius: BorderRadius.circular(AppRadius.r16.r),
                      border: Border.all(color: ColorManager.border),
                    ),
                    child: Center(
                      child: Text(
                        AppStrings.noTransactionsTitle,
                        style: getMediumStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s13,
                        ),
                      ),
                    ),
                  )
                else
                  ...profile.transactions.map(
                    (tx) => ContactTransactionTile(
                      transaction: tx,
                      onTap: () {},
                    ),
                  ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
