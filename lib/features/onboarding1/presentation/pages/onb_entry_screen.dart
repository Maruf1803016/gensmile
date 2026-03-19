import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/core/states/navigator_state.dart';
import 'package:onboarding/common/widgets/buttons.dart';
import 'package:onboarding/features/onboarding/presentation/widgets/role_option_card.dart';
import 'package:onboarding/features/onboarding/presentation/pages/create_account_screen.dart';
import 'package:onboarding/features/auth/presentation/pages/sign_in_screen.dart';

class OnbEntryScreen extends ConsumerStatefulWidget {
  const OnbEntryScreen({super.key});

  @override
  ConsumerState<OnbEntryScreen> createState() => _OnbEntryScreenState();
}

class _OnbEntryScreenState extends ConsumerState<OnbEntryScreen> {
  String? _selectedRole;

  void _onContinue() {
    if (_selectedRole == null) return;
    ref.read(navigatorState.notifier).push(const CreateAccountScreen());
  }

  @override
  Widget build(BuildContext context) {
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
                    width: 32.w, height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.favorite,
                        color: Colors.white, size: 18.w),
                  ),
                  SizedBox(width: 8.w),
                  Text('GenSmile',
                      style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor)),
                ],
              ),
              Gap(48.h),
              Text(
                'Welcome! How would you like to continue?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor),
              ),
              Gap(24.h),
              RoleOptionCard(
                icon: Icons.medical_services_outlined,
                title: "I'm a Doctor",
                subtitle:
                    'Set up your clinic and manage patient simulations',
                isSelected: _selectedRole == 'doctor',
                onTap: () => setState(() => _selectedRole = 'doctor'),
              ),
              Gap(12.h),
              RoleOptionCard(
                icon: Icons.person_outline,
                title: "I'm a Patient",
                subtitle:
                    'Visualize your dream smile with AI-powered simulations',
                isSelected: _selectedRole == 'patient',
                onTap: () => setState(() => _selectedRole = 'patient'),
              ),
              const Spacer(),
              Opacity(
                opacity: _selectedRole != null ? 1.0 : 0.4,
                child: PrimaryButton(
                  text: 'Continue',
                  variant: 'primary',
                  onPressed: _onContinue,
                ),
              ),
              Gap(14.h),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                      fontSize: 13.sp, color: AppColors.gray),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => ref
                            .read(navigatorState.notifier)
                            .push(const SignInScreen()),
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
    );
  }
}
