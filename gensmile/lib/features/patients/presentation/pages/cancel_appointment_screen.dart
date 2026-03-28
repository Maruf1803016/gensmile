import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';

final cancelReasonProvider = StateProvider<String>(
  (ref) => 'Schedule conflict',
);

const _kReasons = [
  'Schedule conflict',
  'Feeling unwell',
  'Personal emergency',
  'Doctor unavailable',
  'Financial reasons',
  'Other',
];

class CancelAppointmentScreen extends ConsumerWidget {
  const CancelAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedReason = ref.watch(cancelReasonProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
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
                            'Cancel Appointment',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            'Are you sure you want to cancel this appointment?',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sarah Davis',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                              Text(
                                'ID: P002  •  28 years • Female',
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
                        ),
                      ],
                    ),
                  ),
                  Gap(16.h),

                  // Reasons
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
                          'Reason for Cancellation',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                        Gap(12.h),
                        ..._kReasons.map(
                          (r) => GestureDetector(
                            onTap: () =>
                                ref.read(cancelReasonProvider.notifier).state =
                                    r,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                color: selectedReason == r
                                    ? AppColors.primary.withOpacity(0.04)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: selectedReason == r
                                      ? AppColors.primary
                                      : AppColors.inputBorder,
                                  width: selectedReason == r ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      r,
                                      style: GoogleFonts.inter(
                                        fontSize: 13.sp,
                                        fontWeight: selectedReason == r
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 18.w,
                                    height: 18.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selectedReason == r
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: selectedReason == r
                                            ? AppColors.primary
                                            : AppColors.inputBorder,
                                        width: 2,
                                      ),
                                    ),
                                    child: selectedReason == r
                                        ? Icon(
                                            Icons.check,
                                            size: 10.sp,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(24.h),

                  // Keep + Confirm
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textColor,
                            side: BorderSide(color: AppColors.inputBorder),
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Keep Appointment',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_forward, size: 14.sp),
                          label: Text(
                            'Confirm',
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
                    ],
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
