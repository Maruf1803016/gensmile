import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';

// ── Providers ─────────────────────────────────────────────────────────────────
final docFilterProvider = StateProvider<String>((ref) => 'All Documents');
final docSearchProvider = StateProvider<String>((ref) => '');

// ── Dummy data ────────────────────────────────────────────────────────────────
const _kDocuments = [
  _Doc(
    title: 'Smile Simulation Report',
    category: 'Simulation Reports',
    date: 'Jan 20, 2026',
    size: '2.4 MB',
    type: 'pdf',
  ),
  _Doc(
    title: 'Intraoral Scan Photos',
    category: 'Scan Files',
    date: 'Jan 20, 2026',
    size: '5.6 MB',
    type: 'scan',
  ),
  _Doc(
    title: 'Smile Simulation Report',
    category: 'Simulation Reports',
    date: 'Jan 20, 2026',
    size: '2.4 MB',
    type: 'pdf',
  ),
  _Doc(
    title: 'Smile Simulation Report',
    category: 'Simulation Reports',
    date: 'Jan 20, 2026',
    size: '2.4 MB',
    type: 'pdf',
  ),
  _Doc(
    title: 'Invoice #INV-001',
    category: 'Treatment Documents',
    date: 'Jan 20, 2026',
    size: '2.4 MB',
    type: 'pdf',
  ),
  _Doc(
    title: 'Smile Simulation Report',
    category: 'Simulation Reports',
    date: 'Jan 20, 2026',
    size: '2.4 MB',
    type: 'pdf',
  ),
  _Doc(
    title: 'Lower Jaw X-Ray',
    category: 'X-Ray Files',
    date: 'Jan 20, 2026',
    size: '2.4 MB',
    type: 'xray',
  ),
];

const _kFilters = [
  'All Documents',
  'Simulation Reports',
  'Treatment Documents',
  'X-Ray Files',
  'Scan Files',
];

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final activeFilter = ref.watch(docFilterProvider);
    final searchQuery = ref.watch(docSearchProvider);

    final filtered = _kDocuments.where((d) {
      final matchFilter =
          activeFilter == 'All Documents' || d.category == activeFilter;
      final matchSearch =
          searchQuery.isEmpty ||
          d.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchFilter && matchSearch;
    }).toList();

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Top bar ──
        Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back arrow row (standalone only)
                  if (!embedded)
                    Row(
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
                        Expanded(
                          child: Text(
                            'Documents & Records',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.notifications_outlined,
                          size: 22.sp,
                          color: AppColors.gray,
                        ),
                      ],
                    ),

                  if (embedded) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Documents & Records',
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                              Text(
                                'All your dental records, reports, and files in one place',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.download, size: 14.sp),
                          label: Text(
                            'Download All',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Gap(4.h),
                    Text(
                      'All your dental records, reports, and files in one place',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // ── Body ──
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Stat cards ──
                isWide
                    ? Row(
                        children: [
                          _StatCard(
                            icon: Icons.folder_open_outlined,
                            label: 'Total Files',
                            value: '10',
                          ),
                          SizedBox(width: 12.w),
                          _StatCard(
                            icon: Icons.description_outlined,
                            label: 'Reports',
                            value: '3',
                          ),
                          SizedBox(width: 12.w),
                          _StatCard(
                            icon: Icons.image_outlined,
                            label: 'X-Rays',
                            value: '5',
                          ),
                          SizedBox(width: 12.w),
                          _StatCard(
                            icon: Icons.view_in_ar_outlined,
                            label: '3D Scans',
                            value: '2',
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _StatCard(
                              icon: Icons.folder_open_outlined,
                              label: 'Total Files',
                              value: '10',
                            ),
                            SizedBox(width: 10.w),
                            _StatCard(
                              icon: Icons.description_outlined,
                              label: 'Reports',
                              value: '3',
                            ),
                            SizedBox(width: 10.w),
                            _StatCard(
                              icon: Icons.image_outlined,
                              label: 'X-Rays',
                              value: '5',
                            ),
                            SizedBox(width: 10.w),
                            _StatCard(
                              icon: Icons.view_in_ar_outlined,
                              label: '3D Scans',
                              value: '2',
                            ),
                          ],
                        ),
                      ),
                Gap(16.h),

                // ── Filter tabs ──
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._kFilters.map(
                        (f) => GestureDetector(
                          onTap: () =>
                              ref.read(docFilterProvider.notifier).state = f,
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
                              borderRadius: BorderRadius.circular(20.r),
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
                      ),
                    ],
                  ),
                ),
                Gap(12.h),

                // ── Search bar ──
                Container(
                  height: 38.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                      Icon(Icons.search, size: 16.sp, color: AppColors.gray),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          onChanged: (v) =>
                              ref.read(docSearchProvider.notifier).state = v,
                          style: GoogleFonts.inter(fontSize: 13.sp),
                          decoration: InputDecoration(
                            hintText: 'Search documents...',
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
                Gap(8.h),

                // ── File count ──
                Text(
                  '${filtered.length} files found',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                ),
                Gap(8.h),

                // ── Document list ──
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Column(
                    children: filtered
                        .map(
                          (doc) => _DocRow(
                            doc: doc,
                            isWide: isWide,
                            onView: () => _showDocumentViewer(context, doc),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
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

  void _showDocumentViewer(BuildContext context, _Doc doc) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    if (isWide) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: SizedBox(
            width: 560.w,
            child: _DocumentViewerContent(doc: doc),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => DraggableScrollableSheet(
          initialChildSize: 0.92,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: _DocumentViewerContent(
              doc: doc,
              scrollController: controller,
            ),
          ),
        ),
      );
    }
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label, value;

  @override
  Widget build(BuildContext context) => Container(
    width: 120.w,
    padding: EdgeInsets.all(14.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: AppColors.inputBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 18.sp, color: AppColors.primary),
        ),
        Gap(8.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
        ),
      ],
    ),
  );
}

// ── Document Row ──────────────────────────────────────────────────────────────
class _DocRow extends StatelessWidget {
  const _DocRow({
    required this.doc,
    required this.isWide,
    required this.onView,
  });
  final _Doc doc;
  final bool isWide;
  final VoidCallback onView;

  IconData get _icon {
    if (doc.type == 'xray') return Icons.image_outlined;
    if (doc.type == 'scan') return Icons.crop_free;
    return Icons.description_outlined;
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
    ),
    child: isWide
        ? Row(
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(_icon, size: 16.sp, color: AppColors.primary),
              ),
              SizedBox(width: 12.w),
              // Title + category + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.title,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          doc.category,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.gray,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 10.sp,
                          color: AppColors.gray,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          doc.date,
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
              // Size
              Row(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Icon(
                      Icons.picture_as_pdf,
                      size: 12.sp,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    doc.size,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 24.w),
              // View
              GestureDetector(
                onTap: onView,
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 16.sp,
                      color: AppColors.gray,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'View',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24.w),
              // Download
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.download_outlined,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Download All',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Row(
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(_icon, size: 16.sp, color: AppColors.primary),
              ),
              SizedBox(width: 10.w),
              // Title + category + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.title,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          doc.category,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: AppColors.gray,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 9.sp,
                          color: AppColors.gray,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          doc.date,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Size + download
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: Icon(
                          Icons.picture_as_pdf,
                          size: 10.sp,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        doc.size,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                  Gap(4.h),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.download_outlined,
                          size: 14.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Download',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
  );
}

// ── Document Viewer ───────────────────────────────────────────────────────────
class _DocumentViewerContent extends StatelessWidget {
  const _DocumentViewerContent({required this.doc, this.scrollController});
  final _Doc doc;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    size: 16.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PROFESSIONAL DOCUMENT',
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          color: Colors.white70,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        'DDS License',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Print button
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.print_outlined,
                    size: 13.sp,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Print',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: Colors.white,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white54),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Download PDF
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.download_outlined, size: 13.sp),
                  label: Text(
                    'Download PDF',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 20.sp, color: Colors.white),
                ),
              ],
            ),
          ),

          // ── Scrollable content ──
          Flexible(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor info row
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 22.r,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            'MC',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Wrap(
                            spacing: 24.w,
                            runSpacing: 8.h,
                            children: [
                              _InfoField(
                                label: 'Name',
                                value: 'Dr. Michael Chen',
                              ),
                              _InfoField(
                                label: 'Doctor ID',
                                value: 'DR-2024-0042',
                              ),
                              _InfoField(
                                label: 'License Number',
                                value: 'NY-DDS-44892',
                              ),
                              _InfoField(
                                label: 'Issue Date',
                                value: 'Jan 15, 2024',
                              ),
                              _InfoField(
                                label: 'Specialty',
                                value: 'Cosmetic Dentistry',
                              ),
                              _InfoField(
                                label: 'Clinic',
                                value: 'BrightSmile Dental',
                              ),
                              _InfoField(
                                label: 'Expiry Date',
                                value: 'Dec 31, 2026',
                              ),
                              _InfoField(
                                label: 'Status',
                                value: 'Active',
                                isStatus: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(16.h),

                  // License Information
                  _SectionCard(
                    title: 'License Information',
                    icon: Icons.verified_outlined,
                    child: Wrap(
                      spacing: 24.w,
                      runSpacing: 12.h,
                      children: [
                        _InfoField(
                          label: 'License Type',
                          value: 'Doctor of Dental Surgery (DDS)',
                        ),
                        _InfoField(
                          label: 'Issuing Authority',
                          value: 'New York State Education Department',
                        ),
                        _InfoField(
                          label: 'License Number',
                          value: 'NY-DDS-44892',
                        ),
                        _InfoField(
                          label: 'Issue Date',
                          value: 'January 15, 2024',
                        ),
                        _InfoField(
                          label: 'Expiration Date',
                          value: 'December 31, 2026',
                        ),
                        _InfoField(
                          label: 'Renewal Status',
                          value: 'Current - Valid',
                          isStatus: true,
                        ),
                      ],
                    ),
                  ),
                  Gap(16.h),

                  // Scope of Practice
                  _SectionCard(
                    title: 'Scope of Practice',
                    child: Column(
                      children: [
                        _ScopeItem(
                          'General Dentistry',
                          'Comprehensive dental care and preventive services',
                        ),
                        _ScopeItem(
                          'Cosmetic Dentistry',
                          'Veneers, whitening, smile makeovers',
                        ),
                        _ScopeItem(
                          'Restorative Procedures',
                          'Crowns, bridges, fillings, and implants',
                        ),
                        _ScopeItem(
                          'Orthodontic Treatment',
                          'Invisalign and clear aligner therapy',
                        ),
                      ],
                    ),
                  ),
                  Gap(16.h),

                  // Verified Credential
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.shield_outlined,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Verified Credential',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                              Gap(4.h),
                              Text(
                                'This license has been verified with the New York State Education Department and is in good standing.',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                              Gap(6.h),
                              Text(
                                'Verification Date: January 20, 2024  •  Next Verification: January 2025',
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
                  Gap(16.h),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Document Generated',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: AppColors.gray,
                            ),
                          ),
                          Text(
                            'Jan 15, 2024 • 2:45 PM',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Issued by',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: AppColors.gray,
                            ),
                          ),
                          Text(
                            'BrightSmile Dental • License #NYC-D865-4892',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(8.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────
class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.value,
    this.isStatus = false,
  });
  final String label, value;
  final bool isStatus;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 160.w,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10.sp, color: AppColors.gray),
        ),
        Gap(2.h),
        isStatus
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
      ],
    ),
  );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.icon});
  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.inputBorder),
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.sp, color: AppColors.primary),
              SizedBox(width: 6.w),
            ],
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
        Gap(12.h),
        child,
      ],
    ),
  );
}

class _ScopeItem extends StatelessWidget {
  const _ScopeItem(this.title, this.subtitle);
  final String title, subtitle;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, size: 10.sp, color: Colors.white),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                subtitle,
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
  );
}

// ── Model ─────────────────────────────────────────────────────────────────────
class _Doc {
  const _Doc({
    required this.title,
    required this.category,
    required this.date,
    required this.size,
    required this.type,
  });
  final String title, category, date, size, type;
}
