import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/common/widgets/gen_smile_logo.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/onboarding/presentation/pages/clinic_details_screen.dart';
import 'package:gen_smile/features/onboarding/presentation/widgets/onb_mobile_top_bar.dart';
import 'package:gen_smile/generated/assets.dart';

class PaymentInfoScreen extends ConsumerStatefulWidget {
  const PaymentInfoScreen({
    super.key,
    required this.selectedPlanName,
    required this.monthlyCost,
  });

  final String selectedPlanName;
  final int monthlyCost;

  @override
  ConsumerState<PaymentInfoScreen> createState() => _PaymentInfoScreenState();
}

class _PaymentInfoScreenState extends ConsumerState<PaymentInfoScreen> {
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String _selectedMethod = 'visa';

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    ref.read(navigatorState.notifier).push(const ClinicDetailsScreen());
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
                    const GenSmileLogo(iconSize: 32, showText: true),
                    SizedBox(width: AppSpacing.s3),
                    Text(
                      'Account Setup',
                      style: AppTextStyles.h5Bold(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              _StepIndicator(currentStep: 3),
            ] else
              const OnbMobileTopBar(currentStep: 3, totalSteps: 5),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isWide ? AppSpacing.s6 : AppSpacing.s4),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 560),
                    padding: EdgeInsets.all(AppSpacing.s6),
                    decoration: isWide
                        ? BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.r3),
                          )
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FIX 3: SVG from assets/icons/ instead of broken PNG
                        Center(
                          child: SvgPicture.asset(
                            Assets.iconsCreditCardPos,
                            width: 56.w,
                            height: 56.w,
                            colorFilter: ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Gap(AppSpacing.s3),
                        Center(
                          child: Text(
                            'Payment Information',
                            style: AppTextStyles.h5Bold(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Gap(AppSpacing.s1),
                        Center(
                          child: Text(
                            'Secure payment processing',
                            style: AppTextStyles.mdRegular(
                              color: AppColors.textSubTitle,
                            ),
                          ),
                        ),
                        Gap(AppSpacing.s6),

                        // Payment method selector
                        Text(
                          'How would you like to pay?',
                          style: AppTextStyles.mdMedium(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Gap(AppSpacing.s3),
                        Row(
                          children: [
                            _PayMethodChip(
                              label: 'VISA',
                              svgPath: null, // text fallback
                              imagePath: Assets.imagesVisa,
                              isSelected: _selectedMethod == 'visa',
                              onTap: () =>
                                  setState(() => _selectedMethod = 'visa'),
                            ),
                            SizedBox(width: AppSpacing.s3),
                            _PayMethodChip(
                              label: 'masterCard',
                              svgPath: Assets.imagesVisa1,
                              imagePath: Assets.imagesVisa1,
                              isSelected:  _selectedMethod == 'masterCard',
                              onTap: () =>
                                 setState(() => _selectedMethod = 'masterCard'),
                              
                            ),
                            SizedBox(width: AppSpacing.s3),
                            _PayMethodChip(
                              label: 'PayPal',
                              svgPath: null, // text fallback
                              imagePath: Assets.imagesVisa2,
                              isSelected: _selectedMethod == 'PayPal',
                              onTap: () =>
                                  setState(() => _selectedMethod = 'PayPal'),
                            ),
                          ],
                        ),
                        Gap(AppSpacing.s4),

                        // Card Number
                        _FieldLabel('Card Number'),
                        Gap(AppSpacing.s1),
                        _InputBox(
                          ctrl: _cardNumberCtrl,
                          hint: '1234 5678 9012 3456',
                          keyboardType: TextInputType.number,
                        ),
                        Gap(AppSpacing.s4),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _FieldLabel('Expiry Date'),
                                  Gap(AppSpacing.s1),
                                  _InputBox(ctrl: _expiryCtrl, hint: 'MM/YY'),
                                ],
                              ),
                            ),
                            SizedBox(width: AppSpacing.s3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _FieldLabel('CVV'),
                                  Gap(AppSpacing.s1),
                                  _InputBox(
                                    ctrl: _cvvCtrl,
                                    hint: '123',
                                    obscureText: true,
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(AppSpacing.s4),

                        _FieldLabel('Cardholder Name'),
                        Gap(AppSpacing.s1),
                        _InputBox(ctrl: _nameCtrl, hint: 'John Doe'),
                        Gap(AppSpacing.s6),

                        // Order Summary
                        Container(
                          padding: EdgeInsets.all(AppSpacing.s4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(AppRadius.r2),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Order Summary',
                                style: AppTextStyles.mdSemibold(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Gap(AppSpacing.s3),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${widget.selectedPlanName} Plan (Monthly)',
                                    style: AppTextStyles.smRegular(
                                      color: AppColors.textSubTitle,
                                    ),
                                  ),
                                  Text(
                                    '\$${widget.monthlyCost}/mo',
                                    style: AppTextStyles.smSemibold(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(AppSpacing.s2),
                              Divider(color: AppColors.borderDefault),
                              Gap(AppSpacing.s2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total today',
                                    style: AppTextStyles.mdSemibold(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '\$0 (Free trial)',
                                    style: AppTextStyles.mdSemibold(
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
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

            _BottomNav(
              onContinue: _onContinue,
              onBack: () => ref.read(navigatorState.notifier).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────
class _PayMethodChip extends StatelessWidget {
  const _PayMethodChip({
    required this.label,
    required this.svgPath,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
    this.isLabel = false,
  });

  final String label;
  final String? svgPath, imagePath;
  final bool isSelected, isLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (isLabel) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s2),
        child: Text(
          label,
          style: AppTextStyles.mdRegular(color: AppColors.textSubTitle),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s3,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.r2),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderDefault,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: imagePath != null
            ? Image.asset(
                imagePath!,
                width: 40.w,
                height: 24.w,
                fit: BoxFit.contain,
              )
            : Text(
                label,
                style: AppTextStyles.mdSemibold(color: AppColors.textPrimary),
              ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTextStyles.mdMedium(color: AppColors.textPrimary));
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.ctrl,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
  });

  final TextEditingController ctrl;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => TextField(
    controller: ctrl,
    obscureText: obscureText,
    keyboardType: keyboardType,
    style: AppTextStyles.mdRegular(color: AppColors.textPrimary),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.mdRegular(color: AppColors.textDisable),
      filled: true,
      fillColor: AppColors.white,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.s3,
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
    ),
  );
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
  const _BottomNav({required this.onContinue, required this.onBack});
  final VoidCallback onContinue, onBack;

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
      child: SizedBox(
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
              Icon(Icons.arrow_forward, size: 16.sp, color: AppColors.white),
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
    );
  }
}
