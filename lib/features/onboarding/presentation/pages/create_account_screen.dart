import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/core/states/navigator_state.dart';
import 'package:onboarding/common/widgets/input_fields.dart';
import 'package:onboarding/common/widgets/buttons.dart';
import 'package:onboarding/features/onboarding/presentation/widgets/onb_mobile_top_bar.dart';
import 'package:onboarding/features/onboarding/presentation/widgets/onb_mobile_step_header.dart';
import 'package:onboarding/features/onboarding/presentation/pages/choose_plan_screen.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState
    extends ConsumerState<CreateAccountScreen> {
  final _fullNameController        = TextEditingController();
  final _emailController           = TextEditingController();
  final _passwordController        = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey                   = GlobalKey<FormState>();

  bool _obscurePassword        = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms          = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_agreedToTerms) return;
    ref.read(navigatorState.notifier).push(const ChoosePlanScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const OnbMobileTopBar(currentStep: 1, totalSteps: 5),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 8.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const OnbMobileStepHeader(),
                      Gap(24.h),

                      Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person_add_outlined,
                            color: AppColors.primary, size: 28.w),
                      ),

                      Gap(12.h),

                      Text(
                        'Create Your Account',
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                      ),

                      Gap(4.h),

                      Text(
                        'Get started with GenSmile in seconds',
                        style: GoogleFonts.inter(
                            fontSize: 13.sp, color: AppColors.gray),
                      ),

                      Gap(24.h),

                      InputField(
                        controller: _fullNameController,
                        label: 'Full Name *',
                        hint: 'Dr. John Doe',
                        validator: 'required',
                      ),

                      Gap(16.h),

                      InputField(
                        controller: _emailController,
                        label: 'Email Address *',
                        hint: 'your.email@example.com',
                        validator: 'required|email',
                      ),

                      Gap(16.h),

                      InputField(
                        controller: _passwordController,
                        label: 'Password *',
                        hint: '••••••••',
                        validator: 'required|min:8',
                        suffix: GestureDetector(
                          onTap: () => setState(() =>
                              _obscurePassword = !_obscurePassword),
                          child: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.gray,
                              size: 20.w,
                            ),
                          ),
                        ),
                      ),

                      Gap(16.h),

                      InputField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password *',
                        hint: '••••••••',
                        validator: 'required|min:8',
                        suffix: GestureDetector(
                          onTap: () => setState(() =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword),
                          child: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.gray,
                              size: 20.w,
                            ),
                          ),
                        ),
                      ),

                      Gap(16.h),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _agreedToTerms,
                            activeColor: AppColors.primary,
                            onChanged: (val) => setState(
                                () => _agreedToTerms = val ?? false),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: AppColors.gray),
                                children: [
                                  const TextSpan(
                                      text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Gap(24.h),
                    ],
                  ),
                ),
              ),
            ),

            _OnbBottomNav(
              onContinue: _agreedToTerms ? _onContinue : null,
              onBack: () => ref.read(navigatorState.notifier).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnbBottomNav extends StatelessWidget {
  const _OnbBottomNav({required this.onContinue, required this.onBack});

  final VoidCallback? onContinue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      child: Column(
        children: [
          Opacity(
            opacity: onContinue != null ? 1.0 : 0.4,
            child: PrimaryButton(
              text: 'Continue',
              variant: 'primary',
              onPressed: onContinue ?? () {},
            ),
          ),
          Gap(12.h),
          GestureDetector(
            onTap: onBack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back,
                    size: 14.w, color: AppColors.gray),
                SizedBox(width: 4.w),
                Text('Back',
                    style: GoogleFonts.inter(
                        fontSize: 13.sp, color: AppColors.gray)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
