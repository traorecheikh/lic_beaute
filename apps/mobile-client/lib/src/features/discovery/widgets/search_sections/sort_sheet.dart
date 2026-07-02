import 'package:cupertino_native_better/components/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/constants/app_strings.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../../core/widgets/app_icon.dart';

/// Bottom sheet with sort options for search results.
class SearchSortSheet extends StatelessWidget {
  const SearchSortSheet({
    required this.currentSort,
    required this.onSortSelected,
    super.key,
  });

  final String currentSort;
  final void Function(String sort) onSortSelected;

  static void show(BuildContext context, {
    required String currentSort,
    required void Function(String sort) onSortSelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => CNSheetGeometryProbe(
        child: SafeArea(
          child: SearchSortSheet(
            currentSort: currentSort,
            onSortSelected: (sort) {
              onSortSelected(sort);
              Navigator.pop(ctx);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.sortByLabel, style: AppTextStyles.headlineSm),
          gapH16,
          _SearchSortOption(
            label: AppStrings.sortRelevance,
            value: 'relevance',
            current: currentSort,
            onTap: () => onSortSelected('relevance'),
          ),
          _SearchSortOption(
            label: AppStrings.sortProximity,
            value: 'nearby',
            current: currentSort,
            onTap: () => onSortSelected('nearby'),
          ),
          _SearchSortOption(
            label: AppStrings.sortTrending,
            value: 'trending',
            current: currentSort,
            onTap: () => onSortSelected('trending'),
          ),
          _SearchSortOption(
            label: AppStrings.sortPrestige,
            value: 'prestige',
            current: currentSort,
            onTap: () => onSortSelected('prestige'),
          ),
          _SearchSortOption(
            label: AppStrings.sortPriceAsc,
            value: 'price_asc',
            current: currentSort,
            onTap: () => onSortSelected('price_asc'),
          ),
          _SearchSortOption(
            label: AppStrings.sortPriceDesc,
            value: 'price_desc',
            current: currentSort,
            onTap: () => onSortSelected('price_desc'),
          ),
        ],
      ),
    );
  }
}

class _SearchSortOption extends StatelessWidget {
  const _SearchSortOption({
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });

  final String label;
  final String value;
  final String current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = value == current;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMd.copyWith(
                  color: active ? AppColors.primary : AppColors.onSurface,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (active) AppIcon('check', size: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
