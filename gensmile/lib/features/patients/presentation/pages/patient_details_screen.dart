import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/lab_links/presentation/pages/case_details_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/new_simulation_screen.dart';

class PatientDetailsScreen extends ConsumerWidget {
  const PatientDetailsScreen({super.key, required this.patient});
  final dynamic patient;

  static const _caseHistory = [
    _Case(
      title: 'Full Smile Makeover',
      status: 'Completed',
      sims: '8 simulations',
      date: 'Mar 5, 2026',
      caseId: 'C001',
    ),
    _Case(
      title: 'Full Smile Makeover',
      status: 'Completed',
      sims: '6 simulations',
      date: 'Mar 5, 2026',
      caseId: 'C001',
    ),
    _Case(
      title: 'Full Smile Makeover',
      status: 'Completed',
      sims: '4 simulations',
      date: 'Mar 5, 2026',
      caseId: 'C001',
    ),
    _Case(
      title: 'Full Smile Makeover',
      status: 'Completed',
      sims: '2 simulations',
      date: 'Mar 5, 2026',
      caseId: 'C001',
    ),
  ];

  static const _caseFilters = [
    'Total (5)',
    'Completed (3)',
    'Next Appointment',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
          // ── Top bar ──
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
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
                            isWide ? 'Patient Details' : 'Case Details',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            'View patient information and case history',
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
                            builder: (_) => const NewSimulationScreen(),
                          ),
                        ),
                        icon: Icon(Icons.auto_awesome_outlined, size: 13.sp),
                        label: Text(
                          'Add new Simulation',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.edit_outlined, size: 13.sp),
                        label: Text(
                          'Edit',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ],
                    Icon(
                      Icons.notifications_outlined,
                      size: 20.sp,
                      color: AppColors.gray,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient info card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Container(
                                  width: 72.w,
                                  height: 72.w,
                                  color: AppColors.primary.withOpacity(0.1),
                                  child: Icon(
                                    Icons.person,
                                    size: 36.sp,
                                    color: AppColors.primary,
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
                                          'Sarah Johnson',
                                          style: GoogleFonts.inter(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textColor,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        _Badge('In Treatment', AppColors.info),
                                      ],
                                    ),
                                    Gap(6.h),
                                    Wrap(
                                      spacing: 24.w,
                                      runSpacing: 4.h,
                                      children: [
                                        _InfoPair('ID: P001'),
                                        _InfoPair(
                                          'Primary Email: sarah.johnson@email.com',
                                        ),
                                        _InfoPair('28 years • Female'),
                                        _InfoPair(
                                          'Phone Number: +1 (555) 234-5678',
                                        ),
                                        _InfoPair('Last Visit: Mar 5, 2026'),
                                        _InfoPair(
                                          'Assigned Dentist: Dr. Smith Johnson',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Container(
                                      width: 56.w,
                                      height: 56.w,
                                      color: AppColors.primary.withOpacity(0.1),
                                      child: Icon(
                                        Icons.person,
                                        size: 28.sp,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          spacing: 8.w,
                                          runSpacing: 4.h,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Text(
                                              'Sarah Johnson',
                                              style: GoogleFonts.inter(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textColor,
                                              ),
                                            ),
                                            _Badge(
                                              'In Treatment',
                                              AppColors.info,
                                            ),
                                          ],
                                        ),
                                        Gap(4.h),
                                        Text(
                                          'ID: P001',
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            color: AppColors.gray,
                                          ),
                                        ),
                                        Text(
                                          '28 years • Female',
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            color: AppColors.gray,
                                          ),
                                        ),
                                        Text(
                                          'Last Visit: Mar 5, 2026',
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
                              Gap(8.h),
                              Text(
                                'Primary Email: sarah.johnson@email.com',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                              Text(
                                'Phone Number: +1 (555) 234-5678',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                              Text(
                                'Assigned Dentist: Dr. Smith Johnson',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                              Gap(12.h),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.edit_outlined, size: 13.sp),
                                label: Text(
                                  'Edit',
                                  style: GoogleFonts.inter(fontSize: 12.sp),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: BorderSide(color: AppColors.primary),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 8.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  Gap(16.h),

                  // Case History
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Case History',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),
                            const Spacer(),
                            if (!isWide)
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'View All',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Gap(10.h),

                        // Filter tabs
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _caseFilters.map((f) {
                              final isFirst = f == _caseFilters.first;
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.only(right: 8.w),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 7.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isFirst
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: isFirst
                                          ? AppColors.primary
                                          : AppColors.inputBorder,
                                    ),
                                  ),
                                  child: Text(
                                    f,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: isFirst
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isFirst
                                          ? Colors.white
                                          : AppColors.gray,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Gap(12.h),

                        // Case rows
                        ..._caseHistory.map(
                          (c) => _CaseRow(
                            caseItem: c,
                            isWide: isWide,
                            onView: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    CaseDetailsScreen(patient: patient),
                              ),
                            ),
                          ),
                        ),

                        // Mobile: Add new Simulation button
                        if (!isWide) ...[
                          Gap(8.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const NewSimulationScreen(),
                                ),
                              ),
                              icon: Icon(
                                Icons.auto_awesome_outlined,
                                size: 14.sp,
                              ),
                              label: Text(
                                'Add new Simulation',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
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

class _CaseRow extends StatelessWidget {
  const _CaseRow({
    required this.caseItem,
    required this.isWide,
    required this.onView,
  });
  final _Case caseItem;
  final bool isWide;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: 10.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: AppColors.inputBorder),
    ),
    child: isWide
        ? Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          caseItem.title,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _Badge(caseItem.status, AppColors.success),
                        SizedBox(width: 8.w),
                        Text(
                          caseItem.sims,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                    Gap(4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 11.sp,
                          color: AppColors.gray,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Case Date: ${caseItem.date}',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.gray,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Icon(Icons.tag, size: 11.sp, color: AppColors.gray),
                        SizedBox(width: 4.w),
                        Text(
                          'Case ID: ${caseItem.caseId}',
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
                      'View Case',
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
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  'JW',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'John Williams',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        _Badge(caseItem.status, AppColors.success),
                      ],
                    ),
                    Text(
                      '${caseItem.date} • Case ID: ${caseItem.caseId}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onView,
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 14.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 3.w),
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

class _Badge extends StatelessWidget {
  const _Badge(this.label, this.color);
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 10.sp,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _InfoPair extends StatelessWidget {
  const _InfoPair(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
  );
}

class _Case {
  const _Case({
    required this.title,
    required this.status,
    required this.sims,
    required this.date,
    required this.caseId,
  });
  final String title, status, sims, date, caseId;
}
