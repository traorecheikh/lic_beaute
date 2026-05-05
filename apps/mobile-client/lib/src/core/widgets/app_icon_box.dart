import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

/// A sized container with a colored background, rounded or circular, holding
/// an icon or arbitrary widget child.
///
/// Replaces the recurring:
///   Container(width: N.r, height: N.r,
///     decoration: BoxDecoration(color: C, borderRadius/shape: ...),
///     child: Center(child: Icon(...)))
class AppIconBox extends StatelessWidget {
  const AppIconBox({
    required this.child,
    this.size,
    this.color = AppColors.primaryLight,
    this.circle = false,
    this.radius,
    this.shadow,
    super.key,
  });

  final Widget child;
  final double? size;
  final Color color;
  final bool circle;
  final BorderRadius? radius;
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    final s = size ?? 36.r;
    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        color: color,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : (radius ?? BorderRadius.circular(10.r)),
        boxShadow: shadow,
      ),
      child: Center(child: child),
    );
  }
}
