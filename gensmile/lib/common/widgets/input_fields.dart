import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_validators/flutter_validators.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/generated/assets.dart';

// ── Shared border helper ──────────────────────────────────────────────────────

OutlineInputBorder _border(Color color) => OutlineInputBorder(
  borderSide: BorderSide(color: color),
  borderRadius: BorderRadius.circular(AppRadius.r2), // 8px
);

// ── Input Field ───────────────────────────────────────────────────────────────

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
      spacing: AppSpacing.s2, // 8
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: AppTextStyles.mdMedium(color: AppColors.textPrimary),
          ),
        TextFormField(
          readOnly: disabled,
          controller: controller,
          style: AppTextStyles.mdRegular(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.mdRegular(color: AppColors.textDisable),
            filled: true,
            fillColor: disabled ? AppColors.surfaceMuted : AppColors.white,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s3, // 12
              vertical: AppSpacing.s3, // 12
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: suffix != null
                ? Padding(
                    padding: EdgeInsets.only(right: AppSpacing.s3),
                    child: suffix,
                  )
                : const SizedBox.shrink(),
            prefixIcon: prefix != null
                ? Padding(
                    padding: EdgeInsets.only(left: AppSpacing.s3),
                    child: prefix,
                  )
                : const SizedBox.shrink(),
            border: _border(AppColors.borderDefault),
            focusedBorder: _border(AppColors.primary),
            enabledBorder: _border(AppColors.borderDefault),
            disabledBorder: _border(AppColors.borderDefault),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error),
            errorStyle: AppTextStyles.smRegular(color: AppColors.error),
          ),
          validator: (val) {
            String value = val ?? '';
            List<String> validators = validator.split('|');

            if (validators.contains('required')) {
              if (value.isEmpty) return 'Please enter $label';
            } else {
              return null;
            }

            if (validators.contains('number')) {
              if (!value.isInt) return 'Please enter a number';
            }

            if (validators.contains('email')) {
              if (!value.isEmail) return 'Please enter a valid email';
            }

            if (validators.contains('date')) {
              if (DateTime.tryParse(value) == null) {
                return 'Please enter a valid date';
              }
            }

            final minLengthRule = validators.firstWhere(
              (v) => v.startsWith('min:'),
              orElse: () => '',
            );
            if (minLengthRule.isNotEmpty) {
              final minLen = int.tryParse(minLengthRule.split(':')[1]) ?? 0;
              if (value.length < minLen) {
                return '$label must be at least $minLen characters';
              }
            }

            final maxLengthRule = validators.firstWhere(
              (v) => v.startsWith('max:'),
              orElse: () => '',
            );
            if (maxLengthRule.isNotEmpty) {
              final maxLen = int.tryParse(maxLengthRule.split(':')[1]) ?? 0;
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
      spacing: AppSpacing.s2, // 8
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: AppTextStyles.mdMedium(color: AppColors.textPrimary),
          ),
        DropdownButtonFormField<String>(
          style: AppTextStyles.mdRegular(color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.s3,
            ),
            border: _border(AppColors.borderDefault),
            focusedBorder: _border(AppColors.primary),
            enabledBorder: _border(AppColors.borderDefault),
            errorBorder: _border(AppColors.error),
          ),
          value: value,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: AppTextStyles.mdRegular(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ── File Picker ───────────────────────────────────────────────────────────────

class InputFilePicker extends StatelessWidget {
  const InputFilePicker({super.key, this.label = '', required this.hint});

  final String label, hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.s2, // 8
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: AppTextStyles.mdMedium(color: AppColors.textPrimary),
          ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s10, // 40
            vertical: AppSpacing.s3, // 12
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r2), // 8
            border: Border.all(color: AppColors.borderDefault),
            color: AppColors.white,
          ),
          child: Column(
            spacing: AppSpacing.s2, // 8
            children: [
              // SvgPicture.asset(Assets.svgFormFile, width: 24.w),
              Text(
                hint,
                textAlign: TextAlign.center,
                style: AppTextStyles.smRegular(color: AppColors.textSubTitle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
