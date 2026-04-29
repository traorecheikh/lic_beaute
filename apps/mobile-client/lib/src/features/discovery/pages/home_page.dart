import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollCtrl = ScrollController();
  // 0 = fully expanded (white icons on image), 1 = fully collapsed (dark icons on bg)
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

  // Interpolate color based on collapse
  Color _iconColor(Color onExpanded, Color onCollapsed) =>
      Color.lerp(onExpanded, onCollapsed, _collapseRatio)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: CustomScrollView(
        controller: _scrollCtrl,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          _SearchBarSliver(),
          _CategoriesSliver(),
          _SectionHeaderSliver(title: 'Près de vous', action: 'Tout voir', onAction: () => context.push(AppRoutes.salonsNearby)),
          _SalonListSliver(),
          _SectionHeaderSliver(title: 'Adresses prestige', action: 'Tout voir', onAction: () => context.push(AppRoutes.salonsPrestige)),
          _FeaturedSalonSliver(),
          SliverPadding(padding: EdgeInsets.only(bottom: 100.h)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    final iconOnExpanded = Colors.white;
    final iconOnCollapsed = AppColors.onSurface;
    final adaptiveIconColor = _iconColor(iconOnExpanded, iconOnCollapsed);
    final appBarBg = Color.lerp(Colors.transparent, AppColors.surface, _collapseRatio)!;
    final titleOpacity = _collapseRatio;

    return SliverAppBar(
      expandedHeight: _heroHeight.h,
      stretch: true,
      pinned: true,
      backgroundColor: appBarBg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      // Logo — white backdrop ring fades away as page collapses
      leading: Padding(
        padding: EdgeInsets.all(10.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity((1 - _collapseRatio) * 0.18),
            shape: BoxShape.circle,
          ),
          child: Image.asset('assets/logo.png', fit: BoxFit.contain),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: _AdaptiveIconButton(
            icon: 'bell',
            color: adaptiveIconColor,
            hasBg: _collapseRatio < 0.6,
            onTap: () => context.push(AppRoutes.notifications),
          ),
        ),
      ],
      // Title slides in as we collapse
      title: Opacity(
        opacity: titleOpacity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Beauté Avenue',
              style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurface),
            ),
          ],
        ),
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground],
        background: RepaintBoundary(
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: 'https://images.unsplash.com/photo-1522337660859-02fbefca4702?q=80&w=1200',
                fit: BoxFit.cover,
              ),
              // Progressive dark gradient — ensures text is ALWAYS readable
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.35, 0.65, 1.0],
                    colors: [
                      Colors.black.withOpacity(0.42),
                      Colors.transparent,
                      Colors.black.withOpacity(0.50),
                      Colors.black.withOpacity(0.80),
                    ],
                  ),
                ),
              ),
              // Hero text
              Positioned(
                bottom: 52.h,
                left: 24.w,
                right: 24.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dakar',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.primaryLight,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Bonne journée,\nque désirez-vous ?',
                      style: AppTextStyles.displaySm.copyWith(
                        color: Colors.white,
                        height: 1.1,
                        shadows: [
                          Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Rounded scoop transition
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
// Adaptive icon button (glass bg when over image, plain when collapsed)
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          color: hasBg ? Colors.white.withOpacity(0.2) : Colors.transparent,
          shape: BoxShape.circle,
          border: hasBg
              ? Border.all(color: Colors.white.withOpacity(0.3), width: 1)
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

class _SearchBarSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 4.h),
        child: GestureDetector(
          onTap: () => context.push(AppRoutes.search),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              children: [
                AppIcon('search', size: 20, color: AppColors.onSurfaceVariant),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Salon, prestation, quartier...',
                    style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIcon('filter', size: 14, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      Text('Filtrer',
                          style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.primary, fontSize: 11.sp)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category pills
// ─────────────────────────────────────────────────────────────────────────────

class _CategoriesSliver extends StatefulWidget {
  @override
  State<_CategoriesSliver> createState() => _CategoriesSliverState();
}

class _CategoriesSliverState extends State<_CategoriesSliver> {
  int _selected = 0;
  static const _categories = [
    _Category('Tous', 'sparkle'),
    _Category('Coiffure', 'user'),
    _Category('Esthétique', 'star'),
    _Category('Spa', 'heart'),
    _Category('Ongles', 'sparkle'),
    _Category('Maquillage', 'star'),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 52.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => SizedBox(width: 8.w),
          itemBuilder: (_, i) {
            final cat = _categories[i];
            final isActive = i == _selected;
            return GestureDetector(
              onTap: () => setState(() => _selected = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.onSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: isActive ? null : AppShadows.sm,
                ),
                child: Row(
                  children: [
                    AppIcon(cat.icon, size: 14,
                        color: isActive ? AppColors.surface : AppColors.onSurfaceVariant),
                    SizedBox(width: 6.w),
                    Text(cat.label,
                        style: AppTextStyles.labelMd.copyWith(
                            color: isActive ? AppColors.surface : AppColors.onSurface)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Category {
  const _Category(this.label, this.icon);
  final String label, icon;
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeaderSliver extends StatelessWidget {
  const _SectionHeaderSliver(
      {required this.title, required this.action, required this.onAction});
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
            GestureDetector(
              onTap: onAction,
              child: Text(action,
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nearby list
// ─────────────────────────────────────────────────────────────────────────────

class _SalonListSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverList.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, i) => RepaintBoundary(
          child: _SalonListCard(
            name: i == 0 ? 'Maison Kinka' : i == 1 ? 'Studio Élégance' : 'Belle & Co',
            category: i == 0 ? 'Coiffure & Spa' : i == 1 ? 'Esthétique' : 'Ongles & Beauté',
            location: 'Almadies, Dakar',
            rating: i == 0 ? '4.9' : i == 1 ? '4.7' : '4.8',
            reviews: i == 0 ? '128' : i == 1 ? '94' : '76',
            imageUrl: i == 0
                ? 'https://images.unsplash.com/photo-1600948836101-f9ff15e720f7?q=80&w=600'
                : 'https://images.unsplash.com/photo-1580618672591-eb180b1a973f?q=80&w=600',
            onTap: () => context.push(AppRoutes.salon('$i')),
          ),
        ),
      ),
    );
  }
}

class _SalonListCard extends StatelessWidget {
  const _SalonListCard({
    required this.name,
    required this.category,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.onTap,
  });

  final String name, category, location, rating, reviews, imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadius.horizontal(left: Radius.circular(20.r)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 96.w,
                height: 96.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.toUpperCase(), style: AppTextStyles.overline),
                    SizedBox(height: 2.h),
                    Text(name, style: AppTextStyles.headlineSm),
                    SizedBox(height: 6.h),
                    Row(children: [
                      AppIcon('map-pin', size: 12, color: AppColors.onSurfaceVariant),
                      SizedBox(width: 3.w),
                      Expanded(
                          child: Text(location,
                              style: AppTextStyles.bodySm,
                              overflow: TextOverflow.ellipsis)),
                    ]),
                    SizedBox(height: 4.h),
                    Row(children: [
                      AppIcon('star', size: 13, color: AppColors.secondary),
                      SizedBox(width: 3.w),
                      Text(rating, style: AppTextStyles.labelMd),
                      SizedBox(width: 4.w),
                      Text('($reviews)', style: AppTextStyles.bodySm),
                    ]),
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

// ─────────────────────────────────────────────────────────────────────────────
// Featured horizontal
// ─────────────────────────────────────────────────────────────────────────────

class _FeaturedSalonSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 280.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: 3,
          separatorBuilder: (_, __) => SizedBox(width: 14.w),
          itemBuilder: (context, i) => RepaintBoundary(
            child: _FeaturedCard(
              name: i == 0 ? 'Maison Kinka' : i == 1 ? 'Le Loft Dakar' : 'Salon Prestige',
              tag: i == 0 ? 'Coup de cœur' : i == 1 ? 'Nouveau' : 'Premium',
              imageUrl: i == 0
                  ? 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=800'
                  : 'https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=800',
              rating: i == 0 ? '4.9' : '4.8',
              price: 'À partir de 5 000 XOF',
              onTap: () => context.push(AppRoutes.salon('$i')),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.name,
    required this.tag,
    required this.imageUrl,
    required this.rating,
    required this.price,
    required this.onTap,
  });

  final String name, tag, imageUrl, rating, price;
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
                    child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 12.h, left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(tag,
                          style: AppTextStyles.labelSm.copyWith(fontSize: 10.sp)),
                    ),
                  ),
                  Positioned(
                    top: 12.h, right: 12.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppIcon('star', size: 11, color: AppColors.secondary),
                              SizedBox(width: 3.w),
                              Text(rating,
                                  style: AppTextStyles.labelSm.copyWith(
                                      color: Colors.white, fontSize: 11.sp)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12.h, right: 12.w,
                    child: Container(
                      width: 34.r, height: 34.r,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.sm),
                      child: Center(
                          child: AppIcon('heart', size: 16,
                              color: AppColors.onSurfaceVariant)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Text(name, style: AppTextStyles.headlineSm),
            SizedBox(height: 3.h),
            Text(price, style: AppTextStyles.bodySm),
          ],
        ),
      ),
    );
  }
}
