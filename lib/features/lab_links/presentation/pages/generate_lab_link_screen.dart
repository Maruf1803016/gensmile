import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';

// ── Providers ─────────────────────────────────────────────────────────────────
final selectedLabProvider = StateProvider<String>(
  (ref) => 'Premium Dental Lab',
);
final generatedLinkProvider = StateProvider<String>((ref) => '');
final messageProvider = StateProvider<String>((ref) => '');

const _kLabs = [
  _Lab(name: 'Premium Dental Lab', location: 'New York'),
  _Lab(name: 'SmileTech Solutions', location: 'California'),
  _Lab(name: 'Digital Smile Lab', location: 'Texas'),
];

const _kPackageItems = [
  'Patient case information',
  'Treatment plan details',
  'AI simulation results',
  'Before/After images',
];

class GenerateLabLinkScreen extends ConsumerStatefulWidget {
  const GenerateLabLinkScreen({super.key});

  @override
  ConsumerState<GenerateLabLinkScreen> createState() =>
      _GenerateLabLinkScreenState();
}

class _GenerateLabLinkScreenState extends ConsumerState<GenerateLabLinkScreen> {
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onGenerate() {
    ref.read(generatedLinkProvider.notifier).state =
        'https://gensmile.app/lab/C001/lab1';
  }

  void _onSendLink() {
    final link = ref.read(generatedLinkProvider);
    if (link.isEmpty) return;
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(28.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green check circle
              Container(
                width: 72.w,
                height: 72.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 36.sp),
              ),
              Gap(16.h),
              Text(
                'Lab Link Sent Successfully',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              Gap(8.h),
              Text(
                'The lab link has been generated and sent successfully to the selected lab partner.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppColors.gray,
                ),
              ),
              Gap(24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textColor,
                        side: BorderSide(color: AppColors.inputBorder),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
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
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).pop();
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
                        'Go to Lab Link',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedLab = ref.watch(selectedLabProvider);
    final generatedLink = ref.watch(generatedLinkProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
          // ── Top bar ──
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
                    SizedBox(width: 12.w),
                    Icon(Icons.link, size: 20.sp, color: AppColors.textColor),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Generate Lab Link',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            'Share case information with your partner lab',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Form ──
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
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _FormLeft(
                              selectedLab: selectedLab,
                              emailController: _emailController,
                              messageController: _messageController,
                              generatedLink: generatedLink,
                              onGenerate: _onGenerate,
                              onSend: _onSendLink,
                              onCancel: () => Navigator.of(context).pop(),
                            ),
                          ),
                          SizedBox(width: 24.w),
                          Expanded(flex: 2, child: _PackageIncludesCard()),
                        ],
                      )
                    : Column(
                        children: [
                          _FormLeft(
                            selectedLab: selectedLab,
                            emailController: _emailController,
                            messageController: _messageController,
                            generatedLink: generatedLink,
                            onGenerate: _onGenerate,
                            onSend: _onSendLink,
                            onCancel: () => Navigator.of(context).pop(),
                          ),
                          Gap(16.h),
                          _PackageIncludesCard(),
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

// ── Form Left ─────────────────────────────────────────────────────────────────
class _FormLeft extends ConsumerWidget {
  const _FormLeft({
    required this.selectedLab,
    required this.emailController,
    required this.messageController,
    required this.generatedLink,
    required this.onGenerate,
    required this.onSend,
    required this.onCancel,
  });
  final String selectedLab, generatedLink;
  final TextEditingController emailController, messageController;
  final VoidCallback onGenerate, onSend, onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Choose Partner Lab
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Choose Partner Lab ',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              TextSpan(
                text: '*',
                style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.red),
              ),
            ],
          ),
        ),
        Gap(10.h),

        // Lab options
        ..._kLabs.map((lab) {
          final isSelected = selectedLab == lab.name;
          return GestureDetector(
            onTap: () =>
                ref.read(selectedLabProvider.notifier).state = lab.name,
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.04)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.inputBorder,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lab.name,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          lab.location,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.inputBorder,
                        width: 2,
                      ),
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? Icon(Icons.check, size: 10.sp, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          );
        }),
        Gap(16.h),

        // Lab Email
        Text(
          'Lab Email Address',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        Gap(8.h),
        TextField(
          controller: emailController,
          style: GoogleFonts.inter(fontSize: 13.sp),
          decoration: InputDecoration(
            hintText: 'contact@premiumdental.com',
            hintStyle: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.gray,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        Gap(16.h),

        // Generated Link
        Text(
          'Generated Link',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        Gap(8.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Text(
                  generatedLink.isEmpty
                      ? 'Please press generate lab link ...'
                      : generatedLink,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: generatedLink.isEmpty
                        ? AppColors.gray
                        : AppColors.textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            if (generatedLink.isEmpty)
              ElevatedButton.icon(
                onPressed: onGenerate,
                icon: Icon(Icons.link, size: 14.sp),
                label: Text(
                  'Generate Lab Link',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: generatedLink)),
                icon: Icon(Icons.copy, size: 14.sp),
                label: Text(
                  'Copy',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
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
        Gap(16.h),

        // Message
        Text(
          'Message (Optional)',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        Gap(8.h),
        TextField(
          controller: messageController,
          maxLines: 4,
          style: GoogleFonts.inter(fontSize: 13.sp),
          decoration: InputDecoration(
            hintText: 'Add a personal message to the lab...',
            hintStyle: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.gray,
            ),
            contentPadding: EdgeInsets.all(14.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        Gap(16.h),

        // Case info footer
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Row(
            children: [
              Text(
                'Case: ',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.gray,
                ),
              ),
              Text(
                'C001',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                '  |  Patient: ',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.gray,
                ),
              ),
              Text(
                'Sarah Johnson',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ),
        Gap(16.h),

        // Cancel + Send
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textColor,
                side: BorderSide(color: AppColors.inputBorder),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
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
              onPressed: onSend,
              icon: Icon(Icons.send_outlined, size: 14.sp),
              label: Text(
                'Send Link',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: generatedLink.isEmpty
                    ? AppColors.gray
                    : AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Package Includes Card ─────────────────────────────────────────────────────
class _PackageIncludesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F6FA),
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: AppColors.inputBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This package will include:',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        Gap(10.h),
        ..._kPackageItems.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Icon(Icons.check, size: 14.sp, color: AppColors.success),
                SizedBox(width: 8.w),
                Text(
                  item,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _Lab {
  const _Lab({required this.name, required this.location});
  final String name, location;
}
