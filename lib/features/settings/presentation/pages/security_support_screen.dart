import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/settings/presentation/widgets/settings_widgets.dart';

class SecuritySupportScreen extends StatelessWidget {
  const SecuritySupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Security ─────────────────────────────────────────────────────
        SettingsSection(
          title: 'Security',
          initiallyExpanded: true,
          children: [
            SettingsField(
              label: 'Current Password',
              value: '••••••••',
              obscureText: true,
              suffix: Icon(
                Icons.visibility_outlined,
                size: 16.sp,
                color: AppColors.gray,
              ),
            ),
            SettingsField(
              label: 'New Password',
              value: '••••••••',
              obscureText: true,
              suffix: Icon(
                Icons.visibility_outlined,
                size: 16.sp,
                color: AppColors.gray,
              ),
            ),
            SettingsField(
              label: 'Confirm New Password',
              value: '••••••••',
              obscureText: true,
              suffix: Icon(
                Icons.visibility_outlined,
                size: 16.sp,
                color: AppColors.gray,
              ),
            ),
            Gap(4.h),
            SettingsSubLabel('Two-Factor Authentication'),
            SettingsToggleRow(
              label: 'Enable 2FA',
              subtitle: 'Adds extra security to your account login',
              value: true,
            ),
          ],
        ),

        // ── Support & Help ────────────────────────────────────────────────
        SettingsSection(
          title: 'Support & Help',
          children: [
            _SupportGrid(
              leftTitle: 'Contact Support',
              leftItems: [
                (Icons.email_outlined, 'support@gensmile.com'),
                (Icons.phone_outlined, '+1 (800) GENSMILE'),
              ],
              rightTitle: 'Support Hours',
              rightItems: [
                (Icons.access_time_outlined, 'Mon – Fri'),
                (Icons.schedule_outlined, '9:00 AM – 6:00 PM ET'),
              ],
            ),
            Gap(16.h),
            _SupportGrid(
              leftTitle: 'Report Issues',
              leftItems: [
                (Icons.bug_report_outlined, 'bugs@gensmile.com'),
                (Icons.phone_outlined, '+1 (800) GENSMILE'),
              ],
              rightTitle: 'Resources',
              rightItems: [
                (Icons.article_outlined, 'Documentation'),
                (Icons.help_outline, 'FAQs & Tutorials'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ── Support grid (2-col info block) ──────────────────────────────────────────

class _SupportGrid extends StatelessWidget {
  const _SupportGrid({
    required this.leftTitle,
    required this.leftItems,
    required this.rightTitle,
    required this.rightItems,
  });

  final String leftTitle;
  final List<(IconData, String)> leftItems;
  final String rightTitle;
  final List<(IconData, String)> rightItems;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    Widget buildColumn(String title, List<(IconData, String)> items) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
          ),
          Gap(6.h),
          ...items.map((item) {
            final (icon, text) = item;
            return Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                children: [
                  Icon(icon, size: 13.sp, color: AppColors.primary),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      text,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    }

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: buildColumn(leftTitle, leftItems)),
          SizedBox(width: 20.w),
          Expanded(child: buildColumn(rightTitle, rightItems)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildColumn(leftTitle, leftItems),
        Gap(12.h),
        buildColumn(rightTitle, rightItems),
      ],
    );
  }
}
