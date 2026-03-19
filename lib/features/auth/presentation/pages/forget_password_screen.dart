import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/core/states/navigator_state.dart';
import 'package:onboarding/common/widgets/buttons.dart';
import 'package:onboarding/common/widgets/input_fields.dart';
import 'package:onboarding/features/auth/presentation/pages/create_new_password_screen.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() =>
      _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey         = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendResetLink() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(navigatorState.notifier).push(const CreateNewPasswordScreen());
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
                      // Lock icon
                      Icon(Icons.lock_reset_outlined,
                          size: 48.sp, color: AppColors.primary),
                      Gap(12.h),
                      Text('Forget password',
                          style: GoogleFonts.inter(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor)),
                      Gap(4.h),
                      Text(
                        "Enter your email and we'll send you a reset link",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize: 13.sp, color: AppColors.gray),
                      ),
                      Gap(24.h),

                      // Email
                      InputField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'your.email@example.com',
                        validator: 'required|email',
                      ),
                      Gap(24.h),

                      // Send Reset Link button
                      PrimaryButton(
                        text: 'Send Reset Link',
                        variant: 'primary',
                        onPressed: _onSendResetLink,
                      ),
                      Gap(14.h),

                      // Back to sign in
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                              fontSize: 13.sp, color: AppColors.gray),
                          children: [
                            const TextSpan(text: 'Remember your password? '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () =>
                                    ref.read(navigatorState.notifier).pop(),
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
