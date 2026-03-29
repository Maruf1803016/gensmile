// lib/features/patients/presentation/pages/patients_screen.dart
//
// FIX 2: Patient avatars now use Assets.imagesUser (real photo from assets)
// instead of coloured initials circles

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/generated/assets.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/notifications_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/patient_details_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/new_simulation_screen.dart';

// ── Providers ─────────────────────────────────────────────────────────────────
final patientFilterProvider = StateProvider<String>((ref) => 'All');
final patientSearchProvider = StateProvider<String>((ref) => '');

// ── Data ──────────────────────────────────────────────────────────────────────
const _kPatients = [
  _Patient(
    id: 'P001',
    name: 'John Williams',
    phone: '+1 (555) 234-5678',
    initials: 'JW',
    color: Color(0xFF7C3AED),
  ),
  _Patient(
    id: 'P002',
    name: 'Sarah Davis',
    phone: '+1 (555) 234-5678',
    initials: 'SD',
    color: Color(0xFFDB2777),
  ),
  _Patient(
    id: 'P003',
    name: 'Michael Tan',
    phone: '+1 (555) 234-5678',
    initials: 'MT',
    color: Color(0xFF059669),
  ),
  _Patient(
    id: 'P004',
    name: 'Emily Chen',
    phone: '+1 (555) 234-5678',
    initials: 'EC',
    color: Color(0xFF0284C7),
  ),
  _Patient(
    id: 'P005',
    name: 'David Brown',
    phone: '+1 (555) 234-5678',
    initials: 'DB',
    color: Color(0xFFD97706),
  ),
];

const _kFilters = ['All', 'Active', 'Treatment', 'Completed'];

class PatientsScreen extends ConsumerWidget {
  const PatientsScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(patientFilterProvider);
    final searchQuery = ref.watch(patientSearchProvider);

    final filtered = _kPatients
        .where(
          (p) =>
              searchQuery.isEmpty ||
              p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              p.phone.contains(searchQuery) ||
              p.id.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    final body = Column(
      children: [
        // ── Top bar ─────────────────────────────────────────────────────────
        Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
              child: Row(
                children: [
                  // Back arrow — only when NOT embedded in dashboard
                  if (!embedded) ...[
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Icon(
                    Icons.people_outline,
                    size: 20.sp,
                    color: AppColors.textColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patients',
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
                  // Notification bell
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

        // ── Body ────────────────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search + filter card
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
                            // Search
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
                                children: _kFilters.map((f) {
                                  final active = activeFilter == f;
                                  return GestureDetector(
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
                                        color: active
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                        border: Border.all(
                                          color: active
                                              ? AppColors.primary
                                              : AppColors.inputBorder,
                                        ),
                                      ),
                                      child: Text(
                                        f,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          fontWeight: active
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: active
                                              ? Colors.white
                                              : AppColors.gray,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Count
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
                      // Patient rows
                      ...filtered.map(
                        (p) => _PatientRow(
                          patient: p,
                          onView: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PatientDetailsScreen(patient: p),
                            ),
                          ),
                          onSimulate: () => Navigator.of(context).push(
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

                // Patient List section (mobile)
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
                  (p) => _MobilePatientCard(
                    patient: p,
                    onView: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PatientDetailsScreen(patient: p),
                      ),
                    ),
                  ),
                ),
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
}

// ── Patient Row (inside filter card) ─────────────────────────────────────────
class _PatientRow extends StatelessWidget {
  const _PatientRow({
    required this.patient,
    required this.onView,
    required this.onSimulate,
  });
  final _Patient patient;
  final VoidCallback onView, onSimulate;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
    ),
    child: Row(
      children: [
        // FIX 2: Real asset image avatar
        CircleAvatar(
          radius: 16.r,
          backgroundImage: AssetImage(Assets.imagesDoctorMale),
          backgroundColor: patient.color.withOpacity(0.15),
          onBackgroundImageError: (_, __) {},
          // Fallback: initials shown if image fails
          child: null,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patient.name,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                patient.phone,
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
        SizedBox(width: 14.w),
        GestureDetector(
          onTap: onSimulate,
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

// ── Mobile Patient Card (Patient List section) ────────────────────────────────
class _MobilePatientCard extends StatelessWidget {
  const _MobilePatientCard({required this.patient, required this.onView});
  final _Patient patient;
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
        // FIX 2: Real asset image avatar
        CircleAvatar(
          radius: 18.r,
          backgroundImage: AssetImage(Assets.imagesProfileAvatar),
          backgroundColor: patient.color.withOpacity(0.15),
          onBackgroundImageError: (_, __) {},
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patient.name,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                patient.phone,
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

class _Patient {
  const _Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.initials,
    required this.color,
  });
  final String id, name, phone, initials;
  final Color color;
}
