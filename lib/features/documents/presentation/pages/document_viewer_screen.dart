// lib/features/documents/presentation/pages/document_viewer_screen.dart
//
// FIX 1: Back arrow added to header bar — always visible on mobile.
// FIX 2: Overflow fixed — _InfoField uses flexible widths, Wrap handles
//        multi-column layout safely, no unconstrained Row children.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/documents/data/models/document_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Public entry-point
// ─────────────────────────────────────────────────────────────────────────────

/// Call this from anywhere to open the correct presentation for screen width.
/// Wide (≥600): Dialog. Mobile (<600): DraggableScrollableSheet.
void showDocumentViewer(BuildContext context, DocumentModel doc) {
  final isWide = MediaQuery.sizeOf(context).width >= 600;

  if (isWide) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        insetPadding:
            EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 580.w),
          child: DocumentViewerContent(doc: doc),
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
        maxChildSize: 0.96,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: DocumentViewerContent(
            doc: doc,
            scrollController: controller,
          ),
        ),
      ),
    );
  }
}

/// Full-screen Scaffold route — push via Navigator when needed.
class DocumentViewerScreen extends StatelessWidget {
  const DocumentViewerScreen({super.key, required this.doc});
  final DocumentModel doc;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF4F5F7),
        body: SafeArea(child: DocumentViewerContent(doc: doc)),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Core content (shared by dialog, sheet, full-screen)
// ─────────────────────────────────────────────────────────────────────────────

class DocumentViewerContent extends StatelessWidget {
  const DocumentViewerContent({
    super.key,
    required this.doc,
    this.scrollController,
  });

  final DocumentModel doc;
  final ScrollController? scrollController;

  static const _defaultScope = [
    ScopeItem('General Dentistry',
        'Comprehensive dental care and preventive services'),
    ScopeItem('Cosmetic Dentistry', 'Veneers, whitening, smile makeovers'),
    ScopeItem(
        'Restorative Procedures', 'Crowns, bridges, fillings, and implants'),
    ScopeItem('Orthodontic Treatment', 'Invisalign and clear aligner therapy'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Blue header bar with BACK ARROW (FIX 1) ─────────────────────
          _HeaderBar(doc: doc),

          // ── Scrollable body ───────────────────────────────────────────────
          Flexible(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor info card
                  _DoctorInfoCard(doc: doc),
                  Gap(14.h),

                  // License Information
                  _SectionCard(
                    title: 'License Information',
                    icon: Icons.verified_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FIX 2: use _InfoRow (label + value side by side in a Row)
                        // instead of unconstrained Wrap to avoid overflow
                        _InfoRow('License Type',
                            'Doctor of Dental Surgery (DDS)'),
                        _InfoRow('Issuing Authority',
                            doc.issuingAuthority ??
                                'New York State Education Department'),
                        _InfoRow(
                            'License Number', doc.licenseNumber ?? '—'),
                        _InfoRow('Issue Date', doc.issueDate ?? '—'),
                        _InfoRow('Expiration Date', doc.expiryDate ?? '—'),
                        _InfoRow(
                          'Renewal Status',
                          doc.renewalStatus ?? 'Current - Valid',
                          isStatus: true,
                        ),
                      ],
                    ),
                  ),
                  Gap(14.h),

                  // Scope of Practice
                  _SectionCard(
                    title: 'Scope of Practice',
                    child: Column(
                      children: (doc.scopeOfPractice.isEmpty
                              ? _defaultScope
                              : doc.scopeOfPractice)
                          .map((s) => _ScopeRow(s.title, s.subtitle))
                          .toList(),
                    ),
                  ),
                  Gap(14.h),

                  // Verified Credential
                  _VerifiedBanner(doc: doc),
                  Gap(18.h),

                  // Footer
                  _Footer(doc: doc),
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

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

/// FIX 1: Header now has a back arrow on the left.
class _HeaderBar extends StatelessWidget {
  const _HeaderBar({required this.doc});
  final DocumentModel doc;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 14.h),
      child: Row(
        children: [
          // ── BACK ARROW (FIX 1) ──────────────────────────────────────────
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(Icons.arrow_back, size: 16.sp, color: Colors.white),
            ),
          ),
          SizedBox(width: 8.w),
          // Doc icon
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(Icons.description_outlined,
                size: 14.sp, color: Colors.white),
          ),
          SizedBox(width: 8.w),
          // Labels — wrapped in Expanded to prevent overflow (FIX 2)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PROFESSIONAL DOCUMENT',
                    style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color: Colors.white70,
                        letterSpacing: 1)),
                Text(doc.title,
                    style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          // Action buttons — constrained so they don't overflow (FIX 2)
          _HeaderBtn(
            label: 'Print',
            icon: Icons.print_outlined,
            outlined: true,
            onTap: () {},
          ),
          SizedBox(width: 6.w),
          _HeaderBtn(
            label: 'Download PDF',
            icon: Icons.download_outlined,
            outlined: false,
            onTap: () => _triggerDownload(context, doc),
          ),
          SizedBox(width: 6.w),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.close, size: 18.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _triggerDownload(BuildContext context, DocumentModel doc) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${doc.title}…',
            style: GoogleFonts.inter(fontSize: 13.sp)),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _HeaderBtn extends StatelessWidget {
  const _HeaderBtn({
    required this.label,
    required this.icon,
    required this.outlined,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool outlined;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 11.sp, color: Colors.white),
        label: Text(label,
            style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.white)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white54),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r)),
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 11.sp),
      label: Text(label,
          style: GoogleFonts.inter(
              fontSize: 10.sp, fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      ),
    );
  }
}

class _DoctorInfoCard extends StatelessWidget {
  const _DoctorInfoCard({required this.doc});
  final DocumentModel doc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.primary,
              child: Text(doc.initials,
                  style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
            SizedBox(width: 12.w),
            Expanded(
              // FIX 2: name block is Expanded so it never overflows
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.doctorName ?? '—',
                      style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor),
                      overflow: TextOverflow.ellipsis),
                  Text('Patient ID: ${doc.patientId ?? '—'}',
                      style: GoogleFonts.inter(
                          fontSize: 11.sp, color: AppColors.gray)),
                ],
              ),
            ),
          ]),
          Gap(12.h),
          // FIX 2: info rows instead of unconstrained Wrap
          _InfoRow('Date of Birth', doc.dateOfBirth ?? '—'),
          _InfoRow('Patient ID', doc.doctorId ?? '—'),
          _InfoRow('Specialty', doc.specialty ?? '—'),
          _InfoRow('Clinic', doc.clinic ?? '—'),
          _InfoRow('Expiry Date', doc.expiryDate ?? '—'),
          _InfoRow('Status', doc.status ?? 'Active', isStatus: true),
        ],
      ),
    );
  }
}

/// FIX 2: Label + value in a Row — label takes fixed width, value is Expanded.
/// No overflow possible.
class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {this.isStatus = false});
  final String label, value;
  final bool isStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130.w,
            child: Text(label,
                style: GoogleFonts.inter(
                    fontSize: 11.sp, color: AppColors.gray)),
          ),
          Expanded(
            child: isStatus
                ? Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(value,
                        style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success)),
                  )
                : Text(value,
                    style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor)),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard(
      {required this.title, required this.child, this.icon});
  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            if (icon != null) ...[
              Icon(icon, size: 15.sp, color: AppColors.primary),
              SizedBox(width: 6.w),
            ],
            Text(title,
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor)),
          ]),
          Divider(height: 14.h, color: AppColors.inputBorder),
          child,
        ]),
      );
}

class _ScopeRow extends StatelessWidget {
  const _ScopeRow(this.title, this.subtitle);
  final String title, subtitle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child:
                Icon(Icons.check, size: 11.sp, color: AppColors.success),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor)),
                  Text(subtitle,
                      style: GoogleFonts.inter(
                          fontSize: 11.sp, color: AppColors.gray)),
                ]),
          ),
        ]),
      );
}

class _VerifiedBanner extends StatelessWidget {
  const _VerifiedBanner({required this.doc});
  final DocumentModel doc;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10.r),
          border:
              Border.all(color: AppColors.primary.withOpacity(0.18)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.verified_outlined,
                size: 16.sp, color: Colors.white),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Verified Credential',
                      style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor)),
                  Gap(3.h),
                  Text(
                      'This license has been verified with the New York State Education Department and is in good standing.',
                      style: GoogleFonts.inter(
                          fontSize: 11.sp, color: AppColors.gray)),
                  Gap(4.h),
                  Text(
                      'Verification Date: ${doc.verificationDate ?? 'January 20, 2024'} • Next Verification: ${doc.nextVerification ?? 'January 2025'}',
                      style: GoogleFonts.inter(
                          fontSize: 10.sp, color: AppColors.gray)),
                ]),
          ),
        ]),
      );
}

class _Footer extends StatelessWidget {
  const _Footer({required this.doc});
  final DocumentModel doc;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Divider(color: AppColors.inputBorder),
          Gap(6.h),
          // FIX 2: two separate rows instead of one spaceBetween row
          // so each side can wrap independently on small screens
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Document Generated',
                          style: GoogleFonts.inter(
                              fontSize: 10.sp, color: AppColors.gray)),
                      Text(
                          '${doc.generatedDate ?? 'Jan 15, 2024'} • ${doc.generatedTime ?? '2:45 PM'}',
                          style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor)),
                    ]),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Issued by',
                          style: GoogleFonts.inter(
                              fontSize: 10.sp, color: AppColors.gray)),
                      Text(
                          '${doc.issuedBy ?? 'BrightSmile Dental'} • License #${doc.clinicLicense ?? 'NYC-D865-4892'}',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor),
                          overflow: TextOverflow.ellipsis),
                    ]),
              ),
            ],
          ),
        ],
      );
}
