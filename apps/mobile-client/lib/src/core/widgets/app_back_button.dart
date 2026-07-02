import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../diagnostics/app_runtime_diagnostics.dart';
import '../platform/ios_version.dart';
import 'app_icon.dart';
import 'app_pressable.dart';
import 'ios_native_icon_button.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({this.onPressed, this.color, super.key});

  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final action = onPressed ?? () => context.pop();
    final useNativeGlass = IOSVersion.supportsNativeGlass &&
        (AppRuntimeDiagnostics.config.enableIOSNativeGlass ||
            AppRuntimeDiagnostics.config.enableIOSNativeIconButtons);

    if (useNativeGlass) {
      return Center(
        child: IOSNativeIconButton(
          iconName: 'chevron-left',
          foregroundColor: color ?? AppColors.onSurface,
          onPressed: action,
          semanticLabel: 'Retour',
          symbolSize: 19,
        ),
      );
    }

    return Semantics(
      button: true,
      label: 'Retour',
      child: AppPressable(
        onTap: action,
        minSize: const Size(44, 44),
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
