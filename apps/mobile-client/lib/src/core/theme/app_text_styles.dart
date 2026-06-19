import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

abstract final class AppTextStyles {
  // ── Display — Inter (hero moments, salon names) ──────────────────────────
  static TextStyle get displayLg => GoogleFonts.inter(
    fontSize: 56.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.05,
    letterSpacing: -0.5,
  );
  static TextStyle get displayMd => GoogleFonts.inter(
    fontSize: 40.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.1,
    letterSpacing: -0.3,
  );
  static TextStyle get displaySm => GoogleFonts.inter(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.15,
  );

  // ── Headline — Inter (section titles, modal headers, card titles) ────────
  static TextStyle get headlineLg => GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
    height: 1.25,
    letterSpacing: -0.3,
  );
  static TextStyle get headlineMd => GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
    height: 1.3,
    letterSpacing: -0.2,
  );
  static TextStyle get headlineSm => GoogleFonts.inter(
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.35,
  );

  // ── Body — Inter ─────────────────────────────────────────────────────────
  static TextStyle get bodyLg => GoogleFonts.inter(
    fontSize: 17.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    height: 1.55,
  );
  static TextStyle get bodyMd => GoogleFonts.inter(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    height: 1.5,
    letterSpacing: 0.15,
  );
  static TextStyle get bodySm => GoogleFonts.inter(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
    height: 1.45,
  );
  static TextStyle get bodyXs => GoogleFonts.inter(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
    height: 1.4,
    letterSpacing: 0.2,
  );

  // ── Label — Inter (buttons, badges, nav labels) ──────────────────────────
  static TextStyle get labelLg => GoogleFonts.inter(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.2,
    letterSpacing: 0.1,
  );
  static TextStyle get labelMd => GoogleFonts.inter(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.2,
    letterSpacing: 0.1,
  );
  static TextStyle get labelSm => GoogleFonts.inter(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.2,
    letterSpacing: 0.3,
  );

  // ── Price — Inter tabular (amounts, durations) ───────────────────────────
  static TextStyle get priceLg => GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
    height: 1.2,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
  static TextStyle get priceMd => GoogleFonts.inter(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.2,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  // ── Overline — Inter caps (section category labels) ─────────────────────
  static TextStyle get overline => GoogleFonts.inter(
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurfaceVariant,
    height: 1.2,
    letterSpacing: 1.2,
  );
}
