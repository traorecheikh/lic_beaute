import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/diagnostics/app_runtime_diagnostics.dart';
import '../../../../core/platform/ios_version.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../../../core/widgets/debounced_action.dart';
import '../../../../core/widgets/ios_native_search_bar.dart';
import '../../../../router/app_router.dart';

class AdaptiveIconButton extends StatelessWidget {
  const AdaptiveIconButton({
    required this.icon,
    required this.color,
    required this.hasBg,
    required this.onTap,
    super.key,
  });

  final String icon;
  final Color color;
  final bool hasBg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          color: hasBg
              ? AppColors.white.withValues(alpha: 0.2)
              : AppColors.transparent,
          shape: BoxShape.circle,
          border: hasBg
              ? Border.all(
                  color: AppColors.white.withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Center(child: AppIcon(icon, size: 20, color: color)),
      ),
    );
  }
}

/// Platform-adaptive discovery search launcher.
///
/// iOS 26+ uses the genuine native Liquid Glass search control. Android uses
/// Material 3. Older iOS versions retain the established Beauté Avenue
/// fallback instead of receiving an imitation of either platform.
class SearchBarContent extends StatelessWidget {
  const SearchBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    final useNativeIOSSearch =
        IOSVersion.supportsNativeGlass &&
        (AppRuntimeDiagnostics.config.enableIOSNativeSearchBar ||
            AppRuntimeDiagnostics.config.enableIOSNativeGlass);

    if (useNativeIOSSearch) {
      return const IOSNativeSearchBar();
    }
    if (Platform.isAndroid) {
      return const AndroidMaterialSearchBar();
    }
    return const _LegacySearchBarContent();
  }
}

class _LegacySearchBarContent extends StatelessWidget {
  const _LegacySearchBarContent();

  static const _searchHeroTag = 'home-search-hero';
  static const _filterHeroTag = 'home-filter-hero';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          boxShadow: AppShadows.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Hero(
                tag: _searchHeroTag,
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: debouncedAction(() => context.push(AppRoutes.search)),
                    child: Row(
                      children: [
                        AppIcon(
                          'search',
                          size: 20,
                          color: AppColors.onSurfaceVariant,
                        ),
                        gapW12,
                        Expanded(
                          child: Text(
                            'Salon, prestation, quartier...',
                            style: AppTextStyles.bodyMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: debouncedAction(
                () => context.push('${AppRoutes.search}?openFilters=1'),
              ),
              child: Hero(
                tag: _filterHeroTag,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.md.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon(
                          'filter',
                          size: 14,
                          color: AppColors.onPrimaryContainer,
                        ),
                        gapW4,
                        Text(
                          'Filtrer',
                          maxLines: 1,
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.onPrimaryContainer,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
