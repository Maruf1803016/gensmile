// lib/features/staff/presentation/pages/send_invite_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import '../../data/models/staff_model.dart';
import 'staff_details_screen.dart';

final _inviteMethodProvider = StateProvider<String>((ref) => 'sms');

class SendInviteScreen extends ConsumerStatefulWidget {
  const SendInviteScreen({super.key, required this.member});

  final StaffMember member;

  @override
  ConsumerState<SendInviteScreen> createState() => _SendInviteScreenState();
}

class _SendInviteScreenState extends ConsumerState<SendInviteScreen> {
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _phoneCtrl = TextEditingController(text: widget.member.phone);
    _emailCtrl = TextEditingController(text: widget.member.email);
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onSend() => _showSuccessDialog();

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
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
                'Invitation Sent Successfully',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              Gap(8.h),
              Text(
                'The staff can now review their invitation link',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray),
              ),
              Gap(24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StaffDetailsScreen(member: widget.member),
                      ),
                    );
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
                    'View Staff Profile',
                    style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Gap(8.h),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // back to staff list
                },
                child: Text(
                  'Back to Staff List',
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
    final method = ref.watch(_inviteMethodProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final previewLink = 'https://gensmile.com/preview/GS-2024-001';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
          // ── Top bar ──────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.arrow_back, size: 22.sp, color: AppColors.textColor),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBrand,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.sentiment_satisfied_outlined,
                      size: 18.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isWide ? 'Send Invite Link to Staff' : 'Send Invitation',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          isWide ? 'Share the invite link' : '',
                          style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.notifications_outlined, size: 20.sp, color: AppColors.gray),
                ],
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────
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
                      isWide ? 'Send Options' : 'Delivery Options',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      'Choose how to send the Invite link',
                      style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
                    ),
                    SizedBox(height: 16.h),

                    // SMS option
                    _DeliveryOption(
                      icon: Icons.sms_outlined,
                      title: 'Send SMS Link',
                      subtitle: 'Staff receives a text message with a secure link to view their Invitation link',
                      isSelected: method == 'sms',
                      onTap: () => ref.read(_inviteMethodProvider.notifier).state = 'sms',
                      child: method == 'sms'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 12.h),
                                Text(
                                  'Staff Phone Number',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                _PhoneField(controller: _phoneCtrl),
                              ],
                            )
                          : null,
                    ),
                    SizedBox(height: 12.h),

                    // Email option
                    _DeliveryOption(
                      icon: Icons.email_outlined,
                      title: 'Send Email Preview',
                      subtitle: 'Staff receives an email with a invitation link',
                      isSelected: method == 'email',
                      onTap: () => ref.read(_inviteMethodProvider.notifier).state = 'email',
                      child: method == 'email'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 12.h),
                                Text(
                                  'Staff Email',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                _PhoneField(controller: _emailCtrl),
                              ],
                            )
                          : null,
                    ),

                    SizedBox(height: 16.h),

                    // Preview link
                    _LinkCard(link: previewLink),

                    SizedBox(height: 24.h),

                    // Cancel + Send
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton.icon(
                          onPressed: _onSend,
                          icon: Icon(Icons.send_outlined, size: 14.sp),
                          label: Text(
                            'Send',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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

// ── Delivery Option ────────────────────────────────────────────────────────────

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
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.inputBorder,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Icon(icon, size: 18.sp, color: AppColors.textColor),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (child != null) child!,
            ],
          ),
        ),
      );
}

// ── Link Card ──────────────────────────────────────────────────────────────────

class _LinkCard extends StatelessWidget {
  const _LinkCard({required this.link});
  final String link;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.link, size: 16.sp, color: AppColors.primary),
                SizedBox(width: 6.w),
                Text(
                  'Preview Link',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Text(
                      link,
                      style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
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
                    child: Icon(Icons.copy_outlined, size: 16.sp, color: AppColors.gray),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              'This secure link expires in 30 days',
              style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
            ),
          ],
        ),
      );
}

// ── Phone/Email field ──────────────────────────────────────────────────────────

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        style: GoogleFonts.inter(fontSize: 13.sp),
        decoration: InputDecoration(
          isDense: true,
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
