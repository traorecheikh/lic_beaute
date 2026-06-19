import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../../core/widgets/app_icon.dart';

/// Filter chip used in search results filter bar.
class SearchFilterChip extends StatelessWidget {
  const SearchFilterChip({
    required this.label,
    required this.active,
    this.icon,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool active;
  final String? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          boxShadow: active ? null : AppShadows.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              AppIcon(icon!, size: 13,
                color: active ? AppColors.white : AppColors.onSurface,
              ),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: AppTextStyles.labelSm.copyWith(
                color: active ? AppColors.white : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
