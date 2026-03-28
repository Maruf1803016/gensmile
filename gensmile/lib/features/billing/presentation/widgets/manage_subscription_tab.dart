import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/common/widgets/buttons.dart';
import 'package:gen_smile/features/billing/data/models/subscription_model.dart';
import 'package:gen_smile/features/billing/states/billing_state.dart';
import 'package:gen_smile/features/billing/presentation/widgets/add_card_sheet.dart';

class ManageSubscriptionTab extends ConsumerWidget {
  const ManageSubscriptionTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedPlan = ref.watch(expandedPlanProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Plan cards (expandable on mobile) ──
          ...availableSubscriptionPlans.map((plan) {
            final isExpanded = expandedPlan == plan.id;
            return GestureDetector(
              onTap: () {
                ref.read(expandedPlanProvider.notifier).state = isExpanded
                    ? null
                    : plan.id;
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: plan.isActive
                        ? AppColors.primary
                        : AppColors.inputBorder,
                    width: plan.isActive ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    // ── Plan name + price + arrow ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          plan.name,
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              plan.isCustom
                                  ? 'Custom'
                                  : '\$${plan.price.toInt()}/mo',
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_right,
                              size: 20.w,
                              color: AppColors.gray,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // ── Expanded content ──
                    if (isExpanded) ...[
                      Gap(16.h),
                      Text(
                        "What's included:",
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: AppColors.gray,
                        ),
                      ),
                      Gap(8.h),
                      _FeatureItem(icon: Icons.bolt, text: plan.simulations),
                      _FeatureItem(
                        icon: Icons.people_outline,
                        text: plan.staffSeats,
                      ),
                      _FeatureItem(
                        icon: Icons.folder_outlined,
                        text: plan.patients,
                      ),
                      Gap(16.h),
                      PrimaryButton(
                        text: plan.isActive ? 'Activated' : 'Upgrade',
                        variant: plan.isActive ? 'secondary' : 'primary',
                        onPressed: plan.isActive
                            ? () {}
                            : () {
                                // TODO: upgrade plan
                              },
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),

          Gap(8.h),

          // ── Buy More Credits ──
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
                Text(
                  'Buy More Credits',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                Gap(4.h),
                Text(
                  'Credits are used for AI simulations and lab link generation.',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                ),
                Gap(16.h),

                // ── Credit packs ──
                ...availableCreditPacks.map(
                  (pack) => Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.inputBorder),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${pack.credits} Credits',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                            Text(
                              '\$${pack.pricePerCredit.toStringAsFixed(2)} per credit',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '\$${pack.totalPrice.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Gap(8.h),

                // ── Buy Credits button ──
                PrimaryButton(
                  text: '+ Buy Credits',
                  variant: 'primary',
                  onPressed: () {
                    // TODO: buy credits
                  },
                ),
              ],
            ),
          ),

          Gap(16.h),

          // ── Payment Method ──
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
                Text(
                  'Payment Method',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                Gap(4.h),
                Text(
                  'Manage your billing payment method and invoice preferences.',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                ),

                Gap(16.h),

                // ── Visa card ──
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.inputBorder),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      // ── Visa badge ──
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F71),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'VISA',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Visa ending in •••• 4242',
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                            ),
                            Text(
                              'Expires 08/28',
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.inputBorder),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'Default',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(12.h),

                // ── Add Payment Method ──
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: const AddCardSheet(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.inputBorder),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.credit_card_outlined,
                          size: 18.w,
                          color: AppColors.gray,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Add Payment Method',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Auto Email Invoice ──
                Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_outlined,
                        size: 18.w,
                        color: AppColors.gray,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Auto Email Invoice',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Gap(24.h),

          // ── Upgrade Plan button ──
          PrimaryButton(
            text: '↗ Upgrade Plan',
            variant: 'primary',
            onPressed: () {
              // TODO: upgrade plan
            },
          ),

          Gap(12.h),

          // ── Professional Plan link ──
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Professional Plan',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          Gap(16.h),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(icon, size: 16.w, color: AppColors.primary),
          SizedBox(width: 8.w),
          Text(
            text,
            style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray),
          ),
        ],
      ),
    );
  }
}
