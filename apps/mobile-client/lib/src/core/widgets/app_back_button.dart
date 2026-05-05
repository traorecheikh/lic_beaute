import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

/// Standard back button for AppBar.leading.
///
/// Replaces the recurring:
///   IconButton(icon: Icon(Icons.arrow_back_ios_new, size: 20.w, color: ...),
///              onPressed: () => context.pop())
class AppBackButton extends StatelessWidget {
  const AppBackButton({this.onPressed, this.color, super.key});

  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new,
        size: 20.w,
        color: color ?? AppColors.onSurface,
      ),
      onPressed: onPressed ?? () => context.pop(),
    );
  }
}
