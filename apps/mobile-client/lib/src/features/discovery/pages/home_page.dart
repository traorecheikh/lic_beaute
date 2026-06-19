import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/location/location_service.dart';
import '../../../core/session/session_store.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../router/app_router.dart';
import '../../profile/providers/profile_provider.dart';
import '../../auth/widgets/auth_required_sheet.dart';
import '../../appointments/providers/pending_review_provider.dart';
import '../../appointments/utils/review_prompt_manager.dart';
import '../../appointments/widgets/review_sheet.dart';
import '../providers/favorites_provider.dart';
import '../providers/salon_list_provider.dart';
import '../widgets/home_sections/app_bar_sections.dart';
import '../widgets/home_sections/carousel_sections.dart';
import '../widgets/home_sections/location_banner.dart';
import '../widgets/home_sections/salon_list_section.dart';
import '../widgets/home_sections/section_header.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkLocationAutoPrompt();
      await _checkPendingReview();
    });
  }

  Future<void> _checkLocationAutoPrompt() async {
    final shouldPrompt = await LocationPromptManager.shouldShowPrompt();
    if (shouldPrompt && mounted) {
      await LocationPromptManager.recordPromptShown();
      if (mounted) {
        await context.push(AppRoutes.locationPermission);
        ref.invalidate(locationStatusProvider);
        ref.invalidate(nearbyProvider);
      }
    }
  }

  Future<void> _checkPendingReview() async {
    if (!mounted) return;
    final pending = await ref.read(pendingReviewProvider.future);
    if (pending == null || !mounted) return;
    await ReviewPromptManager.recordShown(pending.bookingId);
    if (!mounted) return;
    await showReviewSheet(
      context,
      bookingId: pending.bookingId,
      salonName: pending.salonName,
      serviceName: pending.serviceName,
      logoUrl: pending.logoUrl,
      proactive: true,
    );
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

    bool hasPhoto(SearchSuggestionsResponseTopMatchesInner s) =>
        s.logoUrl != null && s.logoUrl!.isNotEmpty;

    final hasNearby = nearbyAsync.asData?.value?.any(hasPhoto) == true;
    final hasTopRatedData = topRatedAsync.asData?.value.any(hasPhoto) == true;
    final hasTrendingData = trendingAsync.asData?.value.any(hasPhoto) == true;
    final hasPrestigeData = prestigeAsync.asData?.value.any(hasPhoto) == true;
    final hasAnyCatalogData = hasTopRatedData || hasTrendingData || hasPrestigeData;
    final allCoreLoading = topRatedAsync.isLoading &&
        trendingAsync.isLoading &&
        prestigeAsync.isLoading &&
        !hasAnyCatalogData;
    final allCoreFailed = topRatedAsync.hasError &&
        trendingAsync.hasError &&
        prestigeAsync.hasError &&
        !hasAnyCatalogData;
    final showGlobalLoading = allCoreLoading;
    final showGlobalError = !showGlobalLoading && allCoreFailed;
    final allLoaded = !topRatedAsync.isLoading &&
        !trendingAsync.isLoading &&
        !prestigeAsync.isLoading;
    final showGlobalEmpty = !showGlobalLoading &&
        !showGlobalError &&
        allLoaded &&
        !hasAnyCatalogData &&
        !hasNearby;

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
            const SliverToBoxAdapter(child: SearchBarContent()),

            if (showBanner)
              SliverToBoxAdapter(
                child: LocationBanner(
                  onDismiss: () =>
                      ref.read(locationBannerDismissedProvider.notifier).dismiss(),
                  onEnable: () async {
                    final granted = await context.push<bool>(AppRoutes.locationPermission);
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
                        AppStrings.loadingSalons,
                        style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
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
                    fallbackTitle: AppStrings.catalogUnavailable,
                    serverTitle: AppStrings.catalogUnavailableServer,
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
                    title: AppStrings.noSalonTitle,
                    subtitle: AppStrings.noSalonNearbySubtitle,
                    action: refreshAll,
                    actionLabel: AppStrings.refreshAction,
                  ),
                ),
              ),

            if (!showGlobalLoading && !showGlobalError)
              if (hasNearby) ...[
                SectionHeaderSliver(
                  title: AppStrings.nearbySection,
                  action: AppStrings.viewAllCta,
                  onAction: () => context.push(AppRoutes.salonsNearby),
                ),
                SalonListSliver(
                  salonsAsync: nearbyAsync,
                  take: 3,
                  showDistance: true,
                  onRetry: refreshAll,
                  heroPrefix: 'nearby_list',
                ),
              ] else if (permDenied && !showBanner) ...[
                // Location denied fallback — subtle card when banner is dismissed
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 4.h),
                    child: GestureDetector(
                      onTap: () async {
                        final granted = await context.push<bool>(AppRoutes.locationPermission);
                        if (granted == true) {
                          ref.invalidate(nearbyProvider);
                          ref.invalidate(locationStatusProvider);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.xl.r),
                          border: Border.all(
                            color: AppColors.outline.withValues(alpha: 0.08),
                            width: 1.2,
                          ),
                          boxShadow: AppShadows.card,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42.r,
                              height: 42.r,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: AppIcon('map-pin', size: 20, color: AppColors.primary)),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppStrings.activatePositionTitle,
                                    style: AppTextStyles.labelLg.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    AppStrings.activatePositionSubtitle,
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            AppIcon(
                              'chevron-right',
                              size: 16,
                              color: AppColors.outline,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],

            if (!showGlobalLoading && !showGlobalError)
              if (hasTrendingData || trendingAsync.isLoading) ...[
                SectionHeaderSliver(
                  title: AppStrings.trendingSection,
                  action: AppStrings.viewAllCta,
                  onAction: () => context.push(AppRoutes.salonsTrending),
                ),
                TrendingSalonSliver(salonsAsync: trendingAsync, onRetry: refreshAll),
              ],

            if (!showGlobalLoading && !showGlobalError)
              if (hasTopRatedData || topRatedAsync.isLoading) ...[
                SectionHeaderSliver(
                  title: AppStrings.topRatedSection,
                  action: AppStrings.viewAllCta,
                  onAction: () => context.push(AppRoutes.salonsTopRated),
                ),
                SalonListSliver(
                  salonsAsync: topRatedAsync,
                  take: 3,
                  showDistance: false,
                  onRetry: refreshAll,
                  heroPrefix: 'top_rated_list',
                ),
              ],

            if (!showGlobalLoading && !showGlobalError)
              if (hasPrestigeData || prestigeAsync.isLoading || prestigeAsync.hasError) ...[
                SectionHeaderSliver(
                  title: AppStrings.prestigeSection,
                  action: AppStrings.viewAllCta,
                  onAction: () => context.push(AppRoutes.salonsPrestige),
                ),
                FeaturedSalonSliver(
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
            Image.asset('assets/logo.png', width: 52.r, height: 52.r, fit: BoxFit.contain),
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
          child: AdaptiveIconButton(
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
                      AppColors.black.withValues(alpha: 0.45),
                      AppColors.black.withValues(alpha: 0.15),
                      AppColors.black.withValues(alpha: 0.55),
                      AppColors.black.withValues(alpha: 0.85),
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
                      ref.watch(cityFromLocationProvider).asData?.value ??
                          ref.watch(profileProvider).asData?.value?.city ??
                          'Dakar',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.primaryLight,
                        letterSpacing: 2,
                      ),
                    ),
                    gapH4,
                    Text(
                      AppStrings.homeGreeting,
                      style: AppTextStyles.displaySm.copyWith(
                        color: AppColors.white,
                        height: 1.1,
                        shadows: [
                          Shadow(
                            color: AppColors.black.withValues(alpha: 0.45),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
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
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                  ),
                  child: Center(
                    child: Container(
                      width: 48.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: AppColors.outline.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppRadius.full.r),
                      ),
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
