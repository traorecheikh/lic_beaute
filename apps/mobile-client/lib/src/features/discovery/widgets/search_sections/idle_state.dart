import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/constants/app_strings.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_icon_box.dart';

/// Idle state shown when no search has been performed yet.
/// Displays recent searches and popular categories.
class SearchIdleState extends StatelessWidget {
  const SearchIdleState({
    required this.categories,
    required this.recentSearches,
    required this.onCategoryTap,
    required this.onRecentTap,
    required this.onRecentRemove,
    super.key,
  });

  final List<String> categories;
  final List<String> recentSearches;
  final void Function(String) onCategoryTap;
  final void Function(String) onRecentTap;
  final void Function(String) onRecentRemove;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recentSearches.isNotEmpty)
              _RecentSearchesSection(
                searches: recentSearches,
                onTap: onRecentTap,
                onRemove: onRecentRemove,
              )
            else
              _EmptyWelcomeSection(),
            if (categories.isNotEmpty) ...[
              SizedBox(height: recentSearches.isNotEmpty ? 28.h : 0),
              _CategoriesSection(
                categories: categories,
                onTap: onCategoryTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecentSearchesSection extends StatelessWidget {
  const _RecentSearchesSection({
    required this.searches,
    required this.onTap,
    required this.onRemove,
  });

  final List<String> searches;
  final void Function(String) onTap;
  final void Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.recentSearches, style: AppTextStyles.labelSm.copyWith(
          color: AppColors.onSurfaceVariant, letterSpacing: 1.2,
        )),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w, runSpacing: 8.h,
          children: searches.map((term) => GestureDetector(
            onTap: () => onTap(term),
            child: Container(
              padding: EdgeInsets.only(left: 12.w, right: 6.w, top: 8.h, bottom: 8.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md.r),
                boxShadow: AppShadows.sm,
                border: Border.all(color: AppColors.outlineVariant, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon('clock', size: 13, color: AppColors.onSurfaceVariant),
                  SizedBox(width: 6.w),
                  Text(term, style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurface)),
                  SizedBox(width: 6.w),
                  GestureDetector(
                    onTap: () => onRemove(term),
                    child: AppIcon('close', size: 13, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class _EmptyWelcomeSection extends StatelessWidget {
  const _EmptyWelcomeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: AppIconBox(
            circle: true, size: 64.r,
            color: AppColors.primaryLight,
            child: AppIcon('search', size: 26, color: AppColors.primary),
          ),
        ),
        SizedBox(height: 20.h),
        Center(
          child: Text(AppStrings.findYourSalon, style: AppTextStyles.headlineSm, textAlign: TextAlign.center),
        ),
        SizedBox(height: 8.h),
        Center(
          child: Text(
            AppStrings.searchWelcomeSubtitle,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection({
    required this.categories,
    required this.onTap,
  });

  final List<String> categories;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.categoriesSection, style: AppTextStyles.labelSm.copyWith(
          color: AppColors.onSurfaceVariant, letterSpacing: 1.2,
        )),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w, runSpacing: 8.h,
          children: categories.take(12).map((cat) => GestureDetector(
            onTap: () => onTap(cat),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md.r),
                boxShadow: AppShadows.sm,
                border: Border.all(color: AppColors.outlineVariant, width: 1),
              ),
              child: Text(cat, style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurface)),
            ),
          )).toList(),
        ),
      ],
    );
  }
}
