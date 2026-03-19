import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sized_context/sized_context.dart';
import 'package:onboarding/common/utils/utils.dart';

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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: getVariant(variant)),
          borderRadius: BorderRadius.circular(8),
        ),
        fixedSize: Size.fromWidth(context.widthPx),
        backgroundColor: outline ? Colors.transparent : getVariant(variant),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      child: Row(
        spacing: 8.w,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null)
            SvgPicture.asset(prefixIcon!, width: outline ? 18.w : 15.w),
          Text(
            text!,
            style: GoogleFonts.inter(
              color: outline ? getVariant(variant) : textColor,
            ),
          ),
          if (suffixIcon != null)
            SvgPicture.asset(suffixIcon!, width: 18.w),
        ],
      ),
    );
  }
}
