// lib/features/patients/presentation/pages/patients_screen.dart
// FIXES:
//   - Back arrow on mobile embedded → sets dashboardIndex = 0
//   - PNG Assets.imagesUserCheck01 for header (not SVG icon)
//   - Notification bell navigates to NotificationsScreen
//   - Add New Patient button → AddNewPatientScreen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/notifications_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/patient_details_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/new_simulation_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/add_new_patient_screen.dart';
import 'package:gen_smile/generated/assets.dart';

final patientFilterProvider = StateProvider<String>((ref) => 'All');
final patientSearchProvider = StateProvider<String>((ref) => '');

const _kPatients = [
  _Pat('P001', 'John Williams', '+1 (555) 234-5678', 'JW', Color(0xFF7C3AED)),
  _Pat('P002', 'Sarah Davis', '+1 (555) 234-5678', 'SD', Color(0xFFDB2777)),
  _Pat('P003', 'Michael Tan', '+1 (555) 234-5678', 'MT', Color(0xFF059669)),
  _Pat('P004', 'Emily Chen', '+1 (555) 234-5678', 'EC', Color(0xFF0284C7)),
  _Pat('P005', 'David Brown', '+1 (555) 234-5678', 'DB', Color(0xFFD97706)),
];

const _kFilters = [
  'All',
  'Active',
  'Treatment',
  'Completed',
  'Next Appointment',
];

class PatientsScreen extends ConsumerWidget {
  const PatientsScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final activeFilter = ref.watch(patientFilterProvider);
    final query = ref.watch(patientSearchProvider);

    final filtered = _kPatients
        .where(
          (p) =>
              query.isEmpty ||
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.phone.contains(query),
        )
        .toList();

    final body = Column(
      children: [
        // ── Top bar ────────────────────────────────────────────────────
        Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
              child: Row(
                children: [
                  // Back arrow on mobile embedded
                  if (embedded && !isWide)
                    GestureDetector(
                      onTap: () =>
                          ref.read(dashboardIndexProvider.notifier).state = 0,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Icon(
                          Icons.arrow_back,
                          size: 22.sp,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  // FIX: PNG image header icon
                  SvgPicture.asset(
                    Assets.iconsPatient,
                    width: 22.w,
                    height: 22.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient Management',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          'View and manage all clinic patients',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isWide) ...[
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddNewPatientScreen(),
                        ),
                      ),
                      icon: Icon(Icons.add, size: 14.sp),
                      label: Text(
                        'Add New Patient',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 10.h,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  // FIX: bell navigates
                  GestureDetector(
                    onTap: () => ref
                        .read(navigatorState.notifier)
                        .push(const NotificationsScreen()),
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
                ],
              ),
            ),
          ),
        ),

        // ── Body ───────────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient list card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          children: [
                            // Search bar
                            Container(
                              height: 38.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F6FA),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: AppColors.inputBorder,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 10.w),
                                  Icon(
                                    Icons.search,
                                    size: 16.sp,
                                    color: AppColors.gray,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (v) =>
                                          ref
                                                  .read(
                                                    patientSearchProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              v,
                                      style: GoogleFonts.inter(fontSize: 12.sp),
                                      decoration: InputDecoration(
                                        hintText: 'Search by Name / Phone / ID',
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
                            SizedBox(height: 10.h),
                            // Filter pills
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _kFilters
                                    .map(
                                      (f) => GestureDetector(
                                        onTap: () =>
                                            ref
                                                    .read(
                                                      patientFilterProvider
                                                          .notifier,
                                                    )
                                                    .state =
                                                f,
                                        child: Container(
                                          margin: EdgeInsets.only(right: 8.w),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 14.w,
                                            vertical: 7.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: activeFilter == f
                                                ? AppColors.primary
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              20.r,
                                            ),
                                            border: Border.all(
                                              color: activeFilter == f
                                                  ? AppColors.primary
                                                  : AppColors.inputBorder,
                                            ),
                                          ),
                                          child: Text(
                                            f,
                                            style: GoogleFonts.inter(
                                              fontSize: 12.sp,
                                              fontWeight: activeFilter == f
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                              color: activeFilter == f
                                                  ? Colors.white
                                                  : AppColors.gray,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Showing ${filtered.length} of ${_kPatients.length} patients',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      if (isWide)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            border: Border(
                              top: BorderSide(color: AppColors.inputBorder),
                              bottom: BorderSide(color: AppColors.inputBorder),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 80.w, child: _hCell('Serial No')),
                              Expanded(child: _hCell('Patient Name')),
                              SizedBox(
                                width: 180.w,
                                child: _hCell('Phone Number'),
                              ),
                              SizedBox(width: 140.w, child: _hCell('Actions')),
                            ],
                          ),
                        ),
                      ...filtered.map(
                        (p) => _PatRow(
                          p: p,
                          isWide: isWide,
                          onView: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PatientDetailsScreen(patient: p),
                            ),
                          ),
                          onSim: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NewSimulationScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(16.h),
                if (!isWide) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Patient List',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View All',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(8.h),
                  ...filtered.map(
                    (p) => _MobRow(
                      p: p,
                      onView: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PatientDetailsScreen(patient: p),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );

    if (!embedded) {
      return Scaffold(backgroundColor: const Color(0xFFF4F5F7), body: body);
    }
    return ColoredBox(color: const Color(0xFFF4F5F7), child: body);
  }

  Widget _hCell(String t) => Text(
    t,
    style: GoogleFonts.inter(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.gray,
      letterSpacing: 0.5,
    ),
  );
}

// ─── Row widgets ──────────────────────────────────────────────────────────────
class _PatRow extends StatelessWidget {
  const _PatRow({
    required this.p,
    required this.isWide,
    required this.onView,
    required this.onSim,
  });
  final _Pat p;
  final bool isWide;
  final VoidCallback onView, onSim;

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14.r,
              backgroundColor: p.color,
              child: Text(
                p.initials,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    p.phone,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onView,
              child: Icon(
                Icons.visibility_outlined,
                size: 18.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: onSim,
              child: Icon(
                Icons.auto_awesome_outlined,
                size: 18.sp,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              p.id,
              style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14.r,
                  backgroundColor: p.color,
                  child: Text(
                    p.initials,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  p.name,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 180.w,
            child: Text(
              p.phone,
              style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
            ),
          ),
          SizedBox(
            width: 140.w,
            child: Row(
              children: [
                _Btn(
                  icon: Icons.visibility_outlined,
                  label: 'View',
                  onTap: onView,
                ),
                SizedBox(width: 8.w),
                _Btn(
                  icon: Icons.auto_awesome_outlined,
                  label: 'Simulate',
                  onTap: onSim,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobRow extends StatelessWidget {
  const _MobRow({required this.p, required this.onView});
  final _Pat p;
  final VoidCallback onView;
  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: 8.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: AppColors.inputBorder),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 16.r,
          backgroundColor: p.color,
          child: Text(
            p.initials,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.name,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                p.phone,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: AppColors.gray,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onView,
          child: Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 16.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 4.w),
              Text(
                'View',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Btn extends StatelessWidget {
  const _Btn({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: AppColors.primary),
        SizedBox(width: 4.w),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class _Pat {
  const _Pat(this.id, this.name, this.phone, this.initials, this.color);
  final String id, name, phone, initials;
  final Color color;
}
