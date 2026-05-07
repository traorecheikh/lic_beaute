import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/utils/app_share.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/salon_map_card.dart';
import '../../../router/app_router.dart';
import '../../booking/providers/booking_funnel_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/salon_detail_provider.dart';
import '../widgets/stale_data_notice.dart';

class SalonDetailPage extends ConsumerStatefulWidget {
  const SalonDetailPage({required this.salonId, super.key});

  final String salonId;

  @override
  ConsumerState<SalonDetailPage> createState() => _SalonDetailPageState();
}

class _SalonDetailPageState extends ConsumerState<SalonDetailPage> {
  final _heroCtrl = PageController();
  int _heroPage = 0;

  @override
  void dispose() {
    _heroCtrl.dispose();
    super.dispose();
  }

  void _showBookingSheet(BuildContext context) {
    ref.read(bookingFunnelProvider.notifier).reset();
    context.push('${AppRoutes.bookingService}?salonId=${widget.salonId}');
  }

  void _openGallery(BuildContext context, List<String> images, int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, _, _) =>
            _GalleryViewer(images: images, initialIndex: index),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(salonDetailResourceProvider(widget.salonId));
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(widget.salonId);
    Future<void> refreshSalon() =>
        ref.refresh(salonDetailResourceProvider(widget.salonId).future);

    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: EdgeInsets.all(24.r),
          child: AppErrorState(
            error: error,
            fallbackTitle: 'Impossible de charger le salon',
            serverTitle: 'La fiche salon est indisponible',
            onRetry: refreshSalon,
          ),
        ),
        data: (resource) {
          final salon = resource.data;
          if (salon == null) {
            return const Center(child: Text('Salon introuvable.'));
          }

          final galleryList = salon.gallery.toList();
          final images = galleryList.isNotEmpty
              ? galleryList
              : (salon.logoUrl != null && salon.logoUrl!.isNotEmpty
                    ? [salon.logoUrl!]
                    : <String>[]);

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
                      leading: _CircleBtn(
                        icon: 'arrow-left',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      actions: [
                        _CircleBtn(
                          icon: 'share',
                          onTap: () {
                            AppHaptics.light();
                            AppShare.text(
                              'Découvrez ${salon.name} sur Beauté Avenue.\n${salon.city}${salon.neighborhood != null ? ', ${salon.neighborhood}' : ''}',
                            );
                          },
                        ),
                        SizedBox(width: 6.w),
                        _CircleBtn(
                          icon: isFavorite ? 'heart-filled' : 'heart',
                          iconColor: isFavorite ? AppColors.primary : null,
                          onTap: () {
                            AppHaptics.light();
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
                                itemBuilder: (_, i) => CachedNetworkImage(
                                  imageUrl: images[i],
                                  fit: BoxFit.cover,
                                ),
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
                                      Colors.transparent,
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
                                            ? Colors.white
                                            : Colors.white.withValues(
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

                            // Photo count badge (tappable → viewer)
                            if (images.length > 1)
                              Positioned(
                                bottom: 48.h,
                                right: 16.w,
                                child: GestureDetector(
                                  onTap: () =>
                                      _openGallery(context, images, _heroPage),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      '${_heroPage + 1} / ${images.length}',
                                      style: AppTextStyles.bodyXs.copyWith(
                                        color: Colors.white,
                                      ),
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
                              top: Radius.circular(32.r),
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
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          color: AppColors.onSecondaryContainer,
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
                                        AppIcon(
                                          'star',
                                          size: 14,
                                          color: AppColors.secondary,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          salon.averageRating.toStringAsFixed(
                                            1,
                                          ),
                                          style: AppTextStyles.labelMd.copyWith(
                                            color: AppColors.onSurface,
                                          ),
                                        ),
                                        SizedBox(width: 14.w),
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

                                    // Inline stats — no Material cards
                                    _InlineStats(
                                      staffCount: salon.staff.length,
                                      servicesCount: salon.services.length,
                                    ),
                                    SizedBox(height: 24.h),

                                    // About
                                    _SectionLabel('À propos'),
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
                                      _SectionLabel('Photos'),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () =>
                                            _openGallery(context, images, 0),
                                        child: Text(
                                          'Voir tout',
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
                                          tag: 'salon_image_strip_${images[i]}',
                                          child: CachedNetworkImage(
                                            imageUrl: images[i],
                                            width: 160.w,
                                            height: 120.h,
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
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Services
                                    _SectionLabel('Prestations populaires'),
                                    SizedBox(height: 12.h),
                                    ...salon.services
                                        .take(5)
                                        .map(
                                          (s) => _ServiceRow(
                                            name: s.name,
                                            duration:
                                                '${s.durationMinutes} min',
                                            price: '${s.priceXof.toInt()} XOF',
                                          ),
                                        ),
                                    SizedBox(height: 28.h),

                                    // Map
                                    _SectionLabel('Localisation'),
                                    SizedBox(height: 12.h),
                                    SalonMapCard(
                                      latitude:
                                          salon.latitude?.toDouble() ?? 14.7167,
                                      longitude:
                                          salon.longitude?.toDouble() ??
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

              // ── Sticky CTA ────────────────────────────────────────────────
              Positioned(
                left: 24.w,
                right: 24.w,
                bottom: 32.h,
                child: _BottomCta(
                  price: salon.services.isNotEmpty
                      ? 'À partir de ${salon.services.first.priceXof.toInt()} XOF'
                      : null,
                  onBook: () => _showBookingSheet(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Gallery viewer ───────────────────────────────────────────────────────────

class _GalleryViewer extends StatefulWidget {
  const _GalleryViewer({required this.images, required this.initialIndex});
  final List<String> images;
  final int initialIndex;

  @override
  State<_GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<_GalleryViewer> {
  late final PageController _ctrl;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _ctrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: widget.images.length,
            itemBuilder: (_, i) => InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: widget.images[i],
                fit: BoxFit.contain,
                placeholder: (_, _) => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white38,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          ),

          // Close button
          Positioned(
            top: topPad + 10,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),

          // Counter
          Positioned(
            top: topPad + 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_current + 1} / ${widget.images.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ),

          // Bottom dots
          if (widget.images.length > 1)
            Positioned(
              bottom: botPad + 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: i == _current ? 18 : 5,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i == _current
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Shared helpers ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTextStyles.headlineSm);
}

class _InlineStats extends StatelessWidget {
  const _InlineStats({required this.staffCount, required this.servicesCount});

  final int staffCount;
  final int servicesCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIcon('sparkle', size: 13, color: AppColors.primary),
        SizedBox(width: 5.w),
        Text(
          '$servicesCount prestation${servicesCount > 1 ? 's' : ''}',
          style: AppTextStyles.bodyMd,
        ),
        SizedBox(width: 12.w),
        Container(
          width: 3.r,
          height: 3.r,
          decoration: BoxDecoration(
            color: AppColors.outline,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 12.w),
        AppIcon('user', size: 13, color: AppColors.primary),
        SizedBox(width: 5.w),
        Text(
          '$staffCount spécialiste${staffCount > 1 ? 's' : ''}',
          style: AppTextStyles.bodyMd,
        ),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.name,
    required this.duration,
    required this.price,
  });

  final String name, duration, price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.labelLg),
                SizedBox(height: 2.h),
                Text(
                  duration,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: AppTextStyles.priceMd.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap, this.iconColor});

  final String icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            shape: BoxShape.circle,
            boxShadow: AppShadows.sm,
          ),
          child: Center(
            child: AppIcon(
              icon,
              size: 18,
              color: iconColor ?? AppColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomCta extends StatelessWidget {
  const _BottomCta({required this.onBook, this.price});

  final VoidCallback onBook;
  final String? price;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.onSurface,
        foregroundColor: AppColors.surface,
        elevation: 4,
        shadowColor: AppColors.onSurface.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h),
      ),
      onPressed: onBook,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon('calendar', color: AppColors.surface, size: 18),
          SizedBox(width: 8.w),
          Text(
            price != null ? 'Réserver · $price' : 'Choisir une prestation',
            style: AppTextStyles.labelLg.copyWith(color: AppColors.surface),
          ),
        ],
      ),
    );
  }
}
