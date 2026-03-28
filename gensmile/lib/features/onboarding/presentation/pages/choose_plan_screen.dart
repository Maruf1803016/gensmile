import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/common/widgets/gen_smile_logo.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/onboarding/presentation/pages/payment_info_screen.dart';
import 'package:gen_smile/features/onboarding/presentation/widgets/onb_mobile_top_bar.dart';
import 'package:gen_smile/generated/assets.dart';

class _Plan {
  final String id, name, price, popular;
  final List<String> features;
  const _Plan({
    required this.id,
    required this.name,
    required this.price,
    this.popular = '',
    required this.features,
  });
}

const _plans = [
  _Plan(
    id: 'starter',
    name: 'Starter',
    price: '\$99',
    features: [
      '50 simulations/month',
      'Basic analytics',
      'Email support',
      '1 clinic location',
    ],
  ),
  _Plan(
    id: 'growth',
    name: 'Growth',
    price: '\$249',
    popular: 'POPULAR',
    features: [
      '200 simulations/month',
      'Advanced analytics',
      'Priority support',
      '3 clinic locations',
      'Custom branding',
    ],
  ),
  _Plan(
    id: 'enterprise',
    name: 'Enterprise',
    price: '\$599',
    features: [
      'Unlimited simulations',
      'Enterprise analytics',
      '24/7 dedicated support',
      'Unlimited locations',
      'API access',
    ],
  ),
];

class ChoosePlanScreen extends ConsumerStatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  ConsumerState<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends ConsumerState<ChoosePlanScreen> {
  String _selectedPlanId = 'growth';

  void _onContinue() {
    final selected = _plans.firstWhere((p) => p.id == _selectedPlanId);
    ref
        .read(navigatorState.notifier)
        .push(
          PaymentInfoScreen(
            selectedPlanName: selected.name,
            monthlyCost:
                int.tryParse(
                  selected.price.replaceAll('\$', '').replaceAll(',', ''),
                ) ??
                0,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (isWide) ...[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s6,
                  vertical: AppSpacing.s4,
                ),
                child: Row(
                  children: [
                    const GenSmileLogo(iconSize: 32),
                    SizedBox(width: AppSpacing.s3),
                    Text(
                      'Account Setup',
                      style: AppTextStyles.h5Bold(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              _StepIndicator(currentStep: 2),
            ] else
              OnbMobileTopBar(currentStep: 2, totalSteps: 5),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isWide ? AppSpacing.s6 : AppSpacing.s4),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 700),
                    padding: EdgeInsets.all(AppSpacing.s6),
                    decoration: isWide
                        ? BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.r3),
                          )
                        : null,
                    child: Column(
                      children: [
                        Image.asset(
                          Assets.imagesCardExchange02,
                          width: 56.w,
                          height: 56.w,
                        ),
                        Gap(AppSpacing.s3),
                        Text(
                          'Choose Your Plan',
                          style: AppTextStyles.h5Bold(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Gap(AppSpacing.s1),
                        Text(
                          'Select a plan that fits your needs. Upgrade anytime.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.mdRegular(
                            color: AppColors.textSubTitle,
                          ),
                        ),
                        Gap(AppSpacing.s6),

                        // Plan cards
                        isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _plans
                                    .map(
                                      (p) => Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: AppSpacing.s2,
                                          ),
                                          child: _PlanCard(
                                            plan: p,
                                            isSelected: _selectedPlanId == p.id,
                                            onTap: () => setState(
                                              () => _selectedPlanId = p.id,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            : Column(
                                children: _plans
                                    .map(
                                      (p) => Padding(
                                        padding: EdgeInsets.only(
                                          bottom: AppSpacing.s3,
                                        ),
                                        child: _PlanCard(
                                          plan: p,
                                          isSelected: _selectedPlanId == p.id,
                                          onTap: () => setState(
                                            () => _selectedPlanId = p.id,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),

                        Gap(AppSpacing.s4),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTextStyles.smRegular(
                              color: AppColors.textSubTitle,
                            ),
                            children: [
                              const TextSpan(text: 'All plans include a '),
                              TextSpan(
                                text: '14-day free trial',
                                style: AppTextStyles.smSemibold(
                                  color: AppColors.primary,
                                ),
                              ),
                              const TextSpan(
                                text: '. No credit card required.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom nav
            _BottomNav(
              onContinue: _onContinue,
              onBack: () => ref.read(navigatorState.notifier).pop(),
              isWide: isWide,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  final _Plan plan;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.r3),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.borderDefault,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (plan.popular.isNotEmpty) Gap(AppSpacing.s3),
                Text(
                  plan.name,
                  style: AppTextStyles.lgSemibold(color: AppColors.textPrimary),
                ),
                Gap(AppSpacing.s1),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: plan.price,
                        style: AppTextStyles.h4Bold(color: AppColors.primary),
                      ),
                      TextSpan(
                        text: '/month',
                        style: AppTextStyles.smRegular(
                          color: AppColors.textSubTitle,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(AppSpacing.s4),
                ...plan.features.map(
                  (f) => Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.s2),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16.sp,
                          color: AppColors.success,
                        ),
                        SizedBox(width: AppSpacing.s2),
                        Expanded(
                          child: Text(
                            f,
                            style: AppTextStyles.smRegular(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(AppSpacing.s4),
                SizedBox(
                  width: double.infinity,
                  child: isSelected
                      ? ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.round,
                              ),
                            ),
                          ),
                          child: Text(
                            'Selected',
                            style: AppTextStyles.mdSemibold(
                              color: AppColors.white,
                            ),
                          ),
                        )
                      : OutlinedButton(
                          onPressed: onTap,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.borderDefault),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.round,
                              ),
                            ),
                          ),
                          child: Text(
                            'Select plan',
                            style: AppTextStyles.mdRegular(
                              color: AppColors.textSubTitle,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        if (plan.popular.isNotEmpty)
          Positioned(
            top: -12.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s3,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blue600,
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
                child: Text(
                  plan.popular,
                  style: AppTextStyles.xsSemibold(color: AppColors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});
  final int currentStep;

  static const _steps = [
    'Create Account',
    'Choose Plan',
    'Payment Info',
    'Clinic Details',
    'Complete',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s6,
        vertical: AppSpacing.s3,
      ),
      child: Row(
        children: List.generate(_steps.length, (i) {
          final isCompleted = i < currentStep - 1;
          final isCurrent = i == currentStep - 1;
          return Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? AppColors.primary
                            : AppColors.borderDefault,
                        shape: BoxShape.circle,
                      ),
                      child: isCompleted
                          ? Icon(
                              Icons.check,
                              color: AppColors.white,
                              size: 14.sp,
                            )
                          : Center(
                              child: Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? AppColors.white
                                      : AppColors.gray300,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                    ),
                    Gap(4.h),
                    Text(
                      _steps[i],
                      style: AppTextStyles.xsRegular(
                        color: isCurrent
                            ? AppColors.primary
                            : AppColors.textSubTitle,
                      ),
                    ),
                  ],
                ),
                if (i < _steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 1.5,
                      margin: EdgeInsets.only(bottom: 20.h),
                      color: isCompleted
                          ? AppColors.primary
                          : AppColors.borderDefault,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.onContinue,
    required this.onBack,
    required this.isWide,
  });

  final VoidCallback onContinue, onBack;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s6,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.borderDefault)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back,
              size: 16.sp,
              color: AppColors.textSubTitle,
            ),
            label: Text(
              'Back',
              style: AppTextStyles.mdRegular(color: AppColors.textSubTitle),
            ),
          ),
          ElevatedButton.icon(
            onPressed: onContinue,
            icon: const SizedBox.shrink(),
            label: Row(
              children: [
                Text(
                  'Continue',
                  style: AppTextStyles.lgSemibold(color: AppColors.white),
                ),
                SizedBox(width: AppSpacing.s2),
                Icon(Icons.arrow_forward, size: 16.sp, color: AppColors.white),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.s6,
                vertical: AppSpacing.s3,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
