import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';

enum SalonListFilter { nearby, prestige }

// ── Mock data pool ────────────────────────────────────────────────────────────

class _Salon {
  const _Salon({
    required this.id,
    required this.name,
    required this.category,
    required this.neighborhood,
    required this.rating,
    required this.reviewCount,
    required this.priceFrom,
    required this.imageUrl,
    required this.distanceKm,
    this.tag,
  });
  final String id, name, category, neighborhood, imageUrl;
  final double rating, distanceKm;
  final int reviewCount, priceFrom;
  final String? tag;
}

// Full pool — sorted by distance for nearby, by tier for prestige.
// Extend this list freely; pagination will slice it in pages of _pageSize.
const _nearbyPool = [
  _Salon(id: 'n1', name: 'Studio Ndiaye', category: 'Coiffure', neighborhood: 'Point E', rating: 4.7, reviewCount: 84, priceFrom: 3500, distanceKm: 1.8, imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600'),
  _Salon(id: 'n2', name: 'Ongles & Co', category: 'Ongles', neighborhood: 'Mermoz', rating: 4.6, reviewCount: 41, priceFrom: 4000, distanceKm: 2.4, imageUrl: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?q=80&w=600'),
  _Salon(id: 'n3', name: 'La Belle Époque', category: 'Coiffure & Spa', neighborhood: 'Fann', rating: 4.5, reviewCount: 33, priceFrom: 6000, distanceKm: 2.9, imageUrl: 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=600'),
  _Salon(id: 'n4', name: 'Maison Kinka', category: 'Coiffure & Spa', neighborhood: 'Almadies', rating: 4.9, reviewCount: 128, priceFrom: 5000, distanceKm: 3.2, imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=600'),
  _Salon(id: 'n5', name: 'Oasis Spa', category: 'Spa', neighborhood: 'Sacré-Cœur', rating: 4.9, reviewCount: 97, priceFrom: 12000, distanceKm: 4.0, imageUrl: 'https://images.unsplash.com/photo-1470259078422-826894b933aa?q=80&w=600'),
  _Salon(id: 'n6', name: 'Espace Lumière', category: 'Soins', neighborhood: 'Plateau', rating: 4.8, reviewCount: 52, priceFrom: 8000, distanceKm: 5.1, imageUrl: 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?q=80&w=600'),
  _Salon(id: 'n7', name: 'Beauté Dakar', category: 'Esthétique', neighborhood: 'Ouakam', rating: 4.4, reviewCount: 29, priceFrom: 3000, distanceKm: 5.6, imageUrl: 'https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=600'),
  _Salon(id: 'n8', name: 'Salon Élégance', category: 'Coiffure', neighborhood: 'Liberté 6', rating: 4.3, reviewCount: 18, priceFrom: 2500, distanceKm: 6.1, imageUrl: 'https://images.unsplash.com/photo-1619451334792-150fd785ee74?q=80&w=600'),
  _Salon(id: 'n9', name: 'Tendance & Style', category: 'Coiffure', neighborhood: 'Pikine', rating: 4.2, reviewCount: 22, priceFrom: 2000, distanceKm: 7.3, imageUrl: 'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?q=80&w=600'),
  _Salon(id: 'n10', name: 'Lumia Beauty', category: 'Soins & Ongles', neighborhood: 'Guédiawaye', rating: 4.5, reviewCount: 44, priceFrom: 4500, distanceKm: 8.0, imageUrl: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=600'),
  _Salon(id: 'n11', name: 'Nala Beauté', category: 'Spa', neighborhood: 'Thiaroye', rating: 4.1, reviewCount: 15, priceFrom: 5000, distanceKm: 9.2, imageUrl: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=600'),
  _Salon(id: 'n12', name: 'Éclat Naturel', category: 'Soins', neighborhood: 'Rufisque', rating: 4.0, reviewCount: 11, priceFrom: 3500, distanceKm: 11.4, imageUrl: 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?q=80&w=600'),
];

const _prestigePool = [
  _Salon(id: 'p1', name: 'Maison Kinka', category: 'Coiffure & Spa', neighborhood: 'Almadies', rating: 4.9, reviewCount: 128, priceFrom: 5000, distanceKm: 3.2, imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=600', tag: 'Coup de cœur'),
  _Salon(id: 'p2', name: 'Oasis Spa', category: 'Spa', neighborhood: 'Sacré-Cœur', rating: 4.9, reviewCount: 97, priceFrom: 12000, distanceKm: 4.0, imageUrl: 'https://images.unsplash.com/photo-1470259078422-826894b933aa?q=80&w=600', tag: 'Premium'),
  _Salon(id: 'p3', name: 'Le Loft Dakar', category: 'Soins & Spa', neighborhood: 'Plateau', rating: 4.8, reviewCount: 63, priceFrom: 15000, distanceKm: 5.4, imageUrl: 'https://images.unsplash.com/photo-1580618672591-eb180b1a973f?q=80&w=600', tag: 'Nouveau'),
  _Salon(id: 'p4', name: 'Espace Lumière', category: 'Soins', neighborhood: 'Plateau', rating: 4.8, reviewCount: 52, priceFrom: 8000, distanceKm: 5.1, imageUrl: 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?q=80&w=600', tag: 'Premium'),
  _Salon(id: 'p5', name: 'Studio Ndiaye', category: 'Coiffure', neighborhood: 'Point E', rating: 4.7, reviewCount: 84, priceFrom: 3500, distanceKm: 1.8, imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600', tag: 'Coup de cœur'),
  _Salon(id: 'p6', name: 'Hana Beauty Studio', category: 'Esthétique', neighborhood: 'Almadies', rating: 4.7, reviewCount: 71, priceFrom: 9000, distanceKm: 3.8, imageUrl: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=600', tag: 'Premium'),
  _Salon(id: 'p7', name: 'La Maison Rose', category: 'Coiffure & Soins', neighborhood: 'Fann', rating: 4.6, reviewCount: 58, priceFrom: 7000, distanceKm: 2.9, imageUrl: 'https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=600', tag: 'Nouveau'),
  _Salon(id: 'p8', name: 'Lumia Beauty', category: 'Soins & Ongles', neighborhood: 'Guédiawaye', rating: 4.5, reviewCount: 44, priceFrom: 4500, distanceKm: 8.0, imageUrl: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?q=80&w=600', tag: 'Premium'),
  _Salon(id: 'p9', name: 'Prestige Nails', category: 'Ongles', neighborhood: 'Mermoz', rating: 4.5, reviewCount: 36, priceFrom: 5500, distanceKm: 2.4, imageUrl: 'https://images.unsplash.com/photo-1619451334792-150fd785ee74?q=80&w=600', tag: 'Nouveau'),
  _Salon(id: 'p10', name: 'Zen & Beauté', category: 'Spa', neighborhood: 'Liberté 6', rating: 4.4, reviewCount: 29, priceFrom: 10000, distanceKm: 6.1, imageUrl: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=600', tag: 'Premium'),
];

// ── Page ──────────────────────────────────────────────────────────────────────

class SalonsListPage extends StatefulWidget {
  const SalonsListPage({super.key, required this.filter});

  final SalonListFilter filter;

  @override
  State<SalonsListPage> createState() => _SalonsListPageState();
}

class _SalonsListPageState extends State<SalonsListPage> {
  static const _pageSize = 4;

  late final List<_Salon> _pool;
  final List<_Salon> _items = [];
  final _scrollCtrl = ScrollController();
  bool _loading = false;
  bool _hasMore = true;

  String get _title =>
      widget.filter == SalonListFilter.nearby ? 'Près de vous' : 'Adresses prestige';

  @override
  void initState() {
    super.initState();
    _pool = widget.filter == SalonListFilter.nearby
        ? List.of(_nearbyPool)
        : List.of(_prestigePool);
    _loadMore();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200.h) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);

    // Simulate network latency — swap this body for a real API call later
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    final start = _items.length;
    final end = (start + _pageSize).clamp(0, _pool.length);
    setState(() {
      _items.addAll(_pool.sublist(start, end));
      _hasMore = end < _pool.length;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon('arrow-left', size: 22, color: AppColors.onSurface),
          onPressed: () {
            AppHaptics.light();
            context.pop();
          },
        ),
        title: Text(_title, style: AppTextStyles.headlineMd),
        actions: [
          IconButton(
            icon: AppIcon('search', size: 20, color: AppColors.onSurface),
            onPressed: () {
              AppHaptics.light();
              context.push(AppRoutes.search);
            },
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: ListView.separated(
        controller: _scrollCtrl,
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
        itemCount: _items.length + (_loading || _hasMore ? 1 : 0),
        separatorBuilder: (_, __) => SizedBox(height: 14.h),
        itemBuilder: (context, i) {
          if (i == _items.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            );
          }
          return _SalonCard(salon: _items[i]);
        },
      ),
    );
  }
}

// ── Card ──────────────────────────────────────────────────────────────────────

class _SalonCard extends StatelessWidget {
  const _SalonCard({required this.salon});
  final _Salon salon;

  @override
  Widget build(BuildContext context) {
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
                  child: CachedNetworkImage(
                    imageUrl: salon.imageUrl,
                    width: 100.r,
                    height: 100.r,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: AppColors.surfaceVariant),
                  ),
                ),
                if (salon.tag != null)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 7.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        salon.tag!,
                        style: AppTextStyles.labelSm.copyWith(
                          color: Colors.white,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
                        AppIcon('map-pin',
                            size: 12,
                            color: AppColors.onSurfaceVariant),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            '${salon.neighborhood} · ${salon.distanceKm} km',
                            style: AppTextStyles.bodySm,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        AppIcon('star',
                            size: 13, color: AppColors.secondary),
                        SizedBox(width: 3.w),
                        Text('${salon.rating}',
                            style: AppTextStyles.labelMd),
                        Text(' (${salon.reviewCount})',
                            style: AppTextStyles.bodySm),
                        const Spacer(),
                        Text(
                          'dès ${salon.priceFrom ~/ 1000}k XOF',
                          style: AppTextStyles.labelSm
                              .copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 14.w),
              child: AppIcon('chevron-right',
                  size: 18, color: AppColors.outline),
            ),
          ],
        ),
      ),
    );
  }
}
