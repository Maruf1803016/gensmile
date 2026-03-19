import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/core/states/navigator_state.dart';
import 'package:onboarding/common/widgets/input_fields.dart';
import 'package:onboarding/common/widgets/buttons.dart';
import 'package:onboarding/features/onboarding/data/models/clinic_model.dart';
import 'package:onboarding/features/onboarding/presentation/widgets/onb_mobile_top_bar.dart';
import 'package:onboarding/features/onboarding/presentation/widgets/onb_mobile_step_header.dart';
import 'package:onboarding/features/onboarding/presentation/widgets/clinic_card.dart';
import 'package:onboarding/features/onboarding/presentation/pages/onboarding_complete_screen.dart';

class ClinicDetailsScreen extends ConsumerStatefulWidget {
  const ClinicDetailsScreen({super.key});

  @override
  ConsumerState<ClinicDetailsScreen> createState() =>
      _ClinicDetailsScreenState();
}

class _ClinicDetailsScreenState
    extends ConsumerState<ClinicDetailsScreen> {
  final List<ClinicModel> _clinics = [ClinicModel(id: 'clinic_1')];
  final List<StaffModel> _staff   = [StaffModel(id: 'staff_1')];

  void _addClinic() => setState(() =>
      _clinics.add(ClinicModel(id: 'clinic_${_clinics.length + 1}')));

  void _removeClinic(int i) {
    if (_clinics.length == 1) return;
    setState(() => _clinics.removeAt(i));
  }

  void _addStaff() => setState(() =>
      _staff.add(StaffModel(id: 'staff_${_staff.length + 1}')));

  void _removeStaff(int i) {
    if (_staff.length == 1) return;
    setState(() => _staff.removeAt(i));
  }

  void _onContinue() => ref
      .read(navigatorState.notifier)
      .push(const OnboardingCompleteScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const OnbMobileTopBar(currentStep: 4, totalSteps: 5),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: OnbMobileStepHeader()),
                    Gap(24.h),

                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 56.w,
                            height: 56.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.add_business_outlined,
                                color: AppColors.primary, size: 28.w),
                          ),
                          Gap(12.h),
                          Text('Clinic Details',
                              style: GoogleFonts.inter(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              )),
                          Gap(4.h),
                          Text(
                            'Add your clinic information and team members',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                color: AppColors.gray),
                          ),
                        ],
                      ),
                    ),

                    Gap(24.h),

                    Text('Clinic Information *',
                        style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor)),

                    Gap(12.h),

                    ...List.generate(
                      _clinics.length,
                      (i) => ClinicCard(
                        clinic: _clinics[i],
                        onRemove: () => _removeClinic(i),
                        onChanged: () => setState(() {}),
                      ),
                    ),

                    GestureDetector(
                      onTap: _addClinic,
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 4.h, bottom: 24.h),
                        child: Text('+ Add More Clinic',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            )),
                      ),
                    ),

                    Text('Invite Team Members',
                        style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor)),

                    Gap(12.h),

                    ...List.generate(
                      _staff.length,
                      (i) => _StaffRow(
                        staff: _staff[i],
                        onRemove: () => _removeStaff(i),
                        onChanged: () => setState(() {}),
                      ),
                    ),

                    GestureDetector(
                      onTap: _addStaff,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text('+ Add More Staff',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            )),
                      ),
                    ),

                    Gap(24.h),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'Continue',
                    variant: 'primary',
                    onPressed: _onContinue,
                  ),
                  Gap(12.h),
                  GestureDetector(
                    onTap: () =>
                        ref.read(navigatorState.notifier).pop(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back,
                            size: 14.w, color: AppColors.gray),
                        SizedBox(width: 4.w),
                        Text('Back',
                            style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                color: AppColors.gray)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaffRow extends StatefulWidget {
  const _StaffRow({
    required this.staff,
    required this.onRemove,
    required this.onChanged,
  });

  final StaffModel staff;
  final VoidCallback onRemove, onChanged;

  @override
  State<_StaffRow> createState() => _StaffRowState();
}

class _StaffRowState extends State<_StaffRow> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController  = TextEditingController(text: widget.staff.name);
    emailController = TextEditingController(text: widget.staff.email);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.onRemove,
              child: Icon(Icons.close,
                  size: 18.w, color: AppColors.gray),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InputField(
                  controller: nameController,
                  label: 'Staff Name',
                  hint: 'John Smith',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: InputField(
                  controller: emailController,
                  label: 'Email Address',
                  hint: 'john@example.com',
                  validator: 'email',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: InputDropDown(
                  label: 'Role',
                  value: widget.staff.role,
                  items: staffRoles,
                  onChanged: (v) {
                    widget.staff.role = v;
                    widget.onChanged();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
