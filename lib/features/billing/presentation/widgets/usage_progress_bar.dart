import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/features/billing/data/models/subscription_model.dart';

class UsageProgressBar extends StatelessWidget {
  const UsageProgressBar({super.key, required this.stat});

  final UsageStat stat;

  IconData get _icon {
    if (stat.label == 'Simulation Limit')      return Icons.bolt;
    if (stat.label == 'Staff Seats')           return Icons.people_outline;
    return Icons.folder_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final pctText =
        '${_fmt(stat.used)} / ${_fmt(stat.total)} used (${(stat.percentage * 100).toInt()}%)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label row — wraps instead of overflowing ──
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + label — shrinks if needed but never clips
            Expanded(
              child: Row(
                children: [
                  Icon(_icon, size: 14.w, color: AppColors.gray),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      stat.label,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: AppColors.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // Value — fixed on the right, never pushed off screen
            Text(
              pctText,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: AppColors.gray,
              ),
            ),
          ],
        ),

        SizedBox(height: 6.h),

        // ── Progress bar ──
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: stat.percentage,
            minHeight: 6.h,
            backgroundColor: const Color(0xFFE8E8E8),
            valueColor: AlwaysStoppedAnimation<Color>(
              stat.percentage > 0.8 ? AppColors.danger : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  /// Formats numbers with commas: 1284 → "1,284"
  String _fmt(int n) =>
      n.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}
