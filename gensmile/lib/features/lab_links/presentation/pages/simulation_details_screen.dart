import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/lab_links/presentation/pages/generate_lab_link_screen.dart';

class SimulationDetailsScreen extends ConsumerWidget {
  const SimulationDetailsScreen({super.key});

  static const _simulations = [
    _Sim(
      id: 'SIM001-001',
      title: 'Simulation #1.1 - Full Smile',
      date: 'Mar 5, 2026',
    ),
    _Sim(
      id: 'SIM001-002',
      title: 'Simulation #1.2 - Full Smile',
      date: 'Mar 5, 2026',
    ),
    _Sim(
      id: 'SIM001-003',
      title: 'Simulation #1.3 - Full Smile',
      date: 'Mar 5, 2026',
    ),
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
                            'Simulation History of Simulation #1',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            'View all generated versions and analysis results for this simulation',
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
                        icon: Icon(Icons.refresh, size: 14.sp),
                        label: Text(
                          'Run New Simulation',
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
                                        'Sarah Johnson',
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
                                    'ID: P001',
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
                                    'Last Visit: Mar 5, 2026',
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
                                  _StatItem(
                                    icon: Icons.bolt,
                                    label: 'Total Simulations',
                                    value: '4',
                                  ),
                                  _StatItem(
                                    icon: Icons.credit_card_outlined,
                                    label: 'Credit Used',
                                    value: '16',
                                  ),
                                  _StatItem(
                                    icon: Icons.link,
                                    label: 'Lab Links Sent',
                                    value: '2',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(16.h),

                  // Simulation History header
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Simulation History',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                            if (isWide) ...[
                              _OutlineActionBtn(
                                icon: Icons.link,
                                label: 'Generate Lab Link',
                                color: AppColors.primary,
                                filled: true,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const GenerateLabLinkScreen(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              _OutlineActionBtn(
                                icon: Icons.share_outlined,
                                label: 'Share',
                                color: AppColors.gray,
                                onTap: () {},
                              ),
                              SizedBox(width: 8.w),
                              _OutlineActionBtn(
                                icon: Icons.download_outlined,
                                label: 'Download',
                                color: AppColors.gray,
                                onTap: () {},
                              ),
                            ],
                          ],
                        ),
                        Gap(16.h),

                        // Simulation entries
                        ..._simulations.map(
                          (sim) => _SimulationEntry(
                            sim: sim,
                            isWide: isWide,
                            onGenerateLink: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const GenerateLabLinkScreen(),
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
        ],
      ),
    );
  }
}

// ── Simulation Entry ──────────────────────────────────────────────────────────
class _SimulationEntry extends StatelessWidget {
  const _SimulationEntry({
    required this.sim,
    required this.isWide,
    required this.onGenerateLink,
  });
  final _Sim sim;
  final bool isWide;
  final VoidCallback onGenerateLink;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(height: 1, color: AppColors.inputBorder),
      Gap(14.h),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sim.title,
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
                      size: 10.sp,
                      color: AppColors.gray,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      sim.date,
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
              sim.id,
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

      // Before / After
      isWide
          ? Row(
              children: [
                Expanded(
                  child: _SimImg(label: 'Before', caption: 'Current Condition'),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _SimImg(
                    label: 'After Simulation',
                    caption: 'Expected Result',
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _SimImg(label: 'Before', caption: 'Current Condition'),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _SimImg(
                    label: 'After Simulation',
                    caption: 'Expected Result',
                  ),
                ),
              ],
            ),
      Gap(14.h),

      // Analysis Summary
      Text(
        'Analysis Summary',
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
                _AnalysisCard(label: 'Alignment Correction', value: '85%'),
                SizedBox(width: 12.w),
                _AnalysisCard(label: 'Whitening Level', value: '3 shades'),
                SizedBox(width: 12.w),
                _AnalysisCard(label: 'Smile Balance', value: '92%'),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _AnalysisCard(
                        label: 'Alignment Correction',
                        value: '85%',
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _AnalysisCard(
                        label: 'Whitening Level',
                        value: '3 shades',
                      ),
                    ),
                  ],
                ),
                Gap(8.h),
                _AnalysisCard(label: 'Smile Balance', value: '92%'),
              ],
            ),
      Gap(14.h),

      // Action buttons
      isWide
          ? Row(
              children: [
                _OutlineActionBtn(
                  icon: Icons.link,
                  label: 'Generate Lab Link',
                  color: AppColors.primary,
                  filled: true,
                  onTap: onGenerateLink,
                ),
                SizedBox(width: 8.w),
                _OutlineActionBtn(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  color: AppColors.gray,
                  onTap: () {},
                ),
                SizedBox(width: 8.w),
                _OutlineActionBtn(
                  icon: Icons.download_outlined,
                  label: 'Download',
                  color: AppColors.gray,
                  onTap: () {},
                ),
                SizedBox(width: 8.w),
                _OutlineActionBtn(
                  icon: Icons.visibility_outlined,
                  label: 'View Result',
                  color: AppColors.gray,
                  onTap: () {},
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _IconOnlyBtn(
                  icon: Icons.link,
                  color: AppColors.primary,
                  filled: true,
                  onTap: onGenerateLink,
                ),
                _IconOnlyBtn(
                  icon: Icons.visibility_outlined,
                  color: AppColors.gray,
                  filled: false,
                  onTap: () {},
                ),
                _IconOnlyBtn(
                  icon: Icons.download_outlined,
                  color: AppColors.gray,
                  filled: false,
                  onTap: () {},
                ),
                _IconOnlyBtn(
                  icon: Icons.share_outlined,
                  color: AppColors.gray,
                  filled: false,
                  onTap: () {},
                ),
              ],
            ),
      Gap(16.h),
    ],
  );
}

// ── Helpers ───────────────────────────────────────────────────────────────────
class _SimImg extends StatelessWidget {
  const _SimImg({required this.label, required this.caption});
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
          height: 110.h,
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

class _AnalysisCard extends StatelessWidget {
  const _AnalysisCard({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
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

class _OutlineActionBtn extends StatelessWidget {
  const _OutlineActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
  });
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: filled ? color : AppColors.inputBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: filled ? Colors.white : color),
          SizedBox(width: 5.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: filled ? Colors.white : color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

class _IconOnlyBtn extends StatelessWidget {
  const _IconOnlyBtn({
    required this.icon,
    required this.color,
    required this.filled,
    required this.onTap,
  });
  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: filled ? color : AppColors.inputBorder),
      ),
      child: Icon(icon, size: 18.sp, color: filled ? Colors.white : color),
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

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 4.h),
    child: Row(
      children: [
        Icon(icon, size: 12.sp, color: AppColors.gray),
        SizedBox(width: 6.w),
        Text(
          '$label  ',
          style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
      ],
    ),
  );
}

class _Sim {
  const _Sim({required this.id, required this.title, required this.date});
  final String id, title, date;
}
