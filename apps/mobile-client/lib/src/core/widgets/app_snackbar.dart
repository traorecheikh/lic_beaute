import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../utils/app_haptics.dart';
import 'app_sheet.dart';
import 'app_sheet_content.dart';

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
    final result = await AppSheet.show<bool>(
      context,
      builder: (ctx) => AppSheetContent(
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        destructive: true,
        onConfirm: () {
          AppHaptics.heavy();
          Navigator.of(ctx).pop(true);
        },
        onCancel: () => Navigator.of(ctx).pop(false),
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
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
