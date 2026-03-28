import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/generated/assets.dart';

class GenSmileLogo extends StatelessWidget {
  const GenSmileLogo({super.key, this.iconSize = 32, this.textColor});

  final double iconSize;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize.w,
          height: iconSize.w,
          decoration: BoxDecoration(
            color: AppColors.primary, // #0052CC blue
            borderRadius: BorderRadius.circular(iconSize.w * 0.22),
          ),
          padding: EdgeInsets.all(iconSize.w * 0.15),
          child: Image.asset(
            Assets.imagesDentalTooth,
            fit: BoxFit.contain,
            color: Colors.white, // tint transparent PNG white
          ),
        ),
        SizedBox(width: AppSpacing.s2),
        Text(
          'GenSmile',
          style: AppTextStyles.h6Bold(
            color: textColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
