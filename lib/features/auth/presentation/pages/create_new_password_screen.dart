import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/core/states/navigator_state.dart';
import 'package:onboarding/common/widgets/buttons.dart';
import 'package:onboarding/common/widgets/input_fields.dart';
import 'package:onboarding/features/auth/presentation/pages/sign_in_screen.dart';

class CreateNewPasswordScreen extends ConsumerStatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  ConsumerState<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState
    extends ConsumerState<CreateNewPasswordScreen> {
  final _passwordController        = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey                   = GlobalKey<FormState>();

  bool _obscurePassword        = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onResetPassword() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // TODO: call reset password API
    ref.read(navigatorState.notifier).pushReplacementAll(const SignInScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            children: [
              // ── Logo ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32.w, height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.medical_services_outlined,
                        color: Colors.white, size: 18.sp),
                  ),
                  SizedBox(width: 8.w),
                  Text('GenSmile',
                      style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor)),
                ],
              ),

              Gap(32.h),

              // ── Card ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Center(
                        child: Icon(Icons.verified_user_outlined,
                            size: 48.sp, color: AppColors.primary),
                      ),
                      Gap(12.h),
                      Center(
                        child: Text('Create new password',
                            style: GoogleFonts.inter(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor)),
                      ),
                      Gap(4.h),
                      Center(
                        child: Text(
                          'Please enter your new security credentials below.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 13.sp, color: AppColors.gray),
                        ),
                      ),
                      Gap(24.h),

                      // Password
                      InputField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '••••••••',
                        validator: 'required|min:8',
                        suffix: GestureDetector(
                          onTap: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          child: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20.w,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                      ),
                      Gap(4.h),
                      Text('Must be at least 8 characters',
                          style: GoogleFonts.inter(
                              fontSize: 11.sp, color: AppColors.gray)),
                      Gap(16.h),

                      // Confirm Password
                      InputField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
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
                              size: 20.w,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                      ),
                      Gap(16.h),

                      // Password Requirements box
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.inputBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Password Requirements:',
                                style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor)),
                            Gap(10.h),
                            _Requirement('Minimum 8 characters'),
                            _Requirement('Include one uppercase letter'),
                            _Requirement('Include one special character'),
                          ],
                        ),
                      ),
                      Gap(24.h),

                      // Reset password button
                      PrimaryButton(
                        text: 'Reset password',
                        variant: 'primary',
                        onPressed: _onResetPassword,
                      ),
                      Gap(14.h),

                      // Back to sign in
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                                fontSize: 13.sp, color: AppColors.gray),
                            children: [
                              const TextSpan(
                                  text: 'Remember your password? '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => ref
                                      .read(navigatorState.notifier)
                                      .pushReplacementAll(
                                          const SignInScreen()),
                                  child: Text('Sign In',
                                      style: GoogleFonts.inter(
                                          fontSize: 13.sp,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Requirement extends StatelessWidget {
  const _Requirement(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(Icons.circle, size: 6.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Text(text,
              style: GoogleFonts.inter(
                  fontSize: 12.sp, color: AppColors.textColor)),
        ],
      ),
    );
  }
}
