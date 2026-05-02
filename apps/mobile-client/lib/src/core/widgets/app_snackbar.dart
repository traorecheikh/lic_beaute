import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_haptics.dart';

abstract final class AppSnackbar {
  /// Green success toast
  static void success(BuildContext context, String message) {
    AppHaptics.medium();
    _show(
      context,
      message,
      AppColors.success,
      Icons.check_circle_outline_rounded,
    );
  }

  /// Red error toast
  static void error(BuildContext context, String message) {
    AppHaptics.heavy();
    _show(context, message, AppColors.error, Icons.error_outline_rounded);
  }

  /// Neutral info toast
  static void info(BuildContext context, String message) {
    AppHaptics.light();
    _show(
      context,
      message,
      AppColors.onSurfaceVariant,
      Icons.info_outline_rounded,
    );
  }

  /// Destructive confirmation bottom sheet — returns true if confirmed
  static Future<bool> confirmDestructive(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
  }) async {
    AppHaptics.heavy();
    final result = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.headlineMd),
              SizedBox(height: 8.h),
              Text(
                body,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    AppHaptics.heavy();
                    Navigator.of(ctx).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(confirmLabel),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Annuler'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        backgroundColor: AppColors.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(icon, color: color, size: 20.r),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
