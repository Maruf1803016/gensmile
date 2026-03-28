import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/features/patients/presentation/pages/simulation_result_screen.dart';

final simStepProvider = StateProvider<int>((ref) => 0);
final simSelectedPatientProvider = StateProvider<String?>((ref) => null);
final simTypeProvider = StateProvider<String>((ref) => 'Ortho Simulation');
final simGoalsProvider = StateProvider<List<String>>(
  (ref) => ['Teeth Whitening', 'Smile Symmetry'],
);

const _kSteps = [
  'Select Patient',
  'Upload Photo',
  'Simulation Type',
  'Treatment Goals',
];

const _kSimPatients = [
  _SimPatient(
    id: 'P001',
    name: 'John Williams',
    phone: '+1 (555) 234-5678',
    email: 'john.williams@email.com',
    lastVisit: 'Mar 15, 2026',
  ),
  _SimPatient(
    id: 'P001',
    name: 'Sarah Davis',
    phone: '+1 (555) 234-5678',
    email: 'john.williams@email.com',
    lastVisit: 'Mar 8, 2026',
  ),
  _SimPatient(
    id: 'P001',
    name: 'Sarah Davis',
    phone: '+1 (555) 234-5678',
    email: 'john.williams@email.com',
    lastVisit: 'Mar 9, 2026',
  ),
  _SimPatient(
    id: 'P002',
    name: 'Sarah Davis',
    phone: '+1 (555) 234-5678',
    email: 'john.williams@email.com',
    lastVisit: 'Mar 15, 2026',
  ),
  _SimPatient(
    id: 'P003',
    name: 'Michael Tan',
    phone: '+1 (555) 234-5678',
    email: 'john.williams@email.com',
    lastVisit: 'Mar 15, 2026',
  ),
];

const _kSimTypes = [
  _SimType(
    id: 'ortho',
    icon: Icons.sentiment_satisfied_outlined,
    title: 'Ortho Simulation',
    subtitle: 'Predict teeth alignment result',
    desc:
        'Visualize orthodontic treatment outcomes including teeth straightening and bite correction',
  ),
  _SimType(
    id: 'smile',
    icon: Icons.auto_awesome_outlined,
    title: 'Smile Enhancement',
    subtitle: 'Improve aesthetics',
    desc:
        'Preview cosmetic improvements including whitening, veneers, and overall smile aesthetics',
  ),
  _SimType(
    id: 'combined',
    icon: Icons.grid_view_outlined,
    title: 'Combined Simulation',
    subtitle: 'Alignment + smile improvement',
    desc:
        'Comprehensive preview combining orthodontic alignment with cosmetic enhancements',
  ),
];

const _kGoals = [
  _Goal(
    id: 'alignment',
    icon: Icons.grid_on_outlined,
    title: 'Alignment Correction',
    subtitle: 'Straighten misaligned teeth',
  ),
  _Goal(
    id: 'veneers',
    icon: Icons.face_outlined,
    title: 'Veneers',
    subtitle: 'Improve tooth shape and size',
  ),
  _Goal(
    id: 'makeover',
    icon: Icons.sentiment_very_satisfied_outlined,
    title: 'Full Smile Makeover',
    subtitle: 'Comprehensive transformation',
  ),
  _Goal(
    id: 'whitening',
    icon: Icons.brightness_high_outlined,
    title: 'Teeth Whitening',
    subtitle: 'Brighten tooth color',
  ),
  _Goal(
    id: 'symmetry',
    icon: Icons.crop_free_outlined,
    title: 'Smile Symmetry',
    subtitle: 'Balance facial aesthetics',
  ),
];

class NewSimulationScreen extends ConsumerWidget {
  const NewSimulationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(simStepProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                child: Column(
                  children: [
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
                                'New Simulation',
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                              Text(
                                'Create an AI-powered smile preview',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.notifications_outlined,
                          size: 20.sp,
                          color: AppColors.gray,
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    if (!isWide) ...[
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: LinearProgressIndicator(
                                value: (step + 1) / _kSteps.length,
                                minHeight: 4.h,
                                backgroundColor: AppColors.inputBorder,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${step + 1}/${_kSteps.length}',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                    if (isWide) _Stepper(currentStep: step),
                    if (isWide) SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: _buildStep(context, ref, step, isWide),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      if (step == 0)
                        Navigator.of(context).pop();
                      else
                        ref.read(simStepProvider.notifier).state = step - 1;
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gray,
                      side: BorderSide(color: AppColors.inputBorder),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Back',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (step < _kSteps.length - 1) {
                          ref.read(simStepProvider.notifier).state = step + 1;
                        } else {
                          _showGeneratingDialog(context, ref);
                        }
                      },
                      icon: step == _kSteps.length - 1
                          ? Icon(Icons.auto_awesome_outlined, size: 14.sp)
                          : const SizedBox.shrink(),
                      label: Text(
                        step == _kSteps.length - 1
                            ? 'Run AI Simulation'
                            : 'Continue →',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
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
    );
  }

  Widget _buildStep(
    BuildContext context,
    WidgetRef ref,
    int step,
    bool isWide,
  ) {
    switch (step) {
      case 0:
        return _StepSelectPatient(isWide: isWide);
      case 1:
        return _StepUploadPhoto(isWide: isWide);
      case 2:
        return _StepSimulationType();
      case 3:
        return _StepTreatmentGoals(isWide: isWide);
      default:
        return const SizedBox.shrink();
    }
  }

  void _showGeneratingDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _GeneratingDialog(
        onComplete: () {
          Navigator.of(context).pop();
          ref.read(simStepProvider.notifier).state = 0;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SimulationResultScreen()),
          );
        },
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.currentStep});
  final int currentStep;

  @override
  Widget build(BuildContext context) => Row(
    children: List.generate(_kSteps.length, (i) {
      final isDone = i < currentStep;
      final isCurrent = i == currentStep;
      return Expanded(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone || isCurrent
                        ? AppColors.primary
                        : Colors.white,
                    border: Border.all(
                      color: isDone || isCurrent
                          ? AppColors.primary
                          : AppColors.inputBorder,
                    ),
                  ),
                  child: Center(
                    child: isDone
                        ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                        : Text(
                            '${i + 1}',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: isCurrent ? Colors.white : AppColors.gray,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _kSteps[i],
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: isCurrent ? AppColors.primary : AppColors.gray,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
            if (i < _kSteps.length - 1)
              Expanded(
                child: Container(
                  height: 1,
                  color: i < currentStep
                      ? AppColors.primary
                      : AppColors.inputBorder,
                ),
              ),
          ],
        ),
      );
    }),
  );
}

class _StepSelectPatient extends ConsumerWidget {
  const _StepSelectPatient({required this.isWide});
  final bool isWide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(simSelectedPatientProvider);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Patient',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      'Choose an existing patient or add a new one',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              if (isWide)
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.person_add_outlined, size: 13.sp),
                  label: Text(
                    'Add New Patient',
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
          Gap(16.h),
          Container(
            height: 36.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              children: [
                SizedBox(width: 10.w),
                Icon(Icons.search, size: 15.sp, color: AppColors.gray),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
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
          Gap(12.h),
          if (isWide)
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.inputBorder),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 80.w, child: _hCell('Patient ID')),
                  Expanded(child: _hCell('Patient Name')),
                  SizedBox(width: 160.w, child: _hCell('Phone Number')),
                  SizedBox(width: 200.w, child: _hCell('Email')),
                  SizedBox(width: 120.w, child: _hCell('Last Visit')),
                  SizedBox(width: 30.w),
                ],
              ),
            ),
          ..._kSimPatients.map((p) {
            final isSelected = selected == p.id + p.name;
            return GestureDetector(
              onTap: () => ref.read(simSelectedPatientProvider.notifier).state =
                  p.id + p.name,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.inputBorder),
                  ),
                ),
                child: isWide
                    ? Row(
                        children: [
                          SizedBox(
                            width: 80.w,
                            child: Text(
                              p.id,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 13.r,
                                  backgroundColor: AppColors.primary
                                      .withOpacity(0.1),
                                  child: Text(
                                    p.name[0],
                                    style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  p.name,
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
                              p.phone,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200.w,
                            child: Text(
                              p.email,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120.w,
                            child: Text(
                              p.lastVisit,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30.w,
                            child: Radio<bool>(
                              value: true,
                              groupValue: isSelected,
                              activeColor: AppColors.primary,
                              onChanged: (_) {},
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          CircleAvatar(
                            radius: 14.r,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              p.name[0],
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Text(
                                  p.phone,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    color: AppColors.gray,
                                  ),
                                ),
                                Text(
                                  p.email,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    color: AppColors.gray,
                                  ),
                                ),
                                Text(
                                  'Last Visit: ${p.lastVisit}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    color: AppColors.gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Radio<bool>(
                            value: true,
                            groupValue: isSelected,
                            activeColor: AppColors.primary,
                            onChanged: (_) {},
                          ),
                        ],
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _hCell(String text) => Text(
    text,
    style: GoogleFonts.inter(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.gray,
      letterSpacing: 0.5,
    ),
  );
}

class _StepUploadPhoto extends StatelessWidget {
  const _StepUploadPhoto({required this.isWide});
  final bool isWide;

  static const _guidelines = [
    _Guideline(
      'Front Facing Image',
      'Patient should face the camera directly',
      true,
    ),
    _Guideline(
      'Teeth Clearly Visible',
      'Ensure all teeth are visible and in focus',
      true,
    ),
    _Guideline(
      'Good Lighting',
      'Use bright, even lighting for best results',
      true,
    ),
    _Guideline(
      'No Obstruction',
      'Remove any objects blocking the smile',
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final uploadArea = Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Patient Photo',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          Text(
            'Add a clear front-facing photo of the patient smile',
            style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
          ),
          Gap(16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 32.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.upload_outlined,
                  size: 36.sp,
                  color: AppColors.primary,
                ),
                Gap(12.h),
                Text(
                  'Drag & Drop Photo/\nVideo Here',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                Gap(6.h),
                Text(
                  'or choose from options below',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                ),
                Gap(16.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.camera_alt_outlined, size: 13.sp),
                        label: Text(
                          'Capture Now',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.photo_library_outlined, size: 13.sp),
                        label: Text(
                          'Upload Photo & Video',
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final guidelinesCard = Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Photo Guidelines',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          Gap(12.h),
          ..._guidelines.map(
            (g) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    g.ok ? Icons.check_circle_outline : Icons.cancel_outlined,
                    size: 16.sp,
                    color: g.ok ? AppColors.success : AppColors.danger,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g.title,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          g.subtitle,
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
          ),
          Gap(8.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 14.sp,
                  color: const Color(0xFFD97706),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tip: ',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFD97706),
                          ),
                        ),
                        TextSpan(
                          text:
                              'High quality photos produce more accurate AI simulations',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: const Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: uploadArea),
          SizedBox(width: 16.w),
          Expanded(flex: 2, child: guidelinesCard),
        ],
      );
    }
    return Column(children: [uploadArea, Gap(12.h), guidelinesCard]);
  }
}

class _StepSimulationType extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(simTypeProvider);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Simulation Type',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          Text(
            'Choose the treatment goal for this preview',
            style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
          ),
          Gap(16.h),
          ..._kSimTypes.map((t) {
            final isSelected = selectedType == t.title;
            return GestureDetector(
              onTap: () => ref.read(simTypeProvider.notifier).state = t.title,
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.04)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.inputBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : const Color(0xFFF5F6FA),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        t.icon,
                        size: 20.sp,
                        color: isSelected ? AppColors.primary : AppColors.gray,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.title,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            t.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.gray,
                            ),
                          ),
                          if (isSelected) ...[
                            Gap(4.h),
                            Text(
                              t.desc,
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: t.title,
                      groupValue: selectedType,
                      activeColor: AppColors.primary,
                      onChanged: (v) =>
                          ref.read(simTypeProvider.notifier).state = v!,
                    ),
                  ],
                ),
              ),
            );
          }),
          Gap(8.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Note: ',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFD97706),
                    ),
                  ),
                  TextSpan(
                    text:
                        'You can adjust specific parameters in the next step. The simulation type helps pre-configure the AI model for optimal results.',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFF92400E),
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

class _StepTreatmentGoals extends ConsumerWidget {
  const _StepTreatmentGoals({required this.isWide});
  final bool isWide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoals = ref.watch(simGoalsProvider);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Treatment Goals',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          Text(
            'Customize the smile transformation parameters',
            style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
          ),
          Gap(16.h),
          Text(
            'Treatment Goals',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          Gap(10.h),
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: _kGoals
                            .take(3)
                            .map(
                              (g) => _GoalTile(
                                goal: g,
                                selectedGoals: selectedGoals,
                                ref: ref,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        children: _kGoals
                            .skip(3)
                            .map(
                              (g) => _GoalTile(
                                goal: g,
                                selectedGoals: selectedGoals,
                                ref: ref,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: _kGoals
                      .map(
                        (g) => _GoalTile(
                          goal: g,
                          selectedGoals: selectedGoals,
                          ref: ref,
                        ),
                      )
                      .toList(),
                ),
          Gap(16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Text(
              'Selected: ${selectedGoals.length} treatment goals | AI Level: Standard | Display: Before/After Slider',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: const Color(0xFF92400E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.goal,
    required this.selectedGoals,
    required this.ref,
  });
  final _Goal goal;
  final List<String> selectedGoals;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedGoals.contains(goal.title);
    return GestureDetector(
      onTap: () {
        final current = List<String>.from(selectedGoals);
        if (isSelected)
          current.remove(goal.title);
        else
          current.add(goal.title);
        ref.read(simGoalsProvider.notifier).state = current;
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              goal.icon,
              size: 18.sp,
              color: isSelected ? AppColors.primary : AppColors.gray,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    goal.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneratingDialog extends StatefulWidget {
  const _GeneratingDialog({required this.onComplete});
  final VoidCallback onComplete;

  @override
  State<_GeneratingDialog> createState() => _GeneratingDialogState();
}

class _GeneratingDialogState extends State<_GeneratingDialog> {
  double _progress = 0.0;
  int _currentStep = 0;

  static const _steps = [
    'Uploading image',
    'Detecting face',
    'Mapping teeth',
    'Applying treatment model',
    'Generating preview',
  ];

  @override
  void initState() {
    super.initState();
    _animate();
  }

  void _animate() async {
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      setState(() => _currentStep = i);
      await Future.delayed(const Duration(milliseconds: 800));
      for (
        double p = (_currentStep / _steps.length);
        p < ((_currentStep + 1) / _steps.length);
        p += 0.02
      ) {
        if (!mounted) return;
        setState(() => _progress = p);
        await Future.delayed(const Duration(milliseconds: 30));
      }
    }
    if (mounted) {
      setState(() => _progress = 1.0);
      await Future.delayed(const Duration(milliseconds: 300));
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sentiment_satisfied_outlined,
              size: 48.sp,
              color: AppColors.primary,
            ),
            Gap(12.h),
            Text(
              'Generating Smile Simulation',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            Gap(4.h),
            Text(
              'AI is analyzing the patient photo',
              style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
            ),
            Gap(16.h),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 8.h,
                      backgroundColor: AppColors.inputBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            Gap(16.h),
            ..._steps.asMap().entries.map((e) {
              final i = e.key;
              final s = e.value;
              final isDone = i < _currentStep;
              final isCurrent = i == _currentStep;
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.primary.withOpacity(0.06)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.primary.withOpacity(0.2)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone
                            ? AppColors.success
                            : isCurrent
                            ? AppColors.primary
                            : const Color(0xFFF5F6FA),
                        border: Border.all(
                          color: isDone
                              ? AppColors.success
                              : isCurrent
                              ? AppColors.primary
                              : AppColors.inputBorder,
                        ),
                      ),
                      child: Center(
                        child: isDone
                            ? Icon(
                                Icons.check,
                                size: 12.sp,
                                color: Colors.white,
                              )
                            : isCurrent
                            ? SizedBox(
                                width: 12.w,
                                height: 12.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                '${i + 1}',
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  color: AppColors.gray,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        s,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: isCurrent
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isCurrent
                              ? AppColors.textColor
                              : AppColors.gray,
                        ),
                      ),
                    ),
                    if (isCurrent)
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
              );
            }),
            Gap(8.h),
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Estimated time: 15 seconds remaining',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: const Color(0xFF92400E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
