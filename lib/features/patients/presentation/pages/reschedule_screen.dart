import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';

final selectedDateProvider = StateProvider<int>((ref) => 3);
final selectedTimeProvider = StateProvider<String>((ref) => '9:00 AM');

const _kTimes = [
  '9:00 AM',
  '9:30 AM',
  '10:00 AM',
  '10:30 AM',
  '11:00 AM',
  '11:30 AM',
  '2:00 PM',
  '2:30 PM',
  '3:00 PM',
  '3:30 PM',
  '4:00 PM',
];

class RescheduleScreen extends ConsumerWidget {
  const RescheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedTime = ref.watch(selectedTimeProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    final calendar = _CalendarCard(
      selectedDate: selectedDate,
      onDateSelected: (d) => ref.read(selectedDateProvider.notifier).state = d,
    );

    final timesCard = _TimesCard(
      selectedTime: selectedTime,
      onTimeSelected: (t) => ref.read(selectedTimeProvider.notifier).state = t,
      selectedDate: selectedDate,
    );

    final confirmCard = _ConfirmCard(
      selectedDate: selectedDate,
      selectedTime: selectedTime,
      onConfirm: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

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
                      Icons.calendar_month_outlined,
                      size: 18.sp,
                      color: AppColors.textColor,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reschedule Appointment',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            'Select a date, time, and appointment type',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.gray,
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
                            width: 48.w,
                            height: 48.w,
                            color: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              size: 24.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sarah Davis',
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                              Text(
                                'ID: P002  •  28 years • Female',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                              Text(
                                'Primary Email: sarah.davis@email.com',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                              Text(
                                'Phone Number: +1 (555) 234-5678',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                              Text(
                                'Assigned Dentist: Dr. Smith Johnson',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(12.h),

                  isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: calendar),
                            SizedBox(width: 16.w),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [timesCard, Gap(12.h), confirmCard],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            calendar,
                            Gap(12.h),
                            timesCard,
                            Gap(12.h),
                            confirmCard,
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.selectedDate,
    required this.onDateSelected,
  });
  final int selectedDate;
  final ValueChanged<int> onDateSelected;

  static const _days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  static const _unavailable = [5, 7, 18];

  @override
  Widget build(BuildContext context) => Container(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'March 2026',
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            Row(
              children: [
                Icon(Icons.chevron_left, size: 20.sp, color: AppColors.gray),
                SizedBox(width: 4.w),
                Icon(Icons.chevron_right, size: 20.sp, color: AppColors.gray),
              ],
            ),
          ],
        ),
        Gap(12.h),
        Row(
          children: _days
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.gray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        Gap(8.h),
        ...List.generate(
          5,
          (week) => Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Row(
              children: List.generate(7, (day) {
                final date = week * 7 + day - 0;
                if (date < 1 || date > 31)
                  return Expanded(child: SizedBox.shrink());
                final isSelected = date == selectedDate;
                final isUnavailable = _unavailable.contains(date);
                return Expanded(
                  child: GestureDetector(
                    onTap: isUnavailable ? null : () => onDateSelected(date),
                    child: Container(
                      margin: EdgeInsets.all(2.w),
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Center(
                        child: Text(
                          '$date',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: isSelected
                                ? Colors.white
                                : isUnavailable
                                ? AppColors.inputBorder
                                : AppColors.textColor,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Gap(8.h),
        Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              'Selected',
              style: GoogleFonts.inter(fontSize: 10.sp, color: AppColors.gray),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              'Unavailable',
              style: GoogleFonts.inter(fontSize: 10.sp, color: AppColors.gray),
            ),
          ],
        ),
      ],
    ),
  );
}

class _TimesCard extends StatelessWidget {
  const _TimesCard({
    required this.selectedTime,
    required this.onTimeSelected,
    required this.selectedDate,
  });
  final String selectedTime;
  final ValueChanged<String> onTimeSelected;
  final int selectedDate;

  @override
  Widget build(BuildContext context) => Container(
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
          'Available Times · March $selectedDate',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        Gap(12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: _kTimes
              .map(
                (t) => GestureDetector(
                  onTap: () => onTimeSelected(t),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: selectedTime == t
                          ? AppColors.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: selectedTime == t
                            ? AppColors.primary
                            : AppColors.inputBorder,
                      ),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: selectedTime == t
                            ? Colors.white
                            : AppColors.textColor,
                        fontWeight: selectedTime == t
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}

class _ConfirmCard extends StatelessWidget {
  const _ConfirmCard({
    required this.selectedDate,
    required this.selectedTime,
    required this.onConfirm,
  });
  final int selectedDate;
  final String selectedTime;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) => Container(
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
          'Confirm Appointment',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        Gap(12.h),
        _ConfirmRow('Date', 'March $selectedDate, 2026'),
        _ConfirmRow('Time', selectedTime),
        _ConfirmRow('Doctor', 'Dr. Michael Chen'),
        _ConfirmRow('Credit', '20'),
        Gap(16.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onConfirm,
            icon: Icon(Icons.check_circle_outline, size: 14.sp),
            label: Text(
              'Confirm Appointment',
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
  );
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
      ],
    ),
  );
}
