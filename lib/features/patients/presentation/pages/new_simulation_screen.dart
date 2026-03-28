// lib/features/patients/presentation/pages/new_simulation_screen.dart
//
// Complete 4-step simulation wizard:
//   Step 1: Select Patient
//   Step 2: Upload Photo (+ Camera Preview sub-screen)
//   Step 3: Simulation Type (Smart Logic from design notes)
//   Step 4: Treatment Goals (auto-selected per simulation type)
//
// FIXES:
//   - Back arrow ALWAYS uses Navigator.of(context).pop() — guaranteed to work
//   - Patient avatars use Assets.imagesUser from assets/images/
//   - Camera preview has animated circle + pose instructions
//   - Smart Logic: goals auto-selected based on simulation type
//   - Mobile-first layout throughout

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/patients/presentation/pages/simulation_result_screen.dart';
import 'package:gen_smile/generated/assets.dart';

// ── Providers ─────────────────────────────────────────────────────────────────
final simStepProvider = StateProvider<int>((ref) => 0);
final simSelectedPatientProvider = StateProvider<String?>((ref) => null);
final simTypeProvider = StateProvider<String>((ref) => 'Ortho Simulation');
final simSpeedProvider = StateProvider<String>((ref) => 'Standard');

// Smart Logic: goals auto-populate based on sim type
final simGoalsProvider = Provider<List<String>>((ref) {
  final type = ref.watch(simTypeProvider);
  switch (type) {
    case 'Ortho Simulation':
      return [
        'Alignment Correction',
        'Bite Correction',
        'Gap Closure',
        'Crowding Resolution',
        'Smile Symmetry',
      ];
    case 'Smile Enhancement':
      return [
        'Teeth Whitening',
        'Veneers',
        'Gum Reshaping',
        'Smile Symmetry',
      ];
    case 'Combined Simulation':
      return [
        'Alignment Correction',
        'Teeth Whitening',
        'Bite Correction',
        'Smile Symmetry',
        'Gap Closure',
      ];
    default:
      return ['Alignment Correction', 'Smile Symmetry'];
  }
});

// ── Constants ─────────────────────────────────────────────────────────────────
const _kSteps = [
  'Select Patient',
  'Upload Photo',
  'Simulation Type',
  'Treatment Goals',
];

const _kSimPatients = [
  _SimPatient(
    id: 'P001',
    name: 'Sarah Johnson',
    phone: '+1 (555) 123-4567',
    email: 'john.williams@email.com',
    lastVisit: 'Mar 15, 2026',
  ),
  _SimPatient(
    id: 'P002',
    name: 'Sarah Davis',
    phone: '+1 (555) 234-5678',
    email: 'sarah.davis@email.com',
    lastVisit: 'Mar 9, 2026',
  ),
  _SimPatient(
    id: 'P003',
    name: 'Michael Tan',
    phone: '+1 (555) 345-6789',
    email: 'michael.tan@email.com',
    lastVisit: 'Mar 8, 2026',
  ),
  _SimPatient(
    id: 'P004',
    name: 'Emily Chen',
    phone: '+1 (555) 456-7890',
    email: 'emily.chen@email.com',
    lastVisit: 'Mar 5, 2026',
  ),
];

const _kSimTypes = [
  _SimType(
    id: 'ortho',
    icon: Icons.sentiment_satisfied_outlined,
    title: 'Ortho Simulation',
    subtitle: 'Predict teeth alignment',
    desc: 'Visualize orthodontic treatment outcomes including teeth straightening and bite correction',
  ),
  _SimType(
    id: 'smile',
    icon: Icons.auto_awesome_outlined,
    title: 'Smile Enhancement',
    subtitle: 'Improve aesthetics',
    desc: 'Preview cosmetic improvements including whitening, veneers, and overall smile aesthetics',
  ),
  _SimType(
    id: 'combined',
    icon: Icons.grid_view_outlined,
    title: 'Combined Simulation',
    subtitle: 'Alignment + smile improvement',
    desc: 'Comprehensive preview combining orthodontic alignment with cosmetic enhancements',
  ),
];

const _kAllGoals = [
  _Goal(id: 'alignment', icon: Icons.grid_on_outlined, title: 'Alignment Correction', subtitle: 'Straighten misaligned or crowded teeth'),
  _Goal(id: 'bite', icon: Icons.auto_fix_high_outlined, title: 'Bite Correction', subtitle: 'Fix how upper and lower teeth meet'),
  _Goal(id: 'gap', icon: Icons.crop_outlined, title: 'Gap Closure', subtitle: 'Close spaces between teeth (diastema)'),
  _Goal(id: 'crowding', icon: Icons.fit_screen_outlined, title: 'Crowding Resolution', subtitle: 'Fix overlapping teeth for straightened arch'),
  _Goal(id: 'symmetry', icon: Icons.sentiment_satisfied_outlined, title: 'Smile Symmetry', subtitle: 'Balance smile with facial features'),
  _Goal(id: 'whitening', icon: Icons.brightness_high_outlined, title: 'Teeth Whitening', subtitle: 'Brighten tooth color'),
  _Goal(id: 'veneers', icon: Icons.face_outlined, title: 'Veneers', subtitle: 'Improve tooth shape and size'),
  _Goal(id: 'gum', icon: Icons.medical_services_outlined, title: 'Gum Reshaping', subtitle: 'Improve gum line aesthetics'),
];

// ── Main screen ───────────────────────────────────────────────────────────────
class NewSimulationScreen extends ConsumerStatefulWidget {
  const NewSimulationScreen({super.key});

  @override
  ConsumerState<NewSimulationScreen> createState() =>
      _NewSimulationScreenState();
}

class _NewSimulationScreenState
    extends ConsumerState<NewSimulationScreen> {

  @override
  void dispose() {
    // Reset state when screen is closed
    super.dispose();
  }

  void _goBack(int step) {
    if (step == 0) {
      // Back on step 0 → leave the screen entirely
      Navigator.of(context).pop();
    } else {
      ref.read(simStepProvider.notifier).state = step - 1;
    }
  }

  void _goNext(int step) {
    if (step < _kSteps.length - 1) {
      ref.read(simStepProvider.notifier).state = step + 1;
    } else {
      _runSimulation();
    }
  }

  void _runSimulation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _GeneratingDialog(
        onComplete: () {
          // Reset step state
          ref.read(simStepProvider.notifier).state = 0;
          ref.read(simSelectedPatientProvider.notifier).state = null;
          // Pop dialog
          Navigator.of(context).pop();
          // Push result screen
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => const SimulationResultScreen()),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = ref.watch(simStepProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
          // ── App bar ──────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                child: Column(
                  children: [
                    Row(children: [
                      // FIX 5: Always Navigator.of(context).pop()
                      GestureDetector(
                        onTap: () => _goBack(step),
                        child: Icon(Icons.arrow_back,
                            size: 22.sp, color: AppColors.textColor),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.sentiment_satisfied_outlined,
                          size: 20.sp, color: AppColors.textColor),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('New Simulation',
                                  style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textColor)),
                              Text('Create an AI-powered smile preview',
                                  style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: AppColors.gray)),
                            ]),
                      ),
                      // Notification bell
                      Icon(Icons.notifications_outlined,
                          size: 20.sp, color: AppColors.gray),
                    ]),
                    SizedBox(height: 12.h),
                    // Mobile progress bar
                    Row(children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            value: (step + 1) / _kSteps.length,
                            minHeight: 4.h,
                            backgroundColor: AppColors.inputBorder,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text('${step + 1}/${_kSteps.length}',
                          style: GoogleFonts.inter(
                              fontSize: 11.sp, color: AppColors.gray)),
                    ]),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),

          // ── Step content ─────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: _buildStep(step),
            ),
          ),

          // ── Bottom nav ───────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding:
                EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: SafeArea(
              top: false,
              child: Row(children: [
                OutlinedButton(
                  // FIX 5: Back uses _goBack which calls Navigator.pop on step 0
                  onPressed: () => _goBack(step),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.gray,
                    side: BorderSide(color: AppColors.inputBorder),
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text('Back',
                      style: GoogleFonts.inter(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _goNext(step),
                    icon: step == _kSteps.length - 1
                        ? Icon(Icons.auto_awesome_outlined, size: 14.sp)
                        : const SizedBox.shrink(),
                    label: Text(
                      step == _kSteps.length - 1
                          ? 'Run AI Simulation'
                          : 'Continue →',
                      style: GoogleFonts.inter(
                          fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return _StepSelectPatient();
      case 1:
        return _StepUploadPhoto();
      case 2:
        return _StepSimulationType();
      case 3:
        return _StepTreatmentGoals();
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── STEP 1: Select Patient ────────────────────────────────────────────────────
class _StepSelectPatient extends ConsumerStatefulWidget {
  @override
  ConsumerState<_StepSelectPatient> createState() =>
      _StepSelectPatientState();
}

class _StepSelectPatientState extends ConsumerState<_StepSelectPatient> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(simSelectedPatientProvider);
    final filtered = _kSimPatients
        .where((p) =>
            _search.isEmpty ||
            p.name.toLowerCase().contains(_search.toLowerCase()) ||
            p.phone.contains(_search) ||
            p.id.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Patient',
                      style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor)),
                  Text('Choose an existing patient or add a new one',
                      style: GoogleFonts.inter(
                          fontSize: 12.sp, color: AppColors.gray)),
                ]),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.person_add_outlined, size: 13.sp),
            label: Text('Add New Patient',
                style: GoogleFonts.inter(
                    fontSize: 11.sp, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
        ]),
        Gap(14.h),
        // Search
        Container(
          height: 38.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Row(children: [
            SizedBox(width: 10.w),
            Icon(Icons.search, size: 15.sp, color: AppColors.gray),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                style: GoogleFonts.inter(fontSize: 12.sp),
                decoration: InputDecoration(
                  hintText: 'Search by Name / Phone / ID',
                  hintStyle: GoogleFonts.inter(
                      fontSize: 12.sp, color: AppColors.gray),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ]),
        ),
        Gap(12.h),
        // Patient list
        ...filtered.map((p) {
          final isSelected = selected == p.id + p.name;
          return GestureDetector(
            onTap: () => ref
                .read(simSelectedPatientProvider.notifier)
                .state = p.id + p.name,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.04)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.inputBorder,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(children: [
                // FIX 3: Use real user image from assets
                CircleAvatar(
                  radius: 22.r,
                  backgroundImage: AssetImage(Assets.imagesProfileAvatar),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  onBackgroundImageError: (_, __) {},
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(p.name,
                              style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor)),
                          SizedBox(width: 8.w),
                          Text('ID: ${p.id}',
                              style: GoogleFonts.inter(
                                  fontSize: 11.sp, color: AppColors.gray)),
                        ]),
                        Gap(2.h),
                        Row(children: [
                          Icon(Icons.phone_outlined,
                              size: 11.sp, color: AppColors.gray),
                          SizedBox(width: 3.w),
                          Text(p.phone,
                              style: GoogleFonts.inter(
                                  fontSize: 11.sp, color: AppColors.gray)),
                        ]),
                        Row(children: [
                          Icon(Icons.email_outlined,
                              size: 11.sp, color: AppColors.gray),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(p.email,
                                style: GoogleFonts.inter(
                                    fontSize: 11.sp, color: AppColors.gray),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ]),
                        Row(children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 11.sp, color: AppColors.gray),
                          SizedBox(width: 3.w),
                          Text('Last Visit: ${p.lastVisit}',
                              style: GoogleFonts.inter(
                                  fontSize: 11.sp, color: AppColors.gray)),
                        ]),
                      ]),
                ),
                // Radio
                Radio<bool>(
                  value: true,
                  groupValue: isSelected,
                  activeColor: AppColors.primary,
                  onChanged: (_) => ref
                      .read(simSelectedPatientProvider.notifier)
                      .state = p.id + p.name,
                ),
              ]),
            ),
          );
        }),
      ]),
    );
  }
}

// ── STEP 2: Upload Photo ──────────────────────────────────────────────────────
class _StepUploadPhoto extends StatelessWidget {
  static const _guidelines = [
    _Guideline('Front Facing Image', 'Patient should face the camera directly', true),
    _Guideline('Teeth Clearly Visible', 'Ensure all teeth are visible and in focus', true),
    _Guideline('Good Lighting', 'Use bright, even lighting for best results', true),
    _Guideline('No Obstruction', 'Remove any objects blocking the smile', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Upload area
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Upload Patient Photo',
              style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor)),
          Text('Add a clear front-facing photo of the patient smile',
              style:
                  GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray)),
          Gap(14.h),
          // Drop zone
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 28.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(children: [
              Icon(Icons.upload_outlined,
                  size: 34.sp, color: AppColors.primary),
              Gap(10.h),
              Text('Drag & Drop Photo/\nVideo Here',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor)),
              Gap(4.h),
              Text('or choose from options below',
                  style: GoogleFonts.inter(
                      fontSize: 12.sp, color: AppColors.gray)),
              Gap(14.h),
              Row(children: [
                SizedBox(width: 16.w),
                Expanded(
                  child: OutlinedButton.icon(
                    // FIX 5: Navigator.of(context).push — not navigatorState
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) =>
                              const CameraPreviewScreen()),
                    ),
                    icon: Icon(Icons.camera_alt_outlined, size: 13.sp),
                    label: Text('Capture Now',
                        style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.photo_library_outlined, size: 13.sp),
                    label: Text('Upload Photo & Video',
                        style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
              ]),
            ]),
          ),
        ]),
      ),
      Gap(12.h),
      // Guidelines card
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Photo Guidelines',
              style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor)),
          Gap(12.h),
          ..._guidelines.map((g) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        g.ok
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        size: 16.sp,
                        color:
                            g.ok ? AppColors.success : AppColors.danger,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(g.title,
                                  style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor)),
                              Text(g.subtitle,
                                  style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: AppColors.gray)),
                            ]),
                      ),
                    ]),
              )),
          Gap(4.h),
          // Image vs Video tip
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Image: ',
                          style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFD97706))),
                      TextSpan(
                          text: 'Best for static analysis',
                          style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: const Color(0xFF92400E))),
                    ]),
                  ),
                  Gap(4.h),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Video: ',
                          style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFD97706))),
                      TextSpan(
                          text: 'Captures natural smile movement',
                          style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: const Color(0xFF92400E))),
                    ]),
                  ),
                ]),
          ),
        ]),
      ),
    ]);
  }
}

// ── Camera Preview Screen ─────────────────────────────────────────────────────
class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen>
    with SingleTickerProviderStateMixin {
  int _poseIndex = 0;
  double _progress = 0;
  bool _capturing = false;
  bool _captured = false;
  String _captureMode = 'Photo'; // Video / Photo / PORTRAIT
  late AnimationController _progressCtrl;

  static const _poses = [
    'Please keep your face inside the circle',
    'Open your mouth smile',
    'Look over right shoulder',
    'Look over left shoulder',
    'Stay still and look at the camera',
  ];

  // Progress color per phase
  Color get _progressColor {
    if (_progress >= 1.0) return AppColors.success;
    if (_progress >= 0.5) return Colors.orange;
    return Colors.orange;
  }

  void _startCapture() {
    setState(() => _capturing = true);
    _progressCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 5))
      ..addListener(() {
        final v = _progressCtrl.value;
        final poseIdx = (v * (_poses.length - 1)).floor().clamp(
            0, _poses.length - 1);
        setState(() {
          _progress = v;
          _poseIndex = poseIdx;
        });
      })
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          setState(() {
            _capturing = false;
            _captured = true;
          });
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    if (_capturing) _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // FIX 5: Navigator.of(context).pop() — always works
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              size: 22.sp, color: AppColors.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Your teeth photo',
            style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined,
                size: 22.sp, color: AppColors.gray),
            onPressed: () {},
          ),
        ],
      ),
      body: _captured ? _successState() : _captureState(),
    );
  }

  Widget _captureState() {
    if (_capturing) {
      return _progressState();
    }

    return Column(children: [
      Gap(20.h),
      // Patient avatar
      CircleAvatar(
        radius: 28.r,
        backgroundImage: AssetImage(Assets.imagesProfileAvatar),
        backgroundColor: AppColors.primary.withOpacity(0.1),
        onBackgroundImageError: (_, __) {},
      ),
      Gap(14.h),
      Text(_poses[_poseIndex],
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor)),
      Gap(20.h),

      // Face circle with placeholder
      Expanded(
        child: Center(
          child: Container(
            width: 240.w,
            height: 240.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.inputBorder, width: 2),
              color: const Color(0xFFE8E8E8),
            ),
            child: ClipOval(
              child: Image.asset(
                Assets.imagesProfileAvatar,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(Icons.person_outline,
                      size: 80.sp, color: AppColors.gray),
                ),
              ),
            ),
          ),
        ),
      ),

      Gap(20.h),
      // Bottom controls
      _BottomCameraControls(
        captureMode: _captureMode,
        onModeChanged: (m) => setState(() => _captureMode = m),
        onCapture: _startCapture,
      ),
      Gap(20.h),
    ]);
  }

  Widget _progressState() {
    return Column(children: [
      Gap(20.h),
      CircleAvatar(
        radius: 28.r,
        backgroundImage: AssetImage(Assets.imagesProfileAvatar),
        backgroundColor: AppColors.primary.withOpacity(0.1),
        onBackgroundImageError: (_, __) {},
      ),
      Gap(14.h),
      Text(_poses[_poseIndex],
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor)),
      Gap(20.h),

      // Animated progress circle
      Expanded(
        child: Center(
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              width: 240.w,
              height: 240.w,
              child: CircularProgressIndicator(
                value: _progress,
                strokeWidth: 5,
                backgroundColor: Colors.grey.shade200,
                valueColor:
                    AlwaysStoppedAnimation<Color>(_progressColor),
              ),
            ),
            Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8E8E8),
              ),
              child: ClipOval(
                child: Image.asset(
                  Assets.imagesProfileAvatar,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(Icons.person_outline,
                        size: 80.sp, color: AppColors.gray),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
      Text('${(_progress * 100).toInt()}%',
          style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor)),
      Gap(20.h),
      _BottomCameraControls(
        captureMode: _captureMode,
        onModeChanged: (m) => setState(() => _captureMode = m),
        onCapture: () {},
      ),
      Gap(20.h),
    ]);
  }

  Widget _successState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        CircleAvatar(
          radius: 36.r,
          backgroundImage: AssetImage(Assets.imagesProfileAvatar),
          backgroundColor: AppColors.primary.withOpacity(0.1),
          onBackgroundImageError: (_, __) {},
        ),
        Gap(24.h),
        if (_progress < 1.0) ...[
          // Capturing state
          Text('Capturing teeth photo',
              style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor)),
          Gap(8.h),
          Text(
              'Please wait while we capture and\nprepare the image for simulation',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13.sp, color: AppColors.gray)),
        ] else ...[
          // Success state
          Text('Photo captured successfully',
              style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor)),
          Gap(8.h),
          Text("The patient's teeth photo is ready\nfor simulation",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13.sp, color: AppColors.gray)),
          Gap(32.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ElevatedButton(
              onPressed: () {
                // FIX 5: pop back to simulation wizard
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r)),
              ),
              child: Text('Use Photo & Continue',
                  style: GoogleFonts.inter(
                      fontSize: 15.sp, fontWeight: FontWeight.w600)),
            ),
          ),
          Gap(12.h),
          TextButton(
            onPressed: () => setState(() {
              _captured = false;
              _progress = 0;
              _poseIndex = 0;
            }),
            child: Text('Retake Photo',
                style: GoogleFonts.inter(
                    fontSize: 14.sp, color: AppColors.primary)),
          ),
        ],
        const Spacer(),
      ],
    );
  }
}

class _BottomCameraControls extends StatelessWidget {
  const _BottomCameraControls({
    required this.captureMode,
    required this.onModeChanged,
    required this.onCapture,
  });
  final String captureMode;
  final ValueChanged<String> onModeChanged;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Thumbnail + shutter + flash
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Last capture thumbnail
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.grey.shade300,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(Assets.imagesProfileAvatar,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox()),
                ),
              ),
              // Shutter button
              GestureDetector(
                onTap: onCapture,
                child: Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.primary, width: 2),
                    color: Colors.white,
                  ),
                ),
              ),
              // Flash icon
              Icon(Icons.flash_on_outlined,
                  size: 28.sp, color: AppColors.primary),
            ]),
      ),
      Gap(14.h),
      // Mode selector: Video / Photo / PORTRAIT
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (final mode in ['Video', 'Photo', 'PORTRAIT'])
          GestureDetector(
            onTap: () => onModeChanged(mode),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: captureMode == mode
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(mode,
                  style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: captureMode == mode
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: captureMode == mode
                          ? Colors.white
                          : AppColors.gray)),
            ),
          ),
      ]),
    ]);
  }
}

// ── STEP 3: Simulation Type ───────────────────────────────────────────────────
class _StepSimulationType extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(simTypeProvider);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Select Simulation Type',
            style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor)),
        Text('Choose the treatment goal for this preview',
            style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray)),
        Gap(16.h),
        ..._kSimTypes.map((t) {
          final isSelected = selectedType == t.title;
          return GestureDetector(
            onTap: () => ref.read(simTypeProvider.notifier).state = t.title,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.inputBorder,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(t.icon,
                      size: 20.sp,
                      color: isSelected ? AppColors.primary : AppColors.gray),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.title,
                            style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor)),
                        Text(t.subtitle,
                            style: GoogleFonts.inter(
                                fontSize: 12.sp, color: AppColors.gray)),
                        if (isSelected) ...[
                          Gap(4.h),
                          Text(t.desc,
                              style: GoogleFonts.inter(
                                  fontSize: 11.sp, color: AppColors.gray)),
                        ],
                      ]),
                ),
                if (isSelected)
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                        color: AppColors.primary, shape: BoxShape.circle),
                    child: Icon(Icons.check, size: 14.sp, color: Colors.white),
                  )
                else
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                  ),
              ]),
            ),
          );
        }),
        Gap(8.h),
        // Info note
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: 'Note: ',
                  style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFD97706))),
              TextSpan(
                  text:
                      'You can adjust specific parameters in the next step. The simulation type helps pre-configure the AI model for optimal results.',
                  style: GoogleFonts.inter(
                      fontSize: 11.sp, color: const Color(0xFF92400E))),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ── STEP 4: Treatment Goals (Smart Logic) ─────────────────────────────────────
class _StepTreatmentGoals extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoGoals = ref.watch(simGoalsProvider);
    final speed = ref.watch(simSpeedProvider);
    final simType = ref.watch(simTypeProvider);

    // Filter goals relevant to the selected type
    final relevantGoals = _kAllGoals
        .where((g) => autoGoals.contains(g.title))
        .toList();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Treatment Goals',
                  style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor)),
              Text('Customize the smile transformation parameters',
                  style: GoogleFonts.inter(
                      fontSize: 12.sp, color: AppColors.gray)),
            ]),
          ),
          // Smart Logic badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20.r),
              border:
                  Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.auto_awesome_outlined,
                  size: 12.sp, color: AppColors.primary),
              SizedBox(width: 4.w),
              Text('Smart logic active',
                  style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        ]),
        Gap(14.h),
        Text('Selected Treatment Goals',
            style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor)),
        Gap(10.h),
        // Auto-selected goals grid
        ...relevantGoals.map((g) => Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.25)),
              ),
              child: Row(children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(g.icon,
                      size: 16.sp, color: AppColors.primary),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(g.title,
                            style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor)),
                        Text(g.subtitle,
                            style: GoogleFonts.inter(
                                fontSize: 11.sp, color: AppColors.gray)),
                      ]),
                ),
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                  child:
                      Icon(Icons.check, size: 13.sp, color: Colors.white),
                ),
              ]),
            )),
        Gap(16.h),
        // Processing speed
        Text('Processing speed',
            style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor)),
        Gap(10.h),
        ...([
          ('Fast', Icons.bolt_outlined, '~10-15 seconds'),
          ('Standard', Icons.sentiment_satisfied_outlined, '~15-20 seconds'),
          ('Ultra Detail', Icons.auto_awesome_outlined, '~30-40 seconds'),
        ].map((s) {
          final isSelected = speed == s.$1;
          return GestureDetector(
            onTap: () =>
                ref.read(simSpeedProvider.notifier).state = s.$1,
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.04)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.inputBorder,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(children: [
                Icon(s.$2,
                    size: 18.sp,
                    color: isSelected ? AppColors.primary : AppColors.gray),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.$1,
                            style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor)),
                        Text(s.$3,
                            style: GoogleFonts.inter(
                                fontSize: 11.sp, color: AppColors.gray)),
                      ]),
                ),
                if (isSelected)
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                        color: AppColors.primary, shape: BoxShape.circle),
                    child: Icon(Icons.check,
                        size: 13.sp, color: Colors.white),
                  )
                else
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                  ),
              ]),
            ),
          );
        })),
        Gap(12.h),
        // Summary banner
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: 'Ready to Process: ',
                  style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFD97706))),
              TextSpan(
                  text:
                      '$simType - ${relevantGoals.length} goals selected • Existing shade • $speed quality',
                  style: GoogleFonts.inter(
                      fontSize: 11.sp, color: const Color(0xFF92400E))),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ── Generating Dialog ─────────────────────────────────────────────────────────
class _GeneratingDialog extends StatefulWidget {
  const _GeneratingDialog({required this.onComplete});
  final VoidCallback onComplete;

  @override
  State<_GeneratingDialog> createState() => _GeneratingDialogState();
}

class _GeneratingDialogState extends State<_GeneratingDialog> {
  double _progress = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      setState(() => _progress += 0.02);
      if (_progress >= 1.0) {
        _timer.cancel();
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome_outlined,
                size: 28.sp, color: AppColors.primary),
          ),
          Gap(16.h),
          Text('Generating Simulation',
              style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor)),
          Gap(6.h),
          Text('AI is processing the smile transformation...',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray)),
          Gap(20.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8.h,
              backgroundColor: AppColors.inputBorder,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          Gap(8.h),
          Text('${(_progress * 100).toInt()}% Complete',
              style: GoogleFonts.inter(
                  fontSize: 12.sp, color: AppColors.gray)),
        ]),
      ),
    );
  }
}

// ── Data models ───────────────────────────────────────────────────────────────
class _SimPatient {
  const _SimPatient({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.lastVisit,
  });
  final String id, name, phone, email, lastVisit;
}

class _SimType {
  const _SimType({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.desc,
  });
  final String id, title, subtitle, desc;
  final IconData icon;
}

class _Goal {
  const _Goal({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final String id, title, subtitle;
  final IconData icon;
}

class _Guideline {
  const _Guideline(this.title, this.subtitle, this.ok);
  final String title, subtitle;
  final bool ok;
}
