import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

import '../../../core/widgets/app_icon.dart';

class EmptySearchState extends StatelessWidget {
  const EmptySearchState({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon(icon, size: 40, color: Theme.of(context).colorScheme.outline),
        gapH16,
        Text(title, style: AppTextStyles.headlineSm),
        gapH8,
        Text(
          subtitle,
          style: AppTextStyles.bodyMd.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
