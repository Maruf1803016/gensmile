import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/generated/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Brand logo widget.
///
/// [showText] — set to false when the logo is placed next to an AppBar title
/// or sidebar label that already shows "GenSmile", to prevent the double
/// "GenSmile GenSmile" bug seen in screenshot 1.
class GenSmileLogo extends StatelessWidget {
  const GenSmileLogo({
    super.key,
    this.iconSize = 32,
    this.textColor,
    this.showText = true, // FIX 1: callers in AppBar/sidebar set this false
  });

  final double iconSize;
  final Color? textColor;
  final bool showText;

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
        if (showText) ...[
          SizedBox(width: AppSpacing.s2),
          Text(
            'GenSmile',
            style: AppTextStyles.h6Bold(
              color: textColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ],
    );
  }
}
