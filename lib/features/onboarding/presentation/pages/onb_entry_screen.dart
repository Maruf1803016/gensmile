// lib/features/onboarding/presentation/pages/onb_entry_screen.dart
// FIX #1: Uses PNG Assets.imagesStethoscope02 (doctor) & Assets.imagesUser (patient)
// FIX #3: Role cards already ARE the cards for this screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/onboarding/presentation/onboarding_states.dart';
import 'package:gen_smile/features/onboarding/presentation/pages/create_account_screen.dart';
import 'package:gen_smile/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:gen_smile/generated/assets.dart';

class OnbEntryScreen extends ConsumerWidget {
  const OnbEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(onboardingRoleProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Logo (SVG only) ──────────────────────────────────────
              SvgPicture.asset(
                Assets.iconsBrandLogo,
                width: isWide ? 160.w : 120.w,
                fit: BoxFit.contain,
              ),
              Gap(40.h),
              Text(
                'Welcome! How would you like to continue?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Gap(24.h),

              // ── Doctor card ──────────────────────────────────────────
              _RoleCard(
                // FIX #1: PNG image
                imageWidget: SvgPicture.asset(
                  Assets.iconsStethoscope02,
                  width: 28.w,
                  height: 28.w,
                  fit: BoxFit.contain,
                ),
                bgColor: AppColors.primary,
                title: "I'm a Doctor",
                subtitle: 'Set up your clinic and manage patient simulations',
                isSelected: role == 'doctor',
                onTap: () =>
                    ref.read(onboardingRoleProvider.notifier).state = 'doctor',
              ),
              Gap(12.h),

              // ── Patient card ─────────────────────────────────────────
              _RoleCard(
                // FIX #1: PNG image
                imageWidget: SvgPicture.asset(
                  Assets.iconsUser,
                  width: 28.w,
                  height: 28.w,
                  fit: BoxFit.contain,
                ),
                bgColor: const Color(0xFF7B5EA7),
                title: "I'm a Patient",
                subtitle:
                    'Visualize your dream smile with AI-powered simulations',
                isSelected: role == 'patient',
                onTap: () =>
                    ref.read(onboardingRoleProvider.notifier).state = 'patient',
              ),

              const Spacer(),

              // ── Continue ─────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: role != null
                      ? () => ref
                            .read(navigatorState.notifier)
                            .push(const CreateAccountScreen())
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.4),
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.round),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Gap(14.h),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.gray,
                  ),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => ref
                            .read(navigatorState.notifier)
                            .push(const SignInScreen()),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
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
    );
  }
}

// ── Role card (IS the specific card for this screen) ─────────────────────────
class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.imageWidget,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });
  final Widget imageWidget;
  final Color bgColor;
  final String title, subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.inputBorder,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          // PNG image in coloured container
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.all(8.w),
            child: imageWidget,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.white, size: 14.w),
            ),
        ],
      ),
    ),
  );
}
