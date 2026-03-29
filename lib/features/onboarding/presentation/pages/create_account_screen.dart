// lib/features/onboarding/presentation/pages/create_account_screen.dart
// FIX #1: SvgPicture.asset(Assets.iconsUserEdit01) — SVG not PNG
// FIX #3: Form always wrapped in white card on BOTH mobile and desktop

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/common/widgets/gen_smile_logo.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/onboarding/presentation/pages/choose_plan_screen.dart';
import 'package:gen_smile/features/onboarding/presentation/widgets/onb_mobile_top_bar.dart';
import 'package:gen_smile/generated/assets.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});
  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePass = true;
  bool _obscureConf = true;
  bool _agreed = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_agreed) return;
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(navigatorState.notifier).push(const ChoosePlanScreen());
    }
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
              _StepBar(current: 1),
            ] else
              OnbMobileTopBar(currentStep: 1, totalSteps: 5),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isWide ? AppSpacing.s6 : AppSpacing.s4),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    // FIX #3: Card on BOTH mobile and desktop
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
                            // FIX #1: SVG user-edit icon
                            SvgPicture.asset(
                              Assets.iconsUserEdit01,
                              width: 56.w,
                              height: 56.w,
                              colorFilter: ColorFilter.mode(
                                AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            Gap(AppSpacing.s3),
                            Text(
                              'Create Your Account',
                              style: AppTextStyles.h5Bold(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Gap(AppSpacing.s1),
                            Text(
                              'Get started with GenSmile in seconds',
                              style: AppTextStyles.mdRegular(
                                color: AppColors.textSubTitle,
                              ),
                            ),
                            Gap(AppSpacing.s6),

                            _FormField(
                              label: 'Full Name',
                              required: true,
                              controller: _nameCtrl,
                              hint: 'Dr. John Doe',
                            ),
                            Gap(AppSpacing.s4),
                            _FormField(
                              label: 'Email Address',
                              required: true,
                              controller: _emailCtrl,
                              hint: 'your.email@example.com',
                              keyboard: TextInputType.emailAddress,
                            ),
                            Gap(AppSpacing.s4),
                            _PasswordField(
                              label: 'Password',
                              required: true,
                              controller: _passCtrl,
                              obscure: _obscurePass,
                              onToggle: () =>
                                  setState(() => _obscurePass = !_obscurePass),
                              helper: 'Must be at least 8 characters',
                            ),
                            Gap(AppSpacing.s4),
                            _PasswordField(
                              label: 'Confirm Password',
                              required: true,
                              controller: _confirmCtrl,
                              obscure: _obscureConf,
                              onToggle: () =>
                                  setState(() => _obscureConf = !_obscureConf),
                            ),
                            Gap(AppSpacing.s4),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _agreed,
                                  onChanged: (v) =>
                                      setState(() => _agreed = v ?? false),
                                  activeColor: AppColors.primary,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                                SizedBox(width: AppSpacing.s1),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: AppTextStyles.smRegular(
                                        color: AppColors.textSubTitle,
                                      ),
                                      children: [
                                        const TextSpan(text: 'I agree to the '),
                                        TextSpan(
                                          text: 'Terms of Service',
                                          style: AppTextStyles.smSemibold(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: AppTextStyles.smSemibold(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
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

// ── Shared field widgets ──────────────────────────────────────────────────────
class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    required this.hint,
    this.required = false,
    this.keyboard,
  });
  final String label, hint;
  final TextEditingController controller;
  final bool required;
  final TextInputType? keyboard;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          style: AppTextStyles.mdMedium(color: AppColors.textPrimary),
          children: [
            TextSpan(text: label),
            if (required)
              TextSpan(
                text: ' *',
                style: AppTextStyles.mdMedium(color: AppColors.error),
              ),
          ],
        ),
      ),
      Gap(4.h),
      TextFormField(
        controller: controller,
        keyboardType: keyboard,
        style: AppTextStyles.mdRegular(color: AppColors.textPrimary),
        validator: required
            ? (v) => (v?.isEmpty ?? true) ? 'Required' : null
            : null,
        decoration: _deco(hint),
      ),
    ],
  );
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
    this.required = false,
    this.helper,
  });
  final String label;
  final TextEditingController controller;
  final bool obscure, required;
  final VoidCallback onToggle;
  final String? helper;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          style: AppTextStyles.mdMedium(color: AppColors.textPrimary),
          children: [
            TextSpan(text: label),
            if (required)
              TextSpan(
                text: ' *',
                style: AppTextStyles.mdMedium(color: AppColors.error),
              ),
          ],
        ),
      ),
      Gap(4.h),
      TextFormField(
        controller: controller,
        obscureText: obscure,
        style: AppTextStyles.mdRegular(color: AppColors.textPrimary),
        decoration: _deco('••••••••').copyWith(
          suffixIcon: GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: EdgeInsets.only(right: AppSpacing.s3),
              child: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18.sp,
                color: AppColors.gray400,
              ),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          helperText: helper,
          helperStyle: AppTextStyles.smRegular(color: AppColors.textSubTitle),
        ),
      ),
    ],
  );
}

InputDecoration _deco(String hint) => InputDecoration(
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
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.r2),
    borderSide: BorderSide(color: AppColors.error),
  ),
);

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
                  Icon(
                    Icons.arrow_forward,
                    size: 16.sp,
                    color: AppColors.white,
                  ),
                ],
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
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
              ),
              child: Row(
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
