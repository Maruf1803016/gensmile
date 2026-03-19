import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/common/widgets/buttons.dart';
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
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardholderController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardholderController.dispose();
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
            // ── Header ──────────────────────────────────────────────────────
            if (isWide)
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
              )
            else
              OnbMobileTopBar(currentStep: 3, totalSteps: 5),

            // ── Body ─────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isWide ? AppSpacing.s6 : AppSpacing.s4),
                child: Form(
                  key: _formKey,
                  child: isWide
                      ? _DesktopLayout(
                          cardNumberController: _cardNumberController,
                          expiryController: _expiryController,
                          cvvController: _cvvController,
                          cardholderController: _cardholderController,
                          planName: widget.selectedPlanName,
                          monthlyCost: widget.monthlyCost,
                        )
                      : _MobileLayout(
                          cardNumberController: _cardNumberController,
                          expiryController: _expiryController,
                          cvvController: _cvvController,
                          cardholderController: _cardholderController,
                          planName: widget.selectedPlanName,
                          monthlyCost: widget.monthlyCost,
                        ),
                ),
              ),
            ),

            // ── Bottom nav ────────────────────────────────────────────────────
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

// ── Desktop layout ────────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
    required this.cardholderController,
    required this.planName,
    required this.monthlyCost,
  });

  final TextEditingController cardNumberController,
      expiryController,
      cvvController,
      cardholderController;
  final String planName;
  final int monthlyCost;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 760),
        padding: EdgeInsets.all(AppSpacing.s6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.r3),
        ),
        child: Column(
          children: [
            // Icon + title
            Image.asset(Assets.imagesCreditCardPos, width: 56.w, height: 56.w),
            Gap(AppSpacing.s3),
            Text(
              'Payment Information',
              style: AppTextStyles.h5Bold(color: AppColors.textPrimary),
            ),
            Gap(AppSpacing.s1),
            Text(
              'Secure payment processing',
              style: AppTextStyles.mdRegular(color: AppColors.textSubTitle),
            ),
            Gap(AppSpacing.s6),

            // Two column: form + order summary
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _PaymentForm(
                    cardNumberController: cardNumberController,
                    expiryController: expiryController,
                    cvvController: cvvController,
                    cardholderController: cardholderController,
                  ),
                ),
                SizedBox(width: AppSpacing.s6),
                SizedBox(
                  width: 260.w,
                  child: _OrderSummary(
                    planName: planName,
                    monthlyCost: monthlyCost,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mobile layout ─────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
    required this.cardholderController,
    required this.planName,
    required this.monthlyCost,
  });

  final TextEditingController cardNumberController,
      expiryController,
      cvvController,
      cardholderController;
  final String planName;
  final int monthlyCost;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon + title
        Image.asset(Assets.imagesCreditCardPos, width: 56.w, height: 56.w),
        Gap(AppSpacing.s3),
        Text(
          'Payment Information',
          style: AppTextStyles.h5Bold(color: AppColors.textPrimary),
        ),
        Gap(AppSpacing.s1),
        Text(
          'Secure payment processing',
          style: AppTextStyles.mdRegular(color: AppColors.textSubTitle),
        ),
        Gap(AppSpacing.s6),

        _PaymentForm(
          cardNumberController: cardNumberController,
          expiryController: expiryController,
          cvvController: cvvController,
          cardholderController: cardholderController,
        ),
        Gap(AppSpacing.s6),

        _OrderSummary(planName: planName, monthlyCost: monthlyCost),
      ],
    );
  }
}

// ── Payment form ──────────────────────────────────────────────────────────────

class _PaymentForm extends StatelessWidget {
  const _PaymentForm({
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
    required this.cardholderController,
  });

  final TextEditingController cardNumberController,
      expiryController,
      cvvController,
      cardholderController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How would you like to pay?',
          style: AppTextStyles.mdMedium(color: AppColors.textPrimary),
        ),
        Gap(AppSpacing.s3),

        // Payment method logos
        Row(
          children: [
            _PaymentLogo(Assets.imagesVisa),
            SizedBox(width: AppSpacing.s2),
            _PaymentLogo(Assets.imagesVisa1),
            SizedBox(width: AppSpacing.s2),
            _PaymentLogo(Assets.imagesVisa2),
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

        // Card number
        InputField(
          controller: cardNumberController,
          label: 'Card Number',
          hint: '1234 5678 9012 3456',
          validator: 'required',
        ),
        Gap(AppSpacing.s3),

        // Expiry + CVV
        Row(
          children: [
            Expanded(
              child: InputField(
                controller: expiryController,
                label: 'Expiry Date',
                hint: 'MM/YY',
                validator: 'required',
              ),
            ),
            SizedBox(width: AppSpacing.s3),
            Expanded(
              child: InputField(
                controller: cvvController,
                label: 'CVV',
                hint: '123',
                validator: 'required',
              ),
            ),
          ],
        ),
        Gap(AppSpacing.s3),

        // Cardholder name
        InputField(
          controller: cardholderController,
          label: 'Cardholder Name',
          hint: 'John Doe',
          validator: 'required',
        ),
      ],
    );
  }
}

// ── Order summary ─────────────────────────────────────────────────────────────

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.planName, required this.monthlyCost});

  final String planName;
  final int monthlyCost;

  @override
  Widget build(BuildContext context) {
    return Container(
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

          _SummaryRow(
            label: 'Selected Plan',
            value: planName,
            valueColor: AppColors.textPrimary,
          ),
          Gap(AppSpacing.s2),
          _SummaryRow(
            label: 'Monthly Cost',
            value: '\$$monthlyCost',
            valueColor: AppColors.textPrimary,
          ),
          Gap(AppSpacing.s2),
          _SummaryRow(
            label: 'Free Trial',
            value: '14 days',
            valueColor: AppColors.primary,
          ),

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

          // SSL badge
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
                    style: AppTextStyles.smRegular(
                      color: AppColors.textSubTitle,
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label, value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
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
}

class _PaymentLogo extends StatelessWidget {
  const _PaymentLogo(this.assetPath);
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s2,
        vertical: AppSpacing.s1,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.borderDefault),
        borderRadius: BorderRadius.circular(AppRadius.r1),
      ),
      child: Image.asset(assetPath, height: 24.h, fit: BoxFit.contain),
    );
  }
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
                  Icon(
                    Icons.arrow_forward,
                    size: 16.sp,
                    color: AppColors.white,
                  ),
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
                    size: 16.sp,
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
