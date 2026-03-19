import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_agreedToTerms) return;
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
            // ── Desktop header ─────────────────────────────────────────────
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
              _StepIndicator(currentStep: 1),
            ] else
              OnbMobileTopBar(currentStep: 1, totalSteps: 5),

            // ── Content ────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isWide ? AppSpacing.s6 : AppSpacing.s4),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 520),
                    padding: EdgeInsets.all(AppSpacing.s6),
                    decoration: isWide
                        ? BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.r3),
                          )
                        : null,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Image.asset(
                            Assets.imagesUserEdit01,
                            width: 56.w,
                            height: 56.w,
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

                          // Full Name
                          _FormField(
                            label: 'Full Name',
                            required: true,
                            controller: _nameController,
                            hint: 'Dr. John Doe',
                          ),
                          Gap(AppSpacing.s4),

                          // Email
                          _FormField(
                            label: 'Email Address',
                            required: true,
                            controller: _emailController,
                            hint: 'your.email@example.com',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Gap(AppSpacing.s4),

                          // Password
                          _PasswordFormField(
                            label: 'Password',
                            required: true,
                            controller: _passwordController,
                            obscure: _obscurePassword,
                            onToggle: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            helperText: 'Must be at least 8 characters',
                          ),
                          Gap(AppSpacing.s4),

                          // Confirm Password
                          _PasswordFormField(
                            label: 'Confirm Password',
                            required: true,
                            controller: _confirmController,
                            obscure: _obscureConfirm,
                            onToggle: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                          Gap(AppSpacing.s4),

                          // Terms checkbox
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _agreedToTerms,
                                onChanged: (v) =>
                                    setState(() => _agreedToTerms = v ?? false),
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

// ── Step indicator (desktop) ──────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});
  final int currentStep;

  static const _steps = [
    'Create Account',
    'Choose Plan',
    'Payment Info',
    'Clinic Details',
    'Complete',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s6,
        vertical: AppSpacing.s3,
      ),
      child: Row(
        children: List.generate(_steps.length, (i) {
          final isCompleted = i < currentStep - 1;
          final isCurrent = i == currentStep - 1;
          return Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? AppColors.primary
                            : AppColors.borderDefault,
                        shape: BoxShape.circle,
                      ),
                      child: isCompleted
                          ? Icon(
                              Icons.check,
                              color: AppColors.white,
                              size: 14.sp,
                            )
                          : Center(
                              child: Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: isCurrent
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
                        color: isCurrent
                            ? AppColors.primary
                            : AppColors.textSubTitle,
                      ),
                    ),
                  ],
                ),
                if (i < _steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 1.5,
                      margin: EdgeInsets.only(bottom: 20.h),
                      color: isCompleted
                          ? AppColors.primary
                          : AppColors.borderDefault,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Bottom navigation bar ─────────────────────────────────────────────────────

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

    // Mobile
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

// ── Form field helpers ────────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    required this.hint,
    this.required = false,
    this.keyboardType,
  });

  final String label, hint;
  final TextEditingController controller;
  final bool required;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              borderSide: BorderSide(color: AppColors.borderDefault),
              borderRadius: BorderRadius.circular(AppRadius.r2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderDefault),
              borderRadius: BorderRadius.circular(AppRadius.r2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
              borderRadius: BorderRadius.circular(AppRadius.r2),
            ),
          ),
        ),
      ],
    );
  }
}

class _PasswordFormField extends StatelessWidget {
  const _PasswordFormField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
    this.required = false,
    this.helperText,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure, required;
  final VoidCallback onToggle;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: AppTextStyles.mdRegular(color: AppColors.textDisable),
            filled: true,
            fillColor: AppColors.surfaceMuted,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.s3,
            ),
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
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderDefault),
              borderRadius: BorderRadius.circular(AppRadius.r2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderDefault),
              borderRadius: BorderRadius.circular(AppRadius.r2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
              borderRadius: BorderRadius.circular(AppRadius.r2),
            ),
            helperText: helperText,
            helperStyle: AppTextStyles.smRegular(color: AppColors.textSubTitle),
          ),
        ),
      ],
    );
  }
}
