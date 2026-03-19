import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/core/states/navigator_state.dart';
import 'package:onboarding/features/billing/presentation/pages/billing_screen.dart';
import 'package:onboarding/features/dashboard/presentation/pages/dashboard_home.dart';
//import 'package:onboarding/features/dashboard/presentation/pages/notifications_screen.dart';
import 'package:onboarding/features/analytics/presentation/pages/analytics_screen.dart';
import 'package:onboarding/features/splash/presentation/pages/splash_screen.dart';

final dashboardIndexProvider = StateProvider<int>((ref) => 0);

const double _kSidebarBreakpoint = 600;
const double _kSidebarWidth      = 200;

// Shared labels used across DashboardScreen
const _kSectionLabels = [
  'Dashboard', 'Patients', 'Lab Links', 'Analytics',
  'Billing', 'Staff', 'Settings',
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
            _SidebarContent(selectedIndex: selectedIndex, width: _kSidebarWidth),
            Expanded(child: _buildBody(context, ref, selectedIndex, embedded: true)),
          ],
        ),
      );
    }

    // ── Mobile: bottom nav ──
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(bottom: false, child: _buildBody(context, ref, selectedIndex, embedded: true)),
      bottomNavigationBar: _BottomNav(selectedIndex: selectedIndex),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, int index, {required bool embedded}) {
    switch (index) {
      case 0: return DashboardHome(embedded: embedded);
      case 3: return AnalyticsScreen(embedded: embedded);
      case 4: return BillingScreen(embedded: embedded);
      default: return _PlaceholderBody(index: index);
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
              _BottomNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home',     index: 0, selectedIndex: selectedIndex),
              _BottomNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Patients', index: 1, selectedIndex: selectedIndex),
              // Centre + button
              Expanded(
                child: GestureDetector(
                  onTap: () => _showCreateNewSheet(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44.w, height: 44.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 24.sp),
                      ),
                    ],
                  ),
                ),
              ),
              _BottomNavItem(icon: Icons.group_outlined, activeIcon: Icons.group, label: 'Staff',    index: 5, selectedIndex: selectedIndex),
              // More
              Expanded(
                child: GestureDetector(
                  onTap: () => _showMoreSheet(context, ref),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.more_horiz,
                          size: 22.sp,
                          color: AppColors.gray),
                      SizedBox(height: 2.h),
                      Text('More',
                          style: GoogleFonts.inter(
                              fontSize: 10.sp, color: AppColors.gray)),
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

  void _showCreateNewSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _CreateNewSheet(),
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
        onLogout: () {
          Navigator.pop(context);
          ref.read(navigatorState.notifier).pushReplacementAll(const SplashScreen());
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
            Icon(isSelected ? activeIcon : icon,
                size: 22.sp,
                color: isSelected ? AppColors.primary : AppColors.gray),
            SizedBox(height: 2.h),
            Text(label,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  color: isSelected ? AppColors.primary : AppColors.gray,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                )),
          ],
        ),
      ),
    );
  }
}

// ── Create New Bottom Sheet ───────────────────────────────────────────────────
class _CreateNewSheet extends StatelessWidget {
  const _CreateNewSheet();

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
              width: 40.w, height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Gap(20.h),
          Text('Create New',
              style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
          Gap(4.h),
          Text('Start a new workflow for your clinic',
              style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray)),
          Gap(20.h),
          _CreateNewOption(
            icon: Icons.auto_awesome_outlined,
            color: AppColors.primary,
            title: 'New Simulation',
            subtitle: 'Create a new AI smile or orthodontic simulation for a patient',
            onTap: () { Navigator.pop(context); /* TODO */ },
          ),
          Gap(12.h),
          _CreateNewOption(
            icon: Icons.person_add_outlined,
            color: AppColors.secondary,
            title: 'New Patient',
            subtitle: 'Add a new patient profile to the clinic database',
            onTap: () { Navigator.pop(context); /* TODO */ },
          ),
          Gap(8.h),
        ],
      ),
    );
  }
}

class _CreateNewOption extends StatelessWidget {
  const _CreateNewOption({required this.icon, required this.color, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final Color color;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
              width: 44.w, height: 44.w,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12.r)),
              child: Icon(icon, color: Colors.white, size: 22.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
                  Gap(2.h),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── More Bottom Sheet ─────────────────────────────────────────────────────────
class _MoreSheet extends StatelessWidget {
  const _MoreSheet({required this.selectedIndex, required this.onSelect, required this.onLogout});
  final int selectedIndex;
  final void Function(int) onSelect;
  final VoidCallback onLogout;

  static const _mainItems = [
    _NavItem(icon: Icons.dashboard_outlined,    label: 'Dashboard', index: 0),
    _NavItem(icon: Icons.person_outline,        label: 'Patients',  index: 1),
    _NavItem(icon: Icons.science_outlined,      label: 'Lab Links', index: 2),
    _NavItem(icon: Icons.bar_chart_outlined,    label: 'Analytics', index: 3),
  ];
  static const _moreItems = [
    _NavItem(icon: Icons.receipt_long_outlined, label: 'Billing',   index: 4),
    _NavItem(icon: Icons.group_outlined,        label: 'Staff',     index: 5),
    _NavItem(icon: Icons.settings_outlined,     label: 'Settings',  index: 6),
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
          // Handle
          Center(child: Container(width: 40.w, height: 4.h,
              decoration: BoxDecoration(color: AppColors.inputBorder, borderRadius: BorderRadius.circular(2.r)))),
          Gap(12.h),
          // Logo
          Row(children: [
            Container(width: 28.w, height: 28.w,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6.r)),
                child: Icon(Icons.medical_services_outlined, color: Colors.white, size: 16.sp)),
            SizedBox(width: 8.w),
            Text('GenSmile', style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
          ]),
          Gap(16.h),
          _SheetSectionLabel('Main Menu'),
          Gap(4.h),
          ..._mainItems.map((item) => _SheetTile(item: item, isSelected: selectedIndex == item.index, onTap: () => onSelect(item.index))),
          Gap(8.h),
          _SheetSectionLabel('More'),
          Gap(4.h),
          ..._moreItems.map((item) => _SheetTile(item: item, isSelected: selectedIndex == item.index, onTap: () => onSelect(item.index))),
          Divider(height: 24.h, color: AppColors.inputBorder),
          _SheetTile(item: const _NavItem(icon: Icons.help_outline, label: 'Help Center', index: -1), isSelected: false, onTap: () {}),
          InkWell(
            onTap: onLogout,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              child: Row(children: [
                Icon(Icons.logout, size: 18.sp, color: AppColors.gray),
                SizedBox(width: 10.w),
                Text('Log out', style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.gray)),
              ]),
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
    child: Align(alignment: Alignment.centerLeft,
        child: Text(text, style: GoogleFonts.inter(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.gray, letterSpacing: 0.5))),
  );
}

class _SheetTile extends StatelessWidget {
  const _SheetTile({required this.item, required this.isSelected, required this.onTap});
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
        color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(children: [
        Icon(item.icon, size: 18.sp, color: isSelected ? AppColors.primary : AppColors.gray),
        SizedBox(width: 10.w),
        Text(item.label, style: GoogleFonts.inter(fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.primary : AppColors.textColor)),
      ]),
    ),
  );
}

// ── Placeholder ───────────────────────────────────────────────────────────────
class _PlaceholderBody extends StatelessWidget {
  const _PlaceholderBody({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.construction_outlined, size: 48.sp, color: AppColors.gray),
      SizedBox(height: 12.h),
      Text(_kSectionLabels[index], style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.w600, color: AppColors.primary)),
      SizedBox(height: 6.h),
      Text('Coming soon', style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.gray)),
    ]),
  );
}

// ── Sidebar (desktop/tablet only) ────────────────────────────────────────────
class _SidebarContent extends ConsumerWidget {
  const _SidebarContent({required this.selectedIndex, required this.width});
  final int selectedIndex;
  final double width;

  static const _mainItems = [
    _NavItem(icon: Icons.dashboard_outlined,    label: 'Dashboard', index: 0),
    _NavItem(icon: Icons.person_outline,        label: 'Patients',  index: 1),
    _NavItem(icon: Icons.science_outlined,      label: 'Lab Links', index: 2),
    _NavItem(icon: Icons.bar_chart_outlined,    label: 'Analytics', index: 3),
  ];
  static const _moreItems = [
    _NavItem(icon: Icons.receipt_long_outlined, label: 'Billing',   index: 4),
    _NavItem(icon: Icons.group_outlined,        label: 'Staff',     index: 5),
    _NavItem(icon: Icons.settings_outlined,     label: 'Settings',  index: 6),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: width, height: double.infinity, color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 20.h),
          child: Row(children: [
            Container(width: 32.w, height: 32.w,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8.r)),
                child: Icon(Icons.medical_services_outlined, color: Colors.white, size: 18.sp)),
            SizedBox(width: 8.w),
            Text('GenSmile', style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
          ]),
        ),
        _SectionLabel('Main Menu'), SizedBox(height: 4.h),
        ..._mainItems.map((item) => _SidebarTile(item: item, isSelected: selectedIndex == item.index,
            onTap: () => ref.read(dashboardIndexProvider.notifier).state = item.index)),
        SizedBox(height: 16.h),
        _SectionLabel('More'), SizedBox(height: 4.h),
        ..._moreItems.map((item) => _SidebarTile(item: item, isSelected: selectedIndex == item.index,
            onTap: () => ref.read(dashboardIndexProvider.notifier).state = item.index)),
        const Spacer(),
        _SidebarTile(item: const _NavItem(icon: Icons.help_outline, label: 'Help Center', index: -1), isSelected: false, onTap: () {}),
        InkWell(
          onTap: () => ref.read(navigatorState.notifier).pushReplacementAll(const SplashScreen()),
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            margin: EdgeInsets.fromLTRB(8.w, 0, 8.w, 20.h),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(children: [
              Icon(Icons.logout, size: 16.sp, color: AppColors.gray), SizedBox(width: 10.w),
              Text('Log out', style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.gray)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 18.w),
    child: Text(text, style: GoogleFonts.inter(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.gray, letterSpacing: 0.6)),
  );
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({required this.item, required this.isSelected, required this.onTap});
  final _NavItem item; final bool isSelected; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(8.r),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(children: [
        Icon(item.icon, size: 16.sp, color: isSelected ? AppColors.primary : AppColors.gray),
        SizedBox(width: 10.w),
        Text(item.label, style: GoogleFonts.inter(fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.primary : AppColors.textColor)),
      ]),
    ),
  );
}

class _NavItem {
  const _NavItem({required this.icon, required this.label, required this.index});
  final IconData icon; final String label; final int index;
}
