import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/common/widgets/buttons.dart';
import 'package:gen_smile/common/widgets/gen_smile_logo.dart';
import 'package:gen_smile/common/widgets/input_fields.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/onboarding/data/models/clinic_model.dart';
import 'package:gen_smile/features/onboarding/presentation/pages/onboarding_complete_screen.dart';
import 'package:gen_smile/features/onboarding/presentation/widgets/clinic_card.dart';
import 'package:gen_smile/features/onboarding/presentation/widgets/onb_mobile_top_bar.dart';
import 'package:gen_smile/generated/assets.dart';

class ClinicDetailsScreen extends ConsumerStatefulWidget {
  const ClinicDetailsScreen({super.key});

  @override
  ConsumerState<ClinicDetailsScreen> createState() =>
      _ClinicDetailsScreenState();
}

class _ClinicDetailsScreenState extends ConsumerState<ClinicDetailsScreen> {
  final List<ClinicModel> _clinics = [ClinicModel(id: 'clinic_1')];
  final List<StaffModel> _staff = [StaffModel(id: 'staff_1')];

  void _addClinic() => setState(
    () => _clinics.add(ClinicModel(id: 'clinic_${_clinics.length + 1}')),
  );

  void _removeClinic(int i) {
    if (_clinics.length == 1) return;
    setState(() => _clinics.removeAt(i));
  }

  void _addStaff() =>
      setState(() => _staff.add(StaffModel(id: 'staff_${_staff.length + 1}')));

  void _removeStaff(int i) {
    if (_staff.length == 1) return;
    setState(() => _staff.removeAt(i));
  }

  void _onContinue() =>
      ref.read(navigatorState.notifier).push(const OnboardingCompleteScreen());

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            if (isWide)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s6,
                  vertical: AppSpacing.s4,
                ),
                child: Row(
                  children: [
                    const GenSmileLogo(iconSize: 32),
                    SizedBox(width: AppSpacing.s3),
                    Text(
                      'Account Setup',
                      style: AppTextStyles.h5Bold(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              )
            else
              OnbMobileTopBar(currentStep: 4, totalSteps: 5),

            // ── Body ───────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isWide ? AppSpacing.s6 : AppSpacing.s4),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 760),
                    padding: isWide
                        ? EdgeInsets.all(AppSpacing.s6)
                        : EdgeInsets.zero,
                    decoration: isWide
                        ? BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.r3),
                          )
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon + title
                        Center(
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                Assets.iconsClinic,
                                width: 56.w,
                                height: 56.w,
                                colorFilter: ColorFilter.mode(
                                  AppColors.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Gap(AppSpacing.s3),
                              Text(
                                'Clinic Details',
                                style: AppTextStyles.h5Bold(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Gap(AppSpacing.s1),
                              Text(
                                'Add your clinic information and team members',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.mdRegular(
                                  color: AppColors.textSubTitle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(AppSpacing.s6),

                        // Clinic Information label
                        RichText(
                          text: TextSpan(
                            style: AppTextStyles.mdSemibold(
                              color: AppColors.textPrimary,
                            ),
                            children: [
                              const TextSpan(text: 'Clinic Information'),
                              TextSpan(
                                text: ' *',
                                style: AppTextStyles.mdSemibold(
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(AppSpacing.s3),

                        // Clinic cards
                        ...List.generate(
                          _clinics.length,
                          (i) => ClinicCard(
                            clinic: _clinics[i],
                            onRemove: () => _removeClinic(i),
                            onChanged: () => setState(() {}),
                          ),
                        ),

                        // Add more clinic
                        GestureDetector(
                          onTap: _addClinic,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: AppSpacing.s2,
                              bottom: AppSpacing.s6,
                            ),
                            child: Text(
                              '+ Add More Clinic',
                              style: AppTextStyles.mdSemibold(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),

                        // Invite Team Members
                        Text(
                          'Invite Team Members',
                          style: AppTextStyles.mdSemibold(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Gap(AppSpacing.s3),

                        ...List.generate(
                          _staff.length,
                          (i) => _StaffRow(
                            staff: _staff[i],
                            onRemove: () => _removeStaff(i),
                            onChanged: () => setState(() {}),
                          ),
                        ),

                        // Add more staff
                        GestureDetector(
                          onTap: _addStaff,
                          child: Padding(
                            padding: EdgeInsets.only(top: AppSpacing.s2),
                            child: Text(
                              '+ Add More Staff',
                              style: AppTextStyles.mdSemibold(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        Gap(AppSpacing.s6),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Bottom nav ─────────────────────────────────────────────────
            _BottomNav(
              onContinue: _onContinue,
              onBack: () => ref.read(navigatorState.notifier).pop(),
              isWide: isWide,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Staff row ─────────────────────────────────────────────────────────────────

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
    nameController = TextEditingController(text: widget.staff.name);
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
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.s3),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s3,
        AppSpacing.s2,
        AppSpacing.s3,
        AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.r2),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.onRemove,
              child: Icon(
                Icons.close,
                size: 18.sp,
                color: AppColors.textSubTitle,
              ),
            ),
          ),
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InputField(
                        controller: nameController,
                        label: 'Staff Name',
                        hint: 'John Smith',
                      ),
                    ),
                    SizedBox(width: AppSpacing.s3),
                    Expanded(
                      child: InputField(
                        controller: emailController,
                        label: 'Email Address',
                        hint: 'john@example.com',
                        validator: 'email',
                      ),
                    ),
                    SizedBox(width: AppSpacing.s3),
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
                )
              : Column(
                  children: [
                    InputField(
                      controller: nameController,
                      label: 'Staff Name',
                      hint: 'John Smith',
                    ),
                    Gap(AppSpacing.s3),
                    InputField(
                      controller: emailController,
                      label: 'Email Address',
                      hint: 'john@example.com',
                      validator: 'email',
                    ),
                    Gap(AppSpacing.s3),
                    InputDropDown(
                      label: 'Role',
                      value: widget.staff.role,
                      items: staffRoles,
                      onChanged: (v) {
                        widget.staff.role = v;
                        widget.onChanged();
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

// ── Bottom nav ────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.onContinue,
    required this.onBack,
    required this.isWide,
  });

  final VoidCallback onContinue, onBack;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    if (isWide) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s6,
          vertical: AppSpacing.s4,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.borderDefault)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: onBack,
              icon: Icon(
                Icons.arrow_back,
                size: 16.sp,
                color: AppColors.textSubTitle,
              ),
              label: Text(
                'Back',
                style: AppTextStyles.mdRegular(color: AppColors.textSubTitle),
              ),
            ),
            ElevatedButton.icon(
              onPressed: onContinue,
              icon: const SizedBox.shrink(),
              label: Row(
                children: [
                  Text(
                    'Continue',
                    style: AppTextStyles.lgSemibold(color: AppColors.white),
                  ),
                  SizedBox(width: AppSpacing.s2),
                  Icon(
                    Icons.arrow_forward,
                    size: 16.sp,
                    color: AppColors.white,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s6,
                  vertical: AppSpacing.s3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s4,
        0,
        AppSpacing.s4,
        AppSpacing.s6,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onContinue,
              icon: const SizedBox.shrink(),
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: AppTextStyles.lgSemibold(color: AppColors.white),
                  ),
                  SizedBox(width: AppSpacing.s2),
                  Icon(
                    Icons.arrow_forward,
                    size: 16.sp,
                    color: AppColors.white,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
              ),
            ),
          ),
          Gap(AppSpacing.s3),
          TextButton.icon(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back,
              size: 14.sp,
              color: AppColors.textSubTitle,
            ),
            label: Text(
              'Back',
              style: AppTextStyles.mdRegular(color: AppColors.textSubTitle),
            ),
          ),
        ],
      ),
    );
  }
}
