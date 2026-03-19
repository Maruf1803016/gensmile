import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              // Logo top left
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s6,
                  vertical: AppSpacing.s5,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const GenSmileLogo(iconSize: 32),
                ),
              ),

              // Card
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
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Icon
                        Image.asset(
                          Assets.imagesResetPassword,
                          width: 56.w,
                          height: 56.w,
                        ),
                        Gap(AppSpacing.s3),

                        Text(
                          'Forget password',
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
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        Gap(AppSpacing.s6),

                        // Send reset link button
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
