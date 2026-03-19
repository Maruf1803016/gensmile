import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  static const _todayNotifs = [
    _Notif(
      name: 'Brian Griffin',
      message: 'wants to collaborate',
      time: '10:04 am',
      read: false,
    ),
    _Notif(
      name: 'New Simulation',
      message: 'Create a new AI smile or orthodontic simulation for a patient',
      time: '10:04 am',
      read: false,
    ),
    _Notif(
      name: 'New Simulation',
      message: 'Create a new AI smile or orthodontic simulation for a patient',
      time: '10:04 am',
      read: false,
    ),
  ];

  static const _earlierNotifs = [
    _Notif(
      name: 'New Simulation',
      message: 'Create a new AI smile or orthodontic simulation for a patient',
      time: '10:04 am',
      read: true,
    ),
    _Notif(
      name: 'New Simulation',
      message: 'Create a new AI smile or orthodontic simulation for a patient',
      time: '10:04 am',
      read: true,
    ),
    _Notif(
      name: 'Brian Griffin',
      message: 'wants to collaborate',
      time: '5 days ago',
      read: true,
    ),
    _Notif(
      name: 'Brian Griffin',
      message:
          'Hey Peter, we\'ve got a new user research opportunity for you. Adam from The Mayor\'s Office is looking for people like you.',
      time: '5 days ago',
      read: true,
    ),
    _Notif(
      name: 'Brian Griffin',
      message: 'wants to collaborate',
      time: '5 days ago',
      read: true,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.notifications_outlined,
                    size: 20.sp,
                    color: AppColors.textColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          'Share case information with your partner lab',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Mark all read',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── List ──
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  _GroupLabel('Today'),
                  Gap(8.h),
                  ..._todayNotifs.map((n) => _NotifTile(notif: n)),
                  Gap(16.h),
                  _GroupLabel('Earlier'),
                  Gap(8.h),
                  ..._earlierNotifs.map((n) => _NotifTile(notif: n)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.inter(
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textColor,
    ),
  );
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.notif});
  final _Notif notif;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18.r,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              notif.name[0],
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif.name,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                Gap(2.h),
                Text(
                  notif.message,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4.h),
                Text(
                  notif.time,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Unread dot
          if (!notif.read)
            Container(
              width: 8.w,
              height: 8.w,
              margin: EdgeInsets.only(top: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class _Notif {
  const _Notif({
    required this.name,
    required this.message,
    required this.time,
    required this.read,
  });
  final String name, message, time;
  final bool read;
}
