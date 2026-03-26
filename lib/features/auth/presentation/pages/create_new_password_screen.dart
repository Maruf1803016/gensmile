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
import 'package:flutter_svg/flutter_svg.dart';


class CreateNewPasswordScreen extends ConsumerStatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  ConsumerState<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState
    extends ConsumerState<CreateNewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
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
                        SvgPicture.asset(
                          Assets.iconsPasswordValidation,
                          width: 56.w,
                          height: 56.w,
                        ),
                        Gap(AppSpacing.s3),

                        Text(
                          'Create new password',
                          style: AppTextStyles.h5Bold(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Gap(AppSpacing.s1),
                        Text(
                          'Please enter your new security credentials below.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.mdRegular(
                            color: AppColors.textSubTitle,
                          ),
                        ),
                        Gap(AppSpacing.s6),

                        // Password
                        _PasswordField(
                          label: 'Password',
                          controller: _passwordController,
                          obscure: _obscurePassword,
                          onToggle: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          hint: '••••••••',
                          helperText: 'Must be at least 8 characters',
                        ),
                        Gap(AppSpacing.s4),

                        // Confirm Password
                        _PasswordField(
                          label: 'Confirm Password',
                          controller: _confirmController,
                          obscure: _obscureConfirm,
                          onToggle: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                          hint: '••••••••',
                        ),
                        Gap(AppSpacing.s4),

                        // Password requirements
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppSpacing.s4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(AppRadius.r2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password Requirements:',
                                style: AppTextStyles.mdSemibold(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Gap(AppSpacing.s2),
                              _Requirement('Minimum 8 characters'),
                              _Requirement('Include one uppercase letter'),
                              _Requirement('Include one special character'),
                            ],
                          ),
                        ),
                        Gap(AppSpacing.s6),

                        // Reset password button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                // handle reset
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
                              'Reset password',
                              style: AppTextStyles.lgSemibold(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        Gap(AppSpacing.s4),

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

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
    required this.hint,
    this.helperText,
  });

  final String label, hint;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.mdMedium(color: AppColors.textPrimary),
        ),
        Gap(4.h),
        TextFormField(
          controller: controller,
          obscureText: obscure,
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

class _Requirement extends StatelessWidget {
  const _Requirement(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8.sp, color: AppColors.primary),
          SizedBox(width: AppSpacing.s2),
          Text(
            text,
            style: AppTextStyles.smRegular(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
