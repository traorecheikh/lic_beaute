import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import 'filter_chip.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    required this.sort,
    required this.openNow,
    required this.bookableSoon,
    required this.facets,
    required this.onSortSheet,
    required this.onToggleOpenNow,
    required this.onToggleBookableSoon,
    required this.onApplyFilter,
    super.key,
  });

  final String sort;
  final bool openNow;
  final bool bookableSoon;
  final dynamic facets;
  final VoidCallback onSortSheet;
  final VoidCallback onToggleOpenNow;
  final VoidCallback onToggleBookableSoon;
  final void Function({String? category, String? city, String? neighborhood})
      onApplyFilter;

  String _sortLabel(String sort) {
    switch (sort) {
      case 'nearby':
        return AppStrings.sortProximity;
      case 'trending':
        return AppStrings.sortTrending;
      case 'prestige':
        return AppStrings.sortPrestige;
      case 'price_asc':
        return AppStrings.sortPriceAsc;
      case 'price_desc':
        return AppStrings.sortPriceDesc;
      default:
        return AppStrings.sortLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        children: [
          SearchFilterChip(
            label: sort == 'relevance'
                ? AppStrings.sortLabel
                : _sortLabel(sort),
            active: sort != 'relevance',
            icon: 'filter',
            onTap: onSortSheet,
          ),
          SizedBox(width: 8.w),
          SearchFilterChip(
            label: AppStrings.filterOpenNow,
            active: openNow,
            icon: 'clock',
            onTap: onToggleOpenNow,
          ),
          SizedBox(width: 8.w),
          SearchFilterChip(
            label: AppStrings.filterBookableSoon,
            active: bookableSoon,
            icon: 'calendar',
            onTap: onToggleBookableSoon,
          ),
          if (facets != null) ...[
            for (final cat in facets!.categories.take(5))
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: SearchFilterChip(
                  label: '${cat.value} (${cat.count})',
                  active: cat.active ?? false,
                  onTap: () => onApplyFilter(category: cat.value),
                ),
              ),
            for (final city in facets!.cities.take(3))
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: SearchFilterChip(
                  label: city.value,
                  active: city.active ?? false,
                  onTap: () => onApplyFilter(city: city.value),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
