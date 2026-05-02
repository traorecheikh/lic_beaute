import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

/// Sticky bottom action bar with a surface background and an upward drop shadow.
///
/// Replaces the recurring Container + BoxDecoration + SafeArea pattern used in
/// booking_detail_page, review_new_page, and salon_detail_page.
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    required this.child,
    this.backgroundColor,
    this.padding,
    super.key,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: padding ?? EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: SafeArea(top: false, child: child),
    );
  }
}
