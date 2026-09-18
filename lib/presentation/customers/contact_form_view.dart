// ─────────────────────────────────────────────────────────────
// ContactFormView — Mizan design system & Figma Nodes #3:1402 & #2175:14 compliant
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/customers/contact_form_cubit/contact_form_cubit.dart';
import 'package:mizan/presentation/customers/contact_form_cubit/contact_form_state.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class ContactFormView extends StatelessWidget {
  final Contact? contact;

  const ContactFormView({super.key, this.contact});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactFormCubit>(
      create: (_) => getIt<ContactFormCubit>()..init(contact),
      child: _ContactFormScreen(contact: contact),
    );
  }
}

class _ContactFormScreen extends StatefulWidget {
  final Contact? contact;

  const _ContactFormScreen({this.contact});

  @override
  State<_ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<_ContactFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;
  late final TextEditingController _emailController;
  bool _isVip = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _phoneController = TextEditingController(
      text: widget.contact?.phoneNumber.replaceAll('+20', '').replaceAll('+966', '').trim() ?? '',
    );
    _notesController = TextEditingController(text: widget.contact?.notes ?? '');
    _emailController = TextEditingController(text: widget.contact?.contactEmail ?? '');
    _isVip = widget.contact?.isVip ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<ContactFormCubit>().submit(
          name: _nameController.text,
          phoneNumber: _phoneController.text,
          notes: _notesController.text,
          isVip: _isVip,
          contactEmail: _emailController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.contact != null;

    return BlocConsumer<ContactFormCubit, ContactFormState>(
      listenWhen: (prev, curr) => curr.isActionSuccess && !prev.isActionSuccess,
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context, rootNavigator: true).popUntil((route) => route is! PopupRoute);
          Navigator.of(context).pop(true);
        });
      },
      builder: (context, state) {
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
                  isEdit ? AppStrings.editContact : AppStrings.addNewContactTitle,
                  style: getBoldStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  isEdit ? AppStrings.editContactSubtitle : AppStrings.addContactSubtitle,
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s11,
                  ),
                ),
              ],
            ),
          ),
          body: state.flowState?.getScreenWidget(
                context,
                _buildFormContent(context, isEdit),
                () {},
              ) ??
              _buildFormContent(context, isEdit),
        );
      },
    );
  }

  Widget _buildFormContent(BuildContext context, bool isEdit) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Field 1: Name
            _buildFieldLabel(AppStrings.clientOrBusinessName),
            SizedBox(height: 8.h),
            _buildTextInputField(
              controller: _nameController,
              hint: "مثال: محمود حسن إبراهيم",
              keyboardType: TextInputType.name,
            ),

            SizedBox(height: 18.h),

            // Field 2: Phone with Country Code Badge
            _buildFieldLabel(AppStrings.personalPhoneNumber),
            SizedBox(height: 8.h),
            _buildPhoneInputField(),

            SizedBox(height: 18.h),

            // Field 3: Email (Required in edit mode or optional)
            if (isEdit) ...[
              _buildFieldLabel(AppStrings.optionalEmail),
              SizedBox(height: 8.h),
              _buildTextInputField(
                controller: _emailController,
                hint: "example@domain.com",
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 18.h),
            ],

            // Field 4: Notes (multiline)
            _buildFieldLabel(AppStrings.optionalNotes),
            SizedBox(height: 8.h),
            _buildMultilineNotesField(),

            SizedBox(height: 20.h),

            // Field 5: VIP Toggle Card (Figma Node #2175:14)
            if (isEdit) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: ColorManager.lightSecondary,
                  borderRadius: BorderRadius.circular(AppRadius.r16.r),
                  border: Border.all(
                    color: ColorManager.secondary.withAlpha(160),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Switch.adaptive(
                      value: _isVip,
                      activeThumbColor: ColorManager.secondary,
                      activeTrackColor: ColorManager.secondary.withAlpha(120),
                      onChanged: (val) => setState(() => _isVip = val),
                    ),
                    Text(
                      AppStrings.markAsVipToggle,
                      style: getBoldStyle(
                        color: ColorManager.darkSecondary,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],

            SizedBox(height: 10.h),

            // Submit Button with Primary Gradient
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                gradient: ColorManager.primaryGradient,
                borderRadius: BorderRadius.circular(AppRadius.r14.r),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33C57B57),
                    offset: Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _submit,
                  borderRadius: BorderRadius.circular(AppRadius.r14.r),
                  child: Center(
                    child: Text(
                      isEdit ? AppStrings.saveChanges : AppStrings.saveContactToDirectory,
                      style: getBoldStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        label,
        style: getBoldStyle(
          color: ColorManager.textPrimary,
          fontSize: FontSize.s14,
        ),
      ),
    );
  }

  Widget _buildTextInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.border, width: 1.2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        style: getMediumStyle(
          color: ColorManager.textPrimary,
          fontSize: FontSize.s14,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorManager.surface,
          hintText: hint,
          hintStyle: getRegularStyle(
            color: ColorManager.textTertiary,
            fontSize: FontSize.s14,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        ),
      ),
    );
  }

  Widget _buildPhoneInputField() {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.border, width: 1.2),
      ),
      child: Row(
        children: [
          // Country Code Prefix
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: ColorManager.border, width: 1.2),
              ),
            ),
            child: Text(
              "+966",
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s14,
              ),
            ),
          ),

          // Phone Number Input
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              style: getMediumStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s14,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorManager.surface,
                hintText: "50 555 4321",
                hintStyle: getRegularStyle(
                  color: ColorManager.textTertiary,
                  fontSize: FontSize.s14,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultilineNotesField() {
    return Container(
      height: 116.h,
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.border, width: 1.2),
      ),
      child: TextField(
        controller: _notesController,
        maxLines: 4,
        textAlign: TextAlign.right,
        style: getRegularStyle(
          color: ColorManager.textPrimary,
          fontSize: FontSize.s14,
          height: 1.5,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorManager.surface,
          hintText: AppStrings.notesHint,
          hintStyle: getRegularStyle(
            color: ColorManager.textTertiary,
            fontSize: FontSize.s14,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }
}
