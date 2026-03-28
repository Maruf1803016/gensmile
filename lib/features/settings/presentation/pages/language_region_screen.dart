// lib/features/settings/presentation/pages/language_region_screen.dart
// FIX: forceExpanded: true so mobile always shows "Language & Region" content
//      (previously was collapsed and header showed "Notification Preferences" bleed)

import 'package:flutter/material.dart';
import 'package:gen_smile/features/settings/presentation/widgets/settings_widgets.dart';

class LanguageRegionScreen extends StatelessWidget {
  const LanguageRegionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Language & Region',
      initiallyExpanded: true,
      forceExpanded: true,          // ← always show content on mobile
      children: [
        SettingsField(label: 'Default Language', value: '---'),
        SettingsField(label: 'Time Zone', value: '---'),
        SettingsField(label: 'Date Format', value: '---'),
      ],
    );
  }
}
