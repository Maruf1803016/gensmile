// lib/features/lab_links/presentation/pages/case_details_screen.dart
// FIX #3: back arrow uses Navigator.of(context).pop()
// FIX #6: Image.asset for patient avatar + before/after simulation images
//         Uses Assets.imagesUserCheck01 (patient avatar)
//         Uses Assets.imagesDentalTooth (before/after placeholder)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/lab_links/presentation/pages/simulation_details_screen.dart';
import 'package:gen_smile/generated/assets.dart';

class CaseDetailsScreen extends ConsumerWidget {
  const CaseDetailsScreen({super.key, required this.patient});
  final dynamic patient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
          // ── Top bar ──────────────────────────────────────────────────
          Container(
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // FIX #3: correct back arrow
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // FIX #6: PNG image for header icon
                    SvgPicture.asset(
                      Assets.iconsUserGroup,
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Case Details',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
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
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient info card
                  _Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FIX #6: PNG patient avatar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            width: 64.w,
                            height: 64.w,
                            color: AppColors.primary.withOpacity(0.1),
                            child: Image.asset(
                              Assets.imagesDoctorFemale,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8.w,
                                runSpacing: 4.h,
                                children: [
                                  Text(
                                    'Sarah Johnson',
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  _Badge('In Treatment', AppColors.info),
                                ],
                              ),
                              Gap(6.h),
                              _info('ID: P001'),
                              _info('28 years • Female'),
                              _info('Last Visit: Mar 5, 2026'),
                              Gap(4.h),
                              _info('Primary Email: sarah.johnson@email.com'),
                              _info('Phone Number: +1 (555) 234-5678'),
                              _info('Assigned Dentist: Dr. Smith Johnson'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(16.h),

                  // Treatment Prescription (grouped in one card)
                  _SectionTitle('Treatment Prescription'),
                  Gap(10.h),
                  _Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _PrescCard('Case ID', 'C001')),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _PrescCard(
                                'Treatment Type',
                                'Full Smile Makeover',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _PrescCard('Duration', '12-16 weeks'),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _PrescCard('Estimated Cost', '\$8,500'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gap(16.h),

                  // Clinical details card (all 3 editable sections together)
                  _Card(
                    child: Column(
                      children: [
                        _EditSection(
                          'Diagnosis',
                          'Discolored teeth, minor misalignment, and worn enamel',
                        ),
                        Divider(height: 20.h, color: AppColors.inputBorder),
                        _EditSection(
                          'Recommended Treatment',
                          'Veneers + Teeth Whitening + Minor Orthodontic Adjustment',
                        ),
                        Divider(height: 20.h, color: AppColors.inputBorder),
                        _EditSection(
                          'Clinical Notes',
                          'Patient is an excellent candidate for cosmetic enhancement. Recommend starting with whitening treatment followed by veneer placement.',
                        ),
                      ],
                    ),
                  ),
                  Gap(20.h),

                  // Simulation section
                  _SectionTitle('Simulation Section'),
                  Gap(12.h),
                  ...[1, 2].map(
                    (i) => Column(
                      children: [
                        _SimCard(
                          index: i,
                          onViewAll: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SimulationDetailsScreen(),
                            ),
                          ),
                        ),
                        Gap(16.h),
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

// ─── Simulation Card ──────────────────────────────────────────────────────────
class _SimCard extends StatelessWidget {
  const _SimCard({required this.index, required this.onViewAll});
  final int index;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Simulation #$index - Full Smile',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 11.sp,
                          color: AppColors.gray,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Mar 5, 2026',
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Text(
                  'SIM00$index',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppColors.gray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h),

          // FIX #6: Before / After using PNG assets
          Row(
            children: [
              Expanded(child: _SimImg('Before', 'Current Condition')),
              SizedBox(width: isWide ? 12.w : 8.w),
              Expanded(child: _SimImg('After Simulation', 'Expected Result')),
            ],
          ),
          Gap(14.h),

          Text(
            'Simulation Overview',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          Gap(10.h),

          isWide
              ? Row(
                  children: [
                    _StatBox('Total Simulations', '4'),
                    SizedBox(width: 12.w),
                    _StatBox('Credit Used', '16'),
                    SizedBox(width: 12.w),
                    _StatBox('Lab Links Sent', '2'),
                  ],
                )
              : Column(
                  children: [
                    _OvRow('Total Simulations', '4'),
                    _OvRow('Credit Used', '16'),
                    _OvRow('Lab Links Sent', '2'),
                  ],
                ),
          Gap(12.h),

          ElevatedButton.icon(
            onPressed: onViewAll,
            icon: Icon(Icons.visibility_outlined, size: 14.sp),
            label: Text(
              'view All Simulations',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// FIX #6: uses dental tooth PNG as before/after placeholder
class _SimImg extends StatelessWidget {
  const _SimImg(this.label, this.caption);
  final String label, caption;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
      ),
      Gap(4.h),
      ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          height: 100.h,
          color: Colors.black87,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // FIX #6: dental tooth image as placeholder
              Image.asset(Assets.imagesDoctorMale, fit: BoxFit.cover),
              Positioned(
                bottom: 8.h,
                left: 8.w,
                child: Text(
                  caption,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

// ─── Shared Helpers ───────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: AppColors.inputBorder),
    ),
    child: child,
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.t);
  final String t;
  @override
  Widget build(BuildContext context) => Text(
    t,
    style: GoogleFonts.inter(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.textColor,
    ),
  );
}

class _PrescCard extends StatelessWidget {
  const _PrescCard(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F6FA),
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: AppColors.inputBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10.sp, color: AppColors.gray),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
          softWrap: true,
        ),
      ],
    ),
  );
}

class _EditSection extends StatelessWidget {
  const _EditSection(this.title, this.content);
  final String title, content;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
          ),
          Icon(Icons.edit_outlined, size: 16.sp, color: AppColors.gray),
        ],
      ),
      Gap(8.h),
      Text(
        content,
        style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray),
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
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 11.sp,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _StatBox extends StatelessWidget {
  const _StatBox(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt, size: 12.sp, color: AppColors.primary),
              SizedBox(width: 4.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  color: AppColors.gray,
                ),
              ),
            ],
          ),
          Gap(4.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    ),
  );
}

class _OvRow extends StatelessWidget {
  const _OvRow(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
      ],
    ),
  );
}

Widget _info(String t) => Text(
  t,
  style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
);
