import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';

enum AppButtonVariant { primary, outline, text }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.width,
    this.height,
    super.key,
  });

  static AppButton primary({
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Widget? icon,
    bool isFullWidth = true,
    double? width,
    double? height,
    Key? key,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      isLoading: isLoading,
      icon: icon,
      isFullWidth: isFullWidth,
      width: width,
      height: height,
      key: key,
    );
  }

  static AppButton outline({
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Widget? icon,
    bool isFullWidth = true,
    double? width,
    double? height,
    Key? key,
  }) =>
      AppButton(
        label: label,
        onPressed: onPressed,
        variant: AppButtonVariant.outline,
        isLoading: isLoading,
        icon: icon,
        isFullWidth: isFullWidth,
        width: width,
        height: height,
        key: key,
      );

  static AppButton text({
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Widget? icon,
    bool isFullWidth = false,
    double? width,
    double? height,
    Key? key,
  }) {
    final btn = AppButton(
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.text,
      isLoading: isLoading,
      icon: icon,
      isFullWidth: isFullWidth,
      width: width,
      height: height,
      key: key,
    );
    return btn;
  }

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final bool isFullWidth;
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPrimary = variant == AppButtonVariant.primary;

    final Widget indicator = SizedBox(
      height: 20.h,
      width: 20.h,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: isPrimary ? AppColors.white : theme.primaryColor,
      ),
    );

    final Widget labelWidget = isLoading ? indicator : Text(label);

    final Widget content = icon != null && !isLoading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [icon!, gapW8, labelWidget],
          )
        : labelWidget;

    final VoidCallback? onBtnPressed = isLoading ? null : onPressed;

    final Widget button = switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
          onPressed: onBtnPressed,
          child: content,
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: onBtnPressed,
          child: content,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: onBtnPressed,
          child: content,
        ),
    };

    if (isFullWidth || width != null || height != null) {
      return SizedBox(
        width: width ?? (isFullWidth ? double.infinity : null),
        height: height,
        child: button,
      );
    }
    return button;
  }
}
