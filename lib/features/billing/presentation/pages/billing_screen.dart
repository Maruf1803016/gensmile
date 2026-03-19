import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/billing/states/billing_state.dart';
import 'package:gen_smile/features/billing/presentation/widgets/subscription_overview_tab.dart';
import 'package:gen_smile/features/billing/presentation/widgets/billing_history_tab.dart';
import 'package:gen_smile/features/billing/presentation/widgets/manage_subscription_tab.dart';

class BillingScreen extends ConsumerWidget {
  const BillingScreen({super.key, this.embedded = false});

  final bool embedded;

  static const _tabs = [
    _TabItem(icon: Icons.bolt_outlined, label: 'Subscription Overview'),
    _TabItem(icon: Icons.receipt_outlined, label: 'Billing History'),
    _TabItem(icon: Icons.credit_card_outlined, label: 'Manage Subscription'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(billingTabProvider);

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Back arrow top bar — standalone push only ──
        if (!embedded)
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back,
                    size: 24.w,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Subscription & Billing',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.notifications_outlined,
                  size: 22.w,
                  color: AppColors.gray,
                ),
              ],
            ),
          ),

        // ── Header block: title + subtitle + upgrade button ──
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                children: [
                  Icon(
                    Icons.credit_card_outlined,
                    size: 18.sp,
                    color: AppColors.textColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Subscription & Billing',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              // Subtitle
              Text(
                'Manage your plan, credits, and billing history',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.gray,
                ),
              ),
              SizedBox(height: 10.h),
              // Plan badge + Upgrade button row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.inputBorder),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'Professional Plan',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.trending_up, size: 13.sp),
                      label: Text(
                        'Upgrade Plan',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),

        // ── Tab Bar ──
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                _tabs.length,
                (i) => GestureDetector(
                  onTap: () => ref.read(billingTabProvider.notifier).state = i,
                  child: Container(
                    margin: EdgeInsets.only(right: 20.w),
                    padding: EdgeInsets.only(bottom: 10.h),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: activeTab == i
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _tabs[i].icon,
                          size: 14.w,
                          color: activeTab == i
                              ? AppColors.primary
                              : AppColors.gray,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          _tabs[i].label,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: activeTab == i
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: activeTab == i
                                ? AppColors.primary
                                : AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        Divider(height: 1, color: AppColors.inputBorder),

        // ── Tab Content ──
        Expanded(
          child: IndexedStack(
            index: activeTab,
            children: const [
              SubscriptionOverviewTab(),
              BillingHistoryTab(),
              ManageSubscriptionTab(),
            ],
          ),
        ),
      ],
    );

    if (!embedded) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: body),
      );
    }

    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(bottom: false, child: body),
    );
  }
}

class _TabItem {
  const _TabItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
