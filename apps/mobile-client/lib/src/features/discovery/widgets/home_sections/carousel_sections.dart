import 'dart:ui';
import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../router/app_router.dart';
import 'salon_list_section.dart';
import 'shimmer_skeletons.dart';

/// Prestige / Featured salon horizontal carousel.
class FeaturedSalonSliver extends StatelessWidget {
  const FeaturedSalonSliver({
    required this.salonsAsync,
    required this.favoriteIds,
    required this.isAuthenticated,
    required this.onRetry,
    required this.onFavoriteTap,
    super.key,
  });

  final AsyncValue<List<SearchSuggestionsResponseTopMatchesInner>> salonsAsync;
  final Set<String> favoriteIds;
  final bool isAuthenticated;
  final Future<void> Function() onRetry;
  final Future<void> Function(SearchSuggestionsResponseTopMatchesInner salon) onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return salonsAsync.when(
      loading: () => SliverToBoxAdapter(
        child: SizedBox(
          height: 280.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: 3,
            separatorBuilder: (_, _) => SizedBox(width: 14.w),
            itemBuilder: (_, _) => const FeaturedCardSkeleton(),
          ),
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
      data: (items) {
        final withPhoto = items
            .where((s) => s.logoUrl != null && s.logoUrl!.isNotEmpty)
            .toList();
        if (withPhoto.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 280.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: withPhoto.length,
              separatorBuilder: (_, _) => SizedBox(width: 14.w),
              itemBuilder: (context, i) {
                final salon = withPhoto[i];
                return RepaintBoundary(
                  child: FeaturedCard(
                    id: salon.id,
                    name: salon.name,
                    imageUrl: salon.logoUrl!,
                    rating: salon.reviewCount >= 3 ? salon.averageRating.toStringAsFixed(1) : null,
                    isFavorite: favoriteIds.contains(salon.id),
                    isAuthenticated: isAuthenticated,
                    onFavoriteTap: () => onFavoriteTap(salon),
                    onTap: () => context.push(
                      '${AppRoutes.salon(salon.id)}?heroTag=${Uri.encodeComponent('prestige_salon_image_${salon.id}')}',
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.isFavorite,
    required this.isAuthenticated,
    required this.onFavoriteTap,
    required this.onTap,
    super.key,
  });

  final String id;
  final String name, imageUrl;
  final String? rating;
  final bool isFavorite;
  final bool isAuthenticated;
  final Future<void> Function() onFavoriteTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 220.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.xl.r),
                    child: Hero(
                      tag: 'prestige_salon_image_$id',
                      child: Material(
                        color: Colors.transparent,
                        child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.sm.r),
                      ),
                      child: Text(
                        'Prestige',
                        style: AppTextStyles.labelSm.copyWith(color: AppColors.white, fontSize: 10.sp),
                      ),
                    ),
                  ),
                  if (rating != null)
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.sm.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: AppColors.black.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(AppRadius.sm.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppIcon('star', size: 11, color: AppColors.secondary),
                                SizedBox(width: 3.w),
                                Text(rating!, style: AppTextStyles.labelSm.copyWith(color: AppColors.white, fontSize: 11.sp)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 12.h,
                    right: 12.w,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        width: 34.r,
                        height: 34.r,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.sm,
                        ),
                        child: Center(
                          child: AppIcon(
                            isAuthenticated && isFavorite ? 'heart-filled' : 'heart',
                            size: 16,
                            color: isAuthenticated && isFavorite ? AppColors.primary : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            gapH8,
            Text(name, style: AppTextStyles.headlineSm),
            gapH4,
            Text('Prestige', style: AppTextStyles.bodySm),
          ],
        ),
      ),
    );
  }
}

/// Trending salon horizontal carousel (compact landscape cards).
class TrendingSalonSliver extends StatelessWidget {
  const TrendingSalonSliver({required this.salonsAsync, required this.onRetry, super.key});

  final AsyncValue<List<SearchSuggestionsResponseTopMatchesInner>> salonsAsync;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return salonsAsync.when(
      loading: () => SliverToBoxAdapter(
        child: SizedBox(
          height: 170.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: 4,
            separatorBuilder: (_, _) => SizedBox(width: 14.w),
            itemBuilder: (_, _) => const TrendingCardSkeleton(),
          ),
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
      data: (items) {
        final withPhoto = items
            .where((s) => s.logoUrl != null && s.logoUrl!.isNotEmpty)
            .toList();
        if (withPhoto.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 170.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: withPhoto.length,
              separatorBuilder: (_, _) => gapW12,
              itemBuilder: (context, i) {
                final salon = withPhoto[i];
                return RepaintBoundary(
                  child: TrendingCard(
                    salon: salon,
                    rank: i + 1,
                    onTap: () => context.push(
                      '${AppRoutes.salon(salon.id)}?heroTag=${Uri.encodeComponent('trending_salon_image_${salon.id}')}',
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class TrendingCard extends StatelessWidget {
  const TrendingCard({
    required this.salon,
    required this.rank,
    required this.onTap,
    super.key,
  });

  final SearchSuggestionsResponseTopMatchesInner salon;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 260.w,
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
                child: Stack(
                  children: [
                    Hero(
                      tag: 'trending_salon_image_${salon.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: CachedNetworkImage(
                          imageUrl: salon.logoUrl!,
                          width: 110.w,
                          height: 170.h,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => SalonPlaceholderBox(width: 110.w, height: 170.h),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      child: Container(
                        width: 28.r,
                        height: 28.r,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '#$rank',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(salon.category.toUpperCase(), style: AppTextStyles.overline),
                      gapH4,
                      Text(salon.name, style: AppTextStyles.headlineSm, maxLines: 2, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          AppIcon('map-pin', size: 11, color: AppColors.onSurfaceVariant),
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
                      gapH8,
                      if (salon.reviewCount >= 3)
                        Row(
                          children: [
                            AppIcon('star', size: 12, color: AppColors.secondary),
                            SizedBox(width: 3.w),
                            Text(salon.averageRating.toStringAsFixed(1), style: AppTextStyles.labelMd),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
