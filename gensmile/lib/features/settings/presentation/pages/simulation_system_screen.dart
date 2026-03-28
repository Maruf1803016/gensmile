import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/features/settings/presentation/widgets/settings_widgets.dart';

class SimulationSystemScreen extends StatelessWidget {
  const SimulationSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Simulation Preferences ───────────────────────────────────────
        SettingsSection(
          title: 'Simulation Preferences',
          initiallyExpanded: true,
          children: [
            SettingsSubLabel('Default Simulation Type'),
            SettingsRadioGroup(
              options: [
                'Ortho Simulation',
                'Smile Enhancement',
                'Combined Simulation',
              ],
              selected: 'Combined Simulation',
            ),
            Gap(8.h),
            SettingsSubLabel('Default Output Mode'),
            SettingsRadioGroup(
              options: ['Before / After Slider', 'Side-by-Side'],
              selected: 'Before / After Slider',
            ),
            Gap(8.h),
            SettingsSubLabel('AI Simulation Quality'),
            SettingsRadioGroup(
              options: ['Standard', 'High Detail'],
              selected: 'Standard',
            ),
            Gap(8.h),
            SettingsToggleRow(
              label: 'Auto Save Simulation Results',
              subtitle:
                  'Automatically save simulation results to patient record',
              value: true,
            ),
          ],
        ),

        // ── Patient Record Settings ──────────────────────────────────────
        SettingsSection(
          title: 'Patient Record Settings',
          children: [
            SettingsSubLabel('Patient ID Format'),
            SettingsRadioGroup(
              options: ['Combined Simulation', 'Custom Prefix'],
              selected: 'Combined Simulation',
            ),
            Gap(8.h),
            SettingsField(label: 'Default Assigned Dentist', value: '---'),
            SettingsSubLabel('Record Retention'),
            SettingsRadioGroup(
              options: ['1 Month', '3 Months', '5 Months'],
              selected: '3 Months',
            ),
            Gap(8.h),
            SettingsSubLabel('Required Fields'),
            SettingsToggleRow(label: 'Phone Number', value: true),
            SettingsToggleRow(label: 'Email', value: true),
            SettingsToggleRow(label: 'Date of Birth', value: false),
          ],
        ),
      ],
    );
  }
}
