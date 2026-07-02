import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/utils/app_share.dart';
import '../../../core/widgets/debounced_action.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/salon_map_card.dart';
import '../../../core/session/session_store.dart';
import '../../../router/app_router.dart';
import '../../auth/widgets/auth_required_sheet.dart';
import '../../booking/providers/booking_funnel_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/salon_detail_provider.dart';
import '../widgets/salon_detail_buttons.dart';
import '../widgets/salon_detail_sections.dart';
import '../widgets/salon_gallery_viewer.dart';
import '../widgets/stale_data_notice.dart';

class SalonDetailPage extends ConsumerStatefulWidget {
  const SalonDetailPage({required this.salonId, this.heroTag, super.key});

  final String salonId;
  final String? heroTag;

  @override
  ConsumerState<SalonDetailPage> createState() => _SalonDetailPageState();
}

class _SalonDetailPageState extends ConsumerState<SalonDetailPage> {
  final _heroCtrl = PageController();
  final _shareKey = GlobalKey();
  int _heroPage = 0;

  @override
  void dispose() {
    _heroCtrl.dispose();
    super.dispose();
  }

  void _showBookingSheet(BuildContext context) {
    final salonId = widget.salonId.trim();
    if (salonId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.salonNotFound)));
      return;
    }

    debugPrint('[BOOKING_CTA] tap salonId=$salonId');
    ref.read(bookingFunnelProvider.notifier).reset();
    // Navigate immediately — don't block on prefetch
    if (!context.mounted) return;
    context.push('${AppRoutes.bookingService}?salonId=$salonId');
    // Fire-and-forget prefetch in background for faster subsequent loads
    ref
        .read(salonDetailResourceProvider(salonId).future)
        .timeout(const Duration(seconds: 12))
        .then((_) {
          debugPrint('[BOOKING_CTA] background_prefetch_ok salonId=$salonId');
        })
        .catchError((_) {
          debugPrint(
            '[BOOKING_CTA] background_prefetch_failed salonId=$salonId',
          );
        });
  }

  void _openGallery(BuildContext context, List<String> images, int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: AppColors.black,
        pageBuilder: (_, _, _) =>
            SalonGalleryViewer(images: images, initialIndex: index),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(salonDetailResourceProvider(widget.salonId));
    final session = ref.watch(sessionProvider);
    final favorites = session.isAuthenticated
        ? ref.watch(favoritesProvider)
        : const FavoritesState();
    final isFavorite = favorites.contains(widget.salonId);
    Future<void> refreshSalon() =>
        ref.refresh(salonDetailResourceProvider(widget.salonId).future);

    return AppScaffold(
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Padding(
          padding: EdgeInsets.all(24.r),
          child: AppErrorState(
            error: error,
            fallbackTitle: AppStrings.loadSalonDetailError,
            serverTitle: AppStrings.salonDetailServer,
            onRetry: refreshSalon,
          ),
        ),
        data: (resource) {
          final salon = resource.data;
          if (salon == null) {
            return Center(child: Text(AppStrings.salonNotFound));
          }

          final galleryList = salon.gallery.toList();
          final images = galleryList.isNotEmpty
              ? galleryList
              : (salon.logoUrl != null && salon.logoUrl!.isNotEmpty
                    ? [salon.logoUrl!]
                    : <String>[]);
          final shareAddress = salon.address.trim();
          final shareNeighborhood = salon.neighborhood?.trim() ?? '';
          final preciseShareLocation = [
            if (shareAddress.isNotEmpty) shareAddress,
            if (shareNeighborhood.isNotEmpty) shareNeighborhood,
            salon.city.trim(),
          ].join(', ');

          return Stack(
            children: [
              RefreshIndicator.adaptive(
                color: AppColors.primary,
                onRefresh: refreshSalon,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    if (resource.isStale && resource.cachedAt != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                          child: StaleDataNotice(cachedAt: resource.cachedAt!),
                        ),
                      ),

                    // ── Swipeable hero ───────────────────────────────────────
                    SliverAppBar(
                      expandedHeight: 300.h,
                      pinned: true,
                      backgroundColor: AppColors.neutral,
                      elevation: 0,
                      leading: SalonCircleBtn(
                        icon: 'arrow-left',
                        semanticLabel: 'Retour',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      actions: [
                        SalonCircleBtn(
                          icon: 'share',
                          semanticLabel: 'Partager le salon',
                          onTap: () {
                            AppHaptics.light();
                            AppShare.card(
                              context: context,
                              repaintKey: _shareKey,
                              text:
                                  'Découvrez ${salon.name} sur Beauté Avenue.\n$preciseShareLocation\nhttps://beauteavenue.sn',
                            );
                          },
                        ),
                        SizedBox(width: 6.w),
                        SalonCircleBtn(
                          icon: isFavorite ? 'heart-filled' : 'heart',
                          semanticLabel: isFavorite
                              ? 'Retirer des favoris'
                              : 'Ajouter aux favoris',
                          iconColor: isFavorite ? AppColors.primary : null,
                          onTap: () async {
                            AppHaptics.light();
                            if (!session.isAuthenticated) {
                              await showAuthRequiredSheet(
                                context,
                                onLogin: () => context.go(AppRoutes.auth),
                              );
                              return;
                            }
                            ref
                                .read(favoritesProvider.notifier)
                                .toggle(widget.salonId);
                          },
                        ),
                        SizedBox(width: 12.w),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Swipeable photo strip
                            if (images.isEmpty)
                              Container(color: AppColors.surfaceVariant)
                            else
                              PageView.builder(
                                controller: _heroCtrl,
                                onPageChanged: (i) =>
                                    setState(() => _heroPage = i),
                                itemCount: images.length,
                                itemBuilder: (_, i) {
                                  final imgWidget = CachedNetworkImage(
                                    imageUrl: images[i],
                                    memCacheWidth: 800,
                                    fit: BoxFit.cover,
                                  );
                                  if (i == 0 && widget.heroTag != null) {
                                    return Hero(
                                      tag: widget.heroTag!,
                                      child: Material(
                                        color: AppColors.transparent,
                                        child: imgWidget,
                                      ),
                                    );
                                  }
                                  return imgWidget;
                                },
                              ),

                            // Bottom gradient → bleeds into rounded card
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 100.h,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.transparent,
                                      AppColors.neutral.withValues(alpha: 0.85),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Page dots
                            if (images.length > 1)
                              Positioned(
                                bottom: 44.h,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    images.length,
                                    (i) => AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 220,
                                      ),
                                      width: i == _heroPage ? 20.w : 5.w,
                                      height: 4.h,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: i == _heroPage
                                            ? AppColors.white
                                            : AppColors.white.withValues(
                                                alpha: 0.45,
                                              ),
                                        borderRadius: BorderRadius.circular(
                                          2.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // Compact gallery counter. Fixed height and an
                            // icon keep the control visibly pill-shaped instead
                            // of collapsing into an oversized circle.
                            if (images.length > 1)
                              Positioned(
                                bottom: 42.h,
                                right: 18.w,
                                child: AppPressable(
                                  onTap: () =>
                                      _openGallery(context, images, _heroPage),
                                  minSize: const Size(56, 34),
                                  child: Container(
                                    height: 34.h,
                                    constraints: BoxConstraints(minWidth: 62.w),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 11.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.black.withValues(
                                        alpha: 0.58,
                                      ),
                                      borderRadius: BorderRadius.circular(17.r),
                                      border: Border.all(
                                        color: AppColors.white.withValues(
                                          alpha: 0.20,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AppIcon(
                                          'image',
                                          size: 13,
                                          color: AppColors.white,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          '${_heroPage + 1}/${images.length}',
                                          style: AppTextStyles.labelSm.copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // ── Content card ─────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Transform.translate(
                        offset: Offset(0, -32.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.neutral,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(AppRadius.xxl.r),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Handle
                              Center(
                                child: Container(
                                  width: 36.w,
                                  height: 4.h,
                                  margin: EdgeInsets.only(
                                    top: 12.h,
                                    bottom: 20.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.outline,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.xs.r,
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 24.w),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // Category chip
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryContainer,
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      child: Text(
                                        salon.category.toUpperCase(),
                                        style: AppTextStyles.overline.copyWith(
                                          color:
                                              AppColors.onSecondaryContainer,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),

                                    // Name
                                    Text(
                                      salon.name,
                                      style: AppTextStyles.displaySm,
                                    ),
                                    SizedBox(height: 10.h),

                                    // Rating + location
                                    Row(
                                      children: [
                                        if (salon.reviewCount >= 3) ...[
                                          AppIcon(
                                            'star',
                                            size: 14,
                                            color: AppColors.secondary,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            salon.averageRating
                                                .toStringAsFixed(1),
                                            style: AppTextStyles.labelMd
                                                .copyWith(
                                                  color: AppColors.onSurface,
                                                ),
                                          ),
                                          SizedBox(width: 14.w),
                                        ],
                                        AppIcon(
                                          'map-pin',
                                          size: 13,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                        SizedBox(width: 4.w),
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
                                    SizedBox(height: 18.h),

                                    // Inline stats
                                    SalonInlineStats(
                                      staffCount: salon.staff.length,
                                      servicesCount: salon.services.length,
                                    ),
                                    SizedBox(height: 24.h),

                                    // About
                                    SalonSectionLabel(
                                      AppStrings.aboutSection,
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      salon.description,
                                      style: AppTextStyles.bodyMd.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                        height: 1.65,
                                      ),
                                    ),
                                    SizedBox(height: 28.h),
                                  ],
                                ),
                              ),

                              // ── Gallery strip ────────────────────────────
                              if (images.isNotEmpty) ...[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                  ),
                                  child: Row(
                                    children: [
                                      SalonSectionLabel(
                                        AppStrings.photosSection,
                                      ),
                                      const Spacer(),
                                      AppPressable(
                                        onTap: () => _openGallery(
                                            context, images, 0),
                                        child: Text(
                                          AppStrings.viewAllCtaShort,
                                          style: AppTextStyles.bodySm.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                SizedBox(
                                  height: 120.h,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                    ),
                                    itemCount: images.length,
                                    separatorBuilder: (_, _) =>
                                        SizedBox(width: 10.w),
                                    itemBuilder: (_, i) => GestureDetector(
                                      onTap: () =>
                                          _openGallery(context, images, i),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          18.r,
                                        ),
                                        child: Hero(
                                          tag:
                                              'salon_image_strip_${images[i]}',
                                          child: CachedNetworkImage(
                                            imageUrl: images[i],
                                            width: 160.w,
                                            height: 120.h,
                                            memCacheWidth: 320,
                                            memCacheHeight: 240,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 32.h),
                              ],

                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 24.w),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // Services
                                    SalonSectionLabel(
                                      AppStrings.popularServices,
                                    ),
                                    SizedBox(height: 12.h),
                                    ...salon.services
                                        .take(5)
                                        .map(
                                          (s) => SalonServiceRow(
                                            name: s.name,
                                            duration:
                                                '${s.durationMinutes} min',
                                            price:
                                                '${s.priceXof.toInt()} XOF',
                                          ),
                                        ),
                                    SizedBox(height: 28.h),

                                    // Map
                                    SalonSectionLabel(
                                      AppStrings.locationSection,
                                    ),
                                    SizedBox(height: 12.h),
                                    SalonMapCard(
                                      latitude: salon.latitude?.toDouble() ??
                                          14.7167,
                                      longitude: salon.longitude?.toDouble() ??
                                          -17.4677,
                                      salonName: salon.name,
                                      address: salon.address,
                                    ),
                                    SizedBox(height: 120.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Off-screen share card (pre-rendered via RepaintBoundary)
              Positioned(
                left: -9999,
                top: 0,
                child: RepaintBoundary(
                  key: _shareKey,
                  child: SalonShareCard(
                    salonName: salon.name,
                    category: salon.category,
                    location: preciseShareLocation,
                    photoUrl: images.isNotEmpty ? images.first : null,
                    logoUrl: salon.logoUrl,
                    rating: salon.reviewCount >= 3
                        ? salon.averageRating.toDouble()
                        : null,
                    reviewCount: salon.reviewCount >= 3 ? salon.reviewCount : null,
                  ),
                ),
              ),

              // ── Sticky CTA ────────────────────────────────────────────────
              Positioned(
                left: 24.w,
                right: 24.w,
                bottom: 32.h,
                child: Semantics(
                  button: true,
                  label: AppStrings.bookCta,
                  child: SalonBottomCta(
                    price: salon.services.isNotEmpty
                        ? '${AppStrings.fromPrice}${salon.services.first.priceXof.toInt()} XOF'
                        : null,
                    onBook: debouncedAction(() => _showBookingSheet(context)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
