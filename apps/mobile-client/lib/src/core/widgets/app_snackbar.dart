import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../utils/app_haptics.dart';
import 'app_icon.dart';
import 'app_sheet.dart';
import 'app_sheet_content.dart';

abstract final class AppSnackbar {
  /// Green success toast
  static void success(BuildContext context, String message) {
    AppHaptics.medium();
    _showCustom(
      context,
      title: 'Succès',
      message: message,
      accentColor: AppColors.success,
      icon: 'check-circle',
    );
  }

  /// Red error toast
  static void error(BuildContext context, String message) {
    AppHaptics.heavy();
    _showCustom(
      context,
      title: 'Erreur',
      message: message,
      accentColor: AppColors.error,
      icon: 'alert-circle',
    );
  }

  /// Neutral info toast
  static void info(BuildContext context, String message) {
    AppHaptics.light();
    _showCustom(
      context,
      title: 'Information',
      message: message,
      accentColor: AppColors.primary,
      icon: 'info',
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

  static void _showCustom(
    BuildContext context, {
    required String title,
    required String message,
    required Color accentColor,
    required String icon,
  }) {
    toastification.showCustom(
      context: context,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 300),
      builder: (context, item) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bgColor = isDark ? AppColors.darkSurface : AppColors.surface;
        final textColor = isDark ? AppColors.darkOnSurface : AppColors.onSurface;
        final subtextColor = isDark ? AppColors.darkOnSurfaceVariant : AppColors.onSurfaceVariant;

        return Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.lg.r),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.18),
                width: 1.5,
              ),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Icon with Tinted Circle Background
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: AppIcon(
                    icon,
                    size: 20,
                    color: accentColor,
                  ),
                ),
                SizedBox(width: 12.w),
                // Text Column
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        message,
                        style: AppTextStyles.bodySm.copyWith(
                          color: subtextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Close button (manual dismiss)
                GestureDetector(
                  onTap: () => toastification.dismiss(item),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: AppIcon(
                      'close',
                      size: 16,
                      color: subtextColor.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
