import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/lab_links/presentation/pages/case_details_screen.dart';
import 'package:gen_smile/features/lab_links/presentation/pages/generate_lab_link_screen.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/notifications_screen.dart';
import 'package:gen_smile/generated/assets.dart';

// ── Providers ─────────────────────────────────────────────────────────────────
final labLinkFilterProvider = StateProvider<String>((ref) => 'All');
final labLinkSearchProvider = StateProvider<String>((ref) => '');

// ── Dummy data ────────────────────────────────────────────────────────────────
const _kPatients = [
  _Patient(
    serial: 'P001',
    name: 'Sarah Johnson',
    initials: 'SJ',
    phone: '+1 (555) 234-5678',
    color: Color(0xFF7C3AED),
  ),
  _Patient(
    serial: 'P002',
    name: 'Michael Chen',
    initials: 'MC',
    phone: '+1 (555) 345-6789',
    color: Color(0xFF059669),
  ),
  _Patient(
    serial: 'P003',
    name: 'Emma Williams',
    initials: 'EW',
    phone: '+1 (555) 456-7890',
    color: Color(0xFFDC2626),
  ),
  _Patient(
    serial: 'P004',
    name: 'David Martinez',
    initials: 'DM',
    phone: '+1 (555) 567-8901',
    color: Color(0xFF2563EB),
  ),
  _Patient(
    serial: 'P005',
    name: 'Lisa Anderson',
    initials: 'LA',
    phone: '+1 (555) 678-9012',
    color: Color(0xFFD97706),
  ),
  _Patient(
    serial: 'P006',
    name: 'James Taylor',
    initials: 'JT',
    phone: '+1 (555) 789-0123',
    color: Color(0xFF0891B2),
  ),
  _Patient(
    serial: 'P007',
    name: 'Sophia Brown',
    initials: 'SB',
    phone: '+1 (555) 890-1234',
    color: Color(0xFF7C3AED),
  ),
  _Patient(
    serial: 'P008',
    name: 'Robert Davis',
    initials: 'RD',
    phone: '+1 (555) 901-2345',
    color: Color(0xFF059669),
  ),
  _Patient(
    serial: 'P009',
    name: 'Robert Davis',
    initials: 'RD',
    phone: '+1 (555) 901-2345',
    color: Color(0xFF059669),
  ),
  _Patient(
    serial: 'P010',
    name: 'Sophia Brown',
    initials: 'SB',
    phone: '+1 (555) 890-1234',
    color: Color(0xFF7C3AED),
  ),
];

const _kFilters = ['All', 'Active', 'Treatment', 'Completed'];

class LabLinksScreen extends ConsumerWidget {
  const LabLinksScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final activeFilter = ref.watch(labLinkFilterProvider);
    final searchQuery = ref.watch(labLinkSearchProvider);

    final filtered = _kPatients.where((p) {
      return searchQuery.isEmpty ||
          p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.phone.contains(searchQuery) ||
          p.serial.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Top bar ──
        // ── Top Bar ──
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // Back arrow
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back,
                  size: 22.sp,
                  color: AppColors.textColor, // adjust for visibility
                ),
              ),
              SizedBox(width: 12.w),

              // Optional icon before title
              Icon(
                Icons.people_outline,
                size: 20.sp,
                color: AppColors.textColor,
              ),
              SizedBox(width: 8.w),

              // Title & subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lab Links', // Replace with your screen title
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      'Manage lab-ready cases and track production status', // Optional subtitle
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),

              // Notification bell
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const NotificationsScreen(), // Make sure this exists
                    ),
                  );
                },
                child: Icon(
                  Icons.notifications_outlined,
                  size: 22.sp,
                  color: AppColors.gray,
                ),
              ),
            ],
          ),
        ),

        // ── Body ──
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Column(
                children: [
                  // Search + filter
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      children: [
                        // Search bar
                        Container(
                          height: 38.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.inputBorder),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 10.w),
                              Icon(
                                Icons.search,
                                size: 16.sp,
                                color: AppColors.gray,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextField(
                                  onChanged: (v) =>
                                      ref
                                              .read(
                                                labLinkSearchProvider.notifier,
                                              )
                                              .state =
                                          v,
                                  style: GoogleFonts.inter(fontSize: 12.sp),
                                  decoration: InputDecoration(
                                    hintText: 'Search by Name / Phone / ID',
                                    hintStyle: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      color: AppColors.gray,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Filter pills — always scrollable row
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _kFilters
                                .map(
                                  (f) => GestureDetector(
                                    onTap: () =>
                                        ref
                                                .read(
                                                  labLinkFilterProvider
                                                      .notifier,
                                                )
                                                .state =
                                            f,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 8.w),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14.w,
                                        vertical: 7.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: activeFilter == f
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                        border: Border.all(
                                          color: activeFilter == f
                                              ? AppColors.primary
                                              : AppColors.inputBorder,
                                        ),
                                      ),
                                      child: Text(
                                        f,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          fontWeight: activeFilter == f
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: activeFilter == f
                                              ? Colors.white
                                              : AppColors.gray,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table header (desktop only)
                  if (isWide)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        border: Border(
                          top: BorderSide(color: AppColors.inputBorder),
                          bottom: BorderSide(color: AppColors.inputBorder),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80.w,
                            child: Text('SERIAL NO', style: _headerStyle()),
                          ),
                          Expanded(
                            child: Text('PATIENT NAME', style: _headerStyle()),
                          ),
                          SizedBox(
                            width: 160.w,
                            child: Text('PHONE NUMBER', style: _headerStyle()),
                          ),
                          SizedBox(width: 200.w),
                        ],
                      ),
                    ),

                  // Rows
                  ...filtered.map(
                    (p) => _PatientRow(
                      patient: p,
                      isWide: isWide,
                      onView: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CaseDetailsScreen(patient: p),
                        ),
                      ),
                      onGenerate: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const GenerateLabLinkScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (!embedded) {
      return Scaffold(backgroundColor: const Color(0xFFF4F5F7), body: body);
    }
    return ColoredBox(color: const Color(0xFFF4F5F7), child: body);
  }

  TextStyle _headerStyle() => GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.gray,
    letterSpacing: 0.5,
  );
}

// ── Patient Row ───────────────────────────────────────────────────────────────
class _PatientRow extends StatelessWidget {
  const _PatientRow({
    required this.patient,
    required this.isWide,
    required this.onView,
    required this.onGenerate,
  });
  final _Patient patient;
  final bool isWide;
  final VoidCallback onView, onGenerate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
      ),
      child: isWide
          ? Row(
              children: [
                SizedBox(
                  width: 80.w,
                  child: Text(
                    patient.serial,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppColors.gray,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      // Avatar from assets
                      CircleAvatar(
                        radius: 14.r,
                        backgroundColor: AppColors.primary.withOpacity(
                          0.1,
                        ), // optional background
                        backgroundImage: AssetImage(Assets.imagesProfileAvatar),
                        onBackgroundImageError:
                            (_, __) {}, // optional error handling
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        patient.name,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 160.w,
                  child: Text(
                    patient.phone,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppColors.gray,
                    ),
                  ),
                ),
                SizedBox(
                  width: 200.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _ActionBtn(
                        icon: Icons.visibility_outlined,
                        label: 'View',
                        color: AppColors.gray,
                        onTap: onView,
                      ),
                      SizedBox(width: 16.w),
                      _ActionBtn(
                        icon: Icons.send_outlined,
                        label: 'Send',
                        color: AppColors.primary,
                        onTap: () {},
                      ),
                      SizedBox(width: 16.w),
                      _ActionBtn(
                        icon: Icons.link,
                        label: 'Generate',
                        color: AppColors.primary,
                        onTap: onGenerate,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              children: [
                // Avatar from assets
                CircleAvatar(
                  radius: 14.r,
                  backgroundColor: AppColors.primary.withOpacity(
                    0.1,
                  ), // optional background
                  backgroundImage: AssetImage(Assets.imagesProfileAvatar),
                  onBackgroundImageError: (_, __) {}, // optional error handling
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        patient.phone,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ),
                _ActionBtn(
                  icon: Icons.send_outlined,
                  label: 'Send',
                  color: AppColors.primary,
                  onTap: () {},
                ),
                SizedBox(width: 12.w),
                _ActionBtn(
                  icon: Icons.visibility_outlined,
                  label: 'View',
                  color: AppColors.gray,
                  onTap: onView,
                ),
              ],
            ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
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
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: color),
        SizedBox(width: 4.w),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

// ── Model ─────────────────────────────────────────────────────────────────────
class _Patient {
  const _Patient({
    required this.serial,
    required this.name,
    required this.initials,
    required this.phone,
    required this.color,
  });
  final String serial, name, initials, phone;
  final Color color;
}
