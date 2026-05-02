import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';
import '../providers/favorites_provider.dart';
import '../providers/salon_list_provider.dart';
import '../widgets/stale_data_notice.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favState = ref.watch(favoritesProvider);
    final salonsAsync = ref.watch(salonListProvider);
    Future<void> refreshSalons() => ref.refresh(salonListProvider.future);

    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: RefreshIndicator.adaptive(
        color: AppColors.primary,
        onRefresh: refreshSalons,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverSafeArea(
              bottom: false,
              sliver: SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                sliver: SliverToBoxAdapter(
                  child: Text('Mes Favoris', style: AppTextStyles.displaySm),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
              sliver: salonsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: AppErrorState(
                      error: error,
                      fallbackTitle: 'Impossible de charger les favoris',
                      serverTitle: 'Les favoris sont indisponibles',
                      onRetry: refreshSalons,
                      compact: true,
                    ),
                  ),
                ),
                data: (resource) {
                  final all = resource.data?.items.toList() ?? const [];
                  final favorites = all
                      .where((s) => favState.salonIds.contains(s.id))
                      .toList();

                  if (favorites.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 80.h),
                        child: Column(
                          children: [
                            AppIcon(
                              'heart',
                              size: 40,
                              color: AppColors.outline,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Aucun favori pour le moment',
                              style: AppTextStyles.headlineSm,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Explorez des salons et enregistrez vos coups de cœur.',
                              style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount:
                        favorites.length +
                        (resource.isStale && resource.cachedAt != null ? 1 : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (_, i) {
                      if (resource.isStale && resource.cachedAt != null) {
                        if (i == 0) {
                          return StaleDataNotice(cachedAt: resource.cachedAt!);
                        }
                        i -= 1;
                      }
                      final salon = favorites[i];
                      return _FavoriteSalonCard(
                        name: salon.name,
                        category: salon.category,
                        location: '${salon.neighborhood ?? ''} ${salon.city}'
                            .trim(),
                        rating: salon.averageRating.toStringAsFixed(1),
                        imageUrl: salon.logoUrl ?? '',
                        isFavorite: true,
                        onTap: () => context.push(AppRoutes.salon(salon.id)),
                        onFavoriteToggle: () {
                          AppHaptics.light();
                          ref.read(favoritesProvider.notifier).toggle(salon.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteSalonCard extends StatelessWidget {
  const _FavoriteSalonCard({
    required this.name,
    required this.category,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  final String name, category, location, rating, imageUrl;
  final bool isFavorite;
  final VoidCallback onTap, onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20.r),
              ),
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 100.r,
                      height: 100.h,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 100.r,
                      height: 100.h,
                      color: AppColors.primaryLight,
                      child: Center(
                        child: AppIcon(
                          'sparkle',
                          size: 28,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 8.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.labelLg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      category,
                      style: AppTextStyles.bodySm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        AppIcon(
                          'map-pin',
                          size: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            location,
                            style: AppTextStyles.bodyXs,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        AppIcon('star', size: 11, color: AppColors.secondary),
                        SizedBox(width: 3.w),
                        Text(
                          rating,
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Favorite toggle
            GestureDetector(
              onTap: onFavoriteToggle,
              child: Padding(
                padding: EdgeInsets.all(14.r),
                child: AppIcon(
                  isFavorite ? 'heart-filled' : 'heart',
                  size: 22,
                  color: isFavorite ? AppColors.primary : AppColors.outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
