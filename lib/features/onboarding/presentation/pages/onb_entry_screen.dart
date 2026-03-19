import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/common/widgets/buttons.dart';
import 'package:gen_smile/features/onboarding/presentation/onboarding_states.dart';
import 'package:gen_smile/features/onboarding/presentation/widgets/role_option_card.dart';

class OnbEntryScreen extends ConsumerWidget {
  const OnbEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRole = ref.watch(onboardingRoleProvider);
    final selectedRoleNotifier = ref.read(onboardingRoleProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 18.w,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'GenSmile',
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),

              Gap(48.h),

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

              RoleOptionCard(
                icon: Icons.medical_services_outlined,
                title: "I'm a Doctor",
                subtitle: 'Set up your clinic and manage patient simulations',
                isSelected: selectedRole.toString() == 'doctor',
                onTap: () => selectedRoleNotifier.setRole('doctor'),
              ),

              Gap(12.h),

              RoleOptionCard(
                icon: Icons.person_outline,
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
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.gray,
                  ),
                  children: [
                    TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Sign In',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
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
