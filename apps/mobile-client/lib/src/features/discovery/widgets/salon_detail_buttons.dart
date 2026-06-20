import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';

class SalonCircleBtn extends StatelessWidget {
  const SalonCircleBtn({
    required this.icon,
    required this.onTap,
    this.iconColor,
    super.key,
  });

  final String icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.88),
            shape: BoxShape.circle,
            boxShadow: AppShadows.sm,
          ),
          child: Center(
            child: AppIcon(
              icon,
              size: 18,
              color: iconColor ?? AppColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class SalonBottomCta extends StatelessWidget {
  const SalonBottomCta({required this.onBook, this.price, super.key});

  final VoidCallback onBook;
  final String? price;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onBook,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.onSurface,
          borderRadius: BorderRadius.circular(AppRadius.full.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon('calendar', color: AppColors.surface, size: 18),
            SizedBox(width: 8.w),
            Flexible(                child: Text(
                  price != null
                      ? '${AppStrings.bookCta} · $price'
                      : AppStrings.salonDetailCta,
                style: AppTextStyles.labelLg.copyWith(color: AppColors.surface),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


