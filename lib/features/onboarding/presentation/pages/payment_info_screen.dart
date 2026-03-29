// lib/features/onboarding/presentation/pages/payment_info_screen.dart
// FIX #1: Image.asset(Assets.imagesCreditCardPos) for header
//          Image.asset(Assets.imagesVisa/Visa1/Visa2) for payment logos
// FIX #3: Card wraps form on BOTH mobile and desktop

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/common/widgets/gen_smile_logo.dart';
import 'package:gen_smile/common/widgets/input_fields.dart';
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
    this.selectedPlanName = 'Growth',
    this.monthlyCost = 249,
  });
  final String selectedPlanName;
  final int monthlyCost;
  @override
  ConsumerState<PaymentInfoScreen> createState() => _PaymentInfoScreenState();
}

class _PaymentInfoScreenState extends ConsumerState<PaymentInfoScreen> {
  final _cardNumCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _holderCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _holderCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
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
                    const GenSmileLogo(iconSize: 32),
                    SizedBox(width: AppSpacing.s3),
                    Text(
                      'Account Setup',
                      style: AppTextStyles.h5Bold(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              _StepBar(current: 3),
            ] else
              OnbMobileTopBar(currentStep: 3, totalSteps: 5),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isWide ? AppSpacing.s6 : AppSpacing.s4),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      // FIX #3: Card on BOTH mobile + desktop
                      child: Container(
                        padding: EdgeInsets.all(AppSpacing.s6),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.r3),
                          border: Border.all(color: AppColors.borderDefault),
                        ),
                        child: Column(
                          children: [
                            // FIX #1: PNG credit card image
                            SvgPicture.asset(
                              Assets.iconsCreditCardPos,
                              width: 64.w,
                              height: 64.w,
                              fit: BoxFit.contain,
                              colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                            ),
                            Gap(AppSpacing.s3),
                            Text(
                              'Payment Information',
                              style: AppTextStyles.h5Bold(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Gap(AppSpacing.s1),
                            Text(
                              'Secure payment processing',
                              style: AppTextStyles.mdRegular(
                                color: AppColors.textSubTitle,
                              ),
                            ),
                            Gap(AppSpacing.s6),

                            isWide
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: _PaymentForm(
                                          cardNumCtrl: _cardNumCtrl,
                                          expiryCtrl: _expiryCtrl,
                                          cvvCtrl: _cvvCtrl,
                                          holderCtrl: _holderCtrl,
                                        ),
                                      ),
                                      SizedBox(width: AppSpacing.s6),
                                      SizedBox(
                                        width: 260.w,
                                        child: _OrderSummary(
                                          planName: widget.selectedPlanName,
                                          monthlyCost: widget.monthlyCost,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      _PaymentForm(
                                        cardNumCtrl: _cardNumCtrl,
                                        expiryCtrl: _expiryCtrl,
                                        cvvCtrl: _cvvCtrl,
                                        holderCtrl: _holderCtrl,
                                      ),
                                      Gap(AppSpacing.s6),
                                      _OrderSummary(
                                        planName: widget.selectedPlanName,
                                        monthlyCost: widget.monthlyCost,
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

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

// ── Payment form ──────────────────────────────────────────────────────────────
class _PaymentForm extends StatelessWidget {
  const _PaymentForm({
    required this.cardNumCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
    required this.holderCtrl,
  });
  final TextEditingController cardNumCtrl, expiryCtrl, cvvCtrl, holderCtrl;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'How would you like to pay?',
        style: AppTextStyles.mdMedium(color: AppColors.textPrimary),
      ),
      Gap(AppSpacing.s3),
      // FIX #1: PNG Visa logos
      Row(
        children: [
          _VisaLogo(Assets.imagesVisa),
          SizedBox(width: AppSpacing.s2),
          _VisaLogo(Assets.imagesVisa1),
          SizedBox(width: AppSpacing.s2),
          _VisaLogo(Assets.imagesVisa2),
        ],
      ),
      Gap(AppSpacing.s3),
      Center(
        child: Text(
          'Or',
          style: AppTextStyles.smRegular(color: AppColors.textSubTitle),
        ),
      ),
      Gap(AppSpacing.s3),
      InputField(
        controller: cardNumCtrl,
        label: 'Card Number',
        hint: '1234 5678 9012 3456',
        validator: 'required',
      ),
      Gap(AppSpacing.s3),
      Row(
        children: [
          Expanded(
            child: InputField(
              controller: expiryCtrl,
              label: 'Expiry Date',
              hint: 'MM/YY',
              validator: 'required',
            ),
          ),
          SizedBox(width: AppSpacing.s3),
          Expanded(
            child: InputField(
              controller: cvvCtrl,
              label: 'CVV',
              hint: '123',
              validator: 'required',
            ),
          ),
        ],
      ),
      Gap(AppSpacing.s3),
      InputField(
        controller: holderCtrl,
        label: 'Cardholder Name',
        hint: 'John Doe',
        validator: 'required',
      ),
    ],
  );
}

class _VisaLogo extends StatelessWidget {
  const _VisaLogo(this.path);
  final String path;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacing.s2,
      vertical: AppSpacing.s1,
    ),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.borderDefault),
      borderRadius: BorderRadius.circular(AppRadius.r1),
    ),
    child: Image.asset(path, height: 24.h, fit: BoxFit.contain),
  );
}

// ── Order summary ─────────────────────────────────────────────────────────────
class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.planName, required this.monthlyCost});
  final String planName;
  final int monthlyCost;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(AppSpacing.s4),
    decoration: BoxDecoration(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(AppRadius.r2),
      border: Border.all(color: AppColors.borderDefault),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: AppTextStyles.lgSemibold(color: AppColors.textPrimary),
        ),
        Gap(AppSpacing.s4),
        _Row('Selected Plan', planName, AppColors.textPrimary),
        Gap(AppSpacing.s2),
        _Row('Monthly Cost', '\$$monthlyCost', AppColors.textPrimary),
        Gap(AppSpacing.s2),
        _Row('Free Trial', '14 days', AppColors.primary),
        Divider(height: AppSpacing.s6, color: AppColors.borderDefault),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Due Today',
              style: AppTextStyles.lgSemibold(color: AppColors.textPrimary),
            ),
            Text(
              '\$0.00',
              style: AppTextStyles.h4Bold(color: AppColors.textPrimary),
            ),
          ],
        ),
        Gap(AppSpacing.s2),
        Text(
          "You'll be charged after 14 days",
          style: AppTextStyles.smRegular(color: AppColors.textSubTitle),
        ),
        Gap(AppSpacing.s4),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.s2,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.r2),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 14.sp,
                color: AppColors.textSubTitle,
              ),
              SizedBox(width: AppSpacing.s2),
              Flexible(
                child: Text(
                  'Secured with 256-bit SSL encryption',
                  style: AppTextStyles.smRegular(color: AppColors.textSubTitle),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, this.valueColor);
  final String label, value;
  final Color valueColor;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: AppTextStyles.mdRegular(color: AppColors.textSubTitle),
      ),
      Text(value, style: AppTextStyles.mdSemibold(color: valueColor)),
    ],
  );
}

// ── Step bar ──────────────────────────────────────────────────────────────────
class _StepBar extends StatelessWidget {
  const _StepBar({required this.current});
  final int current;
  static const _steps = [
    'Create Account',
    'Choose Plan',
    'Payment Info',
    'Clinic Details',
    'Complete',
  ];
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacing.s6,
      vertical: AppSpacing.s3,
    ),
    child: Row(
      children: List.generate(_steps.length, (i) {
        final done = i < current - 1, cur = i == current - 1;
        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: done || cur
                          ? AppColors.primary
                          : AppColors.borderDefault,
                      shape: BoxShape.circle,
                    ),
                    child: done
                        ? Icon(Icons.check, color: AppColors.white, size: 14.sp)
                        : Center(
                            child: Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: cur
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
                      color: cur ? AppColors.primary : AppColors.textSubTitle,
                    ),
                  ),
                ],
              ),
              if (i < _steps.length - 1)
                Expanded(
                  child: Container(
                    height: 1.5,
                    margin: EdgeInsets.only(bottom: 20.h),
                    color: done ? AppColors.primary : AppColors.borderDefault,
                  ),
                ),
            ],
          ),
        );
      }),
    ),
  );
}

// ── Bottom nav ────────────────────────────────────────────────────────────────
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
    if (isWide) {
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
            ElevatedButton(
              onPressed: onContinue,
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
              child: Row(
                children: [
                  Text(
                    'Continue',
                    style: AppTextStyles.lgSemibold(color: AppColors.white),
                  ),
                  SizedBox(width: AppSpacing.s2),
                  Icon(
                    Icons.arrow_forward,
                    size: 16.sp,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s4,
        0,
        AppSpacing.s4,
        AppSpacing.s6,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: AppTextStyles.lgSemibold(color: AppColors.white),
                  ),
                  SizedBox(width: AppSpacing.s2),
                  Icon(
                    Icons.arrow_forward,
                    size: 16.sp,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
          Gap(AppSpacing.s3),
          TextButton.icon(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back,
              size: 14.sp,
              color: AppColors.textSubTitle,
            ),
            label: Text(
              'Back',
              style: AppTextStyles.mdRegular(color: AppColors.textSubTitle),
            ),
          ),
        ],
      ),
    );
  }
}
