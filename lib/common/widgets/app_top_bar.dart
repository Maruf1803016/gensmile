import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/notifications_screen.dart';
import 'package:gen_smile/generated/assets.dart';

/// Shared top-bar used by EVERY main screen.
///
/// Fixes:
///   FIX 6 / FIX 9: notification bell navigates correctly from any screen.
///   FIX 7: search bar is functional (calls [onSearch]); avatar opens profile sheet.
///   FIX 8: avatar uses Assets.imagesUser (the user PNG).
class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.showSearch = false,
    this.onSearch,
    this.showNotification = true,
    this.showAvatar = true,
    this.extraActions = const [],
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool showSearch;
  final ValueChanged<String>? onSearch;
  final bool showNotification;
  final bool showAvatar;
  final List<Widget> extraActions;

  @override
  Size get preferredSize => Size.fromHeight(showSearch ? 96.h : 56.h);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Title row ───────────────────────────────────────────────────
            SizedBox(
              height: 56.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    if (leading != null) ...[leading!, SizedBox(width: 8.w)],
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: AppColors.gray,
                              ),
                            ),
                        ],
                      ),
                    ),
                    ...extraActions,
                    // FIX 9: notification bell works from ANY screen via navigatorState
                    if (showNotification)
                      GestureDetector(
                        onTap: () => ref
                            .read(navigatorState.notifier)
                            .push(const NotificationsScreen()),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
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
                      ),
                    // FIX 7 + FIX 8: avatar opens profile bottom sheet
                    if (showAvatar)
                      GestureDetector(
                        onTap: () => _showProfileSheet(context),
                        child: Padding(
                          padding: EdgeInsets.only(left: 6.w),
                          child: CircleAvatar(
                            radius: 16.r,
                            backgroundColor: AppColors.primary,
                            backgroundImage: AssetImage(
                              Assets.imagesProfileAvatar,
                            ), // FIX 8
                            onBackgroundImageError: (_, __) {},
                            child: null,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // ── Optional search bar ──────────────────────────────────────────
            if (showSearch)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
                child: Container(
                  height: 38.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10.w),
                      Icon(Icons.search, size: 16.sp, color: AppColors.gray),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          // FIX 7: search bar now functional
                          onChanged: onSearch,
                          style: GoogleFonts.inter(fontSize: 12.sp),
                          decoration: InputDecoration(
                            hintText: 'Search patients, cases...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppColors.gray,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // FIX 8: user image
            CircleAvatar(
              radius: 36.r,
              backgroundColor: AppColors.primary,
              backgroundImage: AssetImage(Assets.imagesProfileAvatar),
              onBackgroundImageError: (_, __) {},
            ),
            SizedBox(height: 12.h),
            Text(
              'Dr. Smith',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            Text(
              'Chief Surgeon · Alpha Dental Clinic',
              style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
            ),
            SizedBox(height: 20.h),
            _ProfileAction(icon: Icons.person_outline, label: 'View Profile'),
            _ProfileAction(icon: Icons.settings_outlined, label: 'Settings'),
            _ProfileAction(
              icon: Icons.logout,
              label: 'Log Out',
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });
  final IconData icon;
  final String label;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(
      icon,
      color: isDestructive ? AppColors.danger : AppColors.gray,
    ),
    title: Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        color: isDestructive ? AppColors.danger : AppColors.textColor,
      ),
    ),
    onTap: () => Navigator.pop(context),
    dense: true,
  );
}
