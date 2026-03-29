// lib/features/onboarding/presentation/pages/clinic_details_screen.dart
// FIX #1: Image.asset(Assets.imagesClinic) for header icon
// FIX #3: Form content wrapped in one specific white card

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/common/widgets/gen_smile_logo.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/onboarding/presentation/pages/onboarding_complete_screen.dart';
import 'package:gen_smile/features/onboarding/presentation/widgets/onb_mobile_top_bar.dart';
import 'package:gen_smile/generated/assets.dart';

class ClinicDetailsScreen extends ConsumerStatefulWidget {
  const ClinicDetailsScreen({super.key});
  @override
  ConsumerState<ClinicDetailsScreen> createState() =>
      _ClinicDetailsScreenState();
}

class _ClinicDetailsScreenState extends ConsumerState<ClinicDetailsScreen> {
  final _clinicNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _inviteEmailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _clinicNameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _inviteEmailCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    ref.read(navigatorState.notifier).push(const OnboardingCompleteScreen());
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (isWide) ...[
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
              ),
              _StepBar(current: 4),
            ] else
              OnbMobileTopBar(currentStep: 4, totalSteps: 5),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isWide ? AppSpacing.s6 : AppSpacing.s4),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    // FIX #3: One specific card wrapping entire form
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.s6),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.r3),
                        border: Border.all(color: AppColors.borderDefault),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // FIX #1: PNG clinic image
                            SvgPicture.asset(
                              Assets.iconsClinic,
                              width: 64.w,
                              height: 64.w,
                              fit: BoxFit.contain,
                              colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
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
                            Gap(AppSpacing.s6),

                            // ── Clinic Information section ───────────────────────
                            _SectionHeader(
                              'Clinic Information',
                              required: true,
                            ),
                            Gap(AppSpacing.s3),
                            _ClinicCard(
                              children: [
                                _Field(
                                  label: 'Clinic Name',
                                  hint: 'e.g., Smile Dental Clinic',
                                  controller: _clinicNameCtrl,
                                ),
                                Gap(AppSpacing.s3),
                                _Field(
                                  label: 'Address',
                                  hint: '123 Main Street, City, State',
                                  controller: _addressCtrl,
                                ),
                                Gap(AppSpacing.s3),
                                isWide
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: _Field(
                                              label: 'Phone Number',
                                              hint: '+880 1234-567890',
                                              controller: _phoneCtrl,
                                            ),
                                          ),
                                          SizedBox(width: AppSpacing.s4),
                                          Expanded(child: _LogoUpload()),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _Field(
                                            label: 'Phone Number',
                                            hint: '+880 1234-567890',
                                            controller: _phoneCtrl,
                                          ),
                                          Gap(AppSpacing.s3),
                                          _LogoUpload(),
                                        ],
                                      ),
                              ],
                            ),
                            Gap(AppSpacing.s3),
                            TextButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                size: 14.sp,
                                color: AppColors.primary,
                              ),
                              label: Text(
                                '+ Add More Clinic',
                                style: AppTextStyles.mdMedium(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Gap(AppSpacing.s4),

                            // ── Invite Team Members section ──────────────────────
                            _SectionHeader('Invite Team Members'),
                            Gap(AppSpacing.s3),
                            _ClinicCard(
                              children: [
                                _Field(
                                  label: 'Email Address',
                                  hint: 'team@clinic.com',
                                  controller: _inviteEmailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                Gap(AppSpacing.s3),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.send_outlined,
                                      size: 14.sp,
                                    ),
                                    label: Text(
                                      'Send Invite',
                                      style: AppTextStyles.mdMedium(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: BorderSide(
                                        color: AppColors.primary,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: AppSpacing.s3,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.r2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

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

// ── Helpers ───────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text, {this.required = false});
  final String text;
  final bool required;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: AppTextStyles.mdSemibold(color: AppColors.textPrimary),
          ),
          if (required)
            TextSpan(
              text: ' *',
              style: AppTextStyles.mdSemibold(color: AppColors.error),
            ),
        ],
      ),
    ),
  );
}

class _ClinicCard extends StatelessWidget {
  const _ClinicCard({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(AppSpacing.s4),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.r2),
      border: Border.all(color: AppColors.borderDefault),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
  });
  final String label, hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: AppTextStyles.smRegular(color: AppColors.textSubTitle),
      ),
      Gap(4.h),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTextStyles.mdRegular(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.mdRegular(color: AppColors.textDisable),
          filled: true,
          fillColor: AppColors.surfaceMuted,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.s3,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r2),
            borderSide: BorderSide(color: AppColors.borderDefault),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r2),
            borderSide: BorderSide(color: AppColors.borderDefault),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r2),
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    ],
  );
}

class _LogoUpload extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Clinic Logo',
        style: AppTextStyles.smRegular(color: AppColors.textSubTitle),
      ),
      Gap(4.h),
      GestureDetector(
        onTap: () {},
        child: Container(
          height: 42.h,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderDefault),
            borderRadius: BorderRadius.circular(AppRadius.r2),
          ),
          child: Center(
            child: Text(
              'Choose File',
              style: AppTextStyles.mdRegular(color: AppColors.textSubTitle),
            ),
          ),
        ),
      ),
    ],
  );
}

class _StepBar extends StatelessWidget {
  const _StepBar({required this.current});
  final int current;
  static const _steps = [
    'Create Account',
    'Choose Plan',
    'Payment Info',
    'Clinic Details',
    'Complete',
  ];
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacing.s6,
      vertical: AppSpacing.s3,
    ),
    child: Row(
      children: List.generate(_steps.length, (i) {
        final done = i < current - 1, cur = i == current - 1;
        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: done || cur
                          ? AppColors.primary
                          : AppColors.borderDefault,
                      shape: BoxShape.circle,
                    ),
                    child: done
                        ? Icon(Icons.check, color: AppColors.white, size: 14.sp)
                        : Center(
                            child: Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: cur
                                    ? AppColors.white
                                    : AppColors.gray300,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                  ),
                  Gap(4.h),
                  Text(
                    _steps[i],
                    style: AppTextStyles.xsRegular(
                      color: cur ? AppColors.primary : AppColors.textSubTitle,
                    ),
                  ),
                ],
              ),
              if (i < _steps.length - 1)
                Expanded(
                  child: Container(
                    height: 1.5,
                    margin: EdgeInsets.only(bottom: 20.h),
                    color: done ? AppColors.primary : AppColors.borderDefault,
                  ),
                ),
            ],
          ),
        );
      }),
    ),
  );
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.onContinue,
    required this.onBack,
    required this.isWide,
  });
  final VoidCallback onContinue, onBack;
  final bool isWide;
  @override
  Widget build(BuildContext context) => Container(
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
        ElevatedButton(
          onPressed: onContinue,
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
          child: Row(
            children: [
              Text(
                'Continue',
                style: AppTextStyles.lgSemibold(color: AppColors.white),
              ),
              SizedBox(width: AppSpacing.s2),
              Icon(Icons.arrow_forward, size: 16.sp, color: AppColors.white),
            ],
          ),
        ),
      ],
    ),
  );
}
