import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';

enum AppButtonVariant { primary, outline, text }

class AppButton extends StatefulWidget {
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
  }) =>
      AppButton(
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

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final bool isFullWidth;
  final double? width, height;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  void didUpdateWidget(AppButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final wasEnabled = !oldWidget.isLoading && oldWidget.onPressed != null;
    final isNowDisabled = widget.isLoading || widget.onPressed == null;
    if (wasEnabled && isNowDisabled && _pressed) {
      setState(() => _pressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isLoading || widget.onPressed == null;
    final isPrimary = widget.variant == AppButtonVariant.primary;

    final Widget indicator = SizedBox(
      height: 20.h,
      width: 20.h,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: isPrimary ? AppColors.white : AppColors.primary,
      ),
    );

    final Widget labelWidget =
        widget.isLoading
            ? indicator
            : Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              );

    final Widget content = widget.icon != null && !widget.isLoading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [widget.icon!, gapW8, labelWidget],
          )
        : labelWidget;

    final Color bgColor;
    final Color textColor;
    final BoxBorder? border;
    final EdgeInsets padding;
    final double? minHeight;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        bgColor = isDisabled ? AppColors.outline : AppColors.primary;
        textColor =
            isDisabled ? AppColors.onSurfaceVariant : AppColors.onPrimary;
        border = null;
        padding = EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h);
        minHeight = 56.h;
      case AppButtonVariant.outline:
        bgColor = isDisabled ? AppColors.outlineVariant : AppColors.surface;
        textColor = AppColors.onSurface;
        border = Border.all(color: AppColors.outline, width: 1.5);
        padding = EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h);
        minHeight = 56.h;
      case AppButtonVariant.text:
        bgColor = AppColors.transparent;
        textColor = AppColors.primary;
        border = null;
        padding = EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h);
        minHeight = null;
    }

    Widget container = Container(
      constraints: minHeight != null
          ? BoxConstraints(minHeight: minHeight)
          : null,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100.r),
        border: border,
      ),
      child: DefaultTextStyle(
        style: AppTextStyles.labelLg.copyWith(color: textColor),
        child: IconTheme(
          data: IconThemeData(color: textColor, size: 20.r),
          child: Center(child: content),
        ),
      ),
    );

    Widget button = AnimatedOpacity(
      opacity: _pressed ? 0.7 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: container,
    );

    button = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isDisabled ? null : widget.onPressed,
      onTapDown: isDisabled ? null : _onTapDown,
      onTapUp: isDisabled ? null : _onTapUp,
      onTapCancel: isDisabled ? null : _onTapCancel,
      child: button,
    );

    final fixedHeight = widget.height ??
        (widget.variant == AppButtonVariant.text ? null : 56.h);
    if (widget.isFullWidth || widget.width != null || fixedHeight != null) {
      return SizedBox(
        width: widget.width ?? (widget.isFullWidth ? double.infinity : null),
        height: fixedHeight,
        child: button,
      );
    }
    return button;
  }
}
