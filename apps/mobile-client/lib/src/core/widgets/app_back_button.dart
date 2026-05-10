import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'app_icon.dart';
import 'app_pressable.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({this.onPressed, this.color, super.key});

  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Retour',
      child: AppPressable(
        onTap: onPressed ?? () => context.pop(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: AppIcon(
            'arrow-left',
            size: 20,
            color: color ?? AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
