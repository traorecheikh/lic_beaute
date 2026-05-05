import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

abstract final class AppTextStyles {
  // ── Display — Cormorant Garamond (hero moments, salon names) ─────────────
  static TextStyle get displayLg => GoogleFonts.cormorantGaramond(
    fontSize: 56.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.05,
    letterSpacing: -0.5,
  );
  static TextStyle get displayMd => GoogleFonts.cormorantGaramond(
    fontSize: 40.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.1,
    letterSpacing: -0.3,
  );
  static TextStyle get displaySm => GoogleFonts.cormorantGaramond(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.15,
  );

  // ── Headline — DM Sans (section titles, modal headers, card titles) ───────
  static TextStyle get headlineLg => GoogleFonts.dmSans(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
    height: 1.25,
    letterSpacing: -0.3,
  );
  static TextStyle get headlineMd => GoogleFonts.dmSans(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
    height: 1.3,
    letterSpacing: -0.2,
  );
  static TextStyle get headlineSm => GoogleFonts.dmSans(
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.35,
  );

  // ── Body — DM Sans ────────────────────────────────────────────────────────
  static TextStyle get bodyLg => GoogleFonts.dmSans(
    fontSize: 17.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    height: 1.55,
  );
  static TextStyle get bodyMd => GoogleFonts.dmSans(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    height: 1.5,
  );
  static TextStyle get bodySm => GoogleFonts.dmSans(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
    height: 1.45,
  );
  static TextStyle get bodyXs => GoogleFonts.dmSans(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
    height: 1.4,
  );

  // ── Label — DM Sans (buttons, badges, nav labels) ─────────────────────────
  static TextStyle get labelLg => GoogleFonts.dmSans(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.2,
    letterSpacing: 0.1,
  );
  static TextStyle get labelMd => GoogleFonts.dmSans(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.2,
    letterSpacing: 0.1,
  );
  static TextStyle get labelSm => GoogleFonts.dmSans(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.2,
    letterSpacing: 0.3,
  );

  // ── Price — DM Sans tabular (amounts, durations) ──────────────────────────
  static TextStyle get priceLg => GoogleFonts.dmSans(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
    height: 1.2,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
  static TextStyle get priceMd => GoogleFonts.dmSans(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.2,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  // ── Overline — DM Sans caps (section category labels) ────────────────────
  static TextStyle get overline => GoogleFonts.dmSans(
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurfaceVariant,
    height: 1.2,
    letterSpacing: 1.2,
  );
}
