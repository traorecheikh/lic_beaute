import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';

const kFunnelStepTitles = [
  'Service',
  'Employé(e)',
  'Créneau',
  'Confirmation',
];

class FunnelHandle extends StatelessWidget {
  const FunnelHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 4.h,
      margin: EdgeInsets.only(top: 10.h, bottom: 4.h),
      decoration: BoxDecoration(
        color: AppColors.outline,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}

class FunnelHeader extends StatelessWidget {
  const FunnelHeader({required this.step, required this.onBack, super.key});

  final int step;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar — edge-to-edge
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 0),
          child: Row(
            children: List.generate(
              4,
              (i) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  height: 3.h,
                  margin: EdgeInsets.only(right: i < 3 ? 4.w : 0),
                  decoration: BoxDecoration(
                    color: i <= step
                        ? AppColors.primary
                        : AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Back button + title row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppPressable(
              onTap: onBack,
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: AppIcon(
                  step == 0 ? 'close' : 'arrow-left',
                  size: 20,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            Expanded(
              child: Text(
                kFunnelStepTitles[step],
                style: AppTextStyles.headlineLg,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FunnelCta extends StatelessWidget {
  const FunnelCta({
    required this.label,
    required this.enabled,
    required this.loading,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutral,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: SafeArea(
        top: false,
        child: AppButton.primary(
          onPressed: enabled ? onTap : null,
          isLoading: loading,
          label: label,
        ),
      ),
    );
  }
}
