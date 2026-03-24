// lib/features/staff/presentation/pages/add_staff_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import '../../data/models/staff_model.dart';
import '../../states/staff_state.dart';
import 'send_invite_screen.dart';

// ── Local state providers ─────────────────────────────────────────────────────

final _addStaffStepProvider = StateProvider<int>((ref) => 1);

final _moduleAccessProvider = StateProvider<Map<String, Set<String>>>((ref) => {
      'dashboard': {'create', 'edit', 'remove', 'view'},
      'patients': {'create', 'edit', 'remove', 'view'},
    });

// ── Screen ────────────────────────────────────────────────────────────────────

class AddStaffScreen extends ConsumerStatefulWidget {
  const AddStaffScreen({super.key});

  @override
  ConsumerState<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends ConsumerState<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _jobTitleCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _jobTitleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = ref.watch(_addStaffStepProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;

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
                    onTap: () {
                      if (step == 1) {
                        Navigator.of(context).pop();
                      } else {
                        ref.read(_addStaffStepProvider.notifier).state = 1;
                      }
                    },
                    child: Icon(Icons.arrow_back, size: 22.sp, color: AppColors.textColor),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBrand,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(Icons.person_add_outlined, size: 18.sp, color: AppColors.primary),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Staff',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        'Invite a new team member to your clinic',
                        style: GoogleFonts.inter(fontSize: 11.sp, color: AppColors.gray),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step indicator
                    _StepIndicator(currentStep: step),
                    SizedBox(height: 24.h),

                    // Step content
                    if (step == 1)
                      _Step1Form(
                        formKey: _formKey,
                        nameCtrl: _nameCtrl,
                        emailCtrl: _emailCtrl,
                        phoneCtrl: _phoneCtrl,
                        jobTitleCtrl: _jobTitleCtrl,
                        isWide: isWide,
                        onContinue: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ref.read(_addStaffStepProvider.notifier).state = 2;
                          }
                        },
                        onBack: () => Navigator.of(context).pop(),
                      )
                    else
                      _Step2Permissions(
                        isWide: isWide,
                        onBack: () => ref.read(_addStaffStepProvider.notifier).state = 1,
                        onConfirm: () => _onConfirm(context),
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

  void _onConfirm(BuildContext context) {
    final modules = ref.read(_moduleAccessProvider);
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newMember = StaffMember(
      id: newId,
      employeeId: 'EMP-2024-0${newId.substring(newId.length - 3)}',
      name: _nameCtrl.text.trim(),
      role: _jobTitleCtrl.text.trim().isEmpty ? 'Staff' : _jobTitleCtrl.text.trim(),
      department: 'Dental Services',
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: '',
      joinedDate: DateTime.now(),
      status: StaffStatus.pending,
      permissions: const StaffPermissions(),
      moduleAccess: ModuleAccess(crudMap: modules),
      recentActivity: [],
    );

    ref.read(staffListProvider.notifier).addStaff(newMember);

    // Reset step
    ref.read(_addStaffStepProvider.notifier).state = 1;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(member: newMember),
    );
  }
}

// ── Step Indicator ─────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepCircle(number: 1, label: 'Basic Information', isActive: currentStep == 1, isDone: currentStep > 1),
        Expanded(
          child: Container(
            height: 2.h,
            color: currentStep > 1 ? AppColors.primary : AppColors.inputBorder,
          ),
        ),
        _StepCircle(number: 2, label: 'Set Permissions', isActive: currentStep == 2, isDone: false),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isDone,
  });

  final int number;
  final String label;
  final bool isActive, isDone;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isActive || isDone) ? AppColors.primary : AppColors.inputBorder,
            ),
            child: Center(
              child: isDone
                  ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                  : Text(
                      '$number',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: (isActive || isDone) ? Colors.white : AppColors.gray,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: (isActive || isDone) ? AppColors.primary : AppColors.gray,
            ),
          ),
        ],
      );
}

// ── Step 1 Form ────────────────────────────────────────────────────────────────

class _Step1Form extends StatelessWidget {
  const _Step1Form({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.jobTitleCtrl,
    required this.isWide,
    required this.onContinue,
    required this.onBack,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl, emailCtrl, phoneCtrl, jobTitleCtrl;
  final bool isWide;
  final VoidCallback onContinue, onBack;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Staff Basic Information',
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          Text(
            "Enter the new team member's details",
            style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
          ),
          SizedBox(height: 20.h),

          // Full Name
          _FieldLabel(label: 'Full Name', required: true),
          SizedBox(height: 6.h),
          _InputField(controller: nameCtrl, hint: 'Dr. John Doe', validator: 'required'),
          SizedBox(height: 16.h),

          // Email + Phone (side by side on desktop)
          if (isWide)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(label: 'Email', required: true),
                      SizedBox(height: 6.h),
                      _InputField(
                        controller: emailCtrl,
                        hint: 'Enter your email here...',
                        validator: 'required|email',
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(label: 'Phone Number', required: false),
                      SizedBox(height: 6.h),
                      _InputField(controller: phoneCtrl, hint: '+1 (555) 000-0000'),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            _FieldLabel(label: 'Email', required: true),
            SizedBox(height: 6.h),
            _InputField(
              controller: emailCtrl,
              hint: 'Enter your email here...',
              validator: 'required|email',
            ),
            SizedBox(height: 16.h),
            _FieldLabel(label: 'Phone Number', required: false),
            SizedBox(height: 6.h),
            _InputField(controller: phoneCtrl, hint: '+1 (555) 111-2222'),
          ],

          SizedBox(height: 16.h),

          // Job Title
          _FieldLabel(label: 'Job Title', required: false),
          SizedBox(height: 6.h),
          _InputField(controller: jobTitleCtrl, hint: 'e.g., Senior Dentist'),

          SizedBox(height: 32.h),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onBack,
                child: Text(
                  'Back',
                  style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.textColor),
                ),
              ),
              SizedBox(width: 12.w),
              ElevatedButton.icon(
                onPressed: onContinue,
                icon: Icon(Icons.arrow_forward, size: 14.sp),
                label: Text(
                  'Continue',
                  style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Step 2 Permissions ─────────────────────────────────────────────────────────

const _kModules = [
  'Dashboard',
  'Patients',
  'Simulation',
  'Results',
  'Lab Links',
  'Billing',
  'Settings',
];

const _kModuleKeys = [
  'dashboard',
  'patients',
  'simulation',
  'results',
  'labLinks',
  'billing',
  'settings',
];

const _kActions = ['create', 'edit', 'remove', 'view'];

class _Step2Permissions extends ConsumerWidget {
  const _Step2Permissions({
    required this.isWide,
    required this.onBack,
    required this.onConfirm,
  });

  final bool isWide;
  final VoidCallback onBack, onConfirm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modules = ref.watch(_moduleAccessProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Module Access',
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        Text(
          'Select which modules this staff member can access',
          style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
        ),
        SizedBox(height: 20.h),

        // Table
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.inputBorder),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              // Header
              _TableHeader(isWide: isWide),
              Divider(height: 1, color: AppColors.inputBorder),
              // Rows
              ...List.generate(_kModules.length, (i) {
                final key = _kModuleKeys[i];
                final granted = modules[key] ?? {};
                return Column(
                  children: [
                    _ModuleRow(
                      index: i + 1,
                      name: _kModules[i],
                      moduleKey: key,
                      granted: granted,
                      isWide: isWide,
                    ),
                    if (i < _kModules.length - 1)
                      Divider(height: 1, color: AppColors.inputBorder),
                  ],
                );
              }),
            ],
          ),
        ),

        SizedBox(height: 24.h),

        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onBack,
              child: Text(
                'Back',
                style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.textColor),
              ),
            ),
            SizedBox(width: 12.w),
            ElevatedButton.icon(
              onPressed: onConfirm,
              icon: Icon(Icons.check, size: 14.sp),
              label: Text(
                'Confirm',
                style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.isWide});
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final actions = isWide ? _kActions : ['edit', 'view'];
    return Container(
      color: AppColors.bgSurface,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 28.w,
            child: Text('SL', style: _headerStyle()),
          ),
          Expanded(child: Text('Menu name', style: _headerStyle())),
          ...actions.map((a) => SizedBox(
                width: 44.w,
                child: Text(
                  a[0].toUpperCase() + a.substring(1),
                  style: _headerStyle(),
                  textAlign: TextAlign.center,
                ),
              )),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.gray,
      );
}

class _ModuleRow extends ConsumerWidget {
  const _ModuleRow({
    required this.index,
    required this.name,
    required this.moduleKey,
    required this.granted,
    required this.isWide,
  });

  final int index;
  final String name, moduleKey;
  final Set<String> granted;
  final bool isWide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = isWide ? _kActions : ['edit', 'view'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 28.w,
            child: Text(
              index.toString().padLeft(2, '0'),
              style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.gray),
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.textColor),
            ),
          ),
          ...actions.map((action) => SizedBox(
                width: 44.w,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      final current = Map<String, Set<String>>.from(
                        ref.read(_moduleAccessProvider),
                      );
                      final set = Set<String>.from(current[moduleKey] ?? {});
                      if (set.contains(action)) {
                        set.remove(action);
                      } else {
                        set.add(action);
                      }
                      current[moduleKey] = set;
                      ref.read(_moduleAccessProvider.notifier).state = current;
                    },
                    child: Container(
                      width: 18.w,
                      height: 18.w,
                      decoration: BoxDecoration(
                        color: granted.contains(action) ? AppColors.primary : Colors.transparent,
                        border: Border.all(
                          color: granted.contains(action) ? AppColors.primary : AppColors.borderDefault,
                        ),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      child: granted.contains(action)
                          ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ── Success Dialog ─────────────────────────────────────────────────────────────

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog({required this.member});
  final StaffMember member;

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
              'Staff Member Added Successfully',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            Gap(8.h),
            Text(
              'The staff member has been added and their permissions have been set successfully.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.gray),
            ),
            Gap(24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // close dialog
                      Navigator.pop(context); // go back to staff list
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: AppColors.inputBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text(
                      'Go to Staff List',
                      style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // close dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SendInviteScreen(member: member),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text(
                      'Invite Send Link',
                      style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
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

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.required});
  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          if (required)
            Text(
              ' *',
              style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.error),
            ),
        ],
      );
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    this.validator = '',
  });

  final TextEditingController controller;
  final String hint, validator;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        style: GoogleFonts.inter(fontSize: 13.sp),
        decoration: InputDecoration(
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
        ),
        validator: validator.isEmpty
            ? null
            : (val) {
                final value = val ?? '';
                final rules = validator.split('|');
                if (rules.contains('required') && value.isEmpty) {
                  return 'This field is required';
                }
                if (rules.contains('email') && value.isNotEmpty) {
                  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$');
                  if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
                }
                return null;
              },
      );
}
