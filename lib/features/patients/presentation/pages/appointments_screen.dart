import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/patients/presentation/pages/appointment_details_screen.dart';

final appointmentFilterProvider = StateProvider<String>(
  (ref) => 'Next Appointment',
);

const _kAppointments = [
  _Appt(
    id: 'P001',
    name: 'John Williams',
    initials: 'JW',
    color: Color(0xFF7C3AED),
    phone: '+1 (555) 234-5678',
    dateTime: 'Mar 18, 2026, 10:00 AM',
  ),
  _Appt(
    id: 'P001',
    name: 'Sarah Davis',
    initials: 'SD',
    color: Color(0xFFDB2777),
    phone: '+1 (555) 234-5678',
    dateTime: 'Mar 18, 2026, 10:00 AM',
  ),
  _Appt(
    id: 'P001',
    name: 'Sarah Davis',
    initials: 'SD',
    color: Color(0xFFDB2777),
    phone: '+1 (555) 234-5678',
    dateTime: 'Mar 18, 2026, 10:00 AM',
  ),
  _Appt(
    id: 'P001',
    name: 'Sarah Davis',
    initials: 'SD',
    color: Color(0xFFDB2777),
    phone: '+1 (555) 234-5678',
    dateTime: 'Mar 18, 2026, 10:00 AM',
  ),
  _Appt(
    id: 'P001',
    name: 'Sarah Davis',
    initials: 'SD',
    color: Color(0xFFDB2777),
    phone: '+1 (555) 234-5678',
    dateTime: 'Mar 18, 2026, 10:00 AM',
  ),
  _Appt(
    id: 'P002',
    name: 'Sarah Davis',
    initials: 'SD',
    color: Color(0xFFDB2777),
    phone: '+1 (555) 234-5678',
    dateTime: 'Mar 18, 2026, 10:00 AM',
  ),
  _Appt(
    id: 'P003',
    name: 'Michael Tan',
    initials: 'MT',
    color: Color(0xFF059669),
    phone: '+1 (555) 234-5678',
    dateTime: 'Mar 18, 2026, 10:00 AM',
  ),
];

const _kFilters = [
  'All',
  'Active',
  'Treatment',
  'Completed',
  'Next Appointment',
];

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final activeFilter = ref.watch(appointmentFilterProvider);

    final body = Column(
      children: [
        Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
              child: Row(
                children: [
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
                  if (isWide)
                    ElevatedButton.icon(
                      onPressed: () {},
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
                  Icon(
                    Icons.notifications_outlined,
                    size: 22.sp,
                    color: AppColors.gray,
                  ),
                ],
              ),
            ),
          ),
        ),

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
                            border: Border.all(color: AppColors.inputBorder),
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _kFilters
                                .map(
                                  (f) => GestureDetector(
                                    onTap: () =>
                                        ref
                                                .read(
                                                  appointmentFilterProvider
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
                        'Showing ${_kAppointments.length} of ${_kAppointments.length} patients',
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
                          SizedBox(width: 160.w, child: _hCell('Phone Number')),
                          SizedBox(width: 180.w, child: _hCell('Date & Time')),
                          SizedBox(width: 80.w, child: _hCell('Actions')),
                        ],
                      ),
                    ),

                  ..._kAppointments.map(
                    (a) => _AppointmentRow(
                      appt: a,
                      isWide: isWide,
                      onView: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AppointmentDetailsScreen(appt: a),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (!embedded)
      return Scaffold(backgroundColor: const Color(0xFFF4F5F7), body: body);
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

class _AppointmentRow extends StatelessWidget {
  const _AppointmentRow({
    required this.appt,
    required this.isWide,
    required this.onView,
  });
  final _Appt appt;
  final bool isWide;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
    ),
    child: isWide
        ? Row(
            children: [
              SizedBox(
                width: 80.w,
                child: Text(
                  appt.id,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14.r,
                      backgroundColor: appt.color,
                      child: Text(
                        appt.initials,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      appt.name,
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
                width: 160.w,
                child: Text(
                  appt.phone,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                ),
              ),
              SizedBox(
                width: 180.w,
                child: Text(
                  appt.dateTime,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                ),
              ),
              SizedBox(
                width: 80.w,
                child: GestureDetector(
                  onTap: onView,
                  child: Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 14.sp,
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
              ),
            ],
          )
        : Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: appt.color,
                child: Text(
                  appt.initials,
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
                      appt.name,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      appt.phone,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.gray,
                      ),
                    ),
                    Text(
                      appt.dateTime,
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
                      size: 14.sp,
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

class _Appt {
  const _Appt({
    required this.id,
    required this.name,
    required this.initials,
    required this.color,
    required this.phone,
    required this.dateTime,
  });
  final String id, name, initials, phone, dateTime;
  final Color color;
}
