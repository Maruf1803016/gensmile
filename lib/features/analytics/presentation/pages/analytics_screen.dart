import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'dart:math' as math;
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/core/states/navigator_state.dart';

// ── Time filter provider ──────────────────────────────────────────────────────
final analyticsFilterProvider = StateProvider<String>((ref) => 'Last Months');

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key, this.embedded = false});
  final bool embedded;

  static const _filters = ['Last 7 Days', 'Last Months', 'Last 3 Month', 'Last Year'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final selectedFilter = ref.watch(analyticsFilterProvider);

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back arrow row (mobile standalone only)
              if (!embedded)
                Row(children: [
                  GestureDetector(
                    onTap: () => ref.read(navigatorState.notifier).pop(),
                    child: Icon(Icons.arrow_back, size: 22.sp, color: AppColors.textColor),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text('Analytics Overview',
                        style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
                  ),
                  Icon(Icons.notifications_outlined, size: 22.sp, color: AppColors.gray),
                  SizedBox(height: 14.h),
                ]),

              if (embedded) ...[
                Text('Analytics Overview',
                    style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
                Gap(2.h),
                Text('Track performance, patient insights, and revenue in real time',
                    style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray)),
                Gap(12.h),
              ] else
                Gap(12.h),

              // Time filter tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final isSelected = selectedFilter == f;
                    return GestureDetector(
                      onTap: () => ref.read(analyticsFilterProvider.notifier).state = f,
                      child: Container(
                        margin: EdgeInsets.only(right: 8.w),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.inputBorder),
                        ),
                        child: Text(f,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? Colors.white : AppColors.gray,
                            )),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Gap(14.h),
            ],
          ),
        ),

        // ── Scrollable content ──
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: isWide ? _DesktopContent() : _MobileContent(),
          ),
        ),
      ],
    );

    if (!embedded) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F5F7),
        body: SafeArea(child: body),
      );
    }

    return ColoredBox(
      color: const Color(0xFFF4F5F7),
      child: SafeArea(bottom: false, child: body),
    );
  }
}

// ── Desktop layout ────────────────────────────────────────────────────────────
class _DesktopContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Stat cards
      Row(children: [
        _StatCard(icon: Icons.people_outline,       iconColor: AppColors.primary,   label: 'Total Patients',    value: '1,284', change: '+12%', positive: true),
        SizedBox(width: 12.w),
        _StatCard(icon: Icons.auto_awesome,         iconColor: const Color(0xFF7C3AED), label: 'Total Simulations', value: '42',    change: '+5%',  positive: true),
        SizedBox(width: 12.w),
        _StatCard(icon: Icons.pending_outlined,     iconColor: AppColors.info,      label: 'Active Cases',      value: '15',    change: '-2%',  positive: false),
        SizedBox(width: 12.w),
        _StatCard(icon: Icons.check_circle_outline, iconColor: AppColors.success,   label: 'Completed Cases',   value: '432',   change: '+18%', positive: true),
      ]),
      Gap(16.h),

      // Bar chart + Simulation Conversion
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 3, child: _MonthlyBarChart()),
        SizedBox(width: 16.w),
        Expanded(flex: 2, child: _SimulationConversionCard()),
      ]),
      Gap(16.h),

      // Treatment Distribution + Credit Status + Patient Geography
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _TreatmentDistributionCard()),
        SizedBox(width: 16.w),
        Expanded(child: _CreditStatusCard()),
        SizedBox(width: 16.w),
        Expanded(child: _PatientGeographyCard()),
      ]),
      Gap(16.h),
    ]);
  }
}

// ── Mobile layout ─────────────────────────────────────────────────────────────
class _MobileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Key Metrics 2x2 grid
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Key Metrics', style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
        Text('Live Updates', style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w500)),
      ]),
      Gap(10.h),
      Row(children: [
        Expanded(child: _MiniMetricCard(label: 'Total Patients',    value: '1,284')),
        SizedBox(width: 10.w),
        Expanded(child: _MiniMetricCard(label: 'Total Simulations', value: '42')),
      ]),
      Gap(10.h),
      Row(children: [
        Expanded(child: _MiniMetricCard(label: 'Active Cases',      value: '15')),
        SizedBox(width: 10.w),
        Expanded(child: _MiniMetricCard(label: 'Completed Cases',   value: '432')),
      ]),
      Gap(20.h),

      _MonthlyBarChart(),
      Gap(16.h),
      _SimulationConversionCard(),
      Gap(16.h),
      _TreatmentDistributionCard(),
      Gap(16.h),
      _CreditStatusCard(),
      Gap(16.h),
      _PatientGeographyCard(),
      Gap(16.h),
    ]);
  }
}

// ── Stat card (desktop) ───────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.iconColor, required this.label,
      required this.value, required this.change, required this.positive});
  final IconData icon; final Color iconColor; final String label, value, change; final bool positive;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(color: AppColors.inputBorder)),
      child: Row(children: [
        Container(padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
            child: Icon(icon, size: 18.sp, color: iconColor)),
        SizedBox(width: 10.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray)),
          Gap(2.h),
          Text(value, style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
          Row(children: [
            Icon(positive ? Icons.trending_up : Icons.trending_down, size: 12.sp,
                color: positive ? AppColors.success : AppColors.danger),
            SizedBox(width: 3.w),
            Text(change, style: GoogleFonts.inter(fontSize: 11.sp, color: positive ? AppColors.success : AppColors.danger)),
          ]),
        ])),
      ]),
    ),
  );
}

// ── Mini metric card (mobile) ─────────────────────────────────────────────────
class _MiniMetricCard extends StatelessWidget {
  const _MiniMetricCard({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.inputBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray)),
      Gap(4.h),
      Text(value, style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
    ]),
  );
}

// ── Monthly Bar Chart ─────────────────────────────────────────────────────────
class _MonthlyBarChart extends StatelessWidget {
  static const _data = [
    _Bar('Jan', 0.55), _Bar('Feb', 0.72), _Bar('Mar', 0.48),
    _Bar('Apr', 0.65), _Bar('May', 1.00), _Bar('Jun', 0.60),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.inputBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Monthly Case Trend',
              style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textColor))),
          // Conversion rate + ratio
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('Conversion Rate', style: GoogleFonts.inter(fontSize: 10.sp, color: AppColors.gray)),
            Text('64%', style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
          ]),
          SizedBox(width: 16.w),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('Ratio (C:T)', style: GoogleFonts.inter(fontSize: 10.sp, color: AppColors.gray)),
            Text('3.2:1', style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
          ]),
        ]),
        Gap(16.h),
        SizedBox(
          height: 140.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Y-axis labels
              Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('80', style: GoogleFonts.inter(fontSize: 9.sp, color: AppColors.gray)),
                Text('60', style: GoogleFonts.inter(fontSize: 9.sp, color: AppColors.gray)),
                Text('40', style: GoogleFonts.inter(fontSize: 9.sp, color: AppColors.gray)),
                Text('20', style: GoogleFonts.inter(fontSize: 9.sp, color: AppColors.gray)),
                Text('0',  style: GoogleFonts.inter(fontSize: 9.sp, color: AppColors.gray)),
              ]),
              SizedBox(width: 8.w),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _data.map((bar) => Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: bar.value,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: bar.value == 1.0
                                      ? [AppColors.primary, AppColors.primary]
                                      : [AppColors.primary.withOpacity(0.3), AppColors.primary.withOpacity(0.15)],
                                ),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(bar.label,
                            style: GoogleFonts.inter(fontSize: 9.sp,
                                fontWeight: bar.value == 1.0 ? FontWeight.w700 : FontWeight.w400,
                                color: bar.value == 1.0 ? AppColors.primary : AppColors.gray)),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class _Bar {
  const _Bar(this.label, this.value);
  final String label; final double value;
}

// ── Simulation Conversion ─────────────────────────────────────────────────────
class _SimulationConversionCard extends StatelessWidget {
  static const _items = [
    _ConvItem('Simulation',  1.00, '100% (881)', Color(0xFF7C3AED)),
    _ConvItem('Consultation', 0.68, '68% (605)',  Color(0xFF7C3AED)),
    _ConvItem('Treatment',    0.42, '42% (374)',  Color(0xFFB794F4)),
  ];

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.inputBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text('Simulation Conversion',
            style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textColor))),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r)),
          child: Text('82% Avg Rate', style: GoogleFonts.inter(fontSize: 10.sp, color: AppColors.success, fontWeight: FontWeight.w600)),
        ),
      ]),
      Gap(14.h),
      ..._items.map((item) => Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(item.label, style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.textColor)),
            Text(item.valueText, style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray)),
          ]),
          Gap(6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: item.value,
              minHeight: 10.h,
              backgroundColor: item.color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(item.color),
            ),
          ),
        ]),
      )),
    ]),
  );
}

class _ConvItem {
  const _ConvItem(this.label, this.value, this.valueText, this.color);
  final String label, valueText; final double value; final Color color;
}

// ── Treatment Distribution (Donut) ────────────────────────────────────────────
class _TreatmentDistributionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.inputBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Treatment Distribution',
          style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
      Gap(16.h),
      Center(
        child: SizedBox(
          width: 160.w, height: 160.w,
          child: Stack(alignment: Alignment.center, children: [
            CustomPaint(size: Size(160.w, 160.w), painter: _DonutPainter()),
            Text('45%', style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.textColor)),
          ]),
        ),
      ),
      Gap(12.h),
      Wrap(spacing: 12.w, runSpacing: 6.h, children: [
        _Legend('Clear Aligners', AppColors.primary),
        _Legend('Smile Makeover', const Color(0xFF93C5FD)),
        _Legend('Whitening',      const Color(0xFF1E40AF)),
        _Legend('Veneers',        const Color(0xFF60A5FA)),
      ]),
    ]),
  );
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 28.0;
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.butt;

    final segments = [
      (0.45, const Color(0xFF1D4ED8)),
      (0.25, const Color(0xFF93C5FD)),
      (0.20, const Color(0xFF1E40AF)),
      (0.10, const Color(0xFF60A5FA)),
    ];

    double startAngle = -math.pi / 2;
    for (final seg in segments) {
      paint.color = seg.$2;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          startAngle, seg.$1 * 2 * math.pi, false, paint);
      startAngle += seg.$1 * 2 * math.pi;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Credit Status Bar Chart ───────────────────────────────────────────────────
class _CreditStatusCard extends StatelessWidget {
  static const _data = [
    _Bar('Jan', 0.78), _Bar('Feb', 0.55), _Bar('Mar', 0.90),
    _Bar('Apr', 0.65), _Bar('May', 0.85),
  ];

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.inputBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Credit Status', style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
      Gap(16.h),
      SizedBox(
        height: 140.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('100', style: GoogleFonts.inter(fontSize: 9.sp, color: AppColors.gray)),
              Text('75',  style: GoogleFonts.inter(fontSize: 9.sp, color: AppColors.gray)),
              Text('50',  style: GoogleFonts.inter(fontSize: 9.sp, color: AppColors.gray)),
              Text('25',  style: GoogleFonts.inter(fontSize: 9.sp, color: AppColors.gray)),
              Text('0',   style: GoogleFonts.inter(fontSize: 9.sp, color: AppColors.gray)),
            ]),
            SizedBox(width: 8.w),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _data.map((bar) => Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: bar.value,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(bar.label, style: GoogleFonts.inter(fontSize: 9.sp, color: AppColors.gray)),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    ]),
  );
}

// ── Patient Geography Pie Chart ───────────────────────────────────────────────
class _PatientGeographyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.inputBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Patient Geography',
          style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textColor)),
      Gap(16.h),
      Center(
        child: SizedBox(
          width: 160.w, height: 160.w,
          child: CustomPaint(size: Size(160.w, 160.w), painter: _PiePainter()),
        ),
      ),
      Gap(12.h),
      Wrap(spacing: 12.w, runSpacing: 6.h, children: [
        _Legend('America', const Color(0xFFF59E0B)),
        _Legend('Asia',    const Color(0xFF6366F1)),
        _Legend('Europe',  const Color(0xFFEC4899)),
        _Legend('Africa',  const Color(0xFF10B981)),
      ]),
    ]),
  );
}

class _PiePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final paint = Paint()..style = PaintingStyle.fill;

    final segments = [
      (0.70, const Color(0xFFF59E0B)),
      (0.17, const Color(0xFF6366F1)),
      (0.13, const Color(0xFFEC4899)),
      (0.00, const Color(0xFF10B981)),
    ];

    // Draw pie slices
    double startAngle = -math.pi / 2;
    for (final seg in segments) {
      if (seg.$1 == 0) continue;
      paint.color = seg.$2;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          startAngle, seg.$1 * 2 * math.pi, true, paint);
      startAngle += seg.$1 * 2 * math.pi;
    }

    // Draw percentage labels
    startAngle = -math.pi / 2;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (final seg in segments) {
      if (seg.$1 < 0.08) { startAngle += seg.$1 * 2 * math.pi; continue; }
      final midAngle = startAngle + seg.$1 * math.pi;
      final labelRadius = radius * 0.65;
      final labelPos = Offset(
        center.dx + labelRadius * math.cos(midAngle),
        center.dy + labelRadius * math.sin(midAngle),
      );
      textPainter.text = TextSpan(
        text: '${(seg.$1 * 100).toInt()}%',
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
      );
      textPainter.layout();
      textPainter.paint(canvas, labelPos - Offset(textPainter.width / 2, textPainter.height / 2));
      startAngle += seg.$1 * 2 * math.pi;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Legend item ───────────────────────────────────────────────────────────────
class _Legend extends StatelessWidget {
  const _Legend(this.label, this.color);
  final String label; final Color color;

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 8.w, height: 8.w, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    SizedBox(width: 5.w),
    Text(label, style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray)),
  ]);
}
