import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/common/widgets/gen_smile_logo.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/auth/presentation/pages/forget_password_screen.dart';
import 'package:gen_smile/features/onboarding/presentation/pages/onb_entry_screen.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:gen_smile/generated/assets.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(navigatorState.notifier).push(const DashboardScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: isWide
              ? _DesktopLayout(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  rememberMe: _rememberMe,
                  formKey: _formKey,
                  onTogglePassword: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  onToggleRemember: (v) => setState(() => _rememberMe = v),
                  onContinue: _onContinue,
                  onForgotPassword: () => ref
                      .read(navigatorState.notifier)
                      .push(const ForgetPasswordScreen()),
                  onSignUp: () => ref
                      .read(navigatorState.notifier)
                      .push(const OnbEntryScreen()),
                )
              : _MobileLayout(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  rememberMe: _rememberMe,
                  formKey: _formKey,
                  onTogglePassword: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  onToggleRemember: (v) => setState(() => _rememberMe = v),
                  onContinue: _onContinue,
                  onForgotPassword: () => ref
                      .read(navigatorState.notifier)
                      .push(const ForgetPasswordScreen()),
                  onSignUp: () => ref
                      .read(navigatorState.notifier)
                      .push(const OnbEntryScreen()),
                ),
        ),
      ),
    );
  }
}

// ── Desktop layout ────────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberMe,
    required this.formKey,
    required this.onTogglePassword,
    required this.onToggleRemember,
    required this.onContinue,
    required this.onForgotPassword,
    required this.onSignUp,
  });

  final TextEditingController emailController, passwordController;
  final bool obscurePassword, rememberMe;
  final GlobalKey<FormState> formKey;
  final VoidCallback onTogglePassword, onContinue, onForgotPassword, onSignUp;
  final ValueChanged<bool> onToggleRemember;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s6,
            vertical: AppSpacing.s5,
          ),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: GenSmileLogo(iconSize: 32),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: AppSpacing.s6,
              vertical: AppSpacing.s6,
            ),
            padding: EdgeInsets.all(AppSpacing.s8),
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.r3),
            ),
            child: _FormContent(
              emailController: emailController,
              passwordController: passwordController,
              obscurePassword: obscurePassword,
              rememberMe: rememberMe,
              formKey: formKey,
              onTogglePassword: onTogglePassword,
              onToggleRemember: onToggleRemember,
              onContinue: onContinue,
              onForgotPassword: onForgotPassword,
              onSignUp: onSignUp,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Mobile layout ─────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberMe,
    required this.formKey,
    required this.onTogglePassword,
    required this.onToggleRemember,
    required this.onContinue,
    required this.onForgotPassword,
    required this.onSignUp,
  });

  final TextEditingController emailController, passwordController;
  final bool obscurePassword, rememberMe;
  final GlobalKey<FormState> formKey;
  final VoidCallback onTogglePassword, onContinue, onForgotPassword, onSignUp;
  final ValueChanged<bool> onToggleRemember;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
            vertical: AppSpacing.s4,
          ),
          child: const GenSmileLogo(iconSize: 28),
        ),
        Container(
          margin: EdgeInsets.all(AppSpacing.s4),
          padding: EdgeInsets.all(AppSpacing.s5),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.r3),
          ),
          child: _FormContent(
            emailController: emailController,
            passwordController: passwordController,
            obscurePassword: obscurePassword,
            rememberMe: rememberMe,
            formKey: formKey,
            onTogglePassword: onTogglePassword,
            onToggleRemember: onToggleRemember,
            onContinue: onContinue,
            onForgotPassword: onForgotPassword,
            onSignUp: onSignUp,
          ),
        ),
      ],
    );
  }
}

// ── Shared form content ───────────────────────────────────────────────────────

class _FormContent extends StatelessWidget {
  const _FormContent({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberMe,
    required this.formKey,
    required this.onTogglePassword,
    required this.onToggleRemember,
    required this.onContinue,
    required this.onForgotPassword,
    required this.onSignUp,
  });

  final TextEditingController emailController, passwordController;
  final bool obscurePassword, rememberMe;
  final GlobalKey<FormState> formKey;
  final VoidCallback onTogglePassword, onContinue, onForgotPassword, onSignUp;
  final ValueChanged<bool> onToggleRemember;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Icon
          Image.asset(Assets.imagesUserCheck01, width: 56.w, height: 56.w),
          Gap(AppSpacing.s3),

          // Title
          Text(
            'Sign In',
            style: AppTextStyles.h5Bold(color: AppColors.textPrimary),
          ),
          Gap(AppSpacing.s1),
          Text(
            'Welcome back! Sign in to continue',
            style: AppTextStyles.mdRegular(color: AppColors.textSubTitle),
          ),
          Gap(AppSpacing.s6),

          // Email
          _FieldLabel('Email Address'),
          Gap(AppSpacing.s1),
          _InputBox(
            controller: emailController,
            hint: 'your.email@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          Gap(AppSpacing.s4),

          // Password
          _FieldLabel('Password'),
          Gap(AppSpacing.s1),
          _InputBox(
            controller: passwordController,
            hint: '••••••••',
            obscureText: obscurePassword,
            suffix: GestureDetector(
              onTap: onTogglePassword,
              child: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18.sp,
                color: AppColors.gray400,
              ),
            ),
          ),
          Gap(AppSpacing.s3),

          // Remember me + Forgot password
          Row(
            children: [
              GestureDetector(
                onTap: () => onToggleRemember(!rememberMe),
                child: Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (v) => onToggleRemember(v ?? false),
                      activeColor: AppColors.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    SizedBox(width: AppSpacing.s1),
                    Text(
                      'Remember me',
                      style: AppTextStyles.smRegular(
                        color: AppColors.textSubTitle,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onForgotPassword,
                child: Text(
                  'Forget password?',
                  style: AppTextStyles.smSemibold(color: AppColors.primary),
                ),
              ),
            ],
          ),
          Gap(AppSpacing.s6),

          // Continue button
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
                    size: 18.sp,
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
          Gap(AppSpacing.s4),

          // Sign up link
          RichText(
            text: TextSpan(
              style: AppTextStyles.mdRegular(color: AppColors.textSubTitle),
              children: [
                const TextSpan(text: "Don't have an account? "),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: onSignUp,
                    child: Text(
                      'Sign Up',
                      style: AppTextStyles.mdSemibold(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared field helpers ──────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: AppTextStyles.mdMedium(color: AppColors.textPrimary),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
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
        suffixIcon: suffix != null
            ? Padding(
                padding: EdgeInsets.only(right: AppSpacing.s3),
                child: suffix,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
          borderRadius: BorderRadius.circular(AppRadius.r2),
        ),
      ),
    );
  }
}
