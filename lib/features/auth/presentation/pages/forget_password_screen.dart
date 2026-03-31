// lib/features/auth/presentation/pages/forget_password_screen.dart
// FIX #2: Image.asset(Assets.imagesPasswordValidation) positioned ABOVE title
// FIX #3: Back arrow via navigatorState.pop()

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/common/widgets/gen_smile_logo.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/generated/assets.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() =>
      _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header row: back arrow + logo ────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s4,
                  vertical: AppSpacing.s4,
                ),
                child: Row(
                  children: [
                    // FIX #3: back arrow
                    GestureDetector(
                      onTap: () => ref.read(navigatorState.notifier).pop(),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: AppSpacing.s3),
                    const GenSmileLogo(iconSize: 28),
                  ],
                ),
              ),

              // ── Card ─────────────────────────────────────────────────
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: isWide ? AppSpacing.s6 : AppSpacing.s4,
                    vertical: AppSpacing.s4,
                  ),
                  padding: EdgeInsets.all(
                    isWide ? AppSpacing.s8 : AppSpacing.s5,
                  ),
                  constraints: const BoxConstraints(maxWidth: 480),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.r3),
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // FIX #2: PNG image ABOVE title (not SVG, no wrong placement)
                        SvgPicture.asset(
                          Assets.iconsPasswordValidation,
                          width: 72.w,
                          height: 72.w,
                          fit: BoxFit.contain,
                        ),
                        Gap(AppSpacing.s4),

                        // Title
                        Text(
                          'Forgot Password',
                          style: AppTextStyles.h5Bold(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Gap(AppSpacing.s1),
                        Text(
                          "Enter your email and we'll send you a reset link",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.mdRegular(
                            color: AppColors.textSubTitle,
                          ),
                        ),
                        Gap(AppSpacing.s6),

                        // Email field
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email Address',
                            style: AppTextStyles.mdMedium(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Gap(AppSpacing.s1),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: AppTextStyles.mdRegular(
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'your.email@example.com',
                            hintStyle: AppTextStyles.mdRegular(
                              color: AppColors.textDisable,
                            ),
                            filled: true,
                            fillColor: AppColors.surfaceMuted,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.s3,
                              vertical: AppSpacing.s3,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.borderDefault,
                              ),
                              borderRadius: BorderRadius.circular(AppRadius.r2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.borderDefault,
                              ),
                              borderRadius: BorderRadius.circular(AppRadius.r2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(AppRadius.r2),
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Please enter your email'
                              : null,
                        ),
                        Gap(AppSpacing.s6),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                // handle send reset link
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.s4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.round,
                                ),
                              ),
                            ),
                            child: Text(
                              'Send Reset Link',
                              style: AppTextStyles.lgSemibold(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        Gap(AppSpacing.s4),

                        // Sign in link
                        RichText(
                          text: TextSpan(
                            style: AppTextStyles.mdRegular(
                              color: AppColors.textSubTitle,
                            ),
                            children: [
                              const TextSpan(text: 'Remember your password? '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () =>
                                      ref.read(navigatorState.notifier).pop(),
                                  child: Text(
                                    'Sign In',
                                    style: AppTextStyles.mdSemibold(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
