import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'app_icon_box.dart';
import 'app_pressable.dart';

class AppTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const AppTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm.r),
        child: Row(
          children: [
            AppIconBox(
              size: 44.r,
              color: AppColors.primaryLight,
              radius: BorderRadius.circular(AppRadius.md.r),
              child: AppIcon(icon, size: 22, color: AppColors.primary),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelLg),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              gapW12,
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
