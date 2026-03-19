import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/settings/presentation/widgets/settings_widgets.dart';

class ProfileClinicScreen extends StatelessWidget {
  const ProfileClinicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Avatar card ──────────────────────────────────────────────────
        _AvatarCard(),
        Gap(16.h),

        // ── Basic Information ────────────────────────────────────────────
        SettingsSection(
          title: 'Basic Information',
          initiallyExpanded: true,
          children: [
            SettingsFieldRow(
              left: SettingsField(
                label: 'Full Name',
                value: 'Dr. Smith Johnson',
              ),
              right: SettingsField(
                label: 'Professional Title',
                value: 'Lead Dentist',
              ),
            ),
            SettingsField(label: 'Email Address', value: 'smith@clinic.com'),
            SettingsField(label: 'Phone Number', value: '+1 (555) 111-2222'),
          ],
        ),

        // ── Professional Details ─────────────────────────────────────────
        SettingsSection(
          title: 'Professional Details',
          children: [
            SettingsField(label: 'License Number', value: 'DDS-2019-00842'),
            SettingsField(label: 'Specialization', value: 'Cosmetic Dentistry'),
            SettingsField(label: 'Years of Experience', value: '8'),
          ],
        ),

        // ── Clinic Details ───────────────────────────────────────────────
        SettingsSection(
          title: 'Clinic Details',
          children: [
            SettingsFieldRow(
              left: SettingsField(
                label: 'Clinic Name',
                value: 'SmileCenter Dental Clinic',
              ),
              right: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clinic Logo',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.gray,
                    ),
                  ),
                  Gap(4.h),
                  SettingsUploadButton(label: 'Upload logo'),
                  Gap(14.h),
                ],
              ),
            ),
            SettingsField(
              label: 'Address',
              value: '123 Dental Ave, Suite 200, New York, NY 10001',
            ),
            SettingsFieldRow(
              left: SettingsField(
                label: 'Phone Number',
                value: '+1 (555) 000-1111',
              ),
              right: SettingsField(
                label: 'Email',
                value: 'info@smilecenter.com',
              ),
            ),
            SettingsField(label: 'Website', value: 'www.smilecenter.com'),
          ],
        ),

        // ── Business Information ─────────────────────────────────────────
        SettingsSection(
          title: 'Business Information',
          children: [
            SettingsFieldRow(
              left: SettingsField(label: 'Clinic Type', value: 'Dental'),
              right: SettingsField(label: 'Number of Dentists', value: '3'),
            ),
            SettingsField(
              label: 'Working Hours',
              value: 'Mon–Fri: 9AM–6PM, Sat: 9AM–2PM',
            ),
          ],
        ),
      ],
    );
  }
}

// ── Avatar card ───────────────────────────────────────────────────────────────

class _AvatarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 36.r,
                backgroundColor: AppColors.primary.withOpacity(0.15),
                child: Icon(
                  Icons.person,
                  size: 40.sp,
                  color: AppColors.primary.withOpacity(0.6),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 11.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),
          Text(
            'Dr. Smith Johnson',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          Gap(4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_outlined, size: 13.sp, color: AppColors.gray),
              SizedBox(width: 4.w),
              Text(
                'smith@clinic.com',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.gray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
