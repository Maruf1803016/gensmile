// lib/features/staff/presentation/pages/staff_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import '../../data/models/staff_model.dart';
import '../../states/staff_state.dart';
import 'staff_details_screen.dart';
import 'add_staff_screen.dart';
import 'send_invite_screen.dart';

class StaffScreen extends ConsumerStatefulWidget {
  const StaffScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  ConsumerState<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends ConsumerState<StaffScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staff = ref.watch(filteredStaffProvider);
    final counts = ref.watch(staffCountsProvider);
    final filter = ref.watch(staffFilterProvider);
    final seatUsage = ref.watch(seatUsageProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
          // ── Top bar ──────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: SafeArea(
              bottom: false,
              child: isWide
                  ? _DesktopHeader(seatUsage: seatUsage)
                  : _MobileHeader(seatUsage: seatUsage),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search + filter bar
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: isWide
                          ? _DesktopFilterBar(
                              controller: _searchCtrl,
                              filter: filter,
                              counts: counts,
                              seatUsage: seatUsage,
                            )
                          : _MobileFilterBar(
                              controller: _searchCtrl,
                              filter: filter,
                              counts: counts,
                            ),
                    ),

                    // Table / List
                    isWide
                        ? _DesktopStaffTable(staff: staff)
                        : _MobileStaffList(staff: staff),

                    // Pagination (desktop only)
                    if (isWide) _Pagination(total: staff.length),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Desktop Header ─────────────────────────────────────────────────────────────

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({required this.seatUsage});
  final String seatUsage;

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
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                'Manage your clinic team members',
                style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
              ),
            ],
          ),
        ),
        Consumer(
          builder: (context, ref, _) => ElevatedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddStaffScreen()),
            ),
            icon: Icon(Icons.add, size: 16.sp),
            label: Text(
              'Add Staff',
              style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Mobile Header ──────────────────────────────────────────────────────────────

class _MobileHeader extends StatelessWidget {
  const _MobileHeader({required this.seatUsage});
  final String seatUsage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Staff Directory',
            style: GoogleFonts.inter(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddStaffScreen()),
          ),
          child: Icon(Icons.add, size: 22.sp, color: AppColors.textColor),
        ),
      ],
    );
  }
}

// ── Desktop Filter Bar ─────────────────────────────────────────────────────────

class _DesktopFilterBar extends ConsumerWidget {
  const _DesktopFilterBar({
    required this.controller,
    required this.filter,
    required this.counts,
    required this.seatUsage,
  });

  final TextEditingController controller;
  final StaffFilterTab filter;
  final Map<StaffFilterTab, int> counts;
  final String seatUsage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Search
        Expanded(
          child: SizedBox(
            height: 36.h,
            child: TextField(
              controller: controller,
              onChanged: (v) => ref.read(staffSearchProvider.notifier).state = v,
              style: GoogleFonts.inter(fontSize: 13.sp),
              decoration: InputDecoration(
                hintText: 'Search by name, email, or role',
                hintStyle: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
                prefixIcon: Icon(Icons.search, size: 16.sp, color: AppColors.gray),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Filter tabs
        _FilterChip(
          label: 'All',
          isSelected: filter == StaffFilterTab.all,
          onTap: () => ref.read(staffFilterProvider.notifier).state = StaffFilterTab.all,
          filled: true,
        ),
        SizedBox(width: 6.w),
        _FilterChip(
          label: 'Active (${counts[StaffFilterTab.active]})',
          isSelected: filter == StaffFilterTab.active,
          onTap: () => ref.read(staffFilterProvider.notifier).state = StaffFilterTab.active,
        ),
        SizedBox(width: 6.w),
        _FilterChip(
          label: 'Pending (${counts[StaffFilterTab.pending]})',
          isSelected: filter == StaffFilterTab.pending,
          onTap: () => ref.read(staffFilterProvider.notifier).state = StaffFilterTab.pending,
        ),
        SizedBox(width: 6.w),
        _FilterChip(
          label: 'Inactive (${counts[StaffFilterTab.inactive]})',
          isSelected: filter == StaffFilterTab.inactive,
          onTap: () => ref.read(staffFilterProvider.notifier).state = StaffFilterTab.inactive,
        ),
        SizedBox(width: 12.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.inputBorder),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            'Seat Usage: $seatUsage',
            style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.textColor),
          ),
        ),
      ],
    );
  }
}

// ── Mobile Filter Bar ──────────────────────────────────────────────────────────

class _MobileFilterBar extends ConsumerWidget {
  const _MobileFilterBar({
    required this.controller,
    required this.filter,
    required this.counts,
  });

  final TextEditingController controller;
  final StaffFilterTab filter;
  final Map<StaffFilterTab, int> counts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Search
        SizedBox(
          height: 40.h,
          child: TextField(
            controller: controller,
            onChanged: (v) => ref.read(staffSearchProvider.notifier).state = v,
            style: GoogleFonts.inter(fontSize: 13.sp),
            decoration: InputDecoration(
              hintText: 'Search by name, phone, or ID',
              hintStyle: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
              prefixIcon: Icon(Icons.search, size: 16.sp, color: AppColors.gray),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(color: AppColors.inputBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(color: AppColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: 'All',
                isSelected: filter == StaffFilterTab.all,
                onTap: () => ref.read(staffFilterProvider.notifier).state = StaffFilterTab.all,
                filled: true,
              ),
              SizedBox(width: 8.w),
              _FilterChip(
                label: 'Active (${counts[StaffFilterTab.active]})',
                isSelected: filter == StaffFilterTab.active,
                onTap: () => ref.read(staffFilterProvider.notifier).state = StaffFilterTab.active,
              ),
              SizedBox(width: 8.w),
              _FilterChip(
                label: 'Pending (${counts[StaffFilterTab.pending]})',
                isSelected: filter == StaffFilterTab.pending,
                onTap: () => ref.read(staffFilterProvider.notifier).state = StaffFilterTab.pending,
              ),
              SizedBox(width: 8.w),
              _FilterChip(
                label: 'Inactive (${counts[StaffFilterTab.inactive]})',
                isSelected: filter == StaffFilterTab.inactive,
                onTap: () => ref.read(staffFilterProvider.notifier).state = StaffFilterTab.inactive,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Desktop Staff Table ────────────────────────────────────────────────────────

class _DesktopStaffTable extends ConsumerWidget {
  const _DesktopStaffTable({required this.staff});
  final List<StaffMember> staff;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.5),
        1: FlexColumnWidth(1.8),
        2: FlexColumnWidth(2.2),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(2.2),
      },
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.inputBorder),
              bottom: BorderSide(color: AppColors.inputBorder),
            ),
          ),
          children: [
            _TableHeader('Name'),
            _TableHeader('Role'),
            _TableHeader('Contact'),
            _TableHeader('Status'),
            _TableHeader('Actions'),
          ],
        ),
        // Rows
        ...staff.map(
          (member) => TableRow(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
            ),
            children: [
              _NameCell(member: member),
              _RoleCell(role: member.role),
              _ContactCell(email: member.email, phone: member.phone),
              _StatusCell(status: member.status),
              _ActionsCell(member: member),
            ],
          ),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.gray,
          ),
        ),
      );
}

class _NameCell extends StatelessWidget {
  const _NameCell({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            _StaffAvatar(member: member, radius: 18),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    'S00${member.id}',
                    style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _RoleCell extends StatelessWidget {
  const _RoleCell({required this.role});
  final String role;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: _RoleBadge(role: role),
      );
}

class _ContactCell extends StatelessWidget {
  const _ContactCell({required this.email, required this.phone});
  final String email, phone;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mail_outline, size: 12.sp, color: AppColors.gray),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    email,
                    style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 12.sp, color: AppColors.gray),
                SizedBox(width: 4.w),
                Text(
                  phone,
                  style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.textColor),
                ),
              ],
            ),
          ],
        ),
      );
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({required this.status});
  final StaffStatus status;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: _StatusBadge(status: status),
      );
}

class _ActionsCell extends ConsumerWidget {
  const _ActionsCell({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            _ActionBtn(
              icon: Icons.shield_outlined,
              label: 'Permissions',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => StaffDetailsScreen(member: member)),
              ),
            ),
            if (member.status == StaffStatus.active) ...[
              SizedBox(width: 8.w),
              _ActionBtn(
                icon: Icons.send_outlined,
                label: 'Send',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => SendInviteScreen(member: member)),
                ),
              ),
            ],
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () => _showDeleteDialog(context, ref, member),
              child: Icon(Icons.delete_outline, size: 16.sp, color: AppColors.error),
            ),
          ],
        ),
      );

  void _showDeleteDialog(BuildContext context, WidgetRef ref, StaffMember member) {
    showDialog(
      context: context,
      builder: (_) => _DeleteStaffDialog(member: member),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 14.sp, color: AppColors.gray),
            SizedBox(width: 4.w),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.textColor),
            ),
          ],
        ),
      );
}

// ── Mobile Staff List ──────────────────────────────────────────────────────────

class _MobileStaffList extends ConsumerWidget {
  const _MobileStaffList({required this.staff});
  final List<StaffMember> staff;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: staff.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.inputBorder),
      itemBuilder: (_, i) => _MobileStaffTile(member: staff[i]),
    );
  }
}

class _MobileStaffTile extends ConsumerWidget {
  const _MobileStaffTile({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StaffAvatar(member: member, radius: 20),
          SizedBox(width: 10.w),
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
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                    _RoleBadge(role: member.role, small: true),
                    SizedBox(width: 8.w),
                    _StatusBadge(status: member.status, small: true),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  member.phone,
                  style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
                ),
                Text(
                  member.email,
                  style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    if (member.status == StaffStatus.active) ...[
                      _MobileActionBtn(
                        icon: Icons.delete_outline,
                        label: 'Delete',
                        color: AppColors.error,
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => _DeleteStaffDialog(member: member),
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => StaffDetailsScreen(member: member),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'View Profile',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

class _MobileActionBtn extends StatelessWidget {
  const _MobileActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 14.sp, color: color),
        label: Text(
          label,
          style: GoogleFonts.inter(fontSize: 12.sp, color: color, fontWeight: FontWeight.w500),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          side: BorderSide(color: color.withOpacity(0.4)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      );
}

// ── Pagination ─────────────────────────────────────────────────────────────────

class _Pagination extends StatelessWidget {
  const _Pagination({required this.total});
  final int total;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Text(
              'Showing $total of 100 staff members',
              style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
            ),
            const Spacer(),
            _PageBtn(label: 'Prev', onTap: () {}),
            SizedBox(width: 4.w),
            _PageBtn(label: '1', isActive: true, onTap: () {}),
            SizedBox(width: 4.w),
            _PageBtn(label: '2', onTap: () {}),
            SizedBox(width: 4.w),
            _PageBtn(label: '3', onTap: () {}),
            SizedBox(width: 4.w),
            Text('...', style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray)),
            SizedBox(width: 4.w),
            _PageBtn(label: '10', onTap: () {}),
            SizedBox(width: 4.w),
            _PageBtn(label: 'Next', onTap: () {}),
          ],
        ),
      );
}

class _PageBtn extends StatelessWidget {
  const _PageBtn({required this.label, required this.onTap, this.isActive = false});
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(4.r),
            border: isActive ? null : Border.all(color: AppColors.inputBorder),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: isActive ? Colors.white : AppColors.textColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      );
}

// ── Delete Dialog ──────────────────────────────────────────────────────────────

class _DeleteStaffDialog extends ConsumerWidget {
  const _DeleteStaffDialog({required this.member});
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
              decoration: const BoxDecoration(
                color: Color(0xFFEE6A5F),
                shape: BoxShape.circle,
              ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(staffListProvider.notifier).removeStaff(member.id);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
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

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final bool isSelected, filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            border: isSelected ? null : Border.all(color: AppColors.inputBorder),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textColor,
            ),
          ),
        ),
      );
}

class _StaffAvatar extends StatelessWidget {
  const _StaffAvatar({required this.member, required this.radius});
  final StaffMember member;
  final double radius;

  static const _colors = [
    Color(0xFF0052CC),
    Color(0xFF009965),
    Color(0xFFFAA04E),
    Color(0xFFEE6A5F),
    Color(0xFF55549B),
  ];

  @override
  Widget build(BuildContext context) {
    final colorIdx = member.name.codeUnits.first % _colors.length;
    return CircleAvatar(
      radius: radius.r,
      backgroundColor: _colors[colorIdx],
      child: Text(
        member.initials,
        style: GoogleFonts.inter(
          fontSize: (radius * 0.55).sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role, this.small = false});
  final String role;
  final bool small;

  Color _bg() {
    if (role.contains('Lead')) return const Color(0xFFE8F4FD);
    if (role.contains('Associate')) return const Color(0xFFF0F4FF);
    if (role.contains('Treatment')) return const Color(0xFFF0FFF8);
    if (role.contains('Lab')) return const Color(0xFFFFF7E6);
    if (role.contains('Billing')) return const Color(0xFFF5F0FF);
    if (role.contains('Hygienist')) return const Color(0xFFFFF0F5);
    return AppColors.surfaceBrand;
  }

  Color _fg() {
    if (role.contains('Lead')) return const Color(0xFF0369A1);
    if (role.contains('Associate')) return const Color(0xFF3730A3);
    if (role.contains('Treatment')) return const Color(0xFF047857);
    if (role.contains('Lab')) return const Color(0xFFD97706);
    if (role.contains('Billing')) return const Color(0xFF7C3AED);
    if (role.contains('Hygienist')) return const Color(0xFFDB2777);
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: small ? 6.w : 8.w,
          vertical: small ? 2.h : 4.h,
        ),
        decoration: BoxDecoration(
          color: _bg(),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          role,
          style: GoogleFonts.inter(
            fontSize: small ? 10.sp : 11.sp,
            fontWeight: FontWeight.w500,
            color: _fg(),
          ),
        ),
      );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, this.small = false});
  final StaffStatus status;
  final bool small;

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
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6.w : 10.w,
        vertical: small ? 2.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: small ? 10.sp : 12.sp,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}
