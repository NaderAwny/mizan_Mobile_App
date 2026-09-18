import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

class ContactsSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final String? initialValue;
  final TextEditingController? controller;

  const ContactsSearchBar({
    super.key,
    required this.onChanged,
    this.onClear,
    this.initialValue,
    this.controller,
  });

  @override
  State<ContactsSearchBar> createState() => _ContactsSearchBarState();
}

class _ContactsSearchBarState extends State<ContactsSearchBar> {
  TextEditingController? _internalController;
  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController!;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController =
          TextEditingController(text: widget.initialValue ?? '');
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _internalController?.dispose();
    super.dispose();
  }

  void _onTextChange(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onChanged(value.trim());
    });
    setState(() {});
  }

  void _clear() {
    _effectiveController.clear();
    _debounceTimer?.cancel();
    widget.onChanged('');
    widget.onClear?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
        border: Border.all(color: ColorManager.border, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x081C1816),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: _effectiveController,
        onChanged: _onTextChange,
        style: getMediumStyle(
          color: ColorManager.textPrimary,
          fontSize: FontSize.s14,
        ),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: ColorManager.surface,
          hintText: AppStrings.searchContactsHint,
          hintStyle: getRegularStyle(
            color: ColorManager.textTertiary,
            fontSize: FontSize.s14,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: SvgPicture.asset(
              IconAssets.search,
              width: 20.r,
              height: 20.r,
              colorFilter: const ColorFilter.mode(
                ColorManager.textTertiary,
                BlendMode.srcIn,
              ),
            ),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 44.w),
          suffixIcon: _effectiveController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: ColorManager.textTertiary,
                    size: 18.r,
                  ),
                  onPressed: _clear,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }
}
