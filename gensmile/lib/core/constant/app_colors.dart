import 'package:flutter/material.dart';

/// GenSmile design system — Color tokens
/// Sourced from Figma _Mapped variables + Color ramps
///
/// Structure:
///   1. Primitive ramps  (Color/Black, White, Gray, Blue, Green, Orange, Red)
///   2. Semantic tokens  (Bg, Text, Border, Icon, Surface)
///   3. Opacity values
///   4. Legacy aliases   (backward-compat — do not use in new code)

class AppColors {
  AppColors._();

  // ── 1. Primitive ramps ─────────────────────────────────────────────────────

  // Color / Black
  static const Color black900 = Color(0xFF000009);
  static const Color black800 = Color(0xFF00000C);
  static const Color black700 = Color(0xFF00000F);
  static const Color black600 = Color(0xFF000013);
  static const Color black500 = Color(0xFF000015);
  static const Color black400 = Color(0xFF333344);
  static const Color black300 = Color(0xFF545462);
  static const Color black200 = Color(0xFF8A8A93);
  static const Color black100 = Color(0xFFB0B0B6);
  static const Color black50  = Color(0xFFE6E6E8);

  // Color / White
  static const Color whiteFull = Color(0xFFFFFFFF);

  // Color / Gray  (Nutrals/Light in Figma)
  static const Color gray900 = Color(0xFF2B2B30);
  static const Color gray800 = Color(0xFF38383F);
  static const Color gray700 = Color(0xFF484851);
  static const Color gray600 = Color(0xFF5D5D68);
  static const Color gray500 = Color(0xFF666672);
  static const Color gray400 = Color(0xFF85858E);
  static const Color gray300 = Color(0xFF9898A1);
  static const Color gray200 = Color(0xFFB9B9BE);
  static const Color gray100 = Color(0xFFD0D0D3);
  static const Color gray50  = Color(0xFFF0F0F1);

  // Color / Blue  (Primary)
  static const Color blue900 = Color(0xFF00002D);
  static const Color blue800 = Color(0xFF01003A);
  static const Color blue700 = Color(0xFF01004B);
  static const Color blue600 = Color(0xFF010060);
  static const Color blue500 = Color(0xFF0052CC);   // ← brand primary
  static const Color blue400 = Color(0xFF343388);
  static const Color blue300 = Color(0xFF55549B);
  static const Color blue200 = Color(0xFF8A8ABA);
  static const Color blue100 = Color(0xFFB0B0D1);
  static const Color blue50  = Color(0xFFE6E6FF);

  // Color / Green  (Success)
  static const Color green900 = Color(0xFF00402A);
  static const Color green800 = Color(0xFF005438);
  static const Color green700 = Color(0xFF006D48);
  static const Color green600 = Color(0xFF008B5C);
  static const Color green500 = Color(0xFF009965);
  static const Color green400 = Color(0xFF33AD84);
  static const Color green300 = Color(0xFF54BB98);
  static const Color green200 = Color(0xFF8AD0B8);
  static const Color green100 = Color(0xFFB0DFCF);
  static const Color green50  = Color(0xFFF0FFFA);

  // Color / Orange  (Warning)
  static const Color orange900 = Color(0xFF694321);
  static const Color orange800 = Color(0xFF8A582B);
  static const Color orange700 = Color(0xFFB27237);
  static const Color orange600 = Color(0xFFE49247);
  static const Color orange500 = Color(0xFFFAA04E);
  static const Color orange400 = Color(0xFFFBB371);
  static const Color orange300 = Color(0xFFFCBF88);
  static const Color orange200 = Color(0xFFFDD3AE);
  static const Color orange100 = Color(0xFFFDE2C8);
  static const Color orange50  = Color(0xFFFFF7F0);

  // Color / Red  (Error)
  static const Color red900 = Color(0xFF642D28);
  static const Color red800 = Color(0xFF833A34);
  static const Color red700 = Color(0xFFA94B43);
  static const Color red600 = Color(0xFFD96056);
  static const Color red500 = Color(0xFFEE6A5F);
  static const Color red400 = Color(0xFFF1887F);
  static const Color red300 = Color(0xFFF49B94);
  static const Color red200 = Color(0xFFF7BAB5);
  static const Color red100 = Color(0xFFFAD1CD);
  static const Color red50  = Color(0xFFFEF1F0);

  // ── 2. Semantic tokens ─────────────────────────────────────────────────────

  // Color / Bg
  static const Color bgDefault  = whiteFull;         // Color/White/Full
  static const Color bgSurface  = gray50;            // Color/Nutrals/Light/50
  static const Color bgMuted    = gray100;           // Color/Nutrals/Light/100
  static const Color bgBrand    = blue500;           // Color/Primary/500
  static const Color bgSuccess  = green500;          // Color/Success/500
  static const Color bgWarning  = orange500;         // Color/Warning/500
  static const Color bgError    = red500;            // Color/Error/500
  static const Color bgInverse  = black500;          // Color/Black/500

  // Color / Text
  static const Color textPrimary   = black500;       // Color/Nutrals/Dark/500
  static const Color textSecondary = gray500;        // Color/Nutrals/Light/500
  static const Color textDisable   = gray400;        // Color/Nutrals/Light/400
  static const Color textSubTitle  = gray300;        // Color/Nutrals/Light/300
  static const Color textBrand     = blue500;        // Color/Primary/500
  static const Color textInfo      = blue500;        // Color/Primary/500
  static const Color textSuccess   = green500;       // Color/Success/500
  static const Color textWarning   = orange500;      // Color/Warning/500
  static const Color textError     = red500;         // Color/Error/500
  static const Color textInverse   = whiteFull;      // Color/White/Full

  // Color / Border
  static const Color borderDefault   = gray200;      // Color/Nutrals/Light/200
  static const Color borderSubTitle  = gray100;      // Color/Nutrals/Light/100
  static const Color borderActive    = gray400;      // Color/Nutrals/Light/400
  static const Color borderMuted     = gray100;      // Color/Nutrals/Light/100
  static const Color borderStrong    = gray400;      // Color/Nutrals/Light/400
  static const Color borderInverse   = black500;     // Color/Nutrals/Dark/500
  static const Color borderBrand     = blue500;      // Color/Primary/500
  static const Color borderBrandHover = blue600;     // Color/Primary/600
  static const Color borderBrandFocus = blue700;     // Color/Primary/700
  static const Color borderSuccess   = green600;     // Color/Success/600
  static const Color borderWarning   = orange600;    // Color/Warning/600
  static const Color borderError     = red600;       // Color/Error/600

  // Color / Icon
  static const Color iconDefault   = black500;       // Color/Nutrals/Dark/500
  static const Color iconSecondary = gray500;        // Color/Nutrals/Light/500
  static const Color iconDisable   = gray400;        // Color/Nutrals/Light/400
  static const Color iconBrand     = blue500;        // Color/Primary/500
  static const Color iconInfo      = blue500;        // Color/Primary/500
  static const Color iconSuccess   = green500;       // Color/Success/500
  static const Color iconWarning   = orange500;      // Color/Warning/500
  static const Color iconError     = red500;         // Color/Error/500

  // Color / Surface
  static const Color surfaceSecondary = gray50;      // Color/Nutrals/Light/50
  static const Color surfaceMuted     = gray100;     // Color/Nutrals/Light/100
  static const Color surfaceBrand     = blue50;      // Color/Primary/50
  static const Color surfaceSuccess   = green50;     // Color/Success/50
  static const Color surfaceWarning   = orange50;    // Color/Warning/50
  static const Color surfaceError     = red50;       // Color/Error/50
  static const Color surfaceInverse   = black50;     // Color/Nutrals/Dark/50

  // ── 3. Opacity values ──────────────────────────────────────────────────────

  // General
  static const double opacityGhost    = 0.10; // Opacity/10
  static const double opacityMuted    = 0.60; // Opacity/60
  static const double opacitySubtitle = 0.80; // Opacity/80

  // Disabled state
  static const double opacityDisabledBg      = 0.20; // Opacity/20
  static const double opacityDisabledIcon    = 0.30; // Opacity/30
  static const double opacityDisabledContent = 0.40; // Opacity/40

  // Overlay
  static const double opacityOverlayLight   = 0.30; // Opacity/30
  static const double opacityOverlayDefault = 0.50; // Opacity/50
  static const double opacityOverlayStrong  = 0.70; // Opacity/70

  // ── 4. Shorthand aliases (most used in widgets) ────────────────────────────

  /// Brand primary — use everywhere blue brand color is needed
  static const Color primary = blue500;

  /// Page scaffold background
  static const Color background = bgSurface;         // gray50 → #F0F0F1

  /// White surface (cards, modals)
  static const Color surface = whiteFull;

  /// Input/field border
  static const Color inputBorder = borderDefault;    // gray200

  /// Error / danger
  static const Color error  = red500;
  static const Color danger = red500;

  /// Success
  static const Color success = green500;

  /// Warning
  static const Color warning = orange500;

  // ── 5. Legacy aliases (backward-compat — migrate away from these) ──────────

  /// @deprecated → use [textPrimary]
  static const Color textColor = textPrimary;

  /// @deprecated → use [textSecondary]
  static const Color homeTextGrayColor = textSecondary;

  /// @deprecated → use [textSubTitle]
  static const Color grayColor = textSubTitle;

  /// @deprecated → use [textSecondary]
  static const Color gray = textSecondary;

  /// @deprecated → use [primary]
  static const Color secondary = primary;

  /// @deprecated → use [primary]
  static const Color blue = primary;

  /// @deprecated → use [surfaceBrand]
  static const Color lightBlue = surfaceBrand;

  /// @deprecated → use [textInfo]
  static const Color info = textInfo;

  /// @deprecated → use [blue200]
  static const Color purple = blue200;

  /// @deprecated → use [bgDefault]
  static const Color white = whiteFull;
}
