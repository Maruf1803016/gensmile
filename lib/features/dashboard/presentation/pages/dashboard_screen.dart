// lib/features/dashboard/presentation/pages/dashboard_screen.dart
// FIXES:
//  • case 6 → StaffScreen (no more "Coming soon" placeholder)
//  • Sidebar logo uses Assets.iconsBrandLogo SVG
//  • More sheet logo uses Assets.iconsBrandLogo SVG
//  • Create New sheet uses SVG icons
//  • Notification bell added to sidebar + more sheet

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
import 'package:gen_smile/features/settings/presentation/pages/settings_screen.dart';
import 'package:gen_smile/features/staff/presentation/pages/staff_screen.dart';
import 'package:gen_smile/features/splash/presentation/pages/splash_screen.dart';
import 'package:gen_smile/generated/assets.dart';

final dashboardIndexProvider = StateProvider<int>((ref) => 0);

const double _kSidebarBreakpoint = 600;
const double _kSidebarWidth = 200;

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(dashboardIndexProvider);
    final isWide = MediaQuery.sizeOf(context).width >= _kSidebarBreakpoint;

    if (isWide) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F5F7),
        body: Row(
          children: [
            _SidebarContent(
              selectedIndex: selectedIndex,
              width: _kSidebarWidth,
            ),
            Expanded(
              child: _buildBody(context, ref, selectedIndex, embedded: true),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        bottom: false,
        child: _buildBody(context, ref, selectedIndex, embedded: true),
      ),
      bottomNavigationBar: _BottomNav(selectedIndex: selectedIndex),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    int index, {
    required bool embedded,
  }) {
    switch (index) {
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
        return StaffScreen(embedded: embedded); // ← FIXED
      case 7:
        return const SettingsScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Bottom Nav ────────────────────────────────────────────────────────────────
class _BottomNav extends ConsumerWidget {
  const _BottomNav({required this.selectedIndex});
  final int selectedIndex;

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
              _BottomNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
                selectedIndex: selectedIndex,
              ),
              _BottomNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Patients',
                index: 1,
                selectedIndex: selectedIndex,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showCreateNewSheet(context, ref),
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
              _BottomNavItem(
                icon: Icons.group_outlined,
                activeIcon: Icons.group,
                label: 'Staff',
                index: 6,
                selectedIndex: selectedIndex,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showMoreSheet(context, ref),
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

  void _showCreateNewSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CreateNewSheet(
        onNewPatient: () => Navigator.pop(context),
        onNewSimulation: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewSimulationScreen()),
          );
        },
      ),
    );
  }

  void _showMoreSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _MoreSheet(
        selectedIndex: ref.read(dashboardIndexProvider),
        onSelect: (i) {
          ref.read(dashboardIndexProvider.notifier).state = i;
          Navigator.pop(context);
        },
        onNotification: () {
          Navigator.pop(context);
          ref.read(navigatorState.notifier).push(const NotificationsScreen());
        },
        onLogout: () {
          Navigator.pop(context);
          ref
              .read(navigatorState.notifier)
              .pushReplacementAll(const SplashScreen());
        },
      ),
    );
  }
}

class _BottomNavItem extends ConsumerWidget {
  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.selectedIndex,
  });
  final IconData icon, activeIcon;
  final String label;
  final int index, selectedIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(dashboardIndexProvider.notifier).state = index,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22.sp,
              color: isSelected ? AppColors.primary : AppColors.gray,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: isSelected ? AppColors.primary : AppColors.gray,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Create New Sheet ──────────────────────────────────────────────────────────
class _CreateNewSheet extends StatelessWidget {
  const _CreateNewSheet({
    required this.onNewPatient,
    required this.onNewSimulation,
  });
  final VoidCallback onNewPatient, onNewSimulation;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Start a new workflow for your clinic',
            style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray),
          ),
          Gap(20.h),
          _SheetOption(
            iconPath: Assets.iconsUserAdd02,
            color: AppColors.primary,
            title: 'Add New Patient',
            subtitle: 'Add a new patient profile to the clinic database',
            onTap: onNewPatient,
          ),
          Gap(12.h),
          _SheetOption(
            iconPath: Assets.iconsSmile,
            color: const Color(0xFF7B5EA7),
            title: 'New Simulation',
            subtitle:
                'Create a new AI smile or orthodontic simulation for a patient',
            onTap: onNewSimulation,
          ),
          Gap(8.h),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  const _SheetOption({
    required this.iconPath,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String iconPath, title, subtitle;
  final Color color;
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
              color: color,
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.all(10.w),
            child: SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
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

// ── More Sheet ────────────────────────────────────────────────────────────────
class _MoreSheet extends StatelessWidget {
  const _MoreSheet({
    required this.selectedIndex,
    required this.onSelect,
    required this.onNotification,
    required this.onLogout,
  });
  final int selectedIndex;
  final void Function(int) onSelect;
  final VoidCallback onNotification, onLogout;

  static final _mainItems = [
    _NavItem(
      icon: SvgPicture.asset(Assets.iconsDashboardSquare01, width: 22),
      label: 'Dashboard',
      index: 0,
    ),
    _NavItem(
      icon: SvgPicture.asset(Assets.iconsPatient, width: 22),
      label: 'Patients',
      index: 1,
    ),
    _NavItem(
      icon: SvgPicture.asset(Assets.iconsTestTube01, width: 22),
      label: 'Lab Links',
      index: 2,
    ),
    _NavItem(
      icon: SvgPicture.asset(Assets.iconsDocumentValidation, width: 22),
      label: 'Documents & Records',
      index: 3,
    ),
    _NavItem(
      icon: SvgPicture.asset(Assets.iconsAnalyticsUp, width: 22),
      label: 'Analytics',
      index: 4,
    ),
  ];
  static const _moreItems = [
    _NavItem(
      icon: Icon(Icons.receipt_long_outlined),
      label: 'Billing',
      index: 5,
    ),
    _NavItem(icon: Icon(Icons.group_outlined), label: 'Staff', index: 6),
    _NavItem(icon: Icon(Icons.settings_outlined), label: 'Settings', index: 7),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              SvgPicture.asset(
                Assets.iconsBrandLogo,
                width: 28.w,
                height: 28.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'GenSmile',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          Gap(16.h),
          _SheetSectionLabel('Main Menu'),
          Gap(4.h),
          ..._mainItems.map(
            (item) => _SheetTile(
              item: item,
              isSelected: selectedIndex == item.index,
              onTap: () => onSelect(item.index),
            ),
          ),
          Gap(8.h),
          _SheetSectionLabel('More'),
          Gap(4.h),
          ..._moreItems.map(
            (item) => _SheetTile(
              item: item,
              isSelected: selectedIndex == item.index,
              onTap: () => onSelect(item.index),
            ),
          ),
          Divider(height: 24.h, color: AppColors.inputBorder),
          InkWell(
            onTap: onNotification,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 18.sp,
                    color: AppColors.gray,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Notifications',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _SheetTile(
            item: _NavItem(
              icon: const Icon(Icons.help_outline, size: 22),
              label: 'Help Center',
              index: -1,
            ),
            isSelected: false,
            onTap: () {},
          ),
          InkWell(
            onTap: onLogout,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              child: Row(
                children: [
                  Icon(Icons.logout, size: 18.sp, color: AppColors.gray),
                  SizedBox(width: 10.w),
                  Text(
                    'Log out',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
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
}

class _SheetSectionLabel extends StatelessWidget {
  const _SheetSectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: 8.w, bottom: 2.h),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.gray,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );
}

class _SheetTile extends StatelessWidget {
  const _SheetTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8.r),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          SizedBox(width: 18.sp, height: 18.sp, child: item.icon),
          SizedBox(width: 10.w),
          Text(
            item.label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : AppColors.textColor,
            ),
          ),
        ],
      ),
    ),
  );
}

// ── Sidebar ───────────────────────────────────────────────────────────────────
class _SidebarContent extends ConsumerWidget {
  const _SidebarContent({required this.selectedIndex, required this.width});
  final int selectedIndex;
  final double width;

  static const _mainItems = [
    _NavItem(
      icon: Icon(Icons.dashboard_outlined),
      label: 'Dashboard',
      index: 0,
    ),
    _NavItem(icon: Icon(Icons.person_outline), label: 'Patients', index: 1),
    _NavItem(icon: Icon(Icons.science_outlined), label: 'Lab Links', index: 2),
    _NavItem(
      icon: Icon(Icons.folder_outlined),
      label: 'Documents & Records',
      index: 3,
    ),
    _NavItem(
      icon: Icon(Icons.bar_chart_outlined),
      label: 'Analytics',
      index: 4,
    ),
  ];

  static const _moreItems = [
    _NavItem(
      icon: Icon(Icons.receipt_long_outlined),
      label: 'Billing',
      index: 5,
    ),
    _NavItem(icon: Icon(Icons.group_outlined), label: 'Staff', index: 6),
    _NavItem(icon: Icon(Icons.settings_outlined), label: 'Settings', index: 7),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: width,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo ──────────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 20.h),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.iconsBrandLogo,
                  width: 32.w,
                  height: 32.w,
                ),
                SizedBox(width: 8.w),
                //Text(
                //'GenSmile',
                ///style: GoogleFonts.inter(
                //  fontSize: 16.sp,
                //  fontWeight: FontWeight.w700,
                //  color: AppColors.textColor,
                // ),
                //),
              ],
            ),
          ),
          _SectionLabel('Main Menu'),
          SizedBox(height: 4.h),
          ..._mainItems.map(
            (item) => _SidebarTile(
              item: item,
              isSelected: selectedIndex == item.index,
              onTap: () =>
                  ref.read(dashboardIndexProvider.notifier).state = item.index,
            ),
          ),
          SizedBox(height: 16.h),
          _SectionLabel('More'),
          SizedBox(height: 4.h),
          ..._moreItems.map(
            (item) => _SidebarTile(
              item: item,
              isSelected: selectedIndex == item.index,
              onTap: () =>
                  ref.read(dashboardIndexProvider.notifier).state = item.index,
            ),
          ),
          const Spacer(),
          _SidebarTile(
            item: _NavItem(
              icon: Icon(Icons.notifications_outlined),
              label: 'Notifications',
              index: -1,
            ),
            isSelected: false,
            onTap: () => ref
                .read(navigatorState.notifier)
                .push(const NotificationsScreen()),
          ),
          _SidebarTile(
            item: _NavItem(
              icon: Icon(Icons.help_outline), // ✅ wrap in Icon()
              label: 'Help Center',
              index: -1,
            ),
            isSelected: false,
            onTap: () {},
          ),
          InkWell(
            onTap: () => ref
                .read(navigatorState.notifier)
                .pushReplacementAll(const SplashScreen()),
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              margin: EdgeInsets.fromLTRB(8.w, 0, 8.w, 20.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                children: [
                  Icon(Icons.logout, size: 16.sp, color: AppColors.gray),
                  SizedBox(width: 10.w),
                  Text(
                    'Log out',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
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
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 18.w),
    child: Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.gray,
        letterSpacing: 0.6,
      ),
    ),
  );
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8.r),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16.w, // control size if needed
            height: 16.w,
            child: item.icon, // ✅ directly use the widget
          ),
          SizedBox(width: 10.w),
          Text(
            item.label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : AppColors.textColor,
            ),
          ),
        ],
      ),
    ),
  );
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
  });
  final Widget icon;
  final String label;
  final int index;
}
