import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';

// ── Expandable section ────────────────────────────────────────────────────────

class SettingsSection extends StatefulWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
    this.forceExpanded = false,
  });

  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final bool forceExpanded;

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded || widget.forceExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    if (isWide || widget.forceExpanded) {
      return Container(
        margin: EdgeInsets.only(bottom: AppSpacing.s4), // 16
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.r2), // 8
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.s5, // 20
                vertical: AppSpacing.s4, // 16
              ),
              child: Text(
                widget.title,
                style: AppTextStyles.lgSemibold(color: AppColors.textPrimary),
              ),
            ),
            Divider(height: 1, color: AppColors.borderDefault),
            Padding(
              padding: EdgeInsets.all(AppSpacing.s4), // 16
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
          ],
        ),
      );
    }

    // Mobile accordion
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s4), // 16
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppTextStyles.mdSemibold(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20.sp,
                  color: AppColors.gray400,
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[
          ...widget.children,
          Gap(AppSpacing.s2), // 8
        ],
        Divider(height: 1, color: AppColors.borderDefault),
      ],
    );
  }
}

// ── Labelled field ────────────────────────────────────────────────────────────

class SettingsField extends StatelessWidget {
  const SettingsField({
    super.key,
    required this.label,
    required this.value,
    this.obscureText = false,
    this.suffix,
  });

  final String label;
  final String value;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.smRegular(color: AppColors.textSubTitle),
        ),
        Gap(AppSpacing.s1), // 4
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s3, // 12
            vertical: AppSpacing.s3, // 12
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.borderDefault)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  obscureText ? '••••••••' : value,
                  style: AppTextStyles.mdRegular(color: AppColors.textPrimary),
                ),
              ),
              if (suffix != null) suffix!,
            ],
          ),
        ),
        Gap(AppSpacing.s4), // 16
      ],
    );
  }
}

// ── Two-column row ────────────────────────────────────────────────────────────

class SettingsFieldRow extends StatelessWidget {
  const SettingsFieldRow({super.key, required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          SizedBox(width: AppSpacing.s5), // 20
          Expanded(child: right),
        ],
      );
    }
    return Column(children: [left, right]);
  }
}

// ── Toggle row ────────────────────────────────────────────────────────────────

class SettingsToggleRow extends StatefulWidget {
  const SettingsToggleRow({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    this.onChanged,
  });

  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<SettingsToggleRow> createState() => _SettingsToggleRowState();
}

class _SettingsToggleRowState extends State<SettingsToggleRow> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s2), // 8
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: AppTextStyles.mdMedium(color: AppColors.textPrimary),
                ),
                if (widget.subtitle != null) ...[
                  Gap(AppSpacing.s1), // 4
                  Text(
                    widget.subtitle!,
                    style: AppTextStyles.smRegular(
                      color: AppColors.textSubTitle,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: _value,
            onChanged: (v) {
              setState(() => _value = v);
              widget.onChanged?.call(v);
            },
            activeColor: AppColors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.borderDefault,
          ),
        ],
      ),
    );
  }
}

// ── Radio group ───────────────────────────────────────────────────────────────

class SettingsRadioGroup extends StatefulWidget {
  const SettingsRadioGroup({
    super.key,
    required this.options,
    required this.selected,
    this.onChanged,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String>? onChanged;

  @override
  State<SettingsRadioGroup> createState() => _SettingsRadioGroupState();
}

class _SettingsRadioGroupState extends State<SettingsRadioGroup> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((opt) {
        final isSelected = opt == _selected;
        return GestureDetector(
          onTap: () {
            setState(() => _selected = opt);
            widget.onChanged?.call(opt);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: AppSpacing.s2), // 8
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s4, // 16
              vertical: AppSpacing.s3, // 12
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.borderDefault,
                width: isSelected ? 1.5 : 0.5,
              ),
              borderRadius: BorderRadius.circular(AppRadius.r2), // 8
              color: isSelected
                  ? AppColors.primary.withOpacity(0.04)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    opt,
                    style: AppTextStyles.mdMedium(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSubTitle,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 12.sp,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Sub label ─────────────────────────────────────────────────────────────────

class SettingsSubLabel extends StatelessWidget {
  const SettingsSubLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.s2, top: AppSpacing.s1),
      child: Text(
        text,
        style: AppTextStyles.mdSemibold(color: AppColors.textPrimary),
      ),
    );
  }
}

// ── Upload button ─────────────────────────────────────────────────────────────

class SettingsUploadButton extends StatelessWidget {
  const SettingsUploadButton({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.s3), // 12
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderDefault),
          borderRadius: BorderRadius.circular(AppRadius.r2), // 8
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upload_outlined,
              size: 16.sp,
              color: AppColors.textSubTitle,
            ),
            SizedBox(width: AppSpacing.s2), // 8
            Text(
              label,
              style: AppTextStyles.mdRegular(color: AppColors.textSubTitle),
            ),
          ],
        ),
      ),
    );
  }
}
