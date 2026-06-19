import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/constants/app_strings.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../../core/widgets/app_icon.dart';

/// Loading indicator for search results.
class SearchLoadingState extends StatelessWidget {
  const SearchLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

/// Error state when search fails.
class SearchErrorState extends StatelessWidget {
  const SearchErrorState({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon('warning', size: 40, color: AppColors.onSurfaceVariant),
            gapH16,
            Text(message, style: AppTextStyles.bodyMd, textAlign: TextAlign.center),
            gapH16,
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.full.r),
                ),
                child: Text(AppStrings.searchRetry,
                  style: AppTextStyles.labelLg.copyWith(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state when no search results found.
class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({
    required this.query,
    this.correctedQuery,
    this.onCorrectedTap,
    super.key,
  });

  final String query;
  final String? correctedQuery;
  final VoidCallback? onCorrectedTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon('search', size: 40, color: AppColors.onSurfaceVariant),
            gapH16,
            Text('${AppStrings.noResultsFor}"$query"',
              style: AppTextStyles.headlineSm, textAlign: TextAlign.center),
            gapH8,
            Text(
              AppStrings.noResultsSuggestion,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (correctedQuery != null && onCorrectedTap != null) ...[
              gapH16,
              GestureDetector(
                onTap: onCorrectedTap,
                child: Text('${AppStrings.didYouMean}$correctedQuery ?',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
