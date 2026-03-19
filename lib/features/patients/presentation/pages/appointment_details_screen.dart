import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/patients/presentation/pages/reschedule_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/cancel_appointment_screen.dart';
import 'package:gen_smile/features/patients/presentation/pages/join_meeting_screen.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key, required this.appt});
  final dynamic appt;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
          // Top bar
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
                      Icons.calendar_today_outlined,
                      size: 18.sp,
                      color: AppColors.textColor,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment Details',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            'Complete case progression and treatment plan',
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
                            builder: (_) => const JoinMeetingScreen(),
                          ),
                        ),
                        icon: Icon(Icons.video_call_outlined, size: 14.sp),
                        label: Text(
                          'Join Meeting',
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
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RescheduleScreen(),
                          ),
                        ),
                        icon: Icon(Icons.calendar_month_outlined, size: 13.sp),
                        label: Text(
                          'Reschedule',
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
                      SizedBox(width: 8.w),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CancelAppointmentScreen(),
                          ),
                        ),
                        icon: Icon(Icons.close, size: 13.sp),
                        label: Text(
                          'Cancel Appointment',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                          side: BorderSide(color: AppColors.danger),
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

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Patient info
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Row(
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
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Wrap(
                            spacing: 20.w,
                            runSpacing: 4.h,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Sarah Davis',
                                        style: GoogleFonts.inter(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      _Badge('In Treatment', AppColors.info),
                                    ],
                                  ),
                                  Text(
                                    'ID: P002',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                  Text(
                                    '28 years • Female',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                  Text(
                                    'Last Visit: ---',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Primary Email: sarah.davis@email.com',
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(12.h),

                  // Date / Time / Duration
                  isWide
                      ? Row(
                          children: [
                            _InfoCard(label: 'Date', value: 'Mar 18, 2026'),
                            SizedBox(width: 12.w),
                            _InfoCard(label: 'Time', value: '10:00 AM'),
                            SizedBox(width: 12.w),
                            _InfoCard(label: 'Duration', value: '45 minutes'),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                _InfoCard(label: 'Date', value: 'Mar 18, 2026'),
                                SizedBox(width: 10.w),
                                _InfoCard(label: 'Time', value: '10:00 AM'),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            _InfoCard(
                              label: 'Duration',
                              value: '45 minutes',
                              fullWidth: true,
                            ),
                          ],
                        ),
                  Gap(12.h),

                  // Appointment details
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
                        Text(
                          'Appointment Details',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                        Gap(12.h),
                        _DetailItem(
                          icon: Icons.description_outlined,
                          label: 'Treatment Plan',
                          value: 'Full Smile Makeover - Phase 2',
                        ),
                        Gap(10.h),
                        _DetailItem(
                          icon: Icons.note_outlined,
                          label: 'Notes',
                          value:
                              'Follow-up consultation for smile makeover treatment plan review',
                        ),
                      ],
                    ),
                  ),
                  Gap(12.h),

                  // Mobile action buttons
                  if (!isWide) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const JoinMeetingScreen(),
                          ),
                        ),
                        icon: Icon(Icons.video_call_outlined, size: 16.sp),
                        label: Text(
                          'Join Meeting',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    Gap(10.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RescheduleScreen(),
                          ),
                        ),
                        icon: Icon(Icons.calendar_month_outlined, size: 14.sp),
                        label: Text(
                          'Reschedule',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    Gap(10.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CancelAppointmentScreen(),
                          ),
                        ),
                        icon: Icon(Icons.close, size: 14.sp),
                        label: Text(
                          'Cancel Appointment',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                          side: BorderSide(color: AppColors.danger),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
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
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.label,
    required this.value,
    this.fullWidth = false,
  });
  final String label, value;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) => fullWidth
      ? Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: AppColors.gray,
                ),
              ),
              Gap(4.h),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        )
      : Expanded(
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppColors.gray,
                  ),
                ),
                Gap(4.h),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        );
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label, value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 14.sp, color: AppColors.gray),
          SizedBox(width: 6.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.gray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      Gap(6.h),
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Text(
          value,
          style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.textColor),
        ),
      ),
    ],
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
