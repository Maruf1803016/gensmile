// lib/features/documents/data/models/document_model.dart

enum DocType { pdf, xray, scan, license, invoice }

/// Represents a single document / record in the clinic system.
class DocumentModel {
  const DocumentModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.size,
    required this.type,
    this.doctorName,
    this.doctorId,
    this.licenseNumber,
    this.issueDate,
    this.expiryDate,
    this.specialty,
    this.clinic,
    this.status,
    this.issuingAuthority,
    this.renewalStatus,
    this.scopeOfPractice = const [],
    this.verificationDate,
    this.nextVerification,
    this.generatedDate,
    this.generatedTime,
    this.issuedBy,
    this.clinicLicense,
    this.patientId,
    this.dateOfBirth,
  });

  final String id;
  final String title;
  final String category;
  final String date;
  final String size;
  final DocType type;

  // License-specific fields
  final String? doctorName;
  final String? doctorId;
  final String? licenseNumber;
  final String? issueDate;
  final String? expiryDate;
  final String? specialty;
  final String? clinic;
  final String? status;
  final String? issuingAuthority;
  final String? renewalStatus;
  final List<ScopeItem> scopeOfPractice;
  final String? verificationDate;
  final String? nextVerification;
  final String? generatedDate;
  final String? generatedTime;
  final String? issuedBy;
  final String? clinicLicense;
  final String? patientId;
  final String? dateOfBirth;

  /// Safe 2-letter initials from [doctorName]
  String get initials {
    if (doctorName == null || doctorName!.trim().isEmpty) return '??';
    final parts = doctorName!.trim().split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.length == 1) {
      final w = parts[0];
      return w.length >= 2
          ? w.substring(0, 2).toUpperCase()
          : w.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class ScopeItem {
  const ScopeItem(this.title, this.subtitle);
  final String title;
  final String subtitle;
}

// ── Mock data ─────────────────────────────────────────────────────────────────
const kMockDocuments = [
  DocumentModel(
    id: 'doc-001',
    title: 'DDS License',
    category: 'Professional Documents',
    date: 'Jan 20, 2026',
    size: '1.2 MB',
    type: DocType.license,
    doctorName: 'Dr. Michael Chen',
    doctorId: 'DR-2024-0042',
    patientId: 'P-2024-0042',
    dateOfBirth: 'Jan 15, 2024',
    licenseNumber: 'NY-DDS-44892',
    issueDate: 'Jan 15, 2024',
    expiryDate: 'Dec 31, 2026',
    specialty: 'Cosmetic Dentistry',
    clinic: 'BrightSmile Dental',
    status: 'Active',
    issuingAuthority: 'New York State Education Department',
    renewalStatus: 'Current - Valid',
    scopeOfPractice: [
      ScopeItem('General Dentistry', 'Comprehensive dental care and preventive services'),
      ScopeItem('Cosmetic Dentistry', 'Veneers, whitening, smile makeovers'),
      ScopeItem('Restorative Procedures', 'Crowns, bridges, fillings, and implants'),
      ScopeItem('Orthodontic Treatment', 'Invisalign and clear aligner therapy'),
    ],
    verificationDate: 'January 20, 2024',
    nextVerification: 'January 2025',
    generatedDate: 'Jan 15, 2024',
    generatedTime: '2:45 PM',
    issuedBy: 'BrightSmile Dental',
    clinicLicense: 'NYC-D865-4892',
  ),
  DocumentModel(
    id: 'doc-002',
    title: 'Smile Simulation Report',
    category: 'Simulation Reports',
    date: 'Jan 20, 2026',
    size: '2.4 MB',
    type: DocType.pdf,
  ),
  DocumentModel(
    id: 'doc-003',
    title: 'Intraoral Scan Photos',
    category: 'Scan Files',
    date: 'Jan 20, 2026',
    size: '5.6 MB',
    type: DocType.scan,
  ),
  DocumentModel(
    id: 'doc-004',
    title: 'Smile Simulation Report',
    category: 'Simulation Reports',
    date: 'Jan 20, 2026',
    size: '2.4 MB',
    type: DocType.pdf,
  ),
  DocumentModel(
    id: 'doc-005',
    title: 'Invoice #INV-001',
    category: 'Treatment Documents',
    date: 'Jan 20, 2026',
    size: '2.4 MB',
    type: DocType.invoice,
  ),
  DocumentModel(
    id: 'doc-006',
    title: 'Lower Jaw X-Ray',
    category: 'X-Ray Files',
    date: 'Jan 20, 2026',
    size: '2.4 MB',
    type: DocType.xray,
  ),
];
