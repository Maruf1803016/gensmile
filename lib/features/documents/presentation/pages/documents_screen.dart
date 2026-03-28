// lib/features/documents/presentation/pages/documents_screen.dart
//
// FIX 2: Mobile row layout no longer overflows — action buttons moved to
//        a separate bottom row under the title block.
// FIX 3: "View" / tapping card → opens DocumentViewer (not download).
//        "Download All" → triggers immediate download snackbar.
// FIX 4: Each doc card has margin/gap between it — cards rendered in a
//        Column with spacing instead of borderless dividers.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/notifications_screen.dart';
import 'package:gen_smile/features/documents/data/models/document_model.dart';
import 'package:gen_smile/features/documents/presentation/pages/document_viewer_screen.dart';

// ── Providers ─────────────────────────────────────────────────────────────────
final docFilterProvider = StateProvider<String>((ref) => 'All Documents');
final docSearchProvider = StateProvider<String>((ref) => '');

const _kFilters = [
  'All Documents',
  'Simulation Reports',
  'Treatment Documents',
  'X-Ray Files',
  'Scan Files',
  'Professional Documents',
];

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final activeFilter = ref.watch(docFilterProvider);
    final searchQuery = ref.watch(docSearchProvider);

    final filtered = kMockDocuments.where((d) {
      final matchFilter =
          activeFilter == 'All Documents' || d.category == activeFilter;
      final matchSearch = searchQuery.isEmpty ||
          d.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchFilter && matchSearch;
    }).toList();

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Top bar ───────────────────────────────────────────────────────
        Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
              child: Row(
                children: [
                  // FIX 1: back arrow when not embedded
                  if (!embedded) ...[
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back,
                          size: 22.sp, color: AppColors.textColor),
                    ),
                    SizedBox(width: 12.w),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Documents & Records',
                            style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor)),
                        Text(
                            'All your dental records, reports, and files in one place',
                            style: GoogleFonts.inter(
                                fontSize: 11.sp, color: AppColors.gray)),
                      ],
                    ),
                  ),
                  // Notification bell (FIX 9 from previous session)
                  GestureDetector(
                    onTap: () => ref
                        .read(navigatorState.notifier)
                        .push(const NotificationsScreen()),
                    child: Stack(children: [
                      Icon(Icons.notifications_outlined,
                          size: 22.sp, color: AppColors.gray),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 7.w,
                          height: 7.w,
                          decoration: BoxDecoration(
                              color: AppColors.danger,
                              shape: BoxShape.circle),
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(width: 10.w),
                  // Download All button — FIX 3: triggers download immediately
                  ElevatedButton.icon(
                    onPressed: () => _triggerDownloadAll(context),
                    icon: Icon(Icons.download, size: 14.sp),
                    label: Text('Download All',
                        style: GoogleFonts.inter(
                            fontSize: 11.sp, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 8.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Body ──────────────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stat cards
                _StatCardRow(isWide: isWide),

                Gap(16.h),

                // Filter tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _kFilters.map((f) {
                      final active = activeFilter == f;
                      return GestureDetector(
                        onTap: () =>
                            ref.read(docFilterProvider.notifier).state = f,
                        child: Container(
                          margin: EdgeInsets.only(right: 8.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 7.h),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                                color: active
                                    ? AppColors.primary
                                    : AppColors.inputBorder),
                          ),
                          child: Text(f,
                              style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: active
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color:
                                      active ? Colors.white : AppColors.gray)),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Gap(12.h),

                // Search bar
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Row(children: [
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
                              fontSize: 12.sp, color: AppColors.gray),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ]),
                ),

                Gap(10.h),

                Text('${filtered.length} files found',
                    style: GoogleFonts.inter(
                        fontSize: 12.sp, color: AppColors.gray)),

                Gap(10.h),

                // ── Document cards — FIX 4: each card has margin + rounded
                //    corners + elevation shadow so they're clearly separated ──
                ...filtered.map((doc) => _DocCard(
                      doc: doc,
                      isWide: isWide,
                      // FIX 3: View → opens viewer
                      onView: () => showDocumentViewer(context, doc),
                      // FIX 3: Download → immediate snackbar
                      onDownload: () => _triggerDownload(context, doc),
                    )),
              ],
            ),
          ),
        ),
      ],
    );

    if (!embedded) {
      return Scaffold(
          backgroundColor: const Color(0xFFF4F5F7), body: body);
    }
    return ColoredBox(color: const Color(0xFFF4F5F7), child: body);
  }

  // FIX 3: download helpers
  void _triggerDownload(BuildContext context, DocumentModel doc) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          Icon(Icons.download_done_outlined,
              color: Colors.white, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text('Downloading "${doc.title}"…',
                style: GoogleFonts.inter(fontSize: 13.sp)),
          ),
        ]),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  void _triggerDownloadAll(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          Icon(Icons.download_done_outlined,
              color: Colors.white, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text('Downloading all documents…',
                style: GoogleFonts.inter(fontSize: 13.sp)),
          ),
        ]),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}

// ── Stat card row ─────────────────────────────────────────────────────────────
class _StatCardRow extends StatelessWidget {
  const _StatCardRow({required this.isWide});
  final bool isWide;

  static const _stats = [
    (Icons.folder_open_outlined, 'Total Files', '10'),
    (Icons.description_outlined, 'Reports', '3'),
    (Icons.image_outlined, 'X-Rays', '5'),
    (Icons.view_in_ar_outlined, '3D Scans', '2'),
  ];

  @override
  Widget build(BuildContext context) {
    final cards = _stats
        .map((s) => _StatCard(icon: s.$1, label: s.$2, value: s.$3))
        .toList();

    if (isWide) {
      return Row(
        children: cards
            .map((c) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: c,
                  ),
                ))
            .toList(),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cards
            .map((c) => Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: SizedBox(width: 120.w, child: c),
                ))
            .toList(),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label, value;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 18.sp, color: AppColors.primary),
          ),
          Gap(8.h),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor)),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11.sp, color: AppColors.gray)),
        ]),
      );
}

// ── Document card — FIX 4: card with margin + FIX 2: no overflow ─────────────
class _DocCard extends StatelessWidget {
  const _DocCard({
    required this.doc,
    required this.isWide,
    required this.onView,
    required this.onDownload,
  });

  final DocumentModel doc;
  final bool isWide;
  final VoidCallback onView;
  final VoidCallback onDownload;

  IconData get _icon {
    switch (doc.type) {
      case DocType.xray:
        return Icons.image_outlined;
      case DocType.scan:
        return Icons.crop_free;
      case DocType.license:
        return Icons.verified_outlined;
      case DocType.invoice:
        return Icons.receipt_long_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // FIX 3: tapping anywhere on the card opens the viewer
      onTap: onView,
      child: Container(
        // FIX 4: bottom margin creates visible space between cards
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.inputBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isWide ? _wideContent() : _mobileContent(),
      ),
    );
  }

  // ── Wide layout ──────────────────────────────────────────────────────────
  Widget _wideContent() => Row(children: [
        _iconChip(),
        SizedBox(width: 14.w),
        Expanded(child: _titleBlock()),
        SizedBox(width: 16.w),
        _sizeChip(),
        SizedBox(width: 20.w),
        // FIX 3: "View" opens viewer
        _ActionBtn(
          icon: Icons.visibility_outlined,
          label: 'View',
          color: AppColors.gray,
          onTap: onView,
        ),
        SizedBox(width: 16.w),
        // FIX 3: "Download All" triggers download immediately
        _ActionBtn(
          icon: Icons.download_outlined,
          label: 'Download',
          color: AppColors.primary,
          bold: true,
          onTap: onDownload,
        ),
      ]);

  // ── Mobile layout — FIX 2: no overflow, actions in a second row ──────────
  Widget _mobileContent() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _iconChip(),
            SizedBox(width: 12.w),
            Expanded(child: _titleBlock()),
            SizedBox(width: 8.w),
            _sizeChip(),
          ]),
          Gap(10.h),
          // Action buttons in a dedicated row below — no overflow risk
          Row(children: [
            const Spacer(),
            _ActionBtn(
              icon: Icons.visibility_outlined,
              label: 'View',
              color: AppColors.gray,
              onTap: onView,
            ),
            SizedBox(width: 16.w),
            _ActionBtn(
              icon: Icons.download_outlined,
              label: 'Download',
              color: AppColors.primary,
              bold: true,
              onTap: onDownload,
            ),
          ]),
        ],
      );

  Widget _iconChip() => Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.07),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(_icon, size: 18.sp, color: AppColors.primary),
      );

  Widget _titleBlock() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(doc.title,
              style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor),
              overflow: TextOverflow.ellipsis),
          Gap(2.h),
          Row(children: [
            Flexible(
              child: Text(doc.category,
                  style: GoogleFonts.inter(
                      fontSize: 10.sp, color: AppColors.gray),
                  overflow: TextOverflow.ellipsis),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.calendar_today_outlined,
                size: 9.sp, color: AppColors.gray),
            SizedBox(width: 2.w),
            Text(doc.date,
                style: GoogleFonts.inter(
                    fontSize: 10.sp, color: AppColors.gray)),
          ]),
        ],
      );

  Widget _sizeChip() => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 18.w,
          height: 18.w,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Icon(Icons.picture_as_pdf,
              size: 10.sp, color: Colors.red),
        ),
        SizedBox(width: 4.w),
        Text(doc.size,
            style: GoogleFonts.inter(
                fontSize: 11.sp, color: AppColors.gray)),
      ]);
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.bold = false,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool bold;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15.sp, color: color),
          SizedBox(width: 4.w),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: color,
                  fontWeight:
                      bold ? FontWeight.w600 : FontWeight.w400)),
        ]),
      );
}
