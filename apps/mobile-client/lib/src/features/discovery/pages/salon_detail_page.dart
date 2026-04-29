import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/utils/app_share.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/salon_map_card.dart';
import '../../booking/widgets/service_selection_sheet.dart';

class SalonDetailPage extends StatefulWidget {
  const SalonDetailPage({required this.salonId, super.key});

  final String salonId;

  @override
  State<SalonDetailPage> createState() => _SalonDetailPageState();
}

class _SalonDetailPageState extends State<SalonDetailPage> {
  bool _isFavorite = false;

  // TODO: replace with salon.gallery from API response
  static const _mockGallery = [
    'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=800',
    'https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=800',
    'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=800',
    'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?q=80&w=800',
    'https://images.unsplash.com/photo-1470259078422-826894b933aa?q=80&w=800',
  ];

  void _showBookingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (_) => ServiceSelectionSheet(salonId: widget.salonId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: _buildContent(),
              ),
            ],
          ),
          // Bottom CTA
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: _BottomCta(onBook: _showBookingSheet),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 360.h,
      pinned: true,
      backgroundColor: AppColors.neutral,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(8.r),
        child: _CircleIconBtn(
          icon: 'arrow-left',
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: _CircleIconBtn(
            icon: 'share',
            onTap: () {
              AppHaptics.light();
              AppShare.text(
                '✨ Découvrez Maison Kinka sur Beauté Avenue !\n'
                '📍 Almadies, Dakar\n'
                '⭐ 4.9 · 128 avis\n\n'
                'Réservez sur Beauté Avenue 💅',
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: _CircleIconBtn(
            icon: _isFavorite ? 'heart-filled' : 'heart',
            iconColor: _isFavorite ? AppColors.primary : null,
            onTap: () => setState(() => _isFavorite = !_isFavorite),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000',
              fit: BoxFit.cover,
            ),
            // Bottom fade into page
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                  colors: [Colors.transparent, AppColors.neutral],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 120.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              'COIFFURE & SPA',
              style: AppTextStyles.overline.copyWith(
                color: AppColors.onSecondaryContainer,
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // Name
          Text('Maison Kinka', style: AppTextStyles.displaySm),
          SizedBox(height: 8.h),

          // Rating + location row
          Row(
            children: [
              AppIcon('star', size: 15, color: AppColors.secondary),
              SizedBox(width: 4.w),
              Text('4.9', style: AppTextStyles.labelLg),
              Text(' · 128 avis', style: AppTextStyles.bodySm),
              SizedBox(width: 12.w),
              AppIcon('map-pin', size: 13, color: AppColors.onSurfaceVariant),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Almadies, Dakar',
                  style: AppTextStyles.bodySm,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Quick stats
          _QuickStats(),
          SizedBox(height: 24.h),

          // About
          Text('À propos', style: AppTextStyles.headlineMd),
          SizedBox(height: 10.h),
          Text(
            'Une expérience de beauté unique au cœur de Dakar. Maison Kinka allie artisanat traditionnel et techniques modernes pour sublimer votre éclat naturel dans un cadre architectural et apaisant.',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          SizedBox(height: 24.h),

          // Hours section
          Text('Horaires', style: AppTextStyles.headlineMd),
          SizedBox(height: 12.h),
          _HoursCard(),
          SizedBox(height: 24.h),

          // Photo gallery — replace with salon.gallery from API response
          if (_mockGallery.isNotEmpty) ...[
            Text('Photos', style: AppTextStyles.headlineMd),
            SizedBox(height: 12.h),
            _GalleryStrip(photos: _mockGallery),
            SizedBox(height: 24.h),
          ],

          // Popular services
          Text('Prestations populaires', style: AppTextStyles.headlineMd),
          SizedBox(height: 12.h),
          _ServicesPreview(),
          SizedBox(height: 24.h),

          // Location map
          Text('Localisation', style: AppTextStyles.headlineMd),
          SizedBox(height: 12.h),
          SalonMapCard(
            latitude: 14.7445,
            longitude: -17.4677,
            salonName: 'Maison Kinka',
            address: 'Rue 12, Almadies, Dakar',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _QuickStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      _Stat('128', 'Avis', 'star'),
      _Stat('6', 'Stylistes', 'user'),
      _Stat('3.2 km', 'Distance', 'map-pin'),
    ];

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: s != stats.last ? 10.w : 0),
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              children: [
                AppIcon(s.icon, size: 18, color: AppColors.primary),
                SizedBox(height: 6.h),
                Text(s.value, style: AppTextStyles.labelLg),
                Text(s.label, style: AppTextStyles.bodyXs),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Stat {
  const _Stat(this.value, this.label, this.icon);
  final String value, label, icon;
}

class _HoursCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hours = [
      ('Lundi – Vendredi', '09:00 – 19:00', true),
      ('Samedi', '10:00 – 18:00', true),
      ('Dimanche', 'Fermé', false),
    ];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: hours.map((h) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(h.$1, style: AppTextStyles.bodyMd),
                Text(
                  h.$2,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: h.$3 ? AppColors.onSurface : AppColors.error,
                    fontWeight: h.$3 ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ServicesPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const services = [
      ('Shampoing + Brushing', '45 min', '7 500 XOF'),
      ('Soin Visage Hydratant', '60 min', '15 000 XOF'),
      ('Manucure Complète', '45 min', '5 000 XOF'),
    ];

    return Column(
      children: services.map((s) {
        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.$1, style: AppTextStyles.labelLg),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        AppIcon('clock', size: 12, color: AppColors.onSurfaceVariant),
                        SizedBox(width: 3.w),
                        Text(s.$2, style: AppTextStyles.bodySm),
                      ],
                    ),
                  ],
                ),
              ),
              Text(s.$3, style: AppTextStyles.priceMd),
              SizedBox(width: 10.w),
              Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: AppIcon('add', size: 16, color: AppColors.primary),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _BottomCta extends StatelessWidget {
  const _BottomCta({required this.onBook});

  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.neutral.withOpacity(0),
            AppColors.neutral,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: onBook,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.onSurface,
            foregroundColor: AppColors.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon('calendar', size: 18, color: AppColors.surface),
              SizedBox(width: 10.w),
              Text('Réserver · À partir de 5 000 XOF'),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconBtn extends StatelessWidget {
  const _CircleIconBtn({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final String icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppIcon(
                icon,
                size: 17,
                color: iconColor ?? AppColors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _GalleryStrip extends StatelessWidget {
  const _GalleryStrip({required this.photos});

  final List<String> photos;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 110.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: photos.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              AppHaptics.light();
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.black87,
                  barrierDismissible: true,
                  pageBuilder: (_, __, ___) => _GalleryViewer(
                    photos: photos,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: Hero(
              tag: 'gallery_$index',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: CachedNetworkImage(
                  imageUrl: photos[index],
                  width: 110.r,
                  height: 110.h,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: AppColors.surfaceVariant,
                    width: 110.r,
                    height: 110.h,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.surfaceVariant,
                    width: 110.r,
                    height: 110.h,
                    child: Center(
                      child: AppIcon('image', size: 24, color: AppColors.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GalleryViewer extends StatefulWidget {
  const _GalleryViewer({required this.photos, required this.initialIndex});
  final List<String> photos;
  final int initialIndex;

  @override
  State<_GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<_GalleryViewer> {
  late final PageController _controller;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.black87),
          ),
          PageView.builder(
            controller: _controller,
            itemCount: widget.photos.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, index) {
              return Center(
                child: Hero(
                  tag: 'gallery_$index',
                  child: GestureDetector(
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: CachedNetworkImage(
                        imageUrl: widget.photos[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Dot indicators
          Positioned(
            bottom: 48.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.photos.length, (i) {
                final active = i == _current;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: active ? 20.w : 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: active ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                );
              }),
            ),
          ),
          // Close button
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: GestureDetector(
                  onTap: () {
                    AppHaptics.light();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
          ),
          // Counter badge
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${_current + 1} / ${widget.photos.length}',
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
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
