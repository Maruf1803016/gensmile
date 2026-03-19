import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/core/states/navigator_state.dart';
import 'package:onboarding/features/dashboard/presentation/pages/notifications_screen.dart';

class DashboardHome extends ConsumerWidget {
  const DashboardHome({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Column(
      children: [
        // ── Top Bar ──
        _TopBar(isWide: isWide),

        // ── Scrollable body ──
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: isWide
                ? _DesktopLayout()
                : _MobileLayout(),
          ),
        ),
      ],
    );
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────────
class _TopBar extends ConsumerWidget {
  const _TopBar({required this.isWide});
  final bool isWide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            children: [
              // Search bar — takes all remaining space
              Expanded(
                child: Container(
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Row(children: [
                    SizedBox(width: 12.w),
                    Icon(Icons.search, size: 16.sp, color: AppColors.gray),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        isWide ? 'Search patients, cases, or simulations...' : 'Search...',
                        style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
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
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.bolt, size: 12.sp, color: AppColors.primary),
                  SizedBox(width: 3.w),
                  Text(
                    isWide ? '85/100 Credits Used' : '85/100',
                    style: GoogleFonts.inter(fontSize: 10.sp, color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
                ]),
              ),
              SizedBox(width: 8.w),

              // Bell with unread dot
              GestureDetector(
                onTap: () => ref.read(navigatorState.notifier).push(const NotificationsScreen()),
                child: SizedBox(
                  width: 24.w, height: 24.w,
                  child: Stack(children: [
                    Icon(Icons.notifications_outlined, size: 22.sp, color: AppColors.gray),
                    Positioned(
                      right: 0, top: 0,
                      child: Container(
                        width: 7.w, height: 7.w,
                        decoration: BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(width: 8.w),

              // User name + role — desktop only
              if (isWide) ...[
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('Dr. Smith', style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
                  Text('Chief Surgeon', style: GoogleFonts.inter(fontSize: 10.sp, color: AppColors.gray)),
                ]),
                SizedBox(width: 8.w),
              ],

              // Avatar
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.primary,
                child: Text('DS', style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w700)),
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
        // Welcome
        Text('Hello, Dr. Smith', style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
        Gap(4.h),
        Text("Here's what's happening at Alpha Dental Clinic today.",
            style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray)),
        Gap(16.h),

        // Key Metrics
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Key Metrics', style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
          Text('Live Updates', style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w500)),
        ]),
        Gap(10.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            _MetricCard(title: 'Total Patients',    value: '1,284', change: '+12%', positive: true),
            SizedBox(width: 10.w),
            _MetricCard(title: 'Total Simulations', value: '42',    change: '+5%',  positive: true),
            SizedBox(width: 10.w),
            _MetricCard(title: 'Pending Requests',  value: '15',    change: '-2%',  positive: false),
            SizedBox(width: 10.w),
            _MetricCard(title: 'Completed Cases',   value: '432',   change: '+18%', positive: true),
          ]),
        ),
        Gap(20.h),

        // Recent Case Activity
        _SectionHeader(title: 'Recent Case Activity', onViewAll: () {}),
        Gap(10.h),
        ...[
          _CaseRow(name: 'John Williams',  type: 'Invisalign', status: 'Completed', statusColor: AppColors.success, time: '2 hours ago'),
          _CaseRow(name: 'Sarah Davis',    type: 'Root Canal', status: 'In Progress', statusColor: AppColors.info,   time: '5 hours ago'),
          _CaseRow(name: 'Michael Tan',    type: 'Checkup',    status: 'Pending',    statusColor: AppColors.gray,    time: 'Yesterday'),
        ],
        Gap(20.h),

        // Buy More Credits
        _SectionHeader(title: 'Buy More Credits', onViewAll: () {}),
        Gap(10.h),
        ...[
          _CreditPackRow(credits: '250 Credits', perCredit: '\$0.40 per credit'),
          _CreditPackRow(credits: '250 Credits', perCredit: '\$0.40 per credit'),
          _CreditPackRow(credits: '250 Credits', perCredit: '\$0.40 per credit'),
        ],
        Gap(20.h),

        // Next Appointment
        _SectionHeader(title: 'Next Appointment', actionLabel: 'View All Appointment ↗', onViewAll: () {}),
        Gap(10.h),
        ...[
          _AppointmentRow(name: 'John Williams', treatment: 'Teeth Whitening', date: 'Oct 24, 10:30 AM'),
          _AppointmentRow(name: 'John Williams', treatment: 'Teeth Whitening', date: 'Oct 24, 10:30 AM'),
          _AppointmentRow(name: 'John Williams', treatment: 'Teeth Whitening', date: 'Oct 24, 10:30 AM'),
        ],
        Gap(20.h),
      ],
    );
  }
}

// ── Desktop Layout ────────────────────────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome + buttons
        Row(
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Welcome back, Dr. Smith', style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
                Gap(4.h),
                Text("Here's what's happening at Alpha Dental Clinic today.",
                    style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray)),
              ]),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: 14.sp),
              label: Text('New Simulation', style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h), elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
            ),
            SizedBox(width: 10.w),
            OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.person_add_outlined, size: 14.sp),
              label: Text('New Patient', style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
            ),
          ],
        ),
        Gap(16.h),

        // Stat cards row
        Row(children: [
          _StatCard(icon: Icons.people_outline,   iconColor: AppColors.primary,  label: 'Total Patients',    value: '1,284', change: '+12%', positive: true),
          SizedBox(width: 12.w),
          _StatCard(icon: Icons.auto_awesome,     iconColor: AppColors.secondary, label: 'Total Simulations', value: '42',    change: '+5%',  positive: true),
          SizedBox(width: 12.w),
          _StatCard(icon: Icons.pending_outlined, iconColor: AppColors.info,      label: 'Pending Requests',  value: '15',    change: '-2%',  positive: false),
          SizedBox(width: 12.w),
          _StatCard(icon: Icons.check_circle_outline, iconColor: AppColors.success, label: 'Completed Cases', value: '432',   change: '+18%', positive: true),
        ]),
        Gap(16.h),

        // Two column layout
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Left col
          Expanded(
            flex: 3,
            child: Column(children: [
              _RecentCasesTable(),
              Gap(16.h),
              _NextAppointmentCard(),
            ]),
          ),
          SizedBox(width: 16.w),
          // Right col
          Expanded(
            flex: 2,
            child: Column(children: [
              _PatientRequestsCard(),
              Gap(16.h),
              _BuyMoreCreditsCard(),
            ]),
          ),
        ]),
      ],
    );
  }
}

// ── Shared Components ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, required this.onViewAll});
  final String title;
  final String? actionLabel;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
      GestureDetector(onTap: onViewAll,
          child: Text(actionLabel ?? 'View All', style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w500))),
    ],
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value, required this.change, required this.positive});
  final String title, value, change;
  final bool positive;

  @override
  Widget build(BuildContext context) => Container(
    width: 130.w, padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(color: AppColors.inputBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray)),
      Gap(6.h),
      Text(value, style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
      Gap(4.h),
      Row(children: [
        Icon(positive ? Icons.trending_up : Icons.trending_down, size: 12.sp, color: positive ? AppColors.success : AppColors.danger),
        SizedBox(width: 3.w),
        Text(change, style: GoogleFonts.inter(fontSize: 11.sp, color: positive ? AppColors.success : AppColors.danger, fontWeight: FontWeight.w500)),
      ]),
    ]),
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.iconColor, required this.label, required this.value, required this.change, required this.positive});
  final IconData icon; final Color iconColor; final String label, value, change; final bool positive;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(color: AppColors.inputBorder)),
      child: Row(children: [
        Container(padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
            child: Icon(icon, size: 18.sp, color: iconColor)),
        SizedBox(width: 10.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray)),
          Gap(2.h),
          Text(value, style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
          Row(children: [
            Icon(positive ? Icons.trending_up : Icons.trending_down, size: 12.sp, color: positive ? AppColors.success : AppColors.danger),
            SizedBox(width: 3.w),
            Text(change, style: GoogleFonts.inter(fontSize: 11.sp, color: positive ? AppColors.success : AppColors.danger)),
          ]),
        ])),
      ]),
    ),
  );
}

class _CaseRow extends StatelessWidget {
  const _CaseRow({required this.name, required this.type, required this.status, required this.statusColor, required this.time});
  final String name, type, status, time; final Color statusColor;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: 8.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.inputBorder)),
    child: Row(children: [
      CircleAvatar(radius: 16.r, backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(name[0], style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w600))),
      SizedBox(width: 10.w),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
        Text(type, style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray)),
      ])),
      Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r)),
          child: Text(status, style: GoogleFonts.inter(fontSize: 10.sp, color: statusColor, fontWeight: FontWeight.w500))),
      SizedBox(width: 8.w),
      Icon(Icons.visibility_outlined, size: 16.sp, color: AppColors.gray),
    ]),
  );
}

class _CreditPackRow extends StatelessWidget {
  const _CreditPackRow({required this.credits, required this.perCredit});
  final String credits, perCredit;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: 8.h),
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.inputBorder)),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(credits, style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
        Text(perCredit, style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray)),
      ])),
      TextButton(onPressed: () {},
          child: Text('Purchase', style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.primary, fontWeight: FontWeight.w600))),
    ]),
  );
}

class _AppointmentRow extends StatelessWidget {
  const _AppointmentRow({required this.name, required this.treatment, required this.date});
  final String name, treatment, date;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: 8.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.inputBorder)),
    child: Row(children: [
      CircleAvatar(radius: 16.r, backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(name[0], style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w600))),
      SizedBox(width: 10.w),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
        Text('Treatment: $treatment', style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('Schedule', style: GoogleFonts.inter(fontSize: 10.sp, color: AppColors.gray)),
        Text(date, style: GoogleFonts.inter(fontSize: 11.sp, fontWeight: FontWeight.w500, color: AppColors.textColor)),
      ]),
      SizedBox(width: 10.w),
      TextButton(onPressed: () {},
          child: Text('View', style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w600))),
    ]),
  );
}

// ── Desktop-only cards ────────────────────────────────────────────────────────

class _RecentCasesTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.inputBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _SectionHeader(title: 'Recent Case Activity', onViewAll: () {}),
      Gap(12.h),
      // Header row
      Row(children: [
        Expanded(flex: 2, child: Text('Patient Name', style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray, fontWeight: FontWeight.w600))),
        Expanded(flex: 2, child: Text('Case Type',    style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray, fontWeight: FontWeight.w600))),
        Expanded(flex: 2, child: Text('Status',       style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray, fontWeight: FontWeight.w600))),
        Expanded(flex: 2, child: Text('Last Update',  style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray, fontWeight: FontWeight.w600))),
      ]),
      Divider(height: 16.h, color: AppColors.inputBorder),
      ...[
        ['John Williams',  'Invisalign', 'Completed',   '2 hours ago'],
        ['Sarah Davis',    'Root Canal', 'In Progress',  '5 hours ago'],
        ['Michael Tan',    'Checkup',    'Pending',      'Yesterday'],
      ].map((r) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(children: [
          Expanded(flex: 2, child: Row(children: [
            CircleAvatar(radius: 12.r, backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(r[0][0], style: GoogleFonts.inter(fontSize: 10.sp, color: AppColors.primary, fontWeight: FontWeight.w600))),
            SizedBox(width: 8.w),
            Text(r[0], style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textColor)),
          ])),
          Expanded(flex: 2, child: Text(r[1], style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray))),
          Expanded(flex: 2, child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: (r[2] == 'Completed' ? AppColors.success : r[2] == 'In Progress' ? AppColors.info : AppColors.gray).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(r[2], style: GoogleFonts.inter(fontSize: 10.sp, fontWeight: FontWeight.w500,
                color: r[2] == 'Completed' ? AppColors.success : r[2] == 'In Progress' ? AppColors.info : AppColors.gray)),
          )),
          Expanded(flex: 2, child: Text(r[3], style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray))),
        ]),
      )),
    ]),
  );
}

class _NextAppointmentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.inputBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _SectionHeader(title: 'Next Appointment', actionLabel: 'View All Appointment ↗', onViewAll: () {}),
      Gap(12.h),
      ...[
        _AppointmentRow(name: 'John Williams', treatment: 'Teeth Whitening', date: 'Oct 24, 10:30 AM'),
        _AppointmentRow(name: 'John Williams', treatment: 'Teeth Whitening', date: 'Oct 24, 10:30 AM'),
        _AppointmentRow(name: 'John Williams', treatment: 'Teeth Whitening', date: 'Oct 24, 10:30 AM'),
      ],
    ]),
  );
}

class _PatientRequestsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.inputBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Patient Requests', style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
        SizedBox(width: 8.w),
        Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20.r)),
            child: Text('2 New', style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w600))),
      ]),
      Gap(12.h),
      ...[1, 2].map((_) => Container(
        margin: EdgeInsets.only(bottom: 10.h), padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(color: const Color(0xFFF5F6FA), borderRadius: BorderRadius.circular(8.r)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(radius: 14.r, backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Text('E', style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.primary, fontWeight: FontWeight.w700))),
            SizedBox(width: 8.w),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Emily Watson', style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
              Text('Dental Implant Inquiry', style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray)),
            ]),
          ]),
          Gap(10.h),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8.h), elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r))),
                child: Text('Accept', style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600)))),
            SizedBox(width: 8.w),
            Expanded(child: OutlinedButton(onPressed: () {},
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: BorderSide(color: AppColors.primary),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r))),
                child: Text('Schedule', style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600)))),
          ]),
        ]),
      )),
    ]),
  );
}

class _BuyMoreCreditsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.inputBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _SectionHeader(title: 'Buy More Credits', onViewAll: () {}),
      Gap(12.h),
      ...[
        _CreditPackRow(credits: '250 Credits', perCredit: '\$0.40 per credit'),
        _CreditPackRow(credits: '250 Credits', perCredit: '\$0.40 per credit'),
        _CreditPackRow(credits: '250 Credits', perCredit: '\$0.40 per credit'),
      ],
    ]),
  );
}
