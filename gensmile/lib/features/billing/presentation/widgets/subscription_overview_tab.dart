import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/billing/data/models/billing_model.dart';
import 'package:gen_smile/features/billing/data/models/subscription_model.dart';
import 'package:gen_smile/features/billing/presentation/widgets/usage_progress_bar.dart';
import 'package:gen_smile/features/billing/presentation/widgets/credit_usage_row.dart';

class SubscriptionOverviewTab extends StatelessWidget {
  const SubscriptionOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Plan card ──
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Plan name + next billing ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Professional Plan',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // ── Active badge ──
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'Active',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '\$199',
                                style: GoogleFonts.inter(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                              TextSpan(
                                text: '/month',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Next Billing',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.gray,
                          ),
                        ),
                        Text(
                          'April 9, 2026',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          'Monthly',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Gap(20.h),

                // ── Usage bars ──
                ...dummyUsageStats.map(
                  (stat) => Padding(
                    padding: EdgeInsets.only(bottom: 14.h),
                    child: UsageProgressBar(stat: stat),
                  ),
                ),
              ],
            ),
          ),

          Gap(16.h),

          // ── Stat cards ──
          Row(
            children: [
              _StatCard(
                icon: Icons.bolt,
                label: 'Credits Remaining',
                value: '168',
              ),
              SizedBox(width: 12.w),
              _StatCard(
                icon: Icons.credit_card_outlined,
                label: 'Monthly Spend',
                value: '\$223.99',
              ),
              SizedBox(width: 12.w),
              _StatCard(
                icon: Icons.access_time_outlined,
                label: 'Days Until Renewal',
                value: '31',
              ),
            ],
          ),

          Gap(24.h),

          // ── Credits Usage section ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Credits Usage',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          Gap(8.h),

          // ── Transaction rows ──
          ...dummyCreditTransactions.map((t) => CreditUsageRow(transaction: t)),
        ],
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18.w, color: AppColors.primary),
            Gap(8.h),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
            ),
            Gap(4.h),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
