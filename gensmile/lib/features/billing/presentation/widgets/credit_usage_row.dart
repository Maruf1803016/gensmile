import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/billing/data/models/billing_model.dart';

class CreditUsageRow extends StatelessWidget {
  const CreditUsageRow({super.key, required this.transaction});

  final CreditTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.credits > 0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.inputBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          // ── Patient + Transaction ID ──
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.patient,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  transaction.id,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),

          // ── Type badge ──
          _TypeBadge(type: transaction.type),

          SizedBox(width: 8.w),

          // ── Credits ──
          Text(
            '${isPositive ? '+' : ''}${transaction.credits} Credits',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isPositive ? AppColors.success : AppColors.danger,
            ),
          ),

          SizedBox(width: 8.w),

          // ── Date + Balance ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.date,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: AppColors.gray,
                ),
              ),
              Text(
                '${transaction.balanceAfter} Balance',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final String type;

  Color get _color {
    if (type == 'Simulation') return AppColors.primary;
    if (type == 'Lab Link') return AppColors.info;
    if (type == 'Credits Purchased') return AppColors.success;
    return AppColors.gray;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        type,
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: _color,
        ),
      ),
    );
  }
}
