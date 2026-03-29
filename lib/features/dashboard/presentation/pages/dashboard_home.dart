// lib/features/dashboard/presentation/pages/dashboard_home.dart
//
// FIX 4: Every section is now wrapped in a Card widget:
//   - Top bar with search / credits / bell / avatar
//   - Key Metrics cards
//   - Recent Case Activity card
//   - Buy More Credits card
//   - Next Appointment card
// Patient avatars use Assets.imagesUser real photo

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/generated/assets.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/notifications_screen.dart';

class DashboardHome extends ConsumerWidget {
  const DashboardHome({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _TopBar(ref: ref),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: _MobileLayout(),
          ),
        ),
      ],
    );
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            children: [
              // Search bar
              Expanded(
                child: Container(
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                      Icon(Icons.search, size: 16.sp, color: AppColors.gray),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          'Search...',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.gray,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // Credits badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, size: 12.sp, color: AppColors.primary),
                    SizedBox(width: 3.w),
                    Text(
                      '85/100',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Notification bell
              GestureDetector(
                onTap: () => ref
                    .read(navigatorState.notifier)
                    .push(const NotificationsScreen()),
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: 22.sp,
                      color: AppColors.gray,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 7.w,
                        height: 7.w,
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Avatar
              CircleAvatar(
                radius: 16.r,
                backgroundImage: AssetImage(Assets.imagesProfileAvatar),
                backgroundColor: AppColors.primary,
                onBackgroundImageError: (_, __) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Mobile Layout ─────────────────────────────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome text
        Text(
          'Hello, Dr. Smith',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        Gap(4.h),
        Text(
          "Here's what's happening at Alpha Dental Clinic today.",
          style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray),
        ),
        Gap(16.h),

        // ── FIX 4: Key Metrics wrapped in Card ────────────────────────────
        _SectionHeader(
          title: 'Key Metrics',
          actionLabel: 'Live Updates',
          onAction: () {},
        ),
        Gap(10.h),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.inputBorder),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _MetricCard(
                    title: 'Total Patients',
                    value: '1,284',
                    change: '+12%',
                    positive: true,
                  ),
                  SizedBox(width: 10.w),
                  _MetricCard(
                    title: 'Total Simulations',
                    value: '42',
                    change: '+5%',
                    positive: true,
                  ),
                  SizedBox(width: 10.w),
                  _MetricCard(
                    title: 'Pending Requests',
                    value: '15',
                    change: '-2%',
                    positive: false,
                  ),
                  SizedBox(width: 10.w),
                  _MetricCard(
                    title: 'Completed Cases',
                    value: '432',
                    change: '+18%',
                    positive: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap(20.h),

        // ── FIX 4: Recent Case Activity Card ──────────────────────────────
        _SectionHeader(
          title: 'Recent Case Activity',
          actionLabel: 'View All',
          onAction: () {},
        ),
        Gap(10.h),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.inputBorder),
          ),
          child: Column(
            children: [
              _CaseRow(
                name: 'John Williams',
                type: 'Invisalign',
                status: 'Completed',
                statusColor: AppColors.success,
                time: '2 hours ago',
              ),
              _CaseRow(
                name: 'Sarah Davis',
                type: 'Root Canal',
                status: 'In Progress',
                statusColor: AppColors.info,
                time: '5 hours ago',
              ),
              _CaseRow(
                name: 'Michael Tan',
                type: 'Checkup',
                status: 'Pending',
                statusColor: AppColors.gray,
                time: 'Yesterday',
              ),
            ],
          ),
        ),
        Gap(20.h),

        // ── FIX 4: Buy More Credits Card ──────────────────────────────────
        _SectionHeader(
          title: 'Buy More Credits',
          actionLabel: 'View All',
          onAction: () {},
        ),
        Gap(10.h),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.inputBorder),
          ),
          child: Column(
            children: [
              _CreditPackRow(
                credits: '250 Credits',
                perCredit: '\$0.40 per credit',
              ),
              _CreditPackRow(
                credits: '500 Credits',
                perCredit: '\$0.35 per credit',
              ),
              _CreditPackRow(
                credits: '1000 Credits',
                perCredit: '\$0.30 per credit',
              ),
            ],
          ),
        ),
        Gap(20.h),

        // ── FIX 4: Next Appointment Card ──────────────────────────────────
        _SectionHeader(
          title: 'Next Appointment',
          actionLabel: 'View All Appointments ↗',
          onAction: () {},
        ),
        Gap(10.h),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.inputBorder),
          ),
          child: Column(
            children: [
              _AppointmentRow(
                name: 'John Williams',
                treatment: 'Teeth Whitening',
                date: 'Oct 24, 10:30 AM',
              ),
              _AppointmentRow(
                name: 'Sarah Davis',
                treatment: 'Root Canal',
                date: 'Oct 25, 2:00 PM',
              ),
              _AppointmentRow(
                name: 'Michael Tan',
                treatment: 'Checkup',
                date: 'Oct 26, 9:00 AM',
              ),
            ],
          ),
        ),
        Gap(20.h),
      ],
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });
  final String title, actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),
      ),
      GestureDetector(
        onTap: onAction,
        child: Text(
          actionLabel,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

// ── Metric Card ───────────────────────────────────────────────────────────────
class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.change,
    required this.positive,
  });
  final String title, value, change;
  final bool positive;

  @override
  Widget build(BuildContext context) => Container(
    width: 130.w,
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: AppColors.inputBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
        ),
        Gap(6.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        Gap(4.h),
        Row(
          children: [
            Icon(
              positive ? Icons.trending_up : Icons.trending_down,
              size: 12.sp,
              color: positive ? AppColors.success : AppColors.danger,
            ),
            SizedBox(width: 3.w),
            Text(
              change,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: positive ? AppColors.success : AppColors.danger,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// ── Case Row ──────────────────────────────────────────────────────────────────
class _CaseRow extends StatelessWidget {
  const _CaseRow({
    required this.name,
    required this.type,
    required this.status,
    required this.statusColor,
    required this.time,
  });
  final String name, type, status, time;
  final Color statusColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
    ),
    child: Row(
      children: [
        // Patient image avatar
        CircleAvatar(
          radius: 16.r,
          backgroundImage: AssetImage(Assets.imagesAvatarFemale),
          backgroundColor: AppColors.primary.withOpacity(0.1),
          onBackgroundImageError: (_, __) {},
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                type,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: AppColors.gray,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            status,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Icon(Icons.visibility_outlined, size: 16.sp, color: AppColors.gray),
      ],
    ),
  );
}

// ── Credit Pack Row ───────────────────────────────────────────────────────────
class _CreditPackRow extends StatelessWidget {
  const _CreditPackRow({required this.credits, required this.perCredit});
  final String credits, perCredit;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                credits,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                perCredit,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: AppColors.gray,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Purchase',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

// ── Appointment Row ───────────────────────────────────────────────────────────
class _AppointmentRow extends StatelessWidget {
  const _AppointmentRow({
    required this.name,
    required this.treatment,
    required this.date,
  });
  final String name, treatment, date;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 16.r,
          backgroundImage: AssetImage(Assets.imagesDoctorFemale),
          backgroundColor: AppColors.primary.withOpacity(0.1),
          onBackgroundImageError: (_, __) {},
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                'Treatment: $treatment',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: AppColors.gray,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              date,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
        SizedBox(width: 8.w),
        TextButton(
          onPressed: () {},
          child: Text(
            'View',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
