import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_theme.dart';
import 'app_button.dart';
import 'app_icon.dart';
import 'app_icon_box.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.actionLabel,
    this.compact = false,
    super.key,
  });

  final String icon;
  final String title;
  final String? subtitle;
  final VoidCallback? action;
  final String? actionLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 32.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconBox(
            size: compact ? 44.r : 64.r,
            color: AppColors.primaryContainer.withValues(alpha: 0.5),
            circle: true,
            child: AppIcon(icon, size: compact ? 20 : 28, color: AppColors.primary),
          ),
          SizedBox(height: compact ? 10.h : 16.h),
          Text(
            title,
            style: AppTextStyles.headlineSm,
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            SizedBox(height: 6.h),
            Text(
              subtitle!,
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null && actionLabel != null) ...[
            SizedBox(height: 20.h),
            SizedBox(
              width: compact ? double.infinity : 240.w,
              child: AppButton.primary(label: actionLabel!, onPressed: action!),
            ),
          ],
        ],
      ),
    );
  }
}
