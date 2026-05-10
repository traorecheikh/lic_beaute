import 'package:flutter/widgets.dart';
import '../theme/app_theme.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({this.color, super.key});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: color ?? AppColors.outlineVariant);
  }
}
