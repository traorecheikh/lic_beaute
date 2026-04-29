import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppShadows {
  static List<BoxShadow> get card => [
    BoxShadow(
      color: const Color(0xFF1A1614).withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF1A1614).withOpacity(0.03),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get nav => [
    BoxShadow(
      color: const Color(0xFF1A1614).withOpacity(0.10),
      blurRadius: 24,
      offset: const Offset(0, -4),
    ),
    BoxShadow(
      color: const Color(0xFF1A1614).withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, -1),
    ),
  ];

  static List<BoxShadow> get button => [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.28),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get sheet => [
    BoxShadow(
      color: const Color(0xFF1A1614).withOpacity(0.12),
      blurRadius: 40,
      offset: const Offset(0, -8),
    ),
  ];

  static const sm = [
    BoxShadow(color: Color(0x0D1A1614), blurRadius: 8, offset: Offset(0, 2)),
  ];
  static const md = [
    BoxShadow(color: Color(0x141A1614), blurRadius: 16, offset: Offset(0, 4)),
  ];
  static const lg = [
    BoxShadow(color: Color(0x201A1614), blurRadius: 40, offset: Offset(0, 12)),
  ];
  static const panel = [
    BoxShadow(color: Color(0x1A1A1614), blurRadius: 24, offset: Offset(0, 4)),
  ];
}
