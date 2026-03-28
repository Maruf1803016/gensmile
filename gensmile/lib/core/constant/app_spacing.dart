import 'package:flutter_screenutil/flutter_screenutil.dart';

/// GenSmile spacing + radius tokens
/// Sourced from Figma _Mapped variables

// ── Spacing ────────────────────────────────────────────────────────────────
// Raw:  1=4px, 2=8px, 3=12px, 4=16px, 5=20px, 6=24px, 8=32px, 10=40px, 12=48px, 16=64px
// Named: xs=s1, sm=s2, md=s3, lg=s4, xl=s5, 2xl=s6, 3xl=s8, 4xl=s10, 5xl=s12, 6xl=s16

class AppSpacing {
  AppSpacing._();

  // Raw scale
  static double get s1  => 4.w;
  static double get s2  => 8.w;
  static double get s3  => 12.w;
  static double get s4  => 16.w;
  static double get s5  => 20.w;
  static double get s6  => 24.w;
  static double get s8  => 32.w;
  static double get s10 => 40.w;
  static double get s12 => 48.w;
  static double get s16 => 64.w;

  // Semantic aliases (from _Mapped Spacing)
  static double get xs  => s1;   //  4px
  static double get sm  => s2;   //  8px
  static double get md  => s3;   // 12px
  static double get lg  => s4;   // 16px
  static double get xl  => s5;   // 20px
  static double get x2l => s6;   // 24px
  static double get x3l => s8;   // 32px
  static double get x4l => s10;  // 40px
  static double get x5l => s12;  // 48px
  static double get x6l => s16;  // 64px
}

// ── Radius ─────────────────────────────────────────────────────────────────
// Raw:  0=0, 1=4px, 2=8px, 3=12px, 4=16px, 5=20px, 6=24px, Round=99999
// Named: none=r0, xs=r1, sm=r2, md=r3, lg=r4, xl=r5, 2xl=r6, round

class AppRadius {
  AppRadius._();

  // Raw scale
  static double get r0    => 0;
  static double get r1    => 4.r;
  static double get r2    => 8.r;
  static double get r3    => 12.r;
  static double get r4    => 16.r;
  static double get r5    => 20.r;
  static double get r6    => 24.r;
  static double get round => 99999.r;

  // Semantic aliases (from _Mapped Radius)
  static double get none  => r0;    // 0
  static double get xs    => r1;    // 4px  — small tags, badges
  static double get sm    => r2;    // 8px  — inputs, small cards
  static double get md    => r3;    // 12px — cards, modals
  static double get lg    => r4;    // 16px — large cards, sheets
  static double get xl    => r5;    // 20px — bottom sheets
  static double get x2l   => r6;    // 24px — large panels
}
