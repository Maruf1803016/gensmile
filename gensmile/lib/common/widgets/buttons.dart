import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sized_context/sized_context.dart';
import 'package:gen_smile/common/utils/utils.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final String variant;
  final VoidCallback onPressed;
  final Color textColor;
  final bool outline;
  final String? suffixIcon, prefixIcon;

  const PrimaryButton({
    super.key,
    this.text,
    required this.onPressed,
    this.variant = 'primary',
    this.textColor = Colors.white,
    this.outline = false,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final variantColor = getVariant(variant);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s4, // 16
          vertical: AppSpacing.s3, // 12
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: variantColor),
          borderRadius: BorderRadius.circular(AppRadius.r2), // 8
        ),
        fixedSize: Size.fromWidth(context.widthPx),
        backgroundColor: outline ? Colors.transparent : variantColor,
      ),
      child: Row(
        spacing: AppSpacing.s2, // 8
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null)
            SvgPicture.asset(prefixIcon!, width: outline ? 18.w : 15.w),
          Text(
            text!,
            style: AppTextStyles.lgSemibold(
              color: outline ? variantColor : textColor,
            ),
          ),
          if (suffixIcon != null) SvgPicture.asset(suffixIcon!, width: 18.w),
        ],
      ),
    );
  }
}
