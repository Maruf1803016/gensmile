// lib/common/widgets/screen_card.dart
// Shared white card used by all dashboard section pages.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';

class ScreenCard extends StatelessWidget {
  const ScreenCard({
    super.key,
    required this.child,
    this.title,
    this.titleIcon,
    this.accentColor,
    this.actionLabel,
    this.onAction,
    this.padding,
  });

  final Widget child;
  final String? title;
  final IconData? titleIcon;
  final Color? accentColor;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppColors.primary;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
              child: Row(
                children: [
                  if (titleIcon != null) ...[
                    Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(titleIcon, size: 15.sp, color: accent),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Expanded(
                    child: Text(
                      title!,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  if (actionLabel != null && onAction != null)
                    GestureDetector(
                      onTap: onAction,
                      child: Text(
                        actionLabel!,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Divider(height: 14.h, color: AppColors.inputBorder),
          ],
          Padding(padding: padding ?? EdgeInsets.all(16.w), child: child),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.change,
    this.positive,
    this.accentColor,
  });

  final IconData icon;
  final String label, value;
  final String? change;
  final bool? positive;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppColors.primary;
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 18.sp, color: accent),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: AppColors.gray,
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  if (change != null && positive != null)
                    Row(
                      children: [
                        Icon(
                          positive! ? Icons.trending_up : Icons.trending_down,
                          size: 11.sp,
                          color: positive!
                              ? AppColors.success
                              : AppColors.danger,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          change!,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: positive!
                                ? AppColors.success
                                : AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
