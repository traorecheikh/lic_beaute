import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_theme.dart';
import 'app_icon_box.dart';
import 'app_state_card.dart';

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

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? action;
  final String? actionLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AppStateCard(
      compact: compact,
      expandedPadding: 28.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconBox(
            size: 56.r,
            color: AppColors.primaryContainer.withValues(alpha: 0.5),
            circle: true,
            child: Icon(icon, size: 26.r, color: AppColors.primary),
          ),
          SizedBox(height: 14.h),
          Text(
            title,
            style: AppTextStyles.headlineSm,
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            SizedBox(height: 6.h),
            Text(
              subtitle!,
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null && actionLabel != null) ...[
            SizedBox(height: 18.h),
            SizedBox(
              width: compact ? double.infinity : 200.w,
              child: FilledButton(
                onPressed: action,
                style: AppTheme.stateButtonStyle(context),
                child: Text(actionLabel!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
