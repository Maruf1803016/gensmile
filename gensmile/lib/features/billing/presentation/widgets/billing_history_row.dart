import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/billing/data/models/billing_model.dart';

class BillingHistoryRow extends StatelessWidget {
  const BillingHistoryRow({super.key, required this.invoice});

  final BillingInvoice invoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Invoice ID + Paid badge + Description + Date ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      invoice.invoiceId,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // ── Paid badge ──
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 10.w,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            invoice.status,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: AppColors.success,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  invoice.description,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  invoice.date,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),

          // ── Amount + Download ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${invoice.amount.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 6.h),
              ElevatedButton(
                onPressed: () {
                  // TODO: download invoice
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Download',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
