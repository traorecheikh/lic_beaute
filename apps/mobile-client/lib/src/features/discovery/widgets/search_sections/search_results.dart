import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_icon.dart';
import '../salon_list_card.dart';
import 'module_salon_card.dart';

class SearchResultsView extends ConsumerWidget {
  const SearchResultsView({
    required this.results,
    required this.modules,
    required this.correctedQuery,
    required this.isLoadingMore,
    required this.hasMore,
    required this.totalApprox,
    required this.query,
    required this.onRefresh,
    required this.onCorrectedTap,
    required this.onResultTap,
    required this.onModuleTap,
    this.scrollController,
    super.key,
  });

  final List<dynamic> results;
  final List<dynamic> modules;
  final String? correctedQuery;
  final bool isLoadingMore;
  final bool hasMore;
  final int totalApprox;
  final String query;
  final Future<void> Function() onRefresh;
  final void Function() onCorrectedTap;
  final void Function(String salonId, String tag, int index) onResultTap;
  final void Function(String salonId, String tag) onModuleTap;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator.adaptive(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // Did you mean
          if (correctedQuery != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
                child: GestureDetector(
                  onTap: onCorrectedTap,
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMd,
                      children: [
                        TextSpan(
                          text: AppStrings.didYouMean,
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        TextSpan(
                          text: correctedQuery,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Results count
          if (totalApprox > 0)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
                child: Text(
                  '$totalApprox résultat${totalApprox > 1 ? 's' : ''}',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),

          // Main results
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverList.separated(
              itemCount: results.length,
              separatorBuilder: (_, _) => gapH12,
              itemBuilder: (context, i) {
                final salon = results[i];
                final tag = 'search_salon_image_${salon.id}';
                return SalonListCard(
                  salon: salon,
                  heroTag: tag,
                  onTap: () => onResultTap(salon.id, tag, i),
                  height: 88.h,
                  radius: AppRadius.xl.r,
                  trailing: Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: AppIcon(
                      'chevron-right',
                      size: 16,
                      color: AppColors.outline,
                    ),
                  ),
                );
              },
            ),
          ),

          // Loading more indicator
          if (isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Center(
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),

          // Discovery modules
          for (final module in modules) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
                child: Text(
                  module.title,
                  style: AppTextStyles.headlineSm,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: module.items.length,
                  separatorBuilder: (_, _) => SizedBox(width: 12.w),
                  itemBuilder: (context, i) {
                    final salon = module.items.elementAt(i);
                    final mTag = 'module_salon_image_${salon.id}';
                    return SearchModuleSalonCard(
                      salon: salon,
                      heroTag: mTag,
                      onTap: () => onModuleTap(salon.id, mTag),
                    );
                  },
                ),
              ),
            ),
          ],

          // Bottom padding
          SliverToBoxAdapter(child: SizedBox(height: 120.h)),
        ],
      ),
    );
  }
}
