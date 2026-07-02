import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

/// Sticky bottom action surface that always shrink-wraps its content.
///
/// The explicit [Align.heightFactor] is intentional. A bottom-bar child can
/// otherwise inherit a loose full-screen height from a route transition and
/// briefly turn a normal CTA into a screen-sized capsule.
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: topRadius != null
            ? BorderRadius.vertical(top: Radius.circular(topRadius!))
            : null,
        boxShadow: AppShadows.nav,
      ),
      child: SafeArea(
        top: false,
        minimum: padding ?? EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 1,
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}
