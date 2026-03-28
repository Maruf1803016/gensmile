import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gen_smile/common/utils/utils.dart';

class BadgeVariant extends StatelessWidget {
  const BadgeVariant({
    super.key,
    required this.variant,
    required this.text,
    this.borderRadius = 20,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String variant, text;
  final double borderRadius;
  final String? prefixIcon, suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.w),
        color: getVariant(variant).withOpacity(.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8.w,
        children: [
          if (prefixIcon != null) SvgPicture.asset(prefixIcon!, width: 16.w),
          Text(
            text,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: getVariant(variant),
            ),
          ),
          if (suffixIcon != null) SvgPicture.asset(suffixIcon!, width: 16.w),
        ],
      ),
    );
  }
}
