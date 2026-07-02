import 'package:cupertino_native_better/components/button.dart';
import 'package:cupertino_native_better/components/search_bar.dart';
import 'package:cupertino_native_better/style/button_style.dart';
import 'package:cupertino_native_better/style/sf_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_router.dart';
import '../theme/app_theme.dart';
import 'debounced_action.dart';

/// Native iOS 26+ Liquid Glass search launcher for the discovery page.
///
/// The Home control behaves as a route launcher instead of creating a second
/// live search state. The dedicated SearchPage remains the only owner of query
/// state, results, and filters.
class IOSNativeSearchBar extends StatelessWidget {
  const IOSNativeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              button: true,
              label: 'Rechercher un salon, une prestation ou un quartier',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: debouncedAction(() => context.push(AppRoutes.search)),
                child: SizedBox(
                  height: 48.h,
                  child: IgnorePointer(
                    child: CNSearchBar(
                      placeholder: 'Salon, prestation, quartier...',
                      expandable: false,
                      initiallyExpanded: true,
                      expandedHeight: 48.h,
                      showCancelButton: false,
                      tint: AppColors.primary,
                      textColor: AppColors.onSurface,
                      placeholderColor: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Semantics(
            button: true,
            label: 'Ouvrir les filtres de recherche',
            child: SizedBox(
              height: 48.h,
              child: CNButton(
                label: 'Filtrer',
                icon: const CNSymbol('line.3.horizontal.decrease', size: 16),
                onPressed: debouncedAction(
                  () => context.push('${AppRoutes.search}?openFilters=1'),
                ),
                tint: AppColors.primary,
                config: CNButtonConfig(
                  style: CNButtonStyle.glass,
                  minHeight: 48.h,
                  width: 92.w,
                  shrinkWrap: false,
                  maxLines: 1,
                  labelColor: AppColors.primary,
                  labelFontSize: 13.sp,
                  labelFontWeight: FontWeight.w700,
                  imagePadding: 6.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Material 3 search launcher used on Android.
///
/// It intentionally mirrors the existing layout while using Android-native
/// interaction shapes and semantics. Query state still belongs to SearchPage.
class AndroidMaterialSearchBar extends StatelessWidget {
  const AndroidMaterialSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              button: true,
              label: 'Rechercher un salon, une prestation ou un quartier',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: debouncedAction(() => context.push(AppRoutes.search)),
                child: IgnorePointer(
                  child: SearchBar(
                    hintText: 'Salon, prestation, quartier...',
                    leading: const Icon(Icons.search_rounded),
                    elevation: const WidgetStatePropertyAll(1),
                    backgroundColor:
                        const WidgetStatePropertyAll(AppColors.surface),
                    constraints: BoxConstraints(
                      minHeight: 52.h,
                      maxHeight: 52.h,
                    ),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          IconButton.filledTonal(
            onPressed: debouncedAction(
              () => context.push('${AppRoutes.search}?openFilters=1'),
            ),
            tooltip: 'Filtrer',
            style: IconButton.styleFrom(
              minimumSize: Size.square(48.r),
              foregroundColor: AppColors.onPrimaryContainer,
              backgroundColor: AppColors.primaryLight,
            ),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
    );
  }
}
