import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// GenSmile typography system — sourced directly from Figma
///
/// Font family : Mulish
/// Font sizes  : micro=10, xs=12, sm=14, base=16, lg=18, xl=20, 2xl=24, 3xl=30, 4xl=36
/// Line heights: micro=14, xs=16, sm=20, base=24, lg=26, xl=28, 2xl=32, 3xl=38, 4xl=44
/// Weights     : light=300, normal=400, medium=500, semibold=600, bold=700
///
/// Heading scale (from text styles panel):
///   h1 56/56 · h2 40/48 · h3 32/40 · h4 28/36 · h5 24/32 · h6 20/28
///
/// Body scale (from text styles panel):
///   lg 16/24 · md 14/20 · sm 12/16 · xs 10/14

class AppTextStyles {
  AppTextStyles._();

  // ── Helper ──────────────────────────────────────────────────────────────────

  static TextStyle _m(
    double size,
    FontWeight weight,
    double lineHeight, {
    Color? color,
  }) =>
      GoogleFonts.mulish(
        fontSize: size.sp,
        fontWeight: weight,
        height: lineHeight / size,
        color: color,
      );

  // ── Body: lg · 16/24 ──────────────────────────────────────────────────────

  static TextStyle lgSemibold({Color? color}) =>
      _m(16, FontWeight.w600, 24, color: color);
  static TextStyle lgMedium({Color? color}) =>
      _m(16, FontWeight.w500, 24, color: color);
  static TextStyle lgRegular({Color? color}) =>
      _m(16, FontWeight.w400, 24, color: color);

  // ── Body: md · 14/20 ──────────────────────────────────────────────────────

  static TextStyle mdSemibold({Color? color}) =>
      _m(14, FontWeight.w600, 20, color: color);
  static TextStyle mdMedium({Color? color}) =>
      _m(14, FontWeight.w500, 20, color: color);
  static TextStyle mdRegular({Color? color}) =>
      _m(14, FontWeight.w400, 20, color: color);

  // ── Body: sm · 12/16 ──────────────────────────────────────────────────────

  static TextStyle smSemibold({Color? color}) =>
      _m(12, FontWeight.w600, 16, color: color);
  static TextStyle smMedium({Color? color}) =>
      _m(12, FontWeight.w500, 16, color: color);
  static TextStyle smRegular({Color? color}) =>
      _m(12, FontWeight.w400, 16, color: color);

  // ── Body: xs · 10/14 ──────────────────────────────────────────────────────

  static TextStyle xsSemibold({Color? color}) =>
      _m(10, FontWeight.w600, 14, color: color);
  static TextStyle xsMedium({Color? color}) =>
      _m(10, FontWeight.w500, 14, color: color);
  static TextStyle xsRegular({Color? color}) =>
      _m(10, FontWeight.w400, 14, color: color);

  // ── Headings: h1 · 56/56 ──────────────────────────────────────────────────

  static TextStyle h1Bold({Color? color}) =>
      _m(56, FontWeight.w700, 56, color: color);
  static TextStyle h1Semibold({Color? color}) =>
      _m(56, FontWeight.w600, 56, color: color);
  static TextStyle h1Medium({Color? color}) =>
      _m(56, FontWeight.w500, 56, color: color);

  // ── Headings: h2 · 40/48 ──────────────────────────────────────────────────

  static TextStyle h2Bold({Color? color}) =>
      _m(40, FontWeight.w700, 48, color: color);
  static TextStyle h2Semibold({Color? color}) =>
      _m(40, FontWeight.w600, 48, color: color);
  static TextStyle h2Medium({Color? color}) =>
      _m(40, FontWeight.w500, 48, color: color);

  // ── Headings: h3 · 32/40 ──────────────────────────────────────────────────

  static TextStyle h3Bold({Color? color}) =>
      _m(32, FontWeight.w700, 40, color: color);
  static TextStyle h3Semibold({Color? color}) =>
      _m(32, FontWeight.w600, 40, color: color);
  static TextStyle h3Medium({Color? color}) =>
      _m(32, FontWeight.w500, 40, color: color);

  // ── Headings: h4 · 28/36 ──────────────────────────────────────────────────

  static TextStyle h4Bold({Color? color}) =>
      _m(28, FontWeight.w700, 36, color: color);
  static TextStyle h4Semibold({Color? color}) =>
      _m(28, FontWeight.w600, 36, color: color);
  static TextStyle h4Medium({Color? color}) =>
      _m(28, FontWeight.w500, 36, color: color);

  // ── Headings: h5 · 24/32 ──────────────────────────────────────────────────

  static TextStyle h5Bold({Color? color}) =>
      _m(24, FontWeight.w700, 32, color: color);
  static TextStyle h5Semibold({Color? color}) =>
      _m(24, FontWeight.w600, 32, color: color);
  static TextStyle h5Medium({Color? color}) =>
      _m(24, FontWeight.w500, 32, color: color);

  // ── Headings: h6 · 20/28 ──────────────────────────────────────────────────

  static TextStyle h6Bold({Color? color}) =>
      _m(20, FontWeight.w700, 28, color: color);
  static TextStyle h6Semibold({Color? color}) =>
      _m(20, FontWeight.w600, 28, color: color);
  static TextStyle h6Medium({Color? color}) =>
      _m(20, FontWeight.w500, 28, color: color);

  // ── Raw token-based (font size tokens directly) ───────────────────────────
  // sizes  : micro=10, xs=12, sm=14, base=16, lg=18, xl=20, 2xl=24, 3xl=30, 4xl=36
  // heights: micro=14, xs=16, sm=20, base=24, lg=26, xl=28, 2xl=32, 3xl=38, 4xl=44

  static TextStyle micro({
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) => _m(10, weight, 14, color: color);

  static TextStyle xs({
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) => _m(12, weight, 16, color: color);

  static TextStyle sm({
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) => _m(14, weight, 20, color: color);

  static TextStyle base({
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) => _m(16, weight, 24, color: color);

  static TextStyle lg({
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) => _m(18, weight, 26, color: color);

  static TextStyle xl({
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) => _m(20, weight, 28, color: color);

  static TextStyle xxl({
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) => _m(24, weight, 32, color: color);

  static TextStyle xxxl({
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) => _m(30, weight, 38, color: color);

  static TextStyle xxxxl({
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) => _m(36, weight, 44, color: color);
}
