import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_text_styles.dart';

class FunnelStepTitle extends StatelessWidget {
  const FunnelStepTitle({
    required this.step,
    required this.total,
    required this.title,
    this.separator = '/',
    super.key,
  });

  final int step;
  final int total;
  final String title;
  final String separator;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Étape $step $separator $total',
          style: AppTextStyles.labelSm.copyWith(color: colorScheme.primary),
        ),
        Text(title, style: AppTextStyles.headlineMd),
      ],
    );
  }
}

class FunnelSectionHeader extends StatelessWidget {
  const FunnelSectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        title,
        style: AppTextStyles.labelLg.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
