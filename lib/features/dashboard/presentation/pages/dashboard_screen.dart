// lib/features/dashboard/presentation/pages/dashboard_screen.dart
// FIX #2: Sidebar logo is SVG ONLY — no Text('GenSmile') beside it.
//          The Brand logo SVG already includes the wordmark.
// FIX #1: Images used instead of icons in Create New sheet.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/billing/presentation/pages/billing_screen.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/dashboard_home.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/notifications_screen.dart';
import 'package:gen_smile/features/analytics/presentation/pages/analytics_screen.dart';
import 'package:gen_smile/features/documents/presentation/pages/documents_screen.dart';
import 'package:gen_smile/features/lab_links/presentation/pages/lab_links_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/patients_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/new_simulation_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/add_new_patient_screen.dart';
import 'package:gen_smile/features/settings/presentation/pages/settings_screen.dart';
import 'package:gen_smile/features/staff/presentation/pages/staff_screen.dart';
import 'package:gen_smile/features/splash/presentation/pages/splash_screen.dart';
import 'package:gen_smile/generated/assets.dart';

final dashboardIndexProvider = StateProvider<int>((ref) => 0);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(dashboardIndexProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    if (isWide) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F5F7),
        body: Row(
          children: [
            _Sidebar(selected: idx),
            Expanded(child: _body(context, ref, idx, embedded: true)),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        bottom: false,
        child: _body(context, ref, idx, embedded: true),
      ),
      bottomNavigationBar: _BottomNav(selected: idx),
    );
  }

  Widget _body(
    BuildContext ctx,
    WidgetRef ref,
    int idx, {
    required bool embedded,
  }) {
    switch (idx) {
      case 0:
        return DashboardHome(embedded: embedded);
      case 1:
        return PatientsScreen(embedded: embedded);
      case 2:
        return LabLinksScreen(embedded: embedded);
      case 3:
        return DocumentsScreen(embedded: embedded);
      case 4:
        return AnalyticsScreen(embedded: embedded);
      case 5:
        return BillingScreen(embedded: embedded);
      case 6:
        return StaffScreen(embedded: embedded);
      case 7:
        return const SettingsScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SIDEBAR
// ─────────────────────────────────────────────────────────────────────────────
class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.selected});
  final int selected;

  static const _main = [
    _NI(Icons.dashboard_outlined, 'Dashboard', 0),
    _NI(Icons.person_outline, 'Patients', 1),
    _NI(Icons.science_outlined, 'Lab Links', 2),
    _NI(Icons.folder_outlined, 'Documents & Records', 3),
    _NI(Icons.bar_chart_outlined, 'Analytics', 4),
  ];
  static const _more = [
    _NI(Icons.receipt_long_outlined, 'Billing', 5),
    _NI(Icons.group_outlined, 'Staff', 6),
    _NI(Icons.settings_outlined, 'Settings', 7),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 200,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── FIX #2: SVG logo ONLY — no Text beside it ─────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 20.h),
            child: SvgPicture.asset(
              Assets.iconsBrandLogo,
              width: 120.w, // wider so the SVG wordmark is fully visible
              fit: BoxFit.contain,
            ),
          ),
          _lbl('Main Menu'),
          SizedBox(height: 4.h),
          ..._main.map(
            (i) => _Tile(
              i,
              selected == i.idx,
              () => ref.read(dashboardIndexProvider.notifier).state = i.idx,
            ),
          ),
          SizedBox(height: 16.h),
          _lbl('More'),
          SizedBox(height: 4.h),
          ..._more.map(
            (i) => _Tile(
              i,
              selected == i.idx,
              () => ref.read(dashboardIndexProvider.notifier).state = i.idx,
            ),
          ),
          const Spacer(),
          _Tile(
            const _NI(Icons.notifications_outlined, 'Notifications', -1),
            false,
            () => ref
                .read(navigatorState.notifier)
                .push(const NotificationsScreen()),
          ),
          _Tile(const _NI(Icons.help_outline, 'Help Center', -1), false, () {}),
          InkWell(
            onTap: () => ref
                .read(navigatorState.notifier)
                .pushReplacementAll(const SplashScreen()),
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 24.h),
              child: Row(
                children: [
                  Icon(Icons.logout, size: 15.sp, color: AppColors.gray),
                  SizedBox(width: 10.w),
                  Text(
                    'Log out',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lbl(String t) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 18.w),
    child: Text(
      t,
      style: GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.gray,
        letterSpacing: 0.6,
      ),
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile(this.item, this.selected, this.onTap);
  final _NI item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8.r),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            item.icon,
            size: 16.sp,
            color: selected ? AppColors.primary : AppColors.gray,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              item.label,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.primary : AppColors.textColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _NI {
  const _NI(this.icon, this.label, this.idx);
  final IconData icon;
  final String label;
  final int idx;
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM NAV
// ─────────────────────────────────────────────────────────────────────────────
class _BottomNav extends ConsumerWidget {
  const _BottomNav({required this.selected});
  final int selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.inputBorder)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60.h,
          child: Row(
            children: [
              _BNI(Icons.home_outlined, Icons.home, 'Home', 0, selected),
              _BNI(Icons.person_outline, Icons.person, 'Patients', 1, selected),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showCreate(context, ref),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _BNI(Icons.group_outlined, Icons.group, 'Staff', 6, selected),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showMore(context, ref),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.more_horiz,
                        size: 22.sp,
                        color: AppColors.gray,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'More',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreate(BuildContext ctx, WidgetRef ref) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CreateSheet(
        onPatient: () {
          Navigator.pop(ctx);
          Navigator.of(ctx).push(
            MaterialPageRoute(builder: (_) => const AddNewPatientScreen()),
          );
        },
        onSim: () {
          Navigator.pop(ctx);
          Navigator.of(ctx).push(
            MaterialPageRoute(builder: (_) => const NewSimulationScreen()),
          );
        },
      ),
    );
  }

  void _showMore(BuildContext ctx, WidgetRef ref) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _MoreSheet(
        selected: ref.read(dashboardIndexProvider),
        onSelect: (i) {
          ref.read(dashboardIndexProvider.notifier).state = i;
          Navigator.pop(ctx);
        },
        onNotif: () {
          Navigator.pop(ctx);
          ref.read(navigatorState.notifier).push(const NotificationsScreen());
        },
        onLogout: () {
          Navigator.pop(ctx);
          ref
              .read(navigatorState.notifier)
              .pushReplacementAll(const SplashScreen());
        },
      ),
    );
  }
}

class _BNI extends ConsumerWidget {
  const _BNI(this.icon, this.activeIcon, this.label, this.idx, this.selected);
  final IconData icon, activeIcon;
  final String label;
  final int idx, selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = selected == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(dashboardIndexProvider.notifier).state = idx,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              on ? activeIcon : icon,
              size: 22.sp,
              color: on ? AppColors.primary : AppColors.gray,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: on ? AppColors.primary : AppColors.gray,
                fontWeight: on ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CREATE NEW SHEET
// ─────────────────────────────────────────────────────────────────────────────
class _CreateSheet extends StatelessWidget {
  const _CreateSheet({required this.onPatient, required this.onSim});
  final VoidCallback onPatient, onSim;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.inputBorder,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
        Gap(20.h),
        Text(
          'Create New',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        Gap(4.h),
        Text(
          'Start a new workflow',
          style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray),
        ),
        Gap(20.h),
        _SheetOpt(
          // FIX #1: PNG image instead of icon
          imageWidget: Image.asset(
            Assets.iconsUserAdd02,
            width: 24.w,
            height: 24.w,
          ),
          bgColor: AppColors.primary,
          title: 'Add New Patient',
          subtitle: 'Add a new patient profile to the clinic database',
          onTap: onPatient,
        ),
        Gap(12.h),
        _SheetOpt(
          imageWidget: Image.asset(
            Assets.iconsSmile,
            width: 24.w,
            height: 24.w,
          ),
          bgColor: const Color(0xFF7B5EA7),
          title: 'New Simulation',
          subtitle: 'Create a new AI smile simulation for a patient',
          onTap: onSim,
        ),
        Gap(8.h),
      ],
    ),
  );
}

class _SheetOpt extends StatelessWidget {
  const _SheetOpt({
    required this.imageWidget,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final Widget imageWidget;
  final Color bgColor;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12.r),
    child: Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.all(10.w),
            child: imageWidget,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                Gap(2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// MORE SHEET
// ─────────────────────────────────────────────────────────────────────────────
class _MoreSheet extends StatelessWidget {
  const _MoreSheet({
    required this.selected,
    required this.onSelect,
    required this.onNotif,
    required this.onLogout,
  });
  final int selected;
  final void Function(int) onSelect;
  final VoidCallback onNotif, onLogout;

  static const _items = [
    _NI(Icons.dashboard_outlined, 'Dashboard', 0),
    _NI(Icons.person_outline, 'Patients', 1),
    _NI(Icons.science_outlined, 'Lab Links', 2),
    _NI(Icons.folder_outlined, 'Documents & Records', 3),
    _NI(Icons.bar_chart_outlined, 'Analytics', 4),
    _NI(Icons.receipt_long_outlined, 'Billing', 5),
    _NI(Icons.group_outlined, 'Staff', 6),
    _NI(Icons.settings_outlined, 'Settings', 7),
  ];

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.inputBorder,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
        Gap(12.h),
        // FIX #2: SVG only, no text
        SvgPicture.asset(
          Assets.iconsBrandLogo,
          width: 120.w,
          fit: BoxFit.contain,
        ),
        Gap(16.h),
        ..._items.map(
          (i) => _Tile(i, selected == i.idx, () => onSelect(i.idx)),
        ),
        Divider(height: 20.h, color: AppColors.inputBorder),
        _Tile(
          const _NI(Icons.notifications_outlined, 'Notifications', -1),
          false,
          onNotif,
        ),
        _Tile(const _NI(Icons.help_outline, 'Help Center', -1), false, () {}),
        _Tile(const _NI(Icons.logout, 'Log out', -1), false, onLogout),
      ],
    ),
  );
}
