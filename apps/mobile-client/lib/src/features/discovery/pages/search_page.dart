import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────

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
  });
  final String id, name, category, neighborhood, imageUrl;
  final double rating, distanceKm;
  final int reviewCount, priceFrom;
}

const _allSalons = [
  _Salon(
    id: 'salon-1',
    name: 'Maison Kinka',
    category: 'Coiffure & Spa',
    neighborhood: 'Almadies',
    rating: 4.9,
    reviewCount: 128,
    priceFrom: 5000,
    distanceKm: 3.2,
    imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=600',
  ),
  _Salon(
    id: 'salon-2',
    name: 'Studio Ndiaye',
    category: 'Coiffure',
    neighborhood: 'Point E',
    rating: 4.7,
    reviewCount: 84,
    priceFrom: 3500,
    distanceKm: 1.8,
    imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
  ),
  _Salon(
    id: 'salon-3',
    name: 'Espace Lumière',
    category: 'Soins',
    neighborhood: 'Plateau',
    rating: 4.8,
    reviewCount: 52,
    priceFrom: 8000,
    distanceKm: 5.1,
    imageUrl: 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?q=80&w=600',
  ),
  _Salon(
    id: 'salon-4',
    name: 'Ongles & Co',
    category: 'Ongles',
    neighborhood: 'Mermoz',
    rating: 4.6,
    reviewCount: 41,
    priceFrom: 4000,
    distanceKm: 2.4,
    imageUrl: 'https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=600',
  ),
  _Salon(
    id: 'salon-5',
    name: 'Oasis Spa',
    category: 'Spa',
    neighborhood: 'Sacré-Cœur',
    rating: 4.9,
    reviewCount: 97,
    priceFrom: 12000,
    distanceKm: 4.0,
    imageUrl: 'https://images.unsplash.com/photo-1470259078422-826894b933aa?q=80&w=600',
  ),
  _Salon(
    id: 'salon-6',
    name: 'La Belle Époque',
    category: 'Coiffure & Spa',
    neighborhood: 'Fann',
    rating: 4.5,
    reviewCount: 33,
    priceFrom: 6000,
    distanceKm: 2.9,
    imageUrl: 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=600',
  ),
];

const _recentSearches = ['Maison Kinka', 'Soin du visage', 'Dakar Plateau'];

class _Category {
  const _Category(this.label, this.imageUrl);
  final String label, imageUrl;
}

const _categories = [
  _Category('Coiffure',
      'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=400'),
  _Category('Soins',
      'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=400'),
  _Category('Ongles',
      'https://images.unsplash.com/photo-1604654894610-df63bc536371?q=80&w=400'),
  _Category('Spa',
      'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=400'),
];

// ── Page ──────────────────────────────────────────────────────────────────────

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';
  String? _activeCategory;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _query = _controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_Salon> get _results {
    return _allSalons.where((s) {
      final matchesQuery = _query.isEmpty ||
          s.name.toLowerCase().contains(_query.toLowerCase()) ||
          s.category.toLowerCase().contains(_query.toLowerCase()) ||
          s.neighborhood.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _activeCategory == null ||
          s.category.toLowerCase().contains(_activeCategory!.toLowerCase());
      return matchesQuery && matchesCategory;
    }).toList();
  }

  void _selectRecent(String text) {
    AppHaptics.select();
    _controller.text = text;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
  }

  void _selectCategory(String category) {
    AppHaptics.select();
    setState(() {
      _activeCategory = _activeCategory == category ? null : category;
    });
  }

  void _openFilters() {
    AppHaptics.light();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: AppIcon('arrow-left', size: 22, color: AppColors.onSurface),
          onPressed: () {
            AppHaptics.light();
            context.pop();
          },
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: AppTextStyles.bodyMd,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Salon, soin, quartier…',
            hintStyle: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
            suffixIcon: _query.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      AppHaptics.light();
                      _controller.clear();
                      setState(() => _query = '');
                    },
                    child: Icon(
                      Icons.cancel_rounded,
                      size: 18.r,
                      color: AppColors.onSurfaceVariant,
                    ),
                  )
                : null,
          ),
        ),
        actions: [
          IconButton(
            icon: AppIcon('filter', size: 20, color: AppColors.onSurface),
            onPressed: _openFilters,
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: Column(
        children: [
          Divider(color: AppColors.outlineVariant, height: 1),
          Expanded(
            child: _query.isEmpty && _activeCategory == null
                ? _EmptyState(
                    onRecentTap: _selectRecent,
                    onCategoryTap: _selectCategory,
                  )
                : _ResultsView(
                    results: _results,
                    query: _query,
                    activeCategory: _activeCategory,
                    onCategoryTap: _selectCategory,
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state (recents + categories) ───────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRecentTap, required this.onCategoryTap});

  final ValueChanged<String> onRecentTap;
  final ValueChanged<String> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: 32.h),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 14.h),
          child: Text(
            'RECHERCHES RÉCENTES',
            style: AppTextStyles.labelSm.copyWith(
              letterSpacing: 1.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        ..._recentSearches.map(
          (text) => _RecentItem(text: text, onTap: () => onRecentTap(text)),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 36.h, 24.w, 16.h),
          child: Text(
            'PAR CATÉGORIE',
            style: AppTextStyles.labelSm.copyWith(
              letterSpacing: 1.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(
          height: 108.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemCount: _categories.length,
            itemBuilder: (_, i) => _CategoryCard(
              category: _categories[i],
              onTap: () => onCategoryTap(_categories[i].label),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentItem extends StatelessWidget {
  const _RecentItem({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 13.h),
        child: Row(
          children: [
            Icon(
              Icons.history_rounded,
              size: 18.r,
              color: AppColors.onSurfaceVariant,
            ),
            SizedBox(width: 16.w),
            Expanded(child: Text(text, style: AppTextStyles.bodyMd)),
            Icon(
              Icons.north_west_rounded,
              size: 14.r,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});
  final _Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: SizedBox(
          width: 88.w,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: category.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: AppColors.surfaceVariant),
              ),
              // Dark gradient so label is always readable
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Text(
                    category.label,
                    style: AppTextStyles.labelSm.copyWith(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          blurRadius: 4,
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
    );
  }
}

// ── Results view ──────────────────────────────────────────────────────────────

class _ResultsView extends StatelessWidget {
  const _ResultsView({
    required this.results,
    required this.query,
    required this.activeCategory,
    required this.onCategoryTap,
  });

  final List<_Salon> results;
  final String query;
  final String? activeCategory;
  final ValueChanged<String> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category filter chips
        SizedBox(
          height: 44.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemCount: _categories.length,
            itemBuilder: (_, i) {
              final cat = _categories[i];
              final active = activeCategory == cat.label;
              return GestureDetector(
                onTap: () => onCategoryTap(cat.label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : AppColors.neutral,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: active
                          ? AppColors.primary
                          : AppColors.outlineVariant,
                    ),
                  ),
                  child: Text(
                    cat.label,
                    style: AppTextStyles.labelSm.copyWith(
                      color: active ? Colors.white : AppColors.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Count
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
          child: Text(
            results.isEmpty
                ? 'Aucun résultat'
                : '${results.length} salon${results.length > 1 ? 's' : ''}',
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? _NoResults(query: query)
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 40.h),
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemCount: results.length,
                  itemBuilder: (_, i) => _SalonResultCard(salon: results[i]),
                ),
        ),
      ],
    );
  }
}

class _SalonResultCard extends StatelessWidget {
  const _SalonResultCard({required this.salon});
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
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r),
              ),
              child: CachedNetworkImage(
                imageUrl: salon.imageUrl,
                width: 100.r,
                height: 100.r,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.surfaceVariant,
                  width: 100.r,
                  height: 100.r,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(salon.name, style: AppTextStyles.labelLg),
                    SizedBox(height: 3.h),
                    Text(
                      '${salon.category} · ${salon.neighborhood}',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        AppIcon('star', size: 13, color: AppColors.secondary),
                        SizedBox(width: 3.w),
                        Text(
                          '${salon.rating}',
                          style: AppTextStyles.labelSm,
                        ),
                        Text(
                          ' (${salon.reviewCount})',
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${salon.priceFrom ~/ 1000}k XOF',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.primary,
                          ),
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
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon('search', size: 48, color: AppColors.outlineVariant),
            SizedBox(height: 20.h),
            Text(
              'Aucun résultat pour\n"$query"',
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Essayez un autre quartier\nou une autre prestation.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filter bottom sheet ───────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  double _maxDistance = 10;
  double _minRating = 0;
  String? _sortBy = 'distance';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filtres', style: AppTextStyles.headlineMd),
                TextButton(
                  onPressed: () {
                    AppHaptics.light();
                    setState(() {
                      _maxDistance = 10;
                      _minRating = 0;
                      _sortBy = 'distance';
                    });
                  },
                  child: Text(
                    'Réinitialiser',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text('Distance max · ${_maxDistance.toInt()} km',
                style: AppTextStyles.labelMd),
            SizedBox(height: 8.h),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.primary,
                thumbColor: AppColors.primary,
                inactiveTrackColor: AppColors.outlineVariant,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: _maxDistance,
                min: 1,
                max: 30,
                divisions: 29,
                onChanged: (v) => setState(() => _maxDistance = v),
              ),
            ),
            SizedBox(height: 16.h),
            Text('Note minimum · ${_minRating == 0 ? 'Toutes' : '${_minRating.toStringAsFixed(1)}+'}',
                style: AppTextStyles.labelMd),
            SizedBox(height: 8.h),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.secondary,
                thumbColor: AppColors.secondary,
                inactiveTrackColor: AppColors.outlineVariant,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: _minRating,
                min: 0,
                max: 5,
                divisions: 10,
                onChanged: (v) => setState(() => _minRating = v),
              ),
            ),
            SizedBox(height: 16.h),
            Text('Trier par', style: AppTextStyles.labelMd),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              children: [
                _SortChip(
                  label: 'Distance',
                  value: 'distance',
                  groupValue: _sortBy,
                  onTap: (v) => setState(() => _sortBy = v),
                ),
                _SortChip(
                  label: 'Note',
                  value: 'rating',
                  groupValue: _sortBy,
                  onTap: (v) => setState(() => _sortBy = v),
                ),
                _SortChip(
                  label: 'Prix croissant',
                  value: 'price_asc',
                  groupValue: _sortBy,
                  onTap: (v) => setState(() => _sortBy = v),
                ),
              ],
            ),
            SizedBox(height: 28.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AppHaptics.medium();
                  Navigator.of(context).pop();
                },
                child: const Text('Appliquer les filtres'),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });
  final String label, value;
  final String? groupValue;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final active = value == groupValue;
    return GestureDetector(
      onTap: () {
        AppHaptics.select();
        onTap(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.neutral,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSm.copyWith(
            color: active ? Colors.white : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
