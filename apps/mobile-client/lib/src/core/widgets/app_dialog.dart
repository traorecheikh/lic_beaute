import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import 'app_pressable.dart';

class AppDialogAction {
  const AppDialogAction({
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;
}

abstract final class AppDialog {
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String body,
    required List<AppDialogAction> actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => _AppDialogWidget(
        title: title,
        body: body,
        actions: actions,
      ),
    );
  }
}

class _AppDialogWidget extends StatelessWidget {
  const _AppDialogWidget({
    required this.title,
    required this.body,
    required this.actions,
  });

  final String title;
  final String body;
  final List<AppDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg.r),
          boxShadow: AppShadows.card,
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.headlineSm),
            SizedBox(height: 12.h),
            Text(body, style: AppTextStyles.bodyMd),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions.map((action) {
                final color = action.isDestructive
                    ? AppColors.error
                    : AppColors.primary;
                return AppPressable(
                  onTap: () {
                    Navigator.of(context).pop();
                    action.onPressed();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Text(
                      action.label,
                      style: AppTextStyles.labelMd.copyWith(color: color),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
