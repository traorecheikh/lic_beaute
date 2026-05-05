import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

/// Sticky bottom action bar with a surface background and an upward drop shadow.
///
/// Replaces the recurring Container + BoxDecoration + SafeArea pattern used in
/// booking_detail_page, review_new_page, and salon_detail_page.
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    required this.child,
    this.backgroundColor,
    this.padding,
    this.topRadius,
    super.key,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? topRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: topRadius != null
            ? BorderRadius.vertical(top: Radius.circular(topRadius!))
            : null,
        boxShadow: AppShadows.nav,
      ),
      padding: padding ?? EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: SafeArea(top: false, child: child),
    );
  }
}
