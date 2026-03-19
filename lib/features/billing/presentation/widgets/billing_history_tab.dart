import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/features/billing/data/models/billing_model.dart';
import 'package:onboarding/features/billing/presentation/widgets/billing_history_row.dart';

class BillingHistoryTab extends StatelessWidget {
  const BillingHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header + Export All ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Billing History',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              // ── Export All button ──
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: export all invoices
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                icon: Icon(Icons.download_outlined,
                    size: 16.w, color: Colors.white),
                label: Text(
                  'Export All',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          Gap(16.h),

          // ── Invoice list ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.inputBorder),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: dummyBillingInvoices
                  .map((invoice) => BillingHistoryRow(invoice: invoice))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
