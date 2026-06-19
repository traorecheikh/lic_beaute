import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../router/app_router.dart';
import '../../providers/salon_list_provider.dart';
import 'shimmer_skeletons.dart';

/// Salon placeholder widget used when no image is available.
class SalonPlaceholderBox extends StatelessWidget {
  const SalonPlaceholderBox({required this.width, required this.height, super.key});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: AppColors.primaryLight,
      child: Center(
        child: AppIcon('sparkle', size: 28, color: AppColors.primary),
      ),
    );
  }
}

class DistancePill extends StatelessWidget {
  const DistancePill({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon('map-pin', size: 10, color: AppColors.primary),
          SizedBox(width: 3.w),
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.primary,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class SalonListCard extends StatelessWidget {
  const SalonListCard({
    required this.salon,
    required this.showDistance,
    required this.onTap,
    this.heroTag,
    super.key,
  });

  final SearchSuggestionsResponseTopMatchesInner salon;
  final bool showDistance;
  final VoidCallback onTap;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final badge = showDistance ? distanceBadge(salon) : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl.r),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(AppRadius.xl.r)),
              child: heroTag != null
                  ? Hero(
                      tag: heroTag!,
                      child: Material(
                        color: Colors.transparent,
                        child: salon.logoUrl != null && salon.logoUrl!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: salon.logoUrl!,
                                width: 96.w,
                                height: 96.w,
                                memCacheWidth: 192,
                                memCacheHeight: 192,
                                fit: BoxFit.cover,
                                errorWidget: (_, _, _) => SalonPlaceholderBox(width: 96.w, height: 96.w),
                              )
                            : SalonPlaceholderBox(width: 96.w, height: 96.w),
                      ),
                    )
                  : (salon.logoUrl != null && salon.logoUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: salon.logoUrl!,
                          width: 96.w,
                          height: 96.w,
                          memCacheWidth: 192,
                          memCacheHeight: 192,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => SalonPlaceholderBox(width: 96.w, height: 96.w),
                        )
                      : SalonPlaceholderBox(width: 96.w, height: 96.w)),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(salon.category.toUpperCase(), style: AppTextStyles.overline),
                    SizedBox(height: 2.h),
                    Text(salon.name, style: AppTextStyles.headlineSm),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        AppIcon('map-pin', size: 12, color: AppColors.onSurfaceVariant),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            '${salon.neighborhood ?? ''} ${salon.city}'.trim(),
                            style: AppTextStyles.bodySm,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    gapH4,
                    if (salon.reviewCount >= 3)
                      Row(
                        children: [
                          AppIcon('star', size: 13, color: AppColors.secondary),
                          SizedBox(width: 3.w),
                          Text(salon.averageRating.toStringAsFixed(1), style: AppTextStyles.labelMd),
                          if (badge != null) ...[
                            SizedBox(width: 10.w),
                            DistancePill(label: badge),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: AppIcon('chevron-right', size: 18, color: AppColors.outline),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sliver that renders a list of salon cards (used for nearby, top-rated).
class SalonListSliver extends StatelessWidget {
  const SalonListSliver({
    required this.salonsAsync,
    required this.take,
    required this.showDistance,
    required this.onRetry,
    required this.heroPrefix,
    super.key,
  });

  final AsyncValue<List<SearchSuggestionsResponseTopMatchesInner>?> salonsAsync;
  final int take;
  final bool showDistance;
  final Future<void> Function() onRetry;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    return salonsAsync.when(
      loading: () => SliverPadding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
        sliver: SliverList.separated(
          itemCount: take,
          separatorBuilder: (_, _) => gapH12,
          itemBuilder: (_, _) => const SalonListCardSkeleton(),
        ),
      ),
      error: (error, _) => SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
          child: AppErrorState(
            error: error,
            fallbackTitle: 'Impossible de charger les salons',
            serverTitle: 'Le catalogue est indisponible',
            onRetry: onRetry,
            compact: true,
          ),
        ),
      ),
      data: (list) {
        final items = (list ?? [])
            .where((s) => s.logoUrl != null && s.logoUrl!.isNotEmpty)
            .take(take)
            .toList();
        if (items.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: AppEmptyState(
                icon: 'store',
                title: 'Aucun salon pour le moment',
                subtitle: 'Revenez bientôt, de nouveaux salons arrivent !',
                compact: true,
              ),
            ),
          );
        }
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          sliver: SliverList.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => gapH12,
            itemBuilder: (context, i) {
              final salon = items[i];
              final tag = '${heroPrefix}_${salon.id}';
              return RepaintBoundary(
                child: SalonListCard(
                  salon: salon,
                  showDistance: showDistance,
                  heroTag: tag,
                  onTap: () => context.push(
                    '${AppRoutes.salon(salon.id)}?heroTag=${Uri.encodeComponent(tag)}',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
