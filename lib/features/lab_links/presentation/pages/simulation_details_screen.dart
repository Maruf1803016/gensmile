import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'generate_lab_link_screen.dart';
import 'package:gen_smile/generated/assets.dart';

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
    final isWide = MediaQuery.of(context).size.width >= 600;

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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.people_outline,
                      size: 20,
                      color: AppColors.textColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Simulation History of Simulation #1',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            'View all generated versions and analysis results for this simulation',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isWide)
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.refresh, size: 14),
                        label: Text(
                          'Run New Simulation',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            Assets.imagesAvatarFemale,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 4,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Sarah Johnson',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _Badge('In Treatment', AppColors.info),
                                    ],
                                  ),
                                  Text(
                                    'ID: P001',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                  Text(
                                    '28 years • Female',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                  Text(
                                    'Last Visit: Mar 5, 2026',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
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
                  const SizedBox(height: 16),

                  // Simulation History
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

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

// ── Simulation Entry ──
class _SimulationEntry extends StatelessWidget {
  final _Sim sim;
  final bool isWide;
  final VoidCallback onGenerateLink;

  const _SimulationEntry({
    required this.sim,
    required this.isWide,
    required this.onGenerateLink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sim.title,
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            sim.date,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.gray),
          ),
          const SizedBox(height: 12),

          // Images Row
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    Assets.imagesImageBefore,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    Assets.imagesImageAfter,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Analysis Summary
          _AnalysisSummary(isWide: isWide),

          const SizedBox(height: 14),

          // Action Buttons
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
                    const SizedBox(width: 8),
                    _OutlineActionBtn(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      color: AppColors.gray,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _OutlineActionBtn(
                      icon: Icons.download_outlined,
                      label: 'Download',
                      color: AppColors.gray,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
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
        ],
      ),
    );
  }
}

// ── Analysis Summary ──
class _AnalysisSummary extends StatelessWidget {
  final bool isWide;
  const _AnalysisSummary({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Summary',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        isWide
            ? Row(
                children: const [
                  _AnalysisCard(label: 'Alignment Correction', value: '85%'),
                  SizedBox(width: 12),
                  _AnalysisCard(label: 'Whitening Level', value: '3 shades'),
                  SizedBox(width: 12),
                  _AnalysisCard(label: 'Smile Balance', value: '92%'),
                ],
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _AnalysisCard(label: 'Alignment Correction', value: '85%'),
                  _AnalysisCard(label: 'Whitening Level', value: '3 shades'),
                  _AnalysisCard(label: 'Smile Balance', value: '92%'),
                ],
              ),
      ],
    );
  }
}

// ── Analysis Card ──
class _AnalysisCard extends StatelessWidget {
  final String label;
  final String value;
  const _AnalysisCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.gray)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Badge ──
class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Stat Item ──
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.gray),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: GoogleFonts.inter(fontSize: 11, color: AppColors.gray),
        ),
      ],
    );
  }
}

// ── Outline Action Button ──
class _OutlineActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _OutlineActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return filled
        ? ElevatedButton.icon(
            onPressed: onTap,
            icon: Icon(icon, size: 14),
            label: Text(label, style: const TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
          )
        : OutlinedButton.icon(
            onPressed: onTap,
            icon: Icon(icon, size: 14, color: color),
            label: Text(label, style: TextStyle(fontSize: 12, color: color)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
          );
  }
}

// ── Icon Only Button ──
class _IconOnlyBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _IconOnlyBtn({
    required this.icon,
    required this.color,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return filled
        ? ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.all(8),
            ),
            child: Icon(icon, size: 16, color: Colors.white),
          )
        : OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(8)),
            child: Icon(icon, size: 16, color: color),
          );
  }
}

// ── Simulation Model ──
class _Sim {
  final String id;
  final String title;
  final String date;
  const _Sim({required this.id, required this.title, required this.date});
}