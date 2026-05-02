import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Brand (10%) ───────────────────────────────────────────────────────────
  static const primary = Color(0xFFD96B8C); // Rose Pétale
  static const primaryLight = Color(0xFFFFECF2); // Rose ultra-light for tints
  static const primaryMid = Color(0xFFF2A8BE); // Rose mid for pressed/hover
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFFFD9E6);
  static const onPrimaryContainer = Color(0xFF3B0021);

  static const secondary = Color(0xFFC9A26A); // Or Champagne
  static const onSecondary = Color(0xFF2D1A12);
  static const secondaryContainer = Color(0xFFFCEFD8);
  static const onSecondaryContainer = Color(0xFF291900);

  static const tertiary = Color(0xFF8B4A2E);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFFFFDBC8);
  static const onTertiaryContainer = Color(0xFF3A0E00);

  // ── Neutral surfaces (warm whites — not cold grays) ───────────────────────
  static const neutral = Color(0xFFFAFAF8); // warm off-white page bg
  static const surface = Color(0xFFFFFFFF);
  static const surfaceElevated = Color(0xFFF7F5F2); // cards on warm bg
  static const surfaceVariant = Color(0xFFF0EDE8); // inputs, chips
  static const onSurface = Color(0xFF1A1614); // warm near-black
  static const onSurfaceVariant = Color(0xFF6E6460); // warm mid-gray
  static const outline = Color(0xFFD4CFC8);
  static const outlineVariant = Color(0xFFEBE6E0);

  // ── Dark mode ─────────────────────────────────────────────────────────────
  static const darkBackground = Color(0xFF141210);
  static const darkSurface = Color(0xFF1E1B18);
  static const darkSurfaceVariant = Color(0xFF2A2622);
  static const darkOnSurface = Color(0xFFF2EDE8);
  static const darkOnSurfaceVariant = Color(0xFFA09890);
  static const darkOutline = Color(0xFF3A3530);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF410002);
  static const success = Color(0xFF2E7D5E);
  static const successContainer = Color(0xFFD1F2E4);

  // ── Booking status ────────────────────────────────────────────────────────
  static const statusPendingBg = Color(0xFFFFF8ED);
  static const statusPendingText = Color(0xFF92600A);
  static const statusPendingBorder = Color(0xFFFFD89B);

  static const statusConfirmedBg = Color(0xFFEDF4FF);
  static const statusConfirmedText = Color(0xFF1E40AF);
  static const statusConfirmedBorder = Color(0xFFBFD7FF);

  static const statusCheckedInBg = Color(0xFFEDF9F2);
  static const statusCheckedInText = Color(0xFF065F46);
  static const statusCheckedInBorder = Color(0xFFABDDC4);

  // ── Staff calendar tones ─────────────────────────────────────────────────
  static const List<Color> staffTones = [
    Color(0xFFFFECF2),
    Color(0xFFEDF4FF),
    Color(0xFFEDF9F2),
    Color(0xFFFFFAED),
    Color(0xFFF3EEFF),
    Color(0xFFE8FAFD),
    Color(0xFFFFF0EC),
    Color(0xFFF0EBFF),
  ];

  // ── Gradient helpers ──────────────────────────────────────────────────────
  static const List<Color> heroGradient = [
    Color(0x00000000),
    Color(0x66000000),
    Color(0xCC000000),
  ];
  static const List<Color> splashGradient = [
    Color(0xFF1A1614),
    Color(0xFF2D1520),
  ];
}
