import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../router/app_router.dart';
import '../providers/salon_list_provider.dart';

enum SalonListFilter { nearby, prestige, topRated, trending }

class SalonsListPage extends ConsumerWidget {
  const SalonsListPage({super.key, required this.filter});

  final SalonListFilter filter;

  String get _title => switch (filter) {
    SalonListFilter.nearby => 'Près de vous',
    SalonListFilter.prestige => 'Adresses prestige',
    SalonListFilter.topRated => 'Les mieux notés',
    SalonListFilter.trending => 'Tendance',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SalonSummaryListResponseItemsInner>> salonsAsync =
        switch (filter) {
          SalonListFilter.nearby =>
            ref.watch(nearbyProvider).whenData((v) => v ?? []),
          SalonListFilter.prestige => ref.watch(prestigeProvider),
          SalonListFilter.topRated => ref.watch(topRatedProvider),
          SalonListFilter.trending => ref.watch(trendingProvider),
        };

    Future<void> refresh() => switch (filter) {
      SalonListFilter.nearby => ref.refresh(nearbyProvider.future),
      SalonListFilter.prestige => ref.refresh(prestigeProvider.future),
      SalonListFilter.topRated => ref.refresh(topRatedProvider.future),
      SalonListFilter.trending => ref.refresh(trendingProvider.future),
    };

    return AppScaffold(
      appBar: AppTopBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        showBackButton: true,
        onBack: () {
          AppHaptics.light();
          context.pop();
        },
        title: _title,
        actions: [
          AppPressable(
            onTap: () {
              AppHaptics.light();
              context.push(AppRoutes.search);
            },
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: AppIcon('search', size: 20, color: AppColors.onSurface),
            ),
          ),
          gapW4,
        ],
      ),
      body: AppAsyncView(
        value: salonsAsync,
        errorTitle: 'Impossible de charger les salons',
        serverTitle: 'Le catalogue est indisponible',
        onRetry: refresh,
        builder: (items) {
          return RefreshIndicator.adaptive(
            color: AppColors.primary,
            onRefresh: refresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
              itemCount: items.isEmpty ? 1 : items.length,
              separatorBuilder: (_, _) => SizedBox(height: 14.h),
              itemBuilder: (context, i) {
                if (items.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: Center(
                      child: Text(
                        'Aucun salon disponible.',
                        style: AppTextStyles.bodyMd,
                      ),
                    ),
                  );
                }
                return _SalonCard(salon: items[i]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _SalonCard extends StatelessWidget {
  const _SalonCard({required this.salon});
  final SalonSummaryListResponseItemsInner salon;

  @override
  Widget build(BuildContext context) {
    final imageUrl = salon.logoUrl ?? '';
    final badge = distanceBadge(salon);

    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        context.push(AppRoutes.salon(salon.id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(20.r),
                  ),
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 100.r,
                          height: 100.r,
                          fit: BoxFit.cover,
                          placeholder: (_, _) =>
                              Container(color: AppColors.surfaceVariant),
                        )
                      : Container(
                          width: 100.r,
                          height: 100.r,
                          color: AppColors.surfaceVariant,
                          child: Center(
                            child: AppIcon(
                              'store',
                              size: 32,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                ),
                if (salon.isPrestige)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'Prestige',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.white,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      salon.category.toUpperCase(),
                      style: AppTextStyles.overline,
                    ),
                    SizedBox(height: 2.h),
                    Text(salon.name, style: AppTextStyles.headlineSm),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        AppIcon(
                          'map-pin',
                          size: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
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
                    Row(
                      children: [
                        AppIcon('star', size: 13, color: AppColors.secondary),
                        SizedBox(width: 3.w),
                        Text(
                          salon.averageRating.toStringAsFixed(1),
                          style: AppTextStyles.labelMd,
                        ),
                        if (badge != null) ...[
                          SizedBox(width: 10.w),
                          _DistanceBadge(label: badge),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 14.w),
              child: AppIcon(
                'chevron-right',
                size: 18,
                color: AppColors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DistanceBadge extends StatelessWidget {
  const _DistanceBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8.r),
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
