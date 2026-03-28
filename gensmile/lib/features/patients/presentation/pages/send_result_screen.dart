import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';

final sendMethodProvider = StateProvider<String>((ref) => 'sms');

class SendResultScreen extends ConsumerStatefulWidget {
  const SendResultScreen({super.key});

  @override
  ConsumerState<SendResultScreen> createState() => _SendResultScreenState();
}

class _SendResultScreenState extends ConsumerState<SendResultScreen> {
  final _phoneCtrl = TextEditingController(text: '(555) 123-4567');
  final _emailCtrl = TextEditingController(text: 'paitent@gamil.com');

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onSendResult() => _showSuccessDialog();

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 32.sp),
              ),
              Gap(16.h),
              Text(
                'Result Sent Successfully',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              Gap(8.h),
              Text(
                'The patient can now review their smile preview and proceed with consultation.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppColors.gray,
                ),
              ),
              Gap(24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'View Result',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Gap(10.h),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  'Back to Patient Case',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final method = ref.watch(sendMethodProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
          // Top bar
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.sentiment_satisfied_outlined,
                      size: 20.sp,
                      color: AppColors.textColor,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Send Result to Patient',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            'Share the simulation preview',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.notifications_outlined,
                      size: 20.sp,
                      color: AppColors.gray,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Options',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      'Choose how to send the simulation result',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.gray,
                      ),
                    ),
                    Gap(16.h),

                    // SMS option
                    _DeliveryOption(
                      icon: Icons.sms_outlined,
                      title: 'Send SMS Link',
                      subtitle:
                          'Patient receives a text message with a secure link to view their simulation',
                      isSelected: method == 'sms',
                      onTap: () =>
                          ref.read(sendMethodProvider.notifier).state = 'sms',
                      child: method == 'sms'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gap(12.h),
                                Text(
                                  'Patient Phone Number',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Gap(6.h),
                                _InputField(
                                  controller: _phoneCtrl,
                                  hint: '(555) 123-4567',
                                ),
                              ],
                            )
                          : null,
                    ),
                    Gap(12.h),

                    // Email option
                    _DeliveryOption(
                      icon: Icons.email_outlined,
                      title: 'Send Email Preview',
                      subtitle:
                          'Patient receives an email with simulation images and a link to the full preview',
                      isSelected: method == 'email',
                      onTap: () =>
                          ref.read(sendMethodProvider.notifier).state = 'email',
                      child: method == 'email'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gap(12.h),
                                Text(
                                  'Patient Email',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Gap(6.h),
                                _InputField(
                                  controller: _emailCtrl,
                                  hint: 'paitent@gamil.com',
                                ),
                              ],
                            )
                          : null,
                    ),
                    Gap(16.h),

                    // Preview Link
                    _LinkCard(
                      icon: Icons.link,
                      title: 'Preview Link',
                      link: 'https://gensmile.com/preview/GS-2024-001',
                      subtitle: 'This secure link expires in 30 days',
                    ),
                    Gap(12.h),

                    // All Simulation Result Send
                    _LinkCard(
                      icon: Icons.link,
                      title: 'All Simulation Result Send',
                      link: 'https://gensmile.com/preview/GS-2024-003',
                      subtitle: 'This secure link expires in 30 days',
                      showSendAll: true,
                    ),
                    Gap(24.h),

                    // Cancel + Send buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.gray,
                            side: BorderSide(color: AppColors.inputBorder),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton.icon(
                          onPressed: _onSendResult,
                          icon: Icon(Icons.send_outlined, size: 14.sp),
                          label: Text(
                            'Send Result',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  const _DeliveryOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.child,
  });
  final IconData icon;
  final String title, subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.inputBorder,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, size: 16.sp, color: AppColors.primary),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.inputBorder,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                    : null,
              ),
            ],
          ),
          if (child != null) child!,
        ],
      ),
    ),
  );
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    required this.icon,
    required this.title,
    required this.link,
    required this.subtitle,
    this.showSendAll = false,
  });
  final IconData icon;
  final String title, link, subtitle;
  final bool showSendAll;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: AppColors.inputBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.sp, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
        Gap(10.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Text(
                  link,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () => Clipboard.setData(ClipboardData(text: link)),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.inputBorder),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.copy_outlined,
                  size: 16.sp,
                  color: AppColors.gray,
                ),
              ),
            ),
            if (showSendAll) ...[
              SizedBox(width: 8.w),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.send_outlined, size: 13.sp),
                label: Text(
                  'Send All Result',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ],
        ),
        Gap(6.h),
        Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
        ),
      ],
    ),
  );
}

class _InputField extends StatelessWidget {
  const _InputField({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    style: GoogleFonts.inter(fontSize: 13.sp),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.r),
        borderSide: BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.r),
        borderSide: BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.r),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    ),
  );
}
