import 'package:flutter/cupertino.dart';
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
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return showCupertinoDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(body),
          ),
          actions: actions
              .map(
                (action) => CupertinoDialogAction(
                  isDestructiveAction: action.isDestructive,
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    action.onPressed();
                  },
                  child: Text(action.label),
                ),
              )
              .toList(growable: false),
        ),
      );
    }

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
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420.w),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl.r),
            border: Border.all(color: AppColors.outlineVariant),
            boxShadow: AppShadows.card,
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: AppTextStyles.headlineSm),
              SizedBox(height: 12.h),
              Text(
                body,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 22.h),
              ...actions.map(
                (action) => Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: AppPressable(
                    onTap: () {
                      Navigator.of(context).pop();
                      action.onPressed();
                    },
                    minSize: const Size(44, 48),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 13.h,
                      ),
                      decoration: BoxDecoration(
                        color: action.isDestructive
                            ? AppColors.errorContainer
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadius.full.r),
                      ),
                      child: Text(
                        action.label,
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.labelLg.copyWith(
                          color: action.isDestructive
                              ? AppColors.error
                              : AppColors.onSurface,
                        ),
                      ),
                    ),
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
