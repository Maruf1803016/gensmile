import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';

class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({super.key});

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  bool _isRecording = false;
  bool _isMuted = false;
  bool _isVideoOff = false;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: Colors.black,
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
                      Icons.video_call_outlined,
                      size: 18.sp,
                      color: AppColors.textColor,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join Meeting',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            'Connect with your patient for the scheduled consultation.',
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
          // Video area
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: isWide
                  ? Row(
                      children: [
                        Expanded(
                          child: _VideoTile(name: 'Dr. Smith', isDoctor: true),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _VideoTile(
                            name: 'Patient',
                            isDoctor: false,
                            isRecording: true,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: _VideoTile(
                            name: 'Dr. Kareem Ahmed',
                            isDoctor: false,
                            isRecording: false,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Expanded(
                          child: Stack(
                            children: [
                              _VideoTile(
                                name: 'Patient',
                                isDoctor: true,
                                isRecording: false,
                              ),
                              Positioned(
                                bottom: 12.h,
                                left: 12.w,
                                child: Container(
                                  width: 80.w,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 32.sp,
                                    ),
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

          // Controls
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: SafeArea(
              top: false,
              child: isWide
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ControlBtn(
                          icon: Icons.circle,
                          color: _isRecording ? Colors.red : Colors.grey[200]!,
                          iconColor: _isRecording ? Colors.white : Colors.red,
                          onTap: () =>
                              setState(() => _isRecording = !_isRecording),
                        ),
                        SizedBox(width: 16.w),
                        _ControlBtn(
                          icon: _isVideoOff
                              ? Icons.videocam_off
                              : Icons.videocam_outlined,
                          color: Colors.grey[200]!,
                          iconColor: AppColors.textColor,
                          onTap: () =>
                              setState(() => _isVideoOff = !_isVideoOff),
                        ),
                        SizedBox(width: 16.w),
                        _ControlBtn(
                          icon: Icons.volume_up_outlined,
                          color: Colors.grey[200]!,
                          iconColor: AppColors.textColor,
                          onTap: () {},
                        ),
                        SizedBox(width: 16.w),
                        _ControlBtn(
                          icon: _isMuted
                              ? Icons.mic_off
                              : Icons.mic_none_outlined,
                          color: Colors.grey[200]!,
                          iconColor: AppColors.textColor,
                          onTap: () => setState(() => _isMuted = !_isMuted),
                        ),
                        SizedBox(width: 24.w),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.call_end, size: 16.sp),
                          label: Text(
                            'End Call',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 14.h,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _MobileCtrlBtn(
                          icon: Icons.circle,
                          label: 'Record',
                          color: _isRecording ? Colors.red : AppColors.primary,
                          onTap: () =>
                              setState(() => _isRecording = !_isRecording),
                        ),
                        _MobileCtrlBtn(
                          icon: _isVideoOff
                              ? Icons.videocam_off
                              : Icons.videocam,
                          label: 'Video',
                          color: AppColors.primary,
                          onTap: () =>
                              setState(() => _isVideoOff = !_isVideoOff),
                        ),
                        _MobileCtrlBtn(
                          icon: Icons.volume_up,
                          label: 'Sound',
                          color: AppColors.primary,
                          onTap: () {},
                        ),
                        _MobileCtrlBtn(
                          icon: _isMuted ? Icons.mic_off : Icons.mic,
                          label: 'Voice',
                          color: AppColors.primary,
                          onTap: () => setState(() => _isMuted = !_isMuted),
                        ),
                        _MobileCtrlBtn(
                          icon: Icons.more_horiz,
                          label: 'Com',
                          color: AppColors.primary,
                          onTap: () {},
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.call_end,
                              color: Colors.white,
                              size: 22.sp,
                            ),
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

class _VideoTile extends StatelessWidget {
  const _VideoTile({
    required this.name,
    required this.isDoctor,
    this.isRecording = false,
  });
  final String name;
  final bool isDoctor, isRecording;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(12.r),
    child: Container(
      color: isDoctor ? const Color(0xFF2D5F8A) : const Color(0xFF3D3D3D),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Icon(
              isDoctor ? Icons.medical_services : Icons.person,
              size: 48.sp,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          if (isRecording)
            Positioned(
              top: 12.h,
              right: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Recording now',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class _ControlBtn extends StatelessWidget {
  const _ControlBtn({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });
  final IconData icon;
  final Color color, iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Icon(icon, size: 20.sp, color: iconColor),
    ),
  );
}

class _MobileCtrlBtn extends StatelessWidget {
  const _MobileCtrlBtn({
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
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.sp, color: color),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 9.sp, color: AppColors.gray),
        ),
      ],
    ),
  );
}
