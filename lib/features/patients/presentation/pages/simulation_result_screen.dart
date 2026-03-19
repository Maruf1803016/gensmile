import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/patients/presentation/pages/send_result_screen.dart';

final simResultViewProvider = StateProvider<String>((ref) => 'Front View');

class SimulationResultScreen extends ConsumerWidget {
  const SimulationResultScreen({super.key});

  static const _views = [
    'Front View',
    'Side Profile',
    'FrontSmile CloseupView',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeView = ref.watch(simResultViewProvider);
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
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.sentiment_satisfied_outlined,
                      size: 20.sp,
                      color: AppColors.textColor,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smile Simulation Result',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            'Preview the potential smile transformation',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.inputBorder),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 14.sp,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Simulation Complete',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w500,
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
                  Text(
                    'Before / After Comparison',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  Gap(12.h),

                  // Main result card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Column(
                      children: [
                        // View tabs
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.inputBorder),
                          ),
                          child: Row(
                            children: _views.map((v) {
                              final isActive = activeView == v;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      ref
                                              .read(
                                                simResultViewProvider.notifier,
                                              )
                                              .state =
                                          v,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 9.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6.r),
                                      boxShadow: isActive
                                          ? [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.05,
                                                ),
                                                blurRadius: 4,
                                                offset: const Offset(0, 1),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Text(
                                      v,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 11.sp,
                                        fontWeight: isActive
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: isActive
                                            ? AppColors.textColor
                                            : AppColors.gray,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Gap(14.h),

                        // Before/After image with slider divider
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: SizedBox(
                            height: isWide ? 300.h : 220.h,
                            child: Stack(
                              children: [
                                // Before (left half)
                                Positioned.fill(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: const Color(0xFF8B6A50),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              const ColoredBox(
                                                color: Color(0xFF5C3D2E),
                                              ),
                                              Positioned(
                                                bottom: 12.h,
                                                left: 12.w,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 4.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4.r,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'Current Condition',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: const Color(0xFFE8D5C4),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              const ColoredBox(
                                                color: Color(0xFFF5EDE5),
                                              ),
                                              Positioned(
                                                bottom: 12.h,
                                                right: 12.w,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 4.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4.r,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'Expected Result',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Divider line
                                Center(
                                  child: Container(
                                    width: 3,
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 20.w,
                                          height: 20.w,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.compare_arrows,
                                            size: 12.sp,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(14.h),

                        // Quality bars
                        _QualityBar(
                          label: 'Image Quality',
                          value: 0.95,
                          percent: '95%',
                        ),
                        Gap(8.h),
                        _QualityBar(
                          label: 'AI Confidence',
                          value: 0.88,
                          percent: '88%',
                        ),
                      ],
                    ),
                  ),
                  Gap(16.h),

                  // Analysis Summary — content changes per tab
                  _TabAnalysis(activeView: activeView, isWide: isWide),
                  Gap(16.h),

                  // Action buttons
                  isWide
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const SendResultScreen(),
                                ),
                              ),
                              icon: Icon(Icons.send_outlined, size: 14.sp),
                              label: Text(
                                'Send to Patient',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 12.h,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            _OutBtn(icon: Icons.share_outlined, label: 'Share'),
                            SizedBox(width: 10.w),
                            _OutBtn(
                              icon: Icons.download_outlined,
                              label: 'Download Report',
                            ),
                            SizedBox(width: 10.w),
                            _OutBtn(
                              icon: Icons.refresh_outlined,
                              label: 'Run New Simulation',
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _IconCircleBtn(
                              icon: Icons.send_outlined,
                              filled: true,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const SendResultScreen(),
                                ),
                              ),
                            ),
                            _IconCircleBtn(
                              icon: Icons.share_outlined,
                              filled: false,
                              onTap: () {},
                            ),
                            _IconCircleBtn(
                              icon: Icons.download_outlined,
                              filled: false,
                              onTap: () {},
                            ),
                            _IconCircleBtn(
                              icon: Icons.refresh_outlined,
                              filled: false,
                              onTap: () {},
                            ),
                          ],
                        ),
                  Gap(16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab-specific analysis content ─────────────────────────────────────────────
class _TabAnalysis extends StatelessWidget {
  const _TabAnalysis({required this.activeView, required this.isWide});
  final String activeView;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    if (activeView == 'Front View') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis Summary',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
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
                    _AnalysisRow('Alignment Correction', '85%'),
                    _AnalysisRow('Whitening Level', '3 shades'),
                    _AnalysisRow('Smile Balance', '92%'),
                  ],
                ),
        ],
      );
    }

    if (activeView == 'Side Profile') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Analysis Summary',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Gap(10.h),
                          _AnalysisIconCard(
                            icon: Icons.person_outline,
                            label: 'Facial Profile Balance',
                            sublabel: '+15%',
                            value: '94%',
                          ),
                          Gap(8.h),
                          _AnalysisIconCard(
                            icon: Icons.straighten,
                            label: 'Bite Alignment',
                            sublabel: 'Improved',
                            value: '88%',
                          ),
                          Gap(8.h),
                          _AnalysisIconCard(
                            icon: Icons.check_circle_outline,
                            label: 'Jaw Position',
                            sublabel: 'Corrected',
                            value: 'Optimal',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Facial Measurements',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Gap(10.h),
                          _MeasurementRow('Lower Face Height', '63mm'),
                          _MeasurementRow('Nasolabial Angle', '102°'),
                          _MeasurementRow('Chin Prominence', 'Ideal'),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analysis Summary',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    Gap(10.h),
                    _AnalysisRow('Facial Profile Balance', '94%'),
                    _AnalysisRow('Bite Alignment', '88%'),
                    _AnalysisRow('Jaw Position', 'Optimal'),
                    Gap(12.h),
                    Text(
                      'Facial Measurements',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    Gap(10.h),
                    _MeasurementRow('Lower Face Height', '63mm'),
                    _MeasurementRow('Nasolabial Angle', '102°'),
                    _MeasurementRow('Chin Prominence', 'Ideal'),
                  ],
                ),
        ],
      );
    }

    // Closeup View
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analysis Summary',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                        Gap(10.h),
                        _AnalysisIconCard(
                          icon: Icons.brightness_high_outlined,
                          label: 'Tooth Whiteness',
                          sublabel: '+3 Shades',
                          value: 'A1 Shade',
                        ),
                        Gap(8.h),
                        _AnalysisIconCard(
                          icon: Icons.star_outline,
                          label: 'Gum Health Visual',
                          sublabel: 'Excellent',
                          value: '98%',
                        ),
                        Gap(8.h),
                        _AnalysisIconCard(
                          icon: Icons.grid_on_outlined,
                          label: 'Tooth Uniformity',
                          sublabel: '+10%',
                          value: '95%',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tooth Details',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                        Gap(10.h),
                        _MeasurementRow('Upper Central', 'Excellent'),
                        _MeasurementRow('Upper Lateral', 'Very Good'),
                        _MeasurementRow('Upper Canine', 'Good'),
                        _MeasurementRow('Lower Central', 'Excellent'),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analysis Summary',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  Gap(10.h),
                  _AnalysisRow('Tooth Whiteness', 'A1 Shade'),
                  _AnalysisRow('Gum Health Visual', '98%'),
                  _AnalysisRow('Tooth Uniformity', '95%'),
                  Gap(12.h),
                  Text(
                    'Facial Measurements',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  Gap(10.h),
                  _MeasurementRow('Upper Central', 'Excellent'),
                  _MeasurementRow('Upper Lateral', 'Very Good'),
                  _MeasurementRow('Upper Canine', 'Good'),
                  _MeasurementRow('Lower Central', 'Excellent'),
                ],
              ),
      ],
    );
  }
}

class _AnalysisIconCard extends StatelessWidget {
  const _AnalysisIconCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.value,
  });
  final IconData icon;
  final String label, sublabel, value;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: AppColors.inputBorder),
    ),
    child: Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.primary),
        SizedBox(width: 10.w),
        Expanded(
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
              Text(
                sublabel,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  color: AppColors.gray,
                ),
              ),
            ],
          ),
        ),
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
  );
}

class _MeasurementRow extends StatelessWidget {
  const _MeasurementRow(this.label, this.value);
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
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
      ],
    ),
  );
}

class _QualityBar extends StatelessWidget {
  const _QualityBar({
    required this.label,
    required this.value,
    required this.percent,
  });
  final String label, percent;
  final double value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 100.w,
        child: Text(
          label,
          style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
        ),
      ),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6.h,
            backgroundColor: AppColors.inputBorder,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
      SizedBox(width: 8.w),
      Text(
        percent,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
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

class _AnalysisRow extends StatelessWidget {
  const _AnalysisRow(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
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
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    ),
  );
}

class _OutBtn extends StatelessWidget {
  const _OutBtn({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: () {},
    icon: Icon(icon, size: 13.sp),
    label: Text(
      label,
      style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600),
    ),
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.textColor,
      side: BorderSide(color: AppColors.inputBorder),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    ),
  );
}

class _IconCircleBtn extends StatelessWidget {
  const _IconCircleBtn({
    required this.icon,
    required this.filled,
    required this.onTap,
  });
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AppColors.primary : Colors.white,
        border: Border.all(
          color: filled ? AppColors.primary : AppColors.inputBorder,
        ),
      ),
      child: Icon(
        icon,
        size: 20.sp,
        color: filled ? Colors.white : AppColors.gray,
      ),
    ),
  );
}
