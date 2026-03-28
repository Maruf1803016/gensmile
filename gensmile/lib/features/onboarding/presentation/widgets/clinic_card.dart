import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/common/widgets/input_fields.dart';
import 'package:gen_smile/features/onboarding/data/models/clinic_model.dart';

class ClinicCard extends StatefulWidget {
  const ClinicCard({
    super.key,
    required this.clinic,
    required this.onRemove,
    required this.onChanged,
  });

  final ClinicModel clinic;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  @override
  State<ClinicCard> createState() => _ClinicCardState();
}

class _ClinicCardState extends State<ClinicCard> {
  late final TextEditingController nameController;
  late final TextEditingController addressController;
  late final TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.clinic.name);
    addressController = TextEditingController(text: widget.clinic.address);
    phoneController = TextEditingController(text: widget.clinic.phoneNumber);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Primary Clinic',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onRemove,
                  child: Icon(Icons.close, size: 18.w, color: AppColors.gray),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  controller: nameController,
                  label: 'Clinic Name',
                  hint: 'e.g., Smile Dental Clinic',
                ),
                Gap(12.h),
                InputField(
                  controller: addressController,
                  label: 'Address',
                  hint: '123 Main Street, City, State',
                ),
                Gap(12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InputField(
                        controller: phoneController,
                        label: 'Phone Number',
                        hint: '+880 1234-567890',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: InputFilePicker(
                        label: 'Clinic Logo',
                        hint: 'Choose File',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
