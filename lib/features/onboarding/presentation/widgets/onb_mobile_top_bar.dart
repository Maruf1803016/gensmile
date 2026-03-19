import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/states/navigator_state.dart';

class OnbMobileTopBar extends ConsumerWidget {
  const OnbMobileTopBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // ── Back Arrow ──
          GestureDetector(
            onTap: () => ref.read(navigatorState.notifier).pop(),
            child: Icon(
              Icons.chevron_left,
              size: 28.w,
              color: AppColors.textColor,
            ),
          ),

          SizedBox(width: 12.w),

          // ── Progress Bar ──
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: currentStep / totalSteps,
                minHeight: 4.h,
                backgroundColor: AppColors.inputBorder,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // ── Step count e.g. "2/5" ──
          Text(
            '$currentStep/$totalSteps',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}
