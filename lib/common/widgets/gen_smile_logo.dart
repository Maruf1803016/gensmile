// lib/common/widgets/gen_smile_logo.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/generated/assets.dart';

/// Brand logo — SVG icon + "GenSmile" wordmark
class GenSmileLogo extends StatelessWidget {
  const GenSmileLogo({super.key, this.iconSize = 32, this.textColor});

  final double iconSize;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          Assets.iconsBrandLogo,
          width: iconSize.w,
          height: iconSize.w,
          fit: BoxFit.contain,
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
