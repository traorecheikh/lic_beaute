import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';

/// A tile widget for selecting a payment method in the payment handoff page.
class MethodTile extends StatelessWidget {
  const MethodTile({
    required this.id,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String id, label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppIcon('smartphone', size: 20, color: AppColors.onSurfaceVariant),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.labelLg),
                  SizedBox(height: 2.h),
                  Text(
                    id.replaceAll('_', ' ').toUpperCase(),
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              AppIcon('check-circle', color: AppColors.primary, size: 22)
            else
              AppIcon('circle', color: AppColors.outline, size: 22),
          ],
        ),
      ),
    );
  }
}
