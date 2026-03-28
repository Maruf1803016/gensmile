// lib/features/staff/presentation/pages/staff_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import '../../data/models/staff_model.dart';
import '../../states/staff_state.dart';
import 'send_invite_screen.dart';

class StaffDetailsScreen extends ConsumerWidget {
  const StaffDetailsScreen({super.key, required this.member});

  final StaffMember member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
          // ── Top bar ────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: SafeArea(
              bottom: false,
              child: isWide
                  ? _DesktopTopBar(member: member)
                  : _MobileTopBar(member: member),
            ),
          ),

          // ── Body ───────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: isWide
                  ? _DesktopBody(member: member)
                  : _MobileBody(member: member),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Desktop Top Bar ────────────────────────────────────────────────────────────

class _DesktopTopBar extends StatelessWidget {
  const _DesktopTopBar({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceBrand,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(Icons.people_outline, size: 20.sp, color: AppColors.primary),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Staff Directory',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                'Manage your clinic team members',
                style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.shield_outlined, size: 14.sp),
          label: Text(
            'Permissions',
            style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textColor,
            side: BorderSide(color: AppColors.inputBorder),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
        ),
        SizedBox(width: 8.w),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.edit_outlined, size: 14.sp),
          label: Text(
            'Edit',
            style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
        ),
        SizedBox(width: 8.w),
        Consumer(
          builder: (context, ref, _) => OutlinedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => _ConfirmRemoveDialog(member: member),
            ),
            icon: Icon(Icons.delete_outline, size: 14.sp),
            label: Text(
              'Remove',
              style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: BorderSide(color: AppColors.error.withOpacity(0.4)),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Mobile Top Bar ─────────────────────────────────────────────────────────────

class _MobileTopBar extends StatelessWidget {
  const _MobileTopBar({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back, size: 22.sp, color: AppColors.textColor),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            'Case Details',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
        ),
        Icon(Icons.notifications_outlined, size: 20.sp, color: AppColors.gray),
      ],
    );
  }
}

// ── Desktop Body ───────────────────────────────────────────────────────────────

class _DesktopBody extends StatelessWidget {
  const _DesktopBody({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _ProfileCard(member: member),
              SizedBox(height: 16.h),
              _StatsRow(member: member),
              SizedBox(height: 16.h),
              _RecentActivityCard(activities: member.recentActivity),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        SizedBox(
          width: 260.w,
          child: _PermissionsCard(member: member),
        ),
      ],
    );
  }
}

// ── Mobile Body ────────────────────────────────────────────────────────────────

class _MobileBody extends StatelessWidget {
  const _MobileBody({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MobileProfileCard(member: member),
        SizedBox(height: 16.h),
        _StatsRow(member: member),
        SizedBox(height: 16.h),
        _RecentActivityCard(activities: member.recentActivity),
        SizedBox(height: 16.h),
        _MobilePermissionsCard(member: member),
        SizedBox(height: 16.h),
        // Send button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SendInviteScreen(member: member)),
            ),
            icon: Icon(Icons.send_outlined, size: 14.sp),
            label: Text(
              'Send',
              style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Consumer(
          builder: (context, ref, _) => SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => _ConfirmRemoveDialog(member: member),
              ),
              icon: Icon(Icons.delete_outline, size: 14.sp, color: AppColors.error),
              label: Text(
                'Remove',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                side: BorderSide(color: AppColors.error.withOpacity(0.4)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Profile Card (Desktop) ─────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 36.r,
            backgroundColor: AppColors.primary,
            child: Text(
              member.initials,
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _StatusBadgeSmall(status: member.status),
                  ],
                ),
                Text(
                  member.role,
                  style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray),
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 16.w,
                  runSpacing: 6.h,
                  children: [
                    _InfoRow(label: 'Employee ID', value: member.employeeId),
                    _InfoRow(label: 'Department', value: member.department),
                    _InfoRow(label: 'Address', value: member.address),
                    _InfoRow(label: 'Email', value: member.email),
                    _InfoRow(label: 'Phone', value: member.phone),
                    _InfoRow(
                      label: 'Joined',
                      value: DateFormat('MMM d, yyyy').format(member.joinedDate),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Card (Mobile) ─────────────────────────────────────────────────────

class _MobileProfileCard extends StatelessWidget {
  const _MobileProfileCard({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: AppColors.primary,
                child: Text(
                  member.initials,
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            member.name,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        _StatusBadgeSmall(status: member.status),
                      ],
                    ),
                    Text(
                      member.role,
                      style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
                    ),
                    Text(
                      'Joined: ${DateFormat('MMM d, yyyy').format(member.joinedDate)}',
                      style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Additional Information',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          _MobileInfoRow(label: 'Department:', value: member.department),
          _MobileInfoRow(label: 'Employee ID:', value: member.employeeId),
          _MobileInfoRow(label: 'Address:', value: member.address),
          _MobileInfoRow(label: 'Email:', value: member.email),
          _MobileInfoRow(label: 'Phone:', value: member.phone),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit_outlined, size: 14.sp),
              label: Text(
                'Edit',
                style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileInfoRow extends StatelessWidget {
  const _MobileInfoRow({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: 4.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ],
        ),
      );
}

// ── Stats Row ──────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(icon: Icons.people_outline, value: '${member.totalPatients}', label: 'Total Patients'),
        SizedBox(width: 12.w),
        _StatCard(icon: Icons.show_chart, value: '${member.activeCases}', label: 'Active Cases'),
        SizedBox(width: 12.w),
        _StatCard(icon: Icons.check_circle_outline, value: '${member.completed}', label: 'Completed'),
        SizedBox(width: 12.w),
        _StatCard(icon: Icons.show_chart, value: '${member.avgRating}', label: 'Avg Rating'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value, label;

  @override
  Widget build(BuildContext context) => Expanded(
        child: _Card(
          child: Column(
            children: [
              Icon(icon, size: 22.sp, color: AppColors.primary),
              SizedBox(height: 6.h),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

// ── Recent Activity ────────────────────────────────────────────────────────────

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({required this.activities});
  final List<StaffActivity> activities;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 12.h),
          ...activities.map((a) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  children: [
                    Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBrand,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        _iconForType(a.type),
                        size: 14.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.description,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppColors.textColor,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 10.sp, color: AppColors.gray),
                              SizedBox(width: 3.w),
                              Text(
                                a.timeAgo,
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  IconData _iconForType(StaffActivityType type) {
    switch (type) {
      case StaffActivityType.simulation:
        return Icons.show_chart;
      case StaffActivityType.patient:
        return Icons.person_outline;
      case StaffActivityType.labLink:
        return Icons.science_outlined;
      case StaffActivityType.treatment:
        return Icons.check_circle_outline;
      case StaffActivityType.email:
        return Icons.mail_outline;
    }
  }
}

// ── Permissions Card (Desktop) ─────────────────────────────────────────────────

class _PermissionsCard extends StatelessWidget {
  const _PermissionsCard({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context) {
    final p = member.permissions;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, size: 16.sp, color: AppColors.gray),
              SizedBox(width: 6.w),
              Text(
                'Permissions',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _PermRow('view Patients', p.viewPatients),
          _PermRow('edit Patients', p.editPatients),
          _PermRow('delete Patients', p.deletePatients),
          _PermRow('run Simulations', p.runSimulations),
          _PermRow('view Reports', p.viewReports),
          _PermRow('manage Billing', p.manageBilling),
          _PermRow('manage Staff', p.manageStaff),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.shield_outlined, size: 14.sp),
              label: Text(
                'Manage Permissions',
                style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Permissions Card (Mobile) ──────────────────────────────────────────────────

class _MobilePermissionsCard extends StatelessWidget {
  const _MobilePermissionsCard({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context) {
    final p = member.permissions;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Permissions',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 12.h),
          _PermRow('view Patients', p.viewPatients),
          _PermRow('edit Patients', p.editPatients),
          _PermRow('delete Patients', p.deletePatients),
          _PermRow('run Simulations', p.runSimulations),
          _PermRow('view Reports', p.viewReports),
          _PermRow('manage Billing', p.manageBilling),
          _PermRow('manage Staff', p.manageStaff),
        ],
      ),
    );
  }
}

class _PermRow extends StatelessWidget {
  const _PermRow(this.label, this.granted);
  final String label;
  final bool granted;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.textColor)),
            Icon(
              granted ? Icons.check_circle_outline : Icons.info_outline,
              size: 16.sp,
              color: granted ? AppColors.success : AppColors.gray,
            ),
          ],
        ),
      );
}

// ── Confirm Remove Dialog ──────────────────────────────────────────────────────

class _ConfirmRemoveDialog extends ConsumerWidget {
  const _ConfirmRemoveDialog({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: const BoxDecoration(color: Color(0xFFEE6A5F), shape: BoxShape.circle),
              child: Icon(Icons.delete_outline, color: Colors.white, size: 30.sp),
            ),
            Gap(16.h),
            Text(
              'Delete Staff Member',
              style: GoogleFonts.inter(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            Gap(8.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray),
                children: [
                  const TextSpan(text: 'Are you sure you want to delete '),
                  TextSpan(
                    text: member.name,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  const TextSpan(text: '? This action cannot be undone.'),
                ],
              ),
            ),
            Gap(24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: AppColors.inputBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(staffListProvider.notifier).removeStaff(member.id);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text(
                      'Delete',
                      style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: child,
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label  ',
            style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
        ],
      );
}

class _StatusBadgeSmall extends StatelessWidget {
  const _StatusBadgeSmall({required this.status});
  final StaffStatus status;

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    String label;
    switch (status) {
      case StaffStatus.active:
        bg = AppColors.surfaceSuccess;
        fg = AppColors.success;
        label = 'Active';
        break;
      case StaffStatus.pending:
        bg = AppColors.surfaceWarning;
        fg = AppColors.warning;
        label = 'Pending';
        break;
      case StaffStatus.inactive:
        bg = AppColors.surfaceMuted;
        fg = AppColors.gray;
        label = 'Inactive';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20.r)),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 11.sp, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }
}
