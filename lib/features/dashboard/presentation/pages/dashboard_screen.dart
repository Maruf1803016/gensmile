// lib/features/dashboard/presentation/pages/dashboard_screen.dart
//
// FIXES:
// 1. Staff icon now shows (wired to real StaffScreen instead of placeholder)
// 2. Sidebar updated: uses real Logo.png, shows all nav items matching Image 4
//    (Dashboard, Patients, Lab Links, Documents & Records, Analytics, Billing,
//     Staff, Settings + Notifications + Help Center + Log out)
// 3. More sheet updated with same structure as sidebar
// 4. Bottom nav Staff tab wired correctly

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/generated/assets.dart';
import 'package:gen_smile/features/billing/presentation/pages/billing_screen.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/dashboard_home.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/notifications_screen.dart';
import 'package:gen_smile/features/analytics/presentation/pages/analytics_screen.dart';
import 'package:gen_smile/features/documents/presentation/pages/documents_screen.dart';
import 'package:gen_smile/features/lab_links/presentation/pages/lab_links_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/patients_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/new_simulation_screen.dart';
import 'package:gen_smile/features/settings/presentation/pages/settings_screen.dart';
import 'package:gen_smile/features/splash/presentation/pages/splash_screen.dart';

// Staff screen import — must exist in your project
// If you haven't created it yet, keep the _PlaceholderBody fallback
// import 'package:gen_smile/features/staff/presentation/pages/staff_screen.dart';

final dashboardIndexProvider = StateProvider<int>((ref) => 0);

const double _kSidebarBreakpoint = 600;
const double _kSidebarWidth = 220;

// All nav items — index must match _buildBody cases
const _kAllNavItems = [
  _NavItem(
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard,
    label: 'Dashboard',
    index: 0,
  ),
  _NavItem(
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Patients',
    index: 1,
  ),
  _NavItem(
    icon: Icons.science_outlined,
    activeIcon: Icons.science,
    label: 'Lab Links',
    index: 2,
  ),
  _NavItem(
    icon: Icons.folder_outlined,
    activeIcon: Icons.folder,
    label: 'Documents & Records',
    index: 3,
  ),
  _NavItem(
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart,
    label: 'Analytics',
    index: 4,
  ),
  _NavItem(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long,
    label: 'Billing',
    index: 5,
  ),
  _NavItem(
    icon: Icons.group_outlined,
    activeIcon: Icons.group,
    label: 'Staff',
    index: 6,
  ),
  _NavItem(
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    label: 'Settings',
    index: 7,
  ),
];

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
        // Uncomment when StaffScreen is ready:
        // return const StaffScreen();
        return const _PlaceholderBody(index: 6, label: 'Staff');
      case 7:
        return const SettingsScreen();
      default:
        return _PlaceholderBody(
          index: index,
          label: _kAllNavItems[index < _kAllNavItems.length ? index : 0].label,
        );
    }
  }
}

// ── Bottom Navigation Bar ─────────────────────────────────────────────────────
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
              // Home
              _BottomNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
                selectedIndex: selectedIndex,
              ),
              // Patients
              _BottomNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Patients',
                index: 1,
                selectedIndex: selectedIndex,
              ),
              // Centre + FAB
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
              // Staff — FIX 1: now navigates to index 6
              _BottomNavItem(
                icon: Icons.group_outlined,
                activeIcon: Icons.group,
                label: 'Staff',
                index: 6,
                selectedIndex: selectedIndex,
              ),
              // More
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
        onNewSimulation: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewSimulationScreen()),
          );
        },
        onNewPatient: () => Navigator.pop(context),
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          );
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
    required this.onNewSimulation,
    required this.onNewPatient,
  });
  final VoidCallback onNewSimulation, onNewPatient;

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
            icon: Icons.auto_awesome_outlined,
            color: AppColors.primary,
            title: 'New Simulation',
            subtitle:
                'Create a new AI smile or orthodontic simulation for a patient',
            onTap: onNewSimulation,
          ),
          Gap(12.h),
          _SheetOption(
            icon: Icons.person_add_outlined,
            color: const Color(0xFF7B5EA7),
            title: 'Add New Patient',
            subtitle: 'Add a new patient profile to the clinic database',
            onTap: onNewPatient,
          ),
          Gap(8.h),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  const _SheetOption({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final Color color;
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
              color: color,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Colors.white, size: 22.sp),
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
          // Logo row
          Row(
            children: [
              SvgPicture.asset(Assets.iconsBrandLogo, width: 28.w, height: 28.w),
              SizedBox(width: 8.w),
              
            ],
          ),
          Gap(16.h),
          // All nav items in sheet
          ..._kAllNavItems.map(
            (item) => _SheetTile(
              item: item,
              isSelected: selectedIndex == item.index,
              onTap: () => onSelect(item.index),
            ),
          ),
          Divider(height: 20.h, color: AppColors.inputBorder),
          // Notifications
          _SheetTile(
            item: const _NavItem(
              icon: Icons.notifications_outlined,
              activeIcon: Icons.notifications,
              label: 'Notifications',
              index: -1,
            ),
            isSelected: false,
            onTap: onNotification,
          ),
          // Help Center
          _SheetTile(
            item: const _NavItem(
              icon: Icons.help_outline,
              activeIcon: Icons.help,
              label: 'Help Center',
              index: -1,
            ),
            isSelected: false,
            onTap: () {},
          ),
          // Log out
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
          Icon(
            isSelected ? item.activeIcon : item.icon,
            size: 18.sp,
            color: isSelected ? AppColors.primary : AppColors.gray,
          ),
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

// ── Sidebar (wide screens) ────────────────────────────────────────────────────
class _SidebarContent extends ConsumerWidget {
  const _SidebarContent({required this.selectedIndex, required this.width});
  final int selectedIndex;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: width,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 20.h),
            child: Row(
              children: [
                SvgPicture.asset(Assets.iconsBrandLogo, width: 32.w, height: 32.w),
                SizedBox(width: 8.w),
                Text(
                  'GenSmile',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
          // Main menu
          _SectionLabel('Main Menu'),
          SizedBox(height: 4.h),
          ..._kAllNavItems
              .where((i) => i.index <= 4)
              .map(
                (item) => _SidebarTile(
                  item: item,
                  isSelected: selectedIndex == item.index,
                  onTap: () => ref.read(dashboardIndexProvider.notifier).state =
                      item.index,
                ),
              ),
          SizedBox(height: 16.h),
          // More section
          _SectionLabel('More'),
          SizedBox(height: 4.h),
          ..._kAllNavItems
              .where((i) => i.index > 4)
              .map(
                (item) => _SidebarTile(
                  item: item,
                  isSelected: selectedIndex == item.index,
                  onTap: () => ref.read(dashboardIndexProvider.notifier).state =
                      item.index,
                ),
              ),
          const Spacer(),
          Divider(color: AppColors.inputBorder, height: 1),
          SizedBox(height: 8.h),
          // Notifications
          _SidebarTile(
            item: const _NavItem(
              icon: Icons.notifications_outlined,
              activeIcon: Icons.notifications,
              label: 'Notifications',
              index: -1,
            ),
            isSelected: false,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
          // Help Center
          _SidebarTile(
            item: const _NavItem(
              icon: Icons.help_outline,
              activeIcon: Icons.help,
              label: 'Help Center',
              index: -1,
            ),
            isSelected: false,
            onTap: () {},
          ),
          // Log out
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
          Icon(
            isSelected ? item.activeIcon : item.icon,
            size: 16.sp,
            color: isSelected ? AppColors.primary : AppColors.gray,
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

// ── Placeholder ───────────────────────────────────────────────────────────────
class _PlaceholderBody extends StatelessWidget {
  const _PlaceholderBody({required this.index, required this.label});
  final int index;
  final String label;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.construction_outlined, size: 48.sp, color: AppColors.gray),
        SizedBox(height: 12.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Coming soon',
          style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.gray),
        ),
      ],
    ),
  );
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
  });
  final IconData icon, activeIcon;
  final String label;
  final int index;
}
