import 'package:flutter/material.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

abstract final class AppPadding {
  // All sides
  static const allXs = EdgeInsets.all(AppSpacing.xs);
  static const allSm = EdgeInsets.all(AppSpacing.sm);
  static const allMd = EdgeInsets.all(AppSpacing.md);
  static const allLg = EdgeInsets.all(AppSpacing.lg);
  static const allXl = EdgeInsets.all(AppSpacing.xl);

  // Horizontal
  static const horizontalXs = EdgeInsets.symmetric(horizontal: AppSpacing.xs);
  static const horizontalSm = EdgeInsets.symmetric(horizontal: AppSpacing.sm);
  static const horizontalMd = EdgeInsets.symmetric(horizontal: AppSpacing.md);
  static const horizontalLg = EdgeInsets.symmetric(horizontal: AppSpacing.lg);
  static const horizontalXl = EdgeInsets.symmetric(horizontal: AppSpacing.xl);

  // Vertical
  static const verticalXs = EdgeInsets.symmetric(vertical: AppSpacing.xs);
  static const verticalSm = EdgeInsets.symmetric(vertical: AppSpacing.sm);
  static const verticalMd = EdgeInsets.symmetric(vertical: AppSpacing.md);
  static const verticalLg = EdgeInsets.symmetric(vertical: AppSpacing.lg);
  static const verticalXl = EdgeInsets.symmetric(vertical: AppSpacing.xl);

  // Common combinations
  static const screen = EdgeInsets.all(AppSpacing.md);
  static const screenHorizontal = EdgeInsets.symmetric(horizontal: AppSpacing.md);
}
