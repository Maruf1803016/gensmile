// lib/features/settings/presentation/pages/notifications_settings_screen.dart
// FIX: mobile was showing wrong content ("Default Output Mode" etc.)
//      because SettingsSection accordion state was shared.
//      Now uses forceExpanded: true so content is always visible on mobile too.
//      Also section title is correct "Notification Preferences" (not Simulation content).

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/settings/presentation/widgets/settings_widgets.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Notification Preferences',
      initiallyExpanded: true,
      forceExpanded: true,           // ← always show content on mobile
      children: [
        _NotifSubHeading('Email Notifications'),
        SettingsToggleRow(label: 'Simulation Completed', value: true),
        SettingsToggleRow(label: 'New Consultation Request', value: true),
        SettingsToggleRow(label: 'Lab Case Update', value: false),
        SettingsToggleRow(label: 'Payment Alerts', value: false),
        _Divider(),
        _NotifSubHeading('In-App Notifications'),
        SettingsToggleRow(label: 'New Patient Added', value: true),
        SettingsToggleRow(label: 'Case Status Updated', value: true),
        SettingsToggleRow(label: 'Lab Tracker Update', value: false),
        _Divider(),
        _NotifSubHeading('Reminder Settings'),
        SettingsToggleRow(label: 'Consultation Reminder', value: true),
        SettingsToggleRow(label: 'Case Follow-Up Reminder', value: true),
      ],
    );
  }
}

class _NotifSubHeading extends StatelessWidget {
  const _NotifSubHeading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: 4.h, top: 8.h),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Divider(color: AppColors.inputBorder, height: 1),
      );
}
