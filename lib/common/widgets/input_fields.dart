import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_validators/flutter_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/generated/assets.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    this.validator = '',
    this.label = '',
    this.hint = '',
    this.suffix,
    this.prefix,
    this.disabled = false,
  });

  final TextEditingController controller;
  final String validator;
  final String label, hint;
  final Widget? suffix, prefix;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor,
            ),
          ),
        TextFormField(
          readOnly: disabled,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: suffix ?? const SizedBox.shrink(),
            prefixIcon: prefix ?? const SizedBox.shrink(),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.inputBorder),
              borderRadius: BorderRadius.circular(4.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.inputBorder),
              borderRadius: BorderRadius.circular(4.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.inputBorder),
              borderRadius: BorderRadius.circular(4.r),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.inputBorder),
              borderRadius: BorderRadius.circular(4.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.danger),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          validator: (val) {
            String value = val ?? '';
            List<String> validators = validator.split('|');
            if (validators.contains('required')) {
              if (value.isEmpty) return 'Please Enter $label';
            } else {
              return null;
            }
            if (validators.contains('number')) {
              if (!value.isInt) return 'Please Enter a Number';
            }
            if (validators.contains('email')) {
              if (!value.isEmail) return 'Please Enter a Valid Email';
            }
            if (validators.contains('date')) {
              if (DateTime.tryParse(value) == null) {
                return 'Please Enter a Valid Date';
              }
            }
            final minLengthRule = validators.firstWhere(
              (v) => v.startsWith('min:'),
              orElse: () => '',
            );
            if (minLengthRule.isNotEmpty) {
              final minLen =
                  int.tryParse(minLengthRule.split(':')[1]) ?? 0;
              if (value.length < minLen) {
                return '$label must be at least $minLen characters';
              }
            }
            final maxLengthRule = validators.firstWhere(
              (v) => v.startsWith('max:'),
              orElse: () => '',
            );
            if (maxLengthRule.isNotEmpty) {
              final maxLen =
                  int.tryParse(maxLengthRule.split(':')[1]) ?? 0;
              if (value.length > maxLen) {
                return '$label must be at most $maxLen characters';
              }
            }
            final regexRule = validators.firstWhere(
              (v) => v.startsWith('regex:'),
              orElse: () => '',
            );
            if (regexRule.isNotEmpty) {
              final pattern = regexRule.substring(6);
              if (!RegExp(pattern).hasMatch(value)) {
                return '$label format is invalid';
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}

// ── Dropdown ──────────────────────────────────────────────────────────────────
class InputDropDown extends StatelessWidget {
  const InputDropDown({
    super.key,
    this.label = '',
    required this.items,
    this.onChanged,
    this.value,
  });

  final String label;
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor,
            ),
          ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.inputBorder),
              borderRadius: BorderRadius.circular(4.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.inputBorder),
              borderRadius: BorderRadius.circular(4.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.inputBorder),
              borderRadius: BorderRadius.circular(4.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.danger),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          value: value,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ── File Picker ───────────────────────────────────────────────────────────────
class InputFilePicker extends StatelessWidget {
  const InputFilePicker(
      {super.key, this.label = '', required this.hint});

  final String label, hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor,
            ),
          ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 39.5.w,
                  vertical: 12.5.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  spacing: 8.h,
                  children: [
                    SvgPicture.asset(Assets.svgFormFile, width: 24.w),
                    Text(
                      hint,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
