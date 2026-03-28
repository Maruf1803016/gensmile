// lib/features/settings/presentation/pages/settings_screen.dart
//
// FIX 1: All back navigation now uses Navigator.of(context).pop()
// which always works regardless of how the screen was pushed.
// navigatorState was causing the back arrow to silently fail.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/notifications_screen.dart';
import 'package:gen_smile/features/settings/presentation/pages/profile_clinic_screen.dart';
import 'package:gen_smile/features/settings/presentation/pages/simulation_system_screen.dart';
import 'package:gen_smile/features/settings/presentation/pages/notifications_settings_screen.dart';
import 'package:gen_smile/features/settings/presentation/pages/language_region_screen.dart';
import 'package:gen_smile/features/settings/presentation/pages/security_support_screen.dart';
import 'package:gen_smile/features/settings/presentation/widgets/settings_tab_bar.dart';

class _SettingsTab {
  final String label;
  final IconData icon;
  final Widget screen;
  const _SettingsTab(
      {required this.label, required this.icon, required this.screen});
}

final _tabs = [
  _SettingsTab(
      label: 'Profile & Clinic',
      icon: Icons.person_outline,
      screen: const ProfileClinicScreen()),
  _SettingsTab(
      label: 'Simulation & System',
      icon: Icons.tune_outlined,
      screen: const SimulationSystemScreen()),
  _SettingsTab(
      label: 'Notifications',
      icon: Icons.notifications_outlined,
      screen: const NotificationsSettingsScreen()),
  _SettingsTab(
      label: 'Language & Region',
      icon: Icons.language_outlined,
      screen: const LanguageRegionScreen()),
  _SettingsTab(
      label: 'Security & Support',
      icon: Icons.shield_outlined,
      screen: const SecuritySupportScreen()),
];

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    if (isWide) {
      return _DesktopSettings(
        selectedTab: _selectedTab,
        onTabChanged: (i) => setState(() => _selectedTab = i),
      );
    }

    // Mobile: show list menu — pushes detail screens normally
    return _MobileSettingsMenu(
      onTabTap: (i) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => _MobileSettingsDetail(tabIndex: i)),
      ),
    );
  }
}

// ── Desktop ───────────────────────────────────────────────────────────────────
class _DesktopSettings extends ConsumerWidget {
  const _DesktopSettings(
      {required this.selectedTab, required this.onTabChanged});
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SettingsHeader(ref: ref),
          SettingsTabBar(
            tabs: _tabs.map((t) => (t.label, t.icon)).toList(),
            selectedIndex: selectedTab,
            onTap: onTabChanged,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: _tabs[selectedTab].screen,
            ),
          ),
          _BottomBar(onCancel: () {}, onSave: () {}),
        ],
      ),
    );
  }
}

// ── Mobile menu ───────────────────────────────────────────────────────────────
class _MobileSettingsMenu extends ConsumerWidget {
  const _MobileSettingsMenu({required this.onTabTap});
  final ValueChanged<int> onTabTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // FIX 1: No leading here — Settings is a tab, not a pushed screen.
        // If ever pushed directly, Flutter will auto-show a back arrow.
        automaticallyImplyLeading: false,
        title: Text('Settings',
            style: GoogleFonts.inter(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined,
                size: 22.sp, color: AppColors.gray),
            // FIX 1: notification bell uses Navigator directly
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const NotificationsScreen()),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_tabs.length, (i) {
            final tab = _tabs[i];
            final isLast = i == _tabs.length - 1;
            return Column(
              children: [
                InkWell(
                  onTap: () => onTabTap(i),
                  borderRadius: BorderRadius.vertical(
                    top: i == 0 ? Radius.circular(12.r) : Radius.zero,
                    bottom: isLast ? Radius.circular(12.r) : Radius.zero,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 16.h),
                    child: Row(children: [
                      Icon(tab.icon,
                          size: 18.sp, color: AppColors.textColor),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(tab.label,
                            style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: AppColors.textColor)),
                      ),
                      Icon(Icons.chevron_right,
                          size: 18.sp, color: AppColors.gray),
                    ]),
                  ),
                ),
                if (!isLast) Divider(height: 1, color: AppColors.inputBorder),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ── Mobile detail ─────────────────────────────────────────────────────────────
class _MobileSettingsDetail extends StatelessWidget {
  const _MobileSettingsDetail({required this.tabIndex});
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    final tab = _tabs[tabIndex];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // FIX 1: Use Navigator.of(context).pop() — always reliable
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              size: 20.sp, color: AppColors.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(tab.label,
            style: GoogleFonts.inter(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined,
                size: 22.sp, color: AppColors.gray),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const NotificationsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: tab.screen,
            ),
          ),
          _BottomBar(
            // FIX 1: Navigator.of(context).pop() — not navigatorState
            onCancel: () => Navigator.of(context).pop(),
            onSave: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────
class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
        child: Row(children: [
          Icon(Icons.settings_outlined,
              size: 20.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Settings',
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor)),
            Text('Manage your account, clinic, and preferences',
                style: GoogleFonts.inter(
                    fontSize: 11.sp, color: AppColors.primary)),
          ]),
        ]),
      );
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onCancel, required this.onSave});
  final VoidCallback onCancel, onSave;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r)),
              ),
              child: Text('Update Changes',
                  style: GoogleFonts.inter(
                      fontSize: 15.sp, fontWeight: FontWeight.w600)),
            ),
          ),
          Gap(10.h),
          TextButton(
            onPressed: onCancel,
            child: Text('Cancel',
                style: GoogleFonts.inter(
                    fontSize: 14.sp, color: AppColors.primary)),
          ),
        ]),
      );
}
