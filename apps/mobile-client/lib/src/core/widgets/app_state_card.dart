import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

class AppStateCard extends StatelessWidget {
  const AppStateCard({
    required this.child,
    required this.compact,
    this.expandedPadding = 24.0,
    super.key,
  });

  final Widget child;
  final bool compact;

  /// Vertical padding used when [compact] is false.
  final double expandedPadding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: compact ? double.infinity : 320.w,
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: compact ? 18.h : expandedPadding.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: child,
      ),
    );
  }
}
