import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

/// White card surface used by benefit cards, booking summary cards, etc.
///
/// [highlighted] true → primary border (e.g. active subscription).
/// [highlighted] false → outlineVariant border.
class ProfileCardShell extends StatelessWidget {
  const ProfileCardShell({
    required this.child,
    this.highlighted = false,
    this.padding,
    super.key,
  });

  final Widget child;
  final bool highlighted;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl.r),
        boxShadow: AppShadows.card,
        border: highlighted
            ? Border.all(color: AppColors.primary, width: 1.5)
            : Border.all(color: AppColors.outlineVariant),
      ),
      child: child,
    );
  }
}
