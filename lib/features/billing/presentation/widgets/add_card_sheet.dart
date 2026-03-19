import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/common/widgets/input_fields.dart';
import 'package:onboarding/common/widgets/buttons.dart';

class AddCardSheet extends StatefulWidget {
  const AddCardSheet({super.key});

  @override
  State<AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<AddCardSheet> {
  final _cardNumberController   = TextEditingController();
  final _cardholderController   = TextEditingController();
  final _expiryController       = TextEditingController();
  final _cvvController          = TextEditingController();
  final _formKey                = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardholderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ──
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            Gap(20.h),

            // ── Title ──
            Text(
              'Create New Payment',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),

            Gap(4.h),

            Text(
              'Manage your billing payment method\nand invoice preferences.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: AppColors.gray,
              ),
            ),

            Gap(24.h),

            // ── Card Number ──
            InputField(
              controller: _cardNumberController,
              label: 'Card Number *',
              hint: '1234 5678 9012 3456',
              validator: 'required',
            ),

            Gap(16.h),

            // ── Cardholder Name ──
            InputField(
              controller: _cardholderController,
              label: 'Cardholder Name *',
              hint: 'John Doe',
              validator: 'required',
            ),

            Gap(16.h),

            // ── Expiry + CVV side by side ──
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

            Gap(24.h),

            // ── Add Card button ──
            PrimaryButton(
              text: 'Add Card',
              variant: 'primary',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // TODO: save card
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
