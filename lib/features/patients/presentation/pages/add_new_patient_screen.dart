// lib/features/patients/presentation/pages/add_new_patient_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/dashboard/presentation/pages/notifications_screen.dart';
import 'package:gen_smile/generated/assets.dart';

class AddNewPatientScreen extends ConsumerStatefulWidget {
  const AddNewPatientScreen({super.key});

  @override
  ConsumerState<AddNewPatientScreen> createState() =>
      _AddNewPatientScreenState();
}

class _AddNewPatientScreenState extends ConsumerState<AddNewPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _dentistCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _complaintCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _gender = 'Male';

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _phoneCtrl,
      _emailCtrl,
      _dobCtrl,
      _dentistCtrl,
      _addressCtrl,
      _cityCtrl,
      _countryCtrl,
      _complaintCtrl,
      _notesCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _showSuccess();
  }

  void _showSuccess() {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
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
                'Patient Created Successfully',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              Gap(8.h),
              Text(
                'The patient has been added to your clinic. '
                'You can now start a new simulation or view the patient profile.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppColors.gray,
                ),
              ),
              Gap(24.h),
              if (isWide)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: BorderSide(color: AppColors.inputBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'View Patient',
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
                          'View Patient Profile',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
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
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          'View Patient Profile',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Gap(8.h),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.primary,
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
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
          // ── Top bar ────────────────────────────────────────────────
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
                    SizedBox(width: 10.w),
                    // FIX: PNG image for header icon
                    Image.asset(
                      Assets.imagesDoctorFemale,
                      width: 24.w,
                      height: 24.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add New Patient',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            'Create a new patient record',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => ref
                          .read(navigatorState.notifier)
                          .push(const NotificationsScreen()),
                      child: Icon(
                        Icons.notifications_outlined,
                        size: 22.sp,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Scrollable body ────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: isWide ? _DesktopBody(s: this) : _MobileBody(s: this),
              ),
            ),
          ),

          // ── Bottom bar ─────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            child: isWide
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          side: BorderSide(color: AppColors.inputBorder),
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
                      ElevatedButton(
                        onPressed: _submit,
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
                        child: Text(
                          'Create Patient',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: Text(
                            'Create Patient',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Gap(8.h),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppColors.primary,
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

// ─── Desktop form ─────────────────────────────────────────────────────────────
class _DesktopBody extends StatelessWidget {
  const _DesktopBody({required this.s});
  final _AddNewPatientScreenState s;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _FormCard(
        title: 'Patient Information',
        actionLabel: 'View All',
        onAction: () {},
        child: Column(
          children: [
            _Two(
              left: _F(
                label: 'Full Name',
                hint: 'Dr. John Doe',
                ctrl: s._nameCtrl,
                req: true,
              ),
              right: _F(
                label: 'Phone Number',
                hint: '+8801911818285',
                ctrl: s._phoneCtrl,
                req: true,
              ),
            ),
            _Two(
              left: _F(
                label: 'Email',
                hint: 'dr@example.com',
                ctrl: s._emailCtrl,
              ),
              right: _DateF(ctrl: s._dobCtrl),
            ),
            _Two(
              left: _Drop(
                value: s._gender,
                onChanged: (v) => s.setState(() => s._gender = v ?? 'Male'),
              ),
              right: _F(
                label: 'Assigned Dentist',
                hint: 'Dr. John Doe',
                ctrl: s._dentistCtrl,
              ),
            ),
          ],
        ),
      ),
      _FormCard(
        title: 'Contact Information',
        child: Column(
          children: [
            _F(label: 'Address', hint: 'Street address', ctrl: s._addressCtrl),
            _Two(
              left: _F(label: 'City', hint: 'City', ctrl: s._cityCtrl),
              right: _F(
                label: 'Country',
                hint: 'Country',
                ctrl: s._countryCtrl,
              ),
            ),
          ],
        ),
      ),
      _FormCard(
        title: 'Clinical Notes',
        child: Column(
          children: [
            _MF(
              label: 'Chief Complaint',
              hint: 'Describe the complaint',
              ctrl: s._complaintCtrl,
            ),
            _MF(
              label: 'Medical Notes',
              hint: 'Any relevant medical history',
              ctrl: s._notesCtrl,
            ),
          ],
        ),
      ),
    ],
  );
}

// ─── Mobile form ──────────────────────────────────────────────────────────────
class _MobileBody extends StatelessWidget {
  const _MobileBody({required this.s});
  final _AddNewPatientScreenState s;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _FormCard(
        title: 'Patient Information',
        actionLabel: 'View All',
        onAction: () {},
        child: Column(
          children: [
            _F(
              label: 'Full Name',
              hint: 'Dr. Smith Johnson',
              ctrl: s._nameCtrl,
              req: true,
            ),
            _F(
              label: 'Assigned Dentist',
              hint: 'Dr. John Doe',
              ctrl: s._dentistCtrl,
            ),
            _F(
              label: 'Email Address',
              hint: 'dr@example.com',
              ctrl: s._emailCtrl,
            ),
            _F(
              label: 'Phone Number',
              hint: '+1 (555) 111-2222',
              ctrl: s._phoneCtrl,
              req: true,
            ),
            _DateF(ctrl: s._dobCtrl),
            _Drop(
              value: s._gender,
              onChanged: (v) => s.setState(() => s._gender = v ?? 'Male'),
            ),
          ],
        ),
      ),
      _FormCard(
        title: 'Professional Details',
        collapsed: true,
        child: Column(
          children: [
            _F(label: 'Address', hint: 'Street address', ctrl: s._addressCtrl),
            _F(label: 'City', hint: 'City', ctrl: s._cityCtrl),
            _F(label: 'Country', hint: 'Country', ctrl: s._countryCtrl),
          ],
        ),
      ),
      _FormCard(
        title: 'Clinical Notes',
        collapsed: true,
        child: Column(
          children: [
            _MF(
              label: 'Chief Complaint',
              hint: 'Describe the complaint',
              ctrl: s._complaintCtrl,
            ),
            _MF(
              label: 'Medical Notes',
              hint: 'Any relevant medical history',
              ctrl: s._notesCtrl,
            ),
          ],
        ),
      ),
    ],
  );
}

// ─── Form card wrapper ────────────────────────────────────────────────────────
class _FormCard extends StatefulWidget {
  const _FormCard({
    required this.title,
    required this.child,
    this.actionLabel,
    this.onAction,
    this.collapsed = false,
  });
  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool collapsed;

  @override
  State<_FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<_FormCard> {
  late bool _collapsed;
  @override
  void initState() {
    super.initState();
    _collapsed = widget.collapsed;
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: isWide
                ? null
                : () => setState(() => _collapsed = !_collapsed),
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  if (widget.actionLabel != null && widget.onAction != null)
                    GestureDetector(
                      onTap: widget.onAction,
                      child: Text(
                        widget.actionLabel!,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (!isWide)
                    Icon(
                      _collapsed
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      size: 20.sp,
                      color: AppColors.gray,
                    ),
                ],
              ),
            ),
          ),
          if (!_collapsed || isWide) ...[
            Divider(height: 1, color: AppColors.inputBorder),
            Padding(padding: EdgeInsets.all(16.w), child: widget.child),
          ],
        ],
      ),
    );
  }
}

// ─── Field helpers ────────────────────────────────────────────────────────────
class _Two extends StatelessWidget {
  const _Two({required this.left, required this.right});
  final Widget left, right;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: left),
      SizedBox(width: 16.w),
      Expanded(child: right),
    ],
  );
}

class _F extends StatelessWidget {
  const _F({
    required this.label,
    required this.hint,
    required this.ctrl,
    this.req = false,
  });
  final String label, hint;
  final TextEditingController ctrl;
  final bool req;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 14.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
            if (req)
              Text(
                ' *',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppColors.error,
                ),
              ),
          ],
        ),
        Gap(4.h),
        TextFormField(
          controller: ctrl,
          style: GoogleFonts.inter(fontSize: 13.sp),
          validator: req
              ? (v) => (v?.isEmpty ?? true) ? 'Required' : null
              : null,
          decoration: _deco(hint),
        ),
      ],
    ),
  );
}

class _DateF extends StatelessWidget {
  const _DateF({required this.ctrl});
  final TextEditingController ctrl;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 14.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
        Gap(4.h),
        TextFormField(
          controller: ctrl,
          readOnly: true,
          style: GoogleFonts.inter(fontSize: 13.sp),
          decoration: _deco('20/02/1996').copyWith(
            suffixIcon: Icon(
              Icons.calendar_today_outlined,
              size: 16.sp,
              color: AppColors.gray,
            ),
          ),
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: DateTime(1996, 2, 20),
              firstDate: DateTime(1940),
              lastDate: DateTime.now(),
            );
            if (d != null) {
              ctrl.text =
                  '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
            }
          },
        ),
      ],
    ),
  );
}

class _Drop extends StatelessWidget {
  const _Drop({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 14.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
        Gap(4.h),
        DropdownButtonFormField<String>(
          value: value,
          style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.textColor),
          decoration: _deco('Select'),
          items: [
            'Male',
            'Female',
            'Other',
          ].map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

class _MF extends StatelessWidget {
  const _MF({required this.label, required this.hint, required this.ctrl});
  final String label, hint;
  final TextEditingController ctrl;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 14.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
        Gap(4.h),
        TextFormField(
          controller: ctrl,
          maxLines: 3,
          style: GoogleFonts.inter(fontSize: 13.sp),
          decoration: _deco(hint),
        ),
      ],
    ),
  );
}

InputDecoration _deco(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: BorderSide(color: AppColors.error),
  ),
);
