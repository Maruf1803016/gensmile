import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/core/states/navigator_state.dart';
import 'package:onboarding/common/widgets/input_fields.dart';
import 'package:onboarding/common/widgets/buttons.dart';
import 'package:onboarding/features/onboarding/presentation/widgets/onb_mobile_top_bar.dart';
import 'package:onboarding/features/onboarding/presentation/widgets/onb_mobile_step_header.dart';
import 'package:onboarding/features/onboarding/presentation/pages/clinic_details_screen.dart';

class PaymentInfoScreen extends ConsumerStatefulWidget {
  const PaymentInfoScreen({
    super.key,
    this.selectedPlanName = 'Growth',
    this.monthlyCost = 249,
  });

  final String selectedPlanName;
  final int monthlyCost;

  @override
  ConsumerState<PaymentInfoScreen> createState() =>
      _PaymentInfoScreenState();
}

class _PaymentInfoScreenState extends ConsumerState<PaymentInfoScreen> {
  final _cardNumberController  = TextEditingController();
  final _expiryController      = TextEditingController();
  final _cvvController         = TextEditingController();
  final _cardholderController  = TextEditingController();
  final _formKey               = GlobalKey<FormState>();

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const OnbMobileTopBar(currentStep: 3, totalSteps: 5),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 8.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: OnbMobileStepHeader()),
                      Gap(24.h),

                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.credit_card_outlined,
                                color: AppColors.primary, size: 36.w),
                            Gap(10.h),
                            Text(
                              'Payment Information',
                              style: GoogleFonts.inter(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),
                            Gap(4.h),
                            Text(
                              'Secure payment processing',
                              style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  color: AppColors.gray),
                            ),
                          ],
                        ),
                      ),

                      Gap(24.h),

                      Text(
                        'How would you like to pay?',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                      ),

                      Gap(10.h),

                      Row(
                        children: [
                          _PaymentBadge(
                              label: 'VISA',
                              color: const Color(0xFF1A1F71)),
                          SizedBox(width: 8.w),
                          _PaymentBadge(
                              label: 'MC',
                              color: const Color(0xFFEB001B)),
                          SizedBox(width: 8.w),
                          _PaymentBadge(
                              label: 'PayPal',
                              color: const Color(0xFF003087)),
                        ],
                      ),

                      Gap(10.h),

                      Center(
                        child: Text('Or',
                            style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: AppColors.gray)),
                      ),

                      Gap(14.h),

                      InputField(
                        controller: _cardNumberController,
                        label: 'Card Number *',
                        hint: '1234 5678 9012 3456',
                        validator: 'required',
                      ),

                      Gap(14.h),

                      Row(
                        children: [
                          Expanded(
                            child: InputField(
                              controller: _expiryController,
                              label: 'Expiry Date *',
                              hint: 'MM/YY',
                              validator: 'required',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: InputField(
                              controller: _cvvController,
                              label: 'CVV *',
                              hint: '123',
                              validator: 'required',
                            ),
                          ),
                        ],
                      ),

                      Gap(14.h),

                      InputField(
                        controller: _cardholderController,
                        label: 'Cardholder Name *',
                        hint: 'John Doe',
                        validator: 'required',
                      ),

                      Gap(24.h),

                      _OrderSummary(
                        planName: widget.selectedPlanName,
                        monthlyCost: widget.monthlyCost,
                      ),

                      Gap(24.h),
                    ],
                  ),
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

class _OrderSummary extends StatelessWidget {
  const _OrderSummary(
      {required this.planName, required this.monthlyCost});

  final String planName;
  final int monthlyCost;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary',
              style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor)),
          Gap(14.h),
          _SummaryRow(label: 'Selected Plan', value: planName,
              valueColor: AppColors.textColor),
          Gap(8.h),
          _SummaryRow(label: 'Monthly Cost',
              value: '\$$monthlyCost',
              valueColor: AppColors.textColor),
          Gap(8.h),
          _SummaryRow(label: 'Free Trial', value: '14 days',
              valueColor: AppColors.primary),
          Divider(height: 24.h, color: AppColors.inputBorder),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Due Today',
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor)),
              Text('\$0.00',
                  style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor)),
            ],
          ),
          Gap(6.h),
          Text("You'll be charged after 14 days",
              style: GoogleFonts.inter(
                  fontSize: 11.sp, color: AppColors.gray)),
          Gap(14.h),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline,
                    size: 14.w, color: AppColors.gray),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    'Secured with 256-bit SSL encryption',
                    style: GoogleFonts.inter(
                        fontSize: 11.sp, color: AppColors.gray),
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
  const _SummaryRow(
      {required this.label,
      required this.value,
      required this.valueColor});

  final String label, value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 13.sp, color: AppColors.gray)),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: valueColor)),
      ],
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  const _PaymentBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: color)),
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
