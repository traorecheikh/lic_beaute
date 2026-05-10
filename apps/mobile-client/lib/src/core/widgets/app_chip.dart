import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import 'app_pressable.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    this.selected = false,
    this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        selected ? AppColors.primary : AppColors.surfaceVariant;
    final textColor =
        selected ? AppColors.onPrimary : AppColors.onSurfaceVariant;

    return AppPressable(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMd.copyWith(color: textColor),
        ),
      ),
    );
  }
}
