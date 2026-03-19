import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/core/states/navigator_state.dart';
import 'package:onboarding/common/widgets/buttons.dart';
import 'package:onboarding/features/onboarding/data/models/plan_model.dart';
import 'package:onboarding/features/onboarding/presentation/widgets/onb_mobile_top_bar.dart';
import 'package:onboarding/features/onboarding/presentation/widgets/onb_mobile_step_header.dart';
import 'package:onboarding/features/onboarding/presentation/widgets/plan_card.dart';
import 'package:onboarding/features/onboarding/presentation/pages/payment_info_screen.dart';

class ChoosePlanScreen extends ConsumerStatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  ConsumerState<ChoosePlanScreen> createState() =>
      _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends ConsumerState<ChoosePlanScreen> {
  String _selectedPlanId = 'growth';

  void _onContinue() {
    final selected =
        availablePlans.firstWhere((p) => p.id == _selectedPlanId);
    ref.read(navigatorState.notifier).push(
          PaymentInfoScreen(
            selectedPlanName: selected.name,
            monthlyCost: selected.price,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const OnbMobileTopBar(currentStep: 2, totalSteps: 5),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 8.h),
                child: Column(
                  children: [
                    const OnbMobileStepHeader(),
                    Gap(24.h),

                    Icon(Icons.credit_card_outlined,
                        color: AppColors.primary, size: 40.w),
                    Gap(12.h),

                    Text(
                      'Choose Your Plan',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),

                    Gap(6.h),

                    Text(
                      'Select a plan that fits your needs.\nUpgrade anytime.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 13.sp, color: AppColors.gray),
                    ),

                    Gap(20.h),

                    ...availablePlans.map(
                      (plan) => Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: PlanCard(
                          plan: plan,
                          isSelected: _selectedPlanId == plan.id,
                          onTap: () => setState(
                              () => _selectedPlanId = plan.id),
                        ),
                      ),
                    ),

                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                            fontSize: 13.sp, color: AppColors.gray),
                        children: [
                          const TextSpan(text: 'All plans include a '),
                          TextSpan(
                            text: '14-day free trial',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(
                              text: '. No credit card required.'),
                        ],
                      ),
                    ),

                    Gap(24.h),
                  ],
                ),
              ),
            ),

            _OnbBottomNav(
              onContinue: _onContinue,
              onBack: () => ref.read(navigatorState.notifier).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnbBottomNav extends StatelessWidget {
  const _OnbBottomNav(
      {required this.onContinue, required this.onBack});

  final VoidCallback? onContinue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      child: Column(
        children: [
          PrimaryButton(
            text: 'Continue',
            variant: 'primary',
            onPressed: onContinue ?? () {},
          ),
          Gap(12.h),
          GestureDetector(
            onTap: onBack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back,
                    size: 14.w, color: AppColors.gray),
                SizedBox(width: 4.w),
                Text('Back',
                    style: GoogleFonts.inter(
                        fontSize: 13.sp, color: AppColors.gray)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
