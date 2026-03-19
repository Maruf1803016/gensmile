import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/lab_links/presentation/pages/simulation_details_screen.dart';

class CaseDetailsScreen extends ConsumerWidget {
  const CaseDetailsScreen({super.key, required this.patient});
  final dynamic patient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    SizedBox(width: 12.w),
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
                            'Case History Details of Full Smile Makeover',
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

          // ── Content ──
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            width: 64.w,
                            height: 64.w,
                            color: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              size: 32.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name + badge on separate lines if needed
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
                                  _StatusBadge('In Treatment', AppColors.info),
                                ],
                              ),
                              Gap(6.h),
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
                              Gap(4.h),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(16.h),

                  // Treatment Prescription
                  _SectionTitle('Treatment Prescription'),
                  Gap(10.h),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _PrescriptionCard(
                              label: 'Case ID',
                              value: 'C001',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _PrescriptionCard(
                              label: 'Treatment Type',
                              value: 'Full Smile Makeover',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: _PrescriptionCard(
                              label: 'Duration',
                              value: '12-16 weeks',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _PrescriptionCard(
                              label: 'Estimated Cost',
                              value: '\$8,500',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(16.h),

                  // Diagnosis
                  _EditableSection(
                    title: 'Diagnosis',
                    content:
                        'Discolored teeth, minor misalignment, and worn enamel',
                  ),
                  Gap(12.h),

                  // Recommended Treatment
                  _EditableSection(
                    title: 'Recommended Treatment',
                    content:
                        'Veneers + Teeth Whitening + Minor Orthodontic Adjustment',
                  ),
                  Gap(12.h),

                  // Clinical Notes
                  _EditableSection(
                    title: 'Clinical Notes',
                    content:
                        'Patient is an excellent candidate for cosmetic enhancement. Recommend starting with whitening treatment followed by veneer placement.',
                  ),
                  Gap(20.h),

                  // Simulation Section
                  _SectionTitle('Simulation Section'),
                  Gap(12.h),

                  ...[1, 2].map(
                    (i) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SimulationCard(
                          index: i,
                          simId: 'SIM00$i',
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

// ── Simulation Card ───────────────────────────────────────────────────────────
class _SimulationCard extends StatelessWidget {
  const _SimulationCard({
    required this.index,
    required this.simId,
    required this.onViewAll,
  });
  final int index;
  final String simId;
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

          // Before / After images
          isWide
              ? Row(
                  children: [
                    Expanded(
                      child: _SimImage(
                        label: 'Before',
                        caption: 'Current Condition',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _SimImage(
                        label: 'After Simulation',
                        caption: 'Expected Result',
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _SimImage(
                        label: 'Before',
                        caption: 'Current Condition',
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _SimImage(
                        label: 'After Simulation',
                        caption: 'Expected Result',
                      ),
                    ),
                  ],
                ),
          Gap(14.h),

          // Simulation Overview
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
                    _OverviewStat(label: 'Total Simulations', value: '4'),
                    SizedBox(width: 12.w),
                    _OverviewStat(label: 'Credit Used', value: '16'),
                    SizedBox(width: 12.w),
                    _OverviewStat(label: 'Lab Links Sent', value: '2'),
                  ],
                )
              : Column(
                  children: [
                    _OverviewRow('Total Simulations', '4'),
                    _OverviewRow('Credit Used', '16'),
                    _OverviewRow('Lab Links Sent', '2'),
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

// ── Small Helpers ─────────────────────────────────────────────────────────────
class _SimImage extends StatelessWidget {
  const _SimImage({required this.label, required this.caption});
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
              const ColoredBox(color: Color(0xFF1a1a1a)),
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

class _OverviewStat extends StatelessWidget {
  const _OverviewStat({required this.label, required this.value});
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

class _OverviewRow extends StatelessWidget {
  const _OverviewRow(this.label, this.value);
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
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.inter(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.textColor,
    ),
  );
}

class _PrescriptionCard extends StatelessWidget {
  const _PrescriptionCard({required this.label, required this.value});
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

class _EditableSection extends StatelessWidget {
  const _EditableSection({required this.title, required this.content});
  final String title, content;
  @override
  Widget build(BuildContext context) => Container(
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
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.label, this.color);
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
