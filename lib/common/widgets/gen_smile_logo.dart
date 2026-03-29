// lib/common/widgets/gen_smile_logo.dart
// FIX: SVG Brand logo ONLY — no Text beside it.
// The SVG file already contains the "GenSmile" wordmark inside it,
// so adding Text('GenSmile') caused the double-name bug in the sidebar.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_smile/generated/assets.dart';

class GenSmileLogo extends StatelessWidget {
  const GenSmileLogo({super.key, this.iconSize = 32});
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.iconsBrandLogo,
      width: iconSize.w,
      height: iconSize.w,
      fit: BoxFit.contain,
    );
  }
}
