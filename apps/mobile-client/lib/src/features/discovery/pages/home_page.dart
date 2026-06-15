import 'dart:ui';
import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/location/location_service.dart';
import '../../../core/session/session_store.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../router/app_router.dart';
import '../../profile/providers/profile_provider.dart';
import '../../auth/widgets/auth_required_sheet.dart';
import '../providers/favorites_provider.dart';
import '../providers/salon_list_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _scrollCtrl = ScrollController();
  double _collapseRatio = 0.0;
  static const _heroHeight = 320.0;
  static const _appBarCollapsedHeight = 56.0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollCtrl.offset;
    final expandedRange = _heroHeight - _appBarCollapsedHeight;
    final ratio = (offset / expandedRange).clamp(0.0, 1.0);
    if ((ratio - _collapseRatio).abs() > 0.01) {
      setState(() => _collapseRatio = ratio);
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  Color _iconColor(Color onExpanded, Color onCollapsed) =>
      Color.lerp(onExpanded, onCollapsed, _collapseRatio)!;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final bottomNavClearance = bottomInset + 92.h;
    final nearbyAsync = ref.watch(nearbyProvider);
    final topRatedAsync = ref.watch(topRatedProvider);
    final trendingAsync = ref.watch(trendingProvider);
    final prestigeAsync = ref.watch(prestigeProvider);
    final session = ref.watch(sessionProvider);
    final favoriteIds = session.isAuthenticated
        ? ref.watch(favoritesProvider.select((state) => state.salonIds))
        : <String>{};
    final bannerDismissed = ref.watch(locationBannerDismissedProvider);
    final locationStatus = ref.watch(locationStatusProvider);

    bool hasPhoto(SalonSummaryListResponseItemsInner s) =>
        s.logoUrl != null && s.logoUrl!.isNotEmpty;

    final hasNearby =
        nearbyAsync.asData?.value?.any(hasPhoto) == true;
    final hasTopRatedData =
        topRatedAsync.asData?.value.any(hasPhoto) == true;
    final hasTrendingData =
        trendingAsync.asData?.value.any(hasPhoto) == true;
    final hasPrestigeData =
        prestigeAsync.asData?.value.any(hasPhoto) == true;
    final hasAnyCatalogData =
        hasTopRatedData || hasTrendingData || hasPrestigeData;
    final allCoreLoading =
        topRatedAsync.isLoading &&
        trendingAsync.isLoading &&
        prestigeAsync.isLoading &&
        !hasAnyCatalogData;
    final allCoreFailed =
        topRatedAsync.hasError &&
        trendingAsync.hasError &&
        prestigeAsync.hasError &&
        !hasAnyCatalogData;
    final showGlobalLoading = allCoreLoading;
    final showGlobalError = !showGlobalLoading && allCoreFailed;
    final allLoaded = !topRatedAsync.isLoading && !trendingAsync.isLoading && !prestigeAsync.isLoading;
    final showGlobalEmpty = !showGlobalLoading && !showGlobalError && allLoaded && !hasAnyCatalogData && !hasNearby;

    // Show banner when permission is not granted OR GPS is off
    final permDenied =
        locationStatus.asData?.value == LocationStatus.denied ||
        locationStatus.asData?.value == LocationStatus.deniedForever ||
        locationStatus.asData?.value == LocationStatus.serviceDisabled;
    final showBanner =
        !bannerDismissed && !locationStatus.isLoading && permDenied;

    Future<void> refreshAll() async {
      ref.invalidate(locationStatusProvider);
      ref.invalidate(locationProvider);
      ref.invalidate(nearbyProvider);
      ref.invalidate(topRatedProvider);
      ref.invalidate(trendingProvider);
      ref.invalidate(prestigeProvider);
    }

    return AppScaffold(
      body: RefreshIndicator.adaptive(
        color: AppColors.primary,
        onRefresh: refreshAll,
        child: CustomScrollView(
          controller: _scrollCtrl,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: const _SearchBarContent(),
              ),
            ),

                    // Location permission banner
                    if (showBanner)
                      SliverToBoxAdapter(
                        child: _LocationBanner(
                          onDismiss: () => ref
                              .read(locationBannerDismissedProvider.notifier)
                              .dismiss(),
                          onEnable: () async {
                            final granted = await context.push<bool>(
                              AppRoutes.locationPermission,
                            );
                            if (granted == true) {
                              ref.invalidate(nearbyProvider);
                              ref.invalidate(locationStatusProvider);
                            }
                          },
                        ),
                      ),

            if (showGlobalLoading)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator.adaptive(),
                      SizedBox(height: 12.h),
                      Text(
                        'Chargement des salons…',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (showGlobalError)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
                sliver: SliverToBoxAdapter(
                  child: AppErrorState(
                    error: topRatedAsync.error,
                    fallbackTitle: 'Catalogue indisponible',
                    serverTitle: 'Le catalogue est indisponible',
                    onRetry: refreshAll,
                  ),
                ),
              ),

            if (showGlobalEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(32.w, 40.h, 32.w, 120.h),
                  child: AppEmptyState(
                    icon: 'store',
                    title: 'Aucun salon disponible',
                    subtitle: 'Les salons proches de vous apparaîtront ici. Revenez bientôt !',
                    action: refreshAll,
                    actionLabel: 'Actualiser',
                  ),
                ),
              ),

            if (!showGlobalLoading && !showGlobalError)
            if (hasNearby) ...[
              _SectionHeaderSliver(
                title: 'Près de vous',
                action: 'Tout voir',
                onAction: () => context.push(AppRoutes.salonsNearby),
              ),
              _SalonListSliver(
                salonsAsync: nearbyAsync,
                take: 3,
                showDistance: true,
                onRetry: refreshAll,
              ),
            ],

            // Trending — #2 (horizontal carousel, before prestige)
            if (!showGlobalLoading && !showGlobalError)
            if (hasTrendingData || trendingAsync.isLoading) ...[
              _SectionHeaderSliver(
                title: 'Tendance',
                action: 'Tout voir',
                onAction: () => context.push(AppRoutes.salonsTrending),
              ),
              _TrendingSalonSliver(salonsAsync: trendingAsync, onRetry: refreshAll),
            ],

            // Top-rated — only when it has data or is loading
            if (!showGlobalLoading && !showGlobalError)
            if (hasTopRatedData || topRatedAsync.isLoading) ...[
              _SectionHeaderSliver(
                title: 'Les mieux notés',
                action: 'Tout voir',
                onAction: () => context.push(AppRoutes.salonsTopRated),
              ),
              _SalonListSliver(
                salonsAsync: topRatedAsync,
                take: 3,
                showDistance: false,
                onRetry: refreshAll,
              ),
            ],

            // Prestige — horizontal carousel at the bottom
            if (!showGlobalLoading && !showGlobalError)
            if (hasPrestigeData || prestigeAsync.isLoading || prestigeAsync.hasError) ...[
              _SectionHeaderSliver(
                title: 'Adresses prestige',
                action: 'Tout voir',
                onAction: () => context.push(AppRoutes.salonsPrestige),
              ),
              _FeaturedSalonSliver(
                salonsAsync: prestigeAsync,
                favoriteIds: favoriteIds,
                isAuthenticated: session.isAuthenticated,
                onRetry: refreshAll,
                onFavoriteTap: (salon) async {
                  if (!session.isAuthenticated) {
                    await showAuthRequiredSheet(
                      context,
                      onLogin: () => context.go(AppRoutes.auth),
                    );
                    return;
                  }
                  ref.read(favoritesProvider.notifier).toggle(salon.id);
                },
              ),
            ],

            SliverPadding(padding: EdgeInsets.only(bottom: bottomNavClearance)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final iconOnExpanded = AppColors.white;
    final iconOnCollapsed = AppColors.onSurface;
    final adaptiveIconColor = _iconColor(iconOnExpanded, iconOnCollapsed);
    final session = ref.watch(sessionProvider);
    final appBarBg = Color.lerp(
      AppColors.transparent,
      AppColors.surface,
      _collapseRatio,
    )!;

    return SliverAppBar(
      expandedHeight: _heroHeight.h,
      stretch: true,
      pinned: true,
      backgroundColor: appBarBg,
      elevation: 0,
      surfaceTintColor: AppColors.transparent,
      leadingWidth: 230.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 14.w, top: 8.h, bottom: 8.h),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(
                  alpha: (1 - _collapseRatio) * 0.18,
                ),
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'Beauté Avenue',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelLg.copyWith(
                  color: _iconColor(AppColors.white, AppColors.onSurface),
                ),
              ),
            ),
          ],
        ),
      ),
      title: const SizedBox.shrink(),
      centerTitle: false,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: _AdaptiveIconButton(
            icon: 'bell',
            color: adaptiveIconColor,
            hasBg: _collapseRatio < 0.6,
            onTap: () async {
              if (session.isAuthenticated) {
                context.push(AppRoutes.notifications);
                return;
              }
              await showAuthRequiredSheet(
                context,
                onLogin: () => context.go(AppRoutes.auth),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground],
        background: RepaintBoundary(
          child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1522337660859-02fbefca4702?q=80&w=1200',
              fit: BoxFit.cover,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 0.65, 1.0],
                  colors: [
                    AppColors.black.withValues(alpha: 0.42),
                    AppColors.transparent,
                    AppColors.black.withValues(alpha: 0.50),
                    AppColors.black.withValues(alpha: 0.80),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 52.h,
              left: 24.w,
              right: 24.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ref.watch(profileProvider).asData?.value?.city ?? 'Dakar',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.primaryLight,
                      letterSpacing: 2,
                    ),
                  ),
                  gapH4,
                  Text(
                    'Bonne journée,\nque désirez-vous ?',
                    style: AppTextStyles.displaySm.copyWith(
                      color: AppColors.white,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          color: AppColors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 32.r,
                decoration: BoxDecoration(
                  color: AppColors.neutral,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Location permission banner
// ─────────────────────────────────────────────────────────────────────────────

class _LocationBanner extends StatelessWidget {
  const _LocationBanner({required this.onDismiss, required this.onEnable});
  final VoidCallback onDismiss;
  final VoidCallback onEnable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            AppIcon('map-pin', size: 18, color: AppColors.primary),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'Activez la localisation pour voir les salons près de vous',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.primary),
              ),
            ),
            gapW8,
            AppPressable(
              onTap: onEnable,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'Activer',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.white,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 6.w),
            AppPressable(
              onTap: onDismiss,
              child: AppIcon(
                'close',
                size: 16,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Adaptive icon button
// ─────────────────────────────────────────────────────────────────────────────

class _AdaptiveIconButton extends StatelessWidget {
  const _AdaptiveIconButton({
    required this.icon,
    required this.color,
    required this.hasBg,
    required this.onTap,
  });

  final String icon;
  final Color color;
  final bool hasBg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          color: hasBg
              ? AppColors.white.withValues(alpha: 0.2)
              : AppColors.transparent,
          shape: BoxShape.circle,
          border: hasBg
              ? Border.all(
                  color: AppColors.white.withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Center(child: AppIcon(icon, size: 20, color: color)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Search bar
// ─────────────────────────────────────────────────────────────────────────────

class _SearchBarContent extends StatelessWidget {
  static const _searchHeroTag = 'home-search-hero';
  static const _filterHeroTag = 'home-filter-hero';

  const _SearchBarContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 4.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Expanded(
              child: Hero(
                tag: _searchHeroTag,
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.push(AppRoutes.search),
                      child: Row(
                        children: [
                          AppIcon(
                            'search',
                            size: 20,
                            color: AppColors.onSurfaceVariant,
                          ),
                          gapW12,
                          Expanded(
                            child: Text(
                              'Salon, prestation, quartier...',
                              style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => context.push('${AppRoutes.search}?openFilters=1'),
                child: Hero(
                  tag: _filterHeroTag,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final showLabel = constraints.maxWidth >= 84.w;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppIcon(
                                'filter',
                                size: 14,
                                color: AppColors.primary,
                              ),
                              if (showLabel) ...[
                                gapW4,
                                Text(
                                  'Filtrer',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeaderSliver extends StatelessWidget {
  const _SectionHeaderSliver({
    required this.title,
    required this.action,
    required this.onAction,
  });
  final String title, action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.headlineMd),
            AppPressable(
              onTap: onAction,
              child: Text(
                action,
                style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Generic salon list sliver (nearby / top-rated / trending)
// ─────────────────────────────────────────────────────────────────────────────

class _SalonListSliver extends StatelessWidget {
  const _SalonListSliver({
    required this.salonsAsync,
    required this.take,
    required this.showDistance,
    required this.onRetry,
  });

  final AsyncValue<List<SalonSummaryListResponseItemsInner>?> salonsAsync;
  final int take;
  final bool showDistance;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return salonsAsync.when(
      loading: () => SliverPadding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
        sliver: SliverList.separated(
          itemCount: take,
          separatorBuilder: (_, _) => gapH12,
          itemBuilder: (_, _) => const _SalonListCardSkeleton(),
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
              return RepaintBoundary(
                child: _SalonListCard(
                  salon: salon,
                  showDistance: showDistance,
                  onTap: () => context.push(AppRoutes.salon(salon.id)),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SalonListCard extends StatelessWidget {
  const _SalonListCard({
    required this.salon,
    required this.showDistance,
    required this.onTap,
  });

  final SalonSummaryListResponseItemsInner salon;
  final bool showDistance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final badge = showDistance ? distanceBadge(salon) : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20.r),
              ),
              child: salon.logoUrl != null && salon.logoUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: salon.logoUrl!,
                      width: 96.w,
                      height: 96.w,
                      memCacheWidth: 192,
                      memCacheHeight: 192,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => _SalonPlaceholderBox(
                        width: 96.w,
                        height: 96.w,
                      ),
                    )
                  : _SalonPlaceholderBox(width: 96.w, height: 96.w),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h),
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
                          _DistancePill(label: badge),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
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

class _DistancePill extends StatelessWidget {
  const _DistancePill({required this.label});
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

// ─────────────────────────────────────────────────────────────────────────────
// Prestige horizontal carousel
// ─────────────────────────────────────────────────────────────────────────────

class _FeaturedSalonSliver extends StatelessWidget {
  const _FeaturedSalonSliver({
    required this.salonsAsync,
    required this.favoriteIds,
    required this.isAuthenticated,
    required this.onRetry,
    required this.onFavoriteTap,
  });

  final AsyncValue<List<SalonSummaryListResponseItemsInner>> salonsAsync;
  final Set<String> favoriteIds;
  final bool isAuthenticated;
  final Future<void> Function() onRetry;
  final Future<void> Function(SalonSummaryListResponseItemsInner salon)
  onFavoriteTap;

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
            itemBuilder: (_, _) => const _FeaturedCardSkeleton(),
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
                  child: _FeaturedCard(
                    name: salon.name,
                    imageUrl: salon.logoUrl!,
                    rating: salon.averageRating.toStringAsFixed(1),
                    isFavorite: favoriteIds.contains(salon.id),
                    isAuthenticated: isAuthenticated,
                    onFavoriteTap: () => onFavoriteTap(salon),
                    onTap: () => context.push(AppRoutes.salon(salon.id)),
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

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.isFavorite,
    required this.isAuthenticated,
    required this.onFavoriteTap,
    required this.onTap,
  });

  final String name, imageUrl, rating;
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
                    borderRadius: BorderRadius.circular(20.r),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        'Prestige',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.black.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppIcon(
                                'star',
                                size: 11,
                                color: AppColors.secondary,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                rating,
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.white,
                                  fontSize: 11.sp,
                                ),
                              ),
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
                            isAuthenticated && isFavorite
                                ? 'heart-filled'
                                : 'heart',
                            size: 16,
                            color: isAuthenticated && isFavorite
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Text(name, style: AppTextStyles.headlineSm),
            SizedBox(height: 3.h),
            Text('Prestige', style: AppTextStyles.bodySm),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Trending horizontal carousel (compact landscape cards)
// ─────────────────────────────────────────────────────────────────────────────

class _TrendingSalonSliver extends StatelessWidget {
  const _TrendingSalonSliver({required this.salonsAsync, required this.onRetry});

  final AsyncValue<List<SalonSummaryListResponseItemsInner>> salonsAsync;
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
            itemBuilder: (_, _) => const _TrendingCardSkeleton(),
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
                  child: _TrendingCard(
                    salon: salon,
                    rank: i + 1,
                    onTap: () => context.push(AppRoutes.salon(salon.id)),
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

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({
    required this.salon,
    required this.rank,
    required this.onTap,
  });

  final SalonSummaryListResponseItemsInner salon;
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
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              // Image — square left panel
              ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(18.r),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: salon.logoUrl!,
                      width: 110.w,
                      height: 170.h,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => _SalonPlaceholderBox(
                        width: 110.w,
                        height: 170.h,
                      ),
                    ),
                    // Rank badge
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
              // Info — right panel
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        salon.category.toUpperCase(),
                        style: AppTextStyles.overline,
                      ),
                      gapH4,
                      Text(
                        salon.name,
                        style: AppTextStyles.headlineSm,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
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
                              '${salon.neighborhood ?? ''} ${salon.city}'
                                  .trim(),
                              style: AppTextStyles.bodySm,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      gapH8,
                      Row(
                        children: [
                          AppIcon('star', size: 12, color: AppColors.secondary),
                          SizedBox(width: 3.w),
                          Text(
                            salon.averageRating.toStringAsFixed(1),
                            style: AppTextStyles.labelMd,
                          ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Shimmer skeleton widgets
// ─────────────────────────────────────────────────────────────────────────────

Widget _shimmerBox({required double width, required double height, double radius = 8}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

Widget _shimmerWrap(Widget child) => Shimmer.fromColors(
  baseColor: AppColors.surfaceVariant,
  highlightColor: AppColors.outlineVariant,
  child: child,
);

class _SalonListCardSkeleton extends StatelessWidget {
  const _SalonListCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      Container(
        height: 96.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(20.r)),
              child: Container(
                width: 96.w,
                height: 96.w,
                color: AppColors.surface,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(width: 60.w, height: 10.h),
                    SizedBox(height: 8.h),
                    _shimmerBox(width: 120.w, height: 14.h),
                    SizedBox(height: 8.h),
                    _shimmerBox(width: 80.w, height: 10.h),
                    SizedBox(height: 6.h),
                    _shimmerBox(width: 50.w, height: 10.h),
                  ],
                ),
              ),
            ),
            SizedBox(width: 14.w),
          ],
        ),
      ),
    );
  }
}

class _TrendingCardSkeleton extends StatelessWidget {
  const _TrendingCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: 110.w,
          height: 170.h,
          color: AppColors.surface,
        ),
      ),
    );
  }
}

class _FeaturedCardSkeleton extends StatelessWidget {
  const _FeaturedCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: 160.w,
              height: 220.h,
              color: AppColors.surface,
            ),
          ),
          SizedBox(height: 10.h),
          _shimmerBox(width: 120.w, height: 14.h),
          SizedBox(height: 6.h),
          _shimmerBox(width: 60.w, height: 10.h),
        ],
      ),
    );
  }
}

// Branded placeholder used when a salon has no image or the image fails to load.
// Never shows a third-party stock photo — keeps trust signals honest.
class _SalonPlaceholderBox extends StatelessWidget {
  const _SalonPlaceholderBox({required this.width, required this.height});

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
