import 'package:cupertino_native_better/components/button.dart';
import 'package:cupertino_native_better/style/button_style.dart';
import 'package:cupertino_native_better/style/sf_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/diagnostics/app_runtime_diagnostics.dart';
import '../../../core/platform/ios_version.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/ios_native_icon_button.dart';

class SalonCircleBtn extends StatelessWidget {
  const SalonCircleBtn({
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.semanticLabel,
    super.key,
  });

  final String icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final useNativeIOSControl =
        IOSVersion.supportsNativeGlass &&
        (AppRuntimeDiagnostics.config.enableIOSNativeGlass ||
            AppRuntimeDiagnostics.config.enableIOSNativeIconButtons);

    if (useNativeIOSControl) {
      return Padding(
        padding: EdgeInsets.all(6.r),
        child: IOSNativeIconButton(
          iconName: icon,
          foregroundColor: iconColor ?? AppColors.onSurface,
          tintColor: AppColors.white.withValues(alpha: 0.30),
          semanticLabel: semanticLabel,
          onPressed: onTap,
        ),
      );
    }

    if (Theme.of(context).platform == TargetPlatform.android) {
      return Padding(
        padding: EdgeInsets.all(6.r),
        child: IconButton.filledTonal(
          onPressed: onTap,
          tooltip: semanticLabel,
          style: IconButton.styleFrom(
            minimumSize: Size.square(48.r),
            foregroundColor: iconColor ?? AppColors.onSurface,
            backgroundColor: AppColors.white.withValues(alpha: 0.90),
            shadowColor: AppColors.black.withValues(alpha: 0.14),
            elevation: 2,
          ),
          icon: Icon(_materialIcon(icon), size: 22.r),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(8.r),
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.88),
              shape: BoxShape.circle,
              boxShadow: AppShadows.sm,
            ),
            child: Center(
              child: AppIcon(
                icon,
                size: 18,
                color: iconColor ?? AppColors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _materialIcon(String name) {
    switch (name) {
      case 'arrow-left':
        return Icons.arrow_back_rounded;
      case 'share':
        return Icons.ios_share_rounded;
      case 'heart-filled':
      case 'heart-fill':
        return Icons.favorite_rounded;
      case 'heart':
        return Icons.favorite_border_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }
}

class SalonBottomCta extends StatelessWidget {
  const SalonBottomCta({required this.onBook, this.price, super.key});

  final VoidCallback onBook;
  final String? price;

  String get _label {
    if (price == null) return AppStrings.salonDetailCta;
    final compactPrice = price!.replaceFirst('À partir de ', 'Dès ');
    return '${AppStrings.bookCta} · $compactPrice';
  }

  @override
  Widget build(BuildContext context) {
    final useNativeIOSControl =
        IOSVersion.supportsNativeGlass &&
        (AppRuntimeDiagnostics.config.enableIOSNativeGlass ||
            AppRuntimeDiagnostics.config.enableIOSNativeIconButtons);

    if (useNativeIOSControl) {
      return SizedBox(
        width: double.infinity,
        child: CNButton(
          label: _label,
          icon: const CNSymbol('calendar', size: 18),
          onPressed: onBook,
          tint: AppColors.onSurface,
          config: CNButtonConfig(
            style: CNButtonStyle.prominentGlass,
            minHeight: 58.h,
            labelColor: AppColors.surface,
            labelFontSize: _label.length > 28 ? 14.sp : 16.sp,
            labelFontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    if (Theme.of(context).platform == TargetPlatform.android) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 56.h),
        child: FilledButton.icon(
          onPressed: onBook,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.onSurface,
            foregroundColor: AppColors.surface,
            shape: const StadiumBorder(),
            elevation: 4,
            textStyle: AppTextStyles.labelLg,
          ),
          icon: const Icon(Icons.calendar_month_rounded),
          label: Text(
            _label,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return AppPressable(
      onTap: onBook,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.onSurface,
          borderRadius: BorderRadius.circular(AppRadius.full.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon('calendar', color: AppColors.surface, size: 18),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                _label,
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.surface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
