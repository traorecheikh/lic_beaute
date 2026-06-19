import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_icon.dart';

class LocationBanner extends StatelessWidget {
  const LocationBanner({required this.onDismiss, required this.onEnable, super.key});

  final VoidCallback onDismiss;
  final VoidCallback onEnable;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
      child: GestureDetector(
        onTap: onEnable,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkOutline.withValues(alpha: 0.15)
                  : AppColors.outline.withValues(alpha: 0.12),
              width: 1.2,
            ),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AppIcon('map-pin', size: 20, color: AppColors.primary),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Salons proches de vous',
                      style: AppTextStyles.labelLg.copyWith(
                        color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Affichez la distance sur chaque fiche salon.',
                      style: AppTextStyles.bodySm.copyWith(
                        color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              AppIcon(
                'chevron-right',
                size: 16,
                color: isDark ? AppColors.darkOnSurfaceVariant.withValues(alpha: 0.4) : AppColors.outline,
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: onDismiss,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: AppIcon(
                    'close',
                    size: 14,
                    color: isDark ? AppColors.darkOnSurfaceVariant.withValues(alpha: 0.6) : AppColors.outline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
