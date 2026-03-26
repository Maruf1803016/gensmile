import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
//import 'package:hugeicons/hugeicons.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/common/widgets/buttons.dart';
import 'package:gen_smile/generated/assets.dart';
import 'package:gen_smile/features/onboarding/presentation/onboarding_states.dart';
import 'package:gen_smile/features/onboarding/presentation/widgets/role_option_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnbEntryScreen extends ConsumerWidget {
  const OnbEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRole = ref.watch(onboardingRoleProvider);
    final selectedRoleNotifier = ref.read(onboardingRoleProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Logo only — NO "GenSmile" text to avoid double header ─────
              // FIX 1: just the logo image, text removed
              SvgPicture.asset(
                    Assets.iconsBrandLogo, width: 140.w),

              Gap(48.h),

              Text(
                'Welcome! How would you like to continue?',
                textAlign: TextAlign.center,
                style: AppTextStyles.lgSemibold(color: AppColors.textPrimary),
              ),

              Gap(24.h),

              // ── Doctor card ───────────────────────────────────────────────
              RoleOptionCard(
                iconWidget: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.all(10.w),
                  child: SvgPicture.asset(
                    Assets.iconsStethoscope02, // Doctor icon
                    width: 26.w,
                    height: 26.w,
                    color: Colors.white,
                  ),
                ),
                title: "I'm a Doctor",
                subtitle: 'Set up your clinic and manage patient simulations',
                isSelected: selectedRole.toString() == 'doctor',
                onTap: () => selectedRoleNotifier.setRole('doctor'),
              ),

              Gap(12.h),

              // ── Patient card ──────────────────────────────────────────────
              RoleOptionCard(
                iconWidget: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B5EA7),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.all(10.w),
                  child: SvgPicture.asset(
                    Assets.iconsUser, // Patient icon
                    width: 26.w,
                    height: 26.w,
                    color: Colors.white,
                  ),
                ),
                title: "I'm a Patient",
                subtitle:
                    'Visualize your dream smile with AI-powered simulations',
                isSelected: selectedRole.toString() == 'patient',
                onTap: () => selectedRoleNotifier.setRole('patient'),
              ),

              const Spacer(),

              Opacity(
                opacity: selectedRole != null ? 1.0 : 0.4,
                child: PrimaryButton(
                  text: 'Continue',
                  variant: 'primary',
                  onPressed: selectedRoleNotifier.onContinue,
                ),
              ),

              Gap(14.h),

              RichText(
                text: TextSpan(
                  style: AppTextStyles.smRegular(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Sign In',
                      style: AppTextStyles.smSemibold(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
