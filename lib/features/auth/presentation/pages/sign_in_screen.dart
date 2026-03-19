import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/core/states/navigator_state.dart';
import 'package:onboarding/common/widgets/buttons.dart';
import 'package:onboarding/common/widgets/input_fields.dart';
import 'package:onboarding/features/auth/presentation/pages/forget_password_screen.dart';
import 'package:onboarding/features/onboarding/presentation/pages/onb_entry_screen.dart';
import 'package:onboarding/features/dashboard/presentation/pages/dashboard_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey            = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe      = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(navigatorState.notifier).pushReplacementAll(const DashboardScreen());
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
                    children: [
                      // Icon
                      Icon(Icons.person_outline,
                          size: 48.sp, color: AppColors.primary),
                      Gap(12.h),
                      Text('Sign In',
                          style: GoogleFonts.inter(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor)),
                      Gap(4.h),
                      Text('Welcome back! Sign in to continue',
                          style: GoogleFonts.inter(
                              fontSize: 13.sp, color: AppColors.gray)),
                      Gap(24.h),

                      // Email
                      InputField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'your.email@example.com',
                        validator: 'required|email',
                      ),
                      Gap(16.h),

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
                      Gap(12.h),

                      // Remember me + Forget password
                      Row(
                        children: [
                          SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r)),
                              onChanged: (v) =>
                                  setState(() => _rememberMe = v ?? false),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text('Remember me',
                              style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  color: AppColors.textColor)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => ref
                                .read(navigatorState.notifier)
                                .push(const ForgetPasswordScreen()),
                            child: Text('Forget password?',
                                style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      Gap(24.h),

                      // Continue button
                      PrimaryButton(
                        text: 'Continue →',
                        variant: 'primary',
                        onPressed: _onContinue,
                      ),
                      Gap(14.h),

                      // Sign Up link
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                              fontSize: 13.sp, color: AppColors.gray),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => ref
                                    .read(navigatorState.notifier)
                                    .push(const OnbEntryScreen()),
                                child: Text('Sign Up',
                                    style: GoogleFonts.inter(
                                        fontSize: 13.sp,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
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
