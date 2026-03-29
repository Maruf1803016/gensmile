// lib/features/onboarding/presentation/pages/onboarding_complete_screen.dart
// FIX #1: SvgPicture.asset(Assets.iconsSuccess) instead of Icon(Icons.check)
// FIX #3: "Next Steps" block wrapped in a specific white card

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/common/widgets/buttons.dart';
import 'package:gen_smile/features/onboarding/presentation/widgets/onb_mobile_top_bar.dart';
import 'package:gen_smile/features/onboarding/presentation/widgets/onb_mobile_step_header.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:gen_smile/generated/assets.dart';

class OnboardingCompleteScreen extends ConsumerWidget {
  const OnboardingCompleteScreen({super.key});

  static const _steps = [
    _Step(
      '1',
      'Explore your dashboard',
      'Get familiar with all features and tools',
    ),
    _Step('2', 'Add your first patient', 'Start creating smile simulations'),
    _Step(
      '3',
      'Customize your settings',
      'Fine-tune preferences and notifications',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const OnbMobileTopBar(currentStep: 5, totalSteps: 5),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Column(
                  children: [
                    const OnbMobileStepHeader(),
                    Gap(32.h),

                    // FIX #3: Wrap entire content in one specific card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.s6),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.r3),
                        border: Border.all(color: AppColors.borderDefault),
                      ),
                      child: Column(
                        children: [
                          // FIX #1: SVG success image instead of Icon
                          SvgPicture.asset(
                            Assets.iconsSuccess,
                            width: 72.w,
                            height: 72.w,
                          ),
                          Gap(20.h),
                          Text(
                            'Setup Complete!',
                            style: GoogleFonts.inter(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Gap(6.h),
                          Text(
                            'Your GenSmile clinic account is ready to use',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: AppColors.gray,
                            ),
                          ),
                          Gap(28.h),

                          // Next steps inner card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6FA),
                              borderRadius: BorderRadius.circular(AppRadius.r2),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Next Steps:',
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Gap(16.h),
                                ..._steps.map(
                                  (s) => Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 24.w,
                                          height: 24.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              s.number,
                                              style: GoogleFonts.inter(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                s.title,
                                                style: GoogleFonts.inter(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textColor,
                                                ),
                                              ),
                                              Gap(2.h),
                                              Text(
                                                s.subtitle,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.sp,
                                                  color: AppColors.gray,
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
                        ],
                      ),
                    ),
                    Gap(24.h),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'Go to Dashboard',
                    variant: 'primary',
                    onPressed: () => ref
                        .read(navigatorState.notifier)
                        .pushReplacementAll(const DashboardScreen()),
                  ),
                  Gap(12.h),
                  GestureDetector(
                    onTap: () {},
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: AppColors.gray,
                        ),
                        children: [
                          const TextSpan(text: 'Need help? '),
                          TextSpan(
                            text: 'View quick start guide',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step {
  const _Step(this.number, this.title, this.subtitle);
  final String number, title, subtitle;
}
