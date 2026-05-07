import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'app_icon.dart';

/// Standard back button for AppBar.leading.
class AppBackButton extends StatelessWidget {
  const AppBackButton({this.onPressed, this.color, super.key});

  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AppIcon(
        'arrow-left',
        size: 20,
        color: color ?? AppColors.onSurface,
      ),
      onPressed: onPressed ?? () => context.pop(),
    );
  }
}
