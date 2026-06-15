import 'dart:async';

import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_icon_box.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../router/app_router.dart';
import '../providers/categories_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/salon_list_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  static const _searchHeroTag = 'home-search-hero';
  final _controller = TextEditingController();
  final _focus = FocusNode();
  final _scrollController = ScrollController();

  String _query = '';
  String _debouncedQuery = '';
  String? _activeCategory;
  String? _activeCity;
  String? _activeNeighborhood;
  bool _openNow = false;
  bool _bookableSoon = false;
  String _sort = 'relevance';
  Timer? _debounce;
  bool _isDebouncing = false;
  String? _sessionKey;

  // Results state
  List<SearchSuggestionsResponseTopMatchesInner> _results = [];
  List<SearchSalonsResponseModulesInner> _modules = [];
  SearchSalonsResponseFacets? _facets;
  SearchSalonsResponsePageInfo? _pageInfo;
  String? _correctedQuery;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _sessionKey = generateSessionKey();
    _controller.addListener(_onQueryChanged);
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus.requestFocus();
      ref.read(searchEventTrackerProvider).setSessionKey(_sessionKey!);
    });
  }

  void _onQueryChanged() {
    final raw = _controller.text.trim();
    setState(() {
      _query = raw;
      _isDebouncing = raw.isNotEmpty;
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        _debouncedQuery = raw;
        _isDebouncing = false;
      });
      if (raw.length >= 2) {
        _performSearch(reset: true);
        ref.read(recentSearchesProvider.notifier).add(raw);
        ref.read(searchEventTrackerProvider).track(
          eventType: SearchEventsRequestEventsInnerEventTypeEnum.searchSubmitted,
          query: raw,
          category: _activeCategory,
          city: _activeCity,
        );
      } else if (raw.isEmpty) {
        setState(() {
          _results = [];
          _modules = [];
          _facets = null;
          _pageInfo = null;
          _correctedQuery = null;
          _hasSearched = false;
          _error = null;
        });
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _pageInfo != null &&
        _pageInfo!.hasMore) {
      _loadMore();
    }
  }

  Future<void> _performSearch({bool reset = false}) async {
    if (_debouncedQuery.length < 2) return;

    if (reset) {
      setState(() {
        _isLoading = true;
        _error = null;
        _results = [];
        _modules = [];
        _pageInfo = null;
      });
    }

    try {
      final params = SearchParams(
        query: _debouncedQuery,
        category: _activeCategory,
        city: _activeCity,
        neighborhood: _activeNeighborhood,
        openNow: _openNow ? true : null,
        bookableSoon: _bookableSoon ? true : null,
        sort: _sort,
        cursor: reset ? null : _pageInfo?.nextCursor,
      );

      final response = await ref.read(searchResultsProvider(params).future);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _hasSearched = true;

        if (response == null) {
          _error = 'Aucun résultat';
          return;
        }

        _correctedQuery = response.query.corrected;

        if (reset) {
          _results = response.results.toList();
          _modules = response.modules.toList();
        } else {
          _results.addAll(response.results);
        }

        _facets = response.facets;
        _pageInfo = response.pageInfo;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _error = 'Impossible de charger les résultats';
      });
    }
  }

  Future<void> _loadMore() async {
    if (_pageInfo == null || !_pageInfo!.hasMore) return;
    setState(() => _isLoadingMore = true);
    await _performSearch(reset: false);
  }

  void _applyFilter({String? category, String? city, String? neighborhood}) {
    setState(() {
      if (category != null) {
        _activeCategory = _activeCategory == category ? null : category;
      }
      if (city != null) {
        _activeCity = _activeCity == city ? null : city;
      }
      if (neighborhood != null) {
        _activeNeighborhood =
            _activeNeighborhood == neighborhood ? null : neighborhood;
      }
    });

    ref.read(searchEventTrackerProvider).track(
      eventType: SearchEventsRequestEventsInnerEventTypeEnum.filterApplied,
      query: _debouncedQuery,
      category: _activeCategory,
      city: _activeCity,
    );

    if (_debouncedQuery.length >= 2) {
      _performSearch(reset: true);
    }
  }

  void _setSort(String sort) {
    setState(() => _sort = sort);
    if (_debouncedQuery.length >= 2) {
      _performSearch(reset: true);
    }
  }

  void _toggleOpenNow() {
    setState(() => _openNow = !_openNow);
    if (_debouncedQuery.length >= 2) {
      _performSearch(reset: true);
    }
  }

  void _toggleBookableSoon() {
    setState(() => _bookableSoon = !_bookableSoon);
    if (_debouncedQuery.length >= 2) {
      _performSearch(reset: true);
    }
  }

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Trier par', style: AppTextStyles.headlineSm),
              gapH16,
              _SortOption(
                label: 'Pertinence',
                value: 'relevance',
                current: _sort,
                onTap: () {
                  _setSort('relevance');
                  Navigator.pop(ctx);
                },
              ),
              _SortOption(
                label: 'Proximité',
                value: 'nearby',
                current: _sort,
                onTap: () {
                  _setSort('nearby');
                  Navigator.pop(ctx);
                },
              ),
              _SortOption(
                label: 'Tendances',
                value: 'trending',
                current: _sort,
                onTap: () {
                  _setSort('trending');
                  Navigator.pop(ctx);
                },
              ),
              _SortOption(
                label: 'Prestige',
                value: 'prestige',
                current: _sort,
                onTap: () {
                  _setSort('prestige');
                  Navigator.pop(ctx);
                },
              ),
              _SortOption(
                label: 'Prix croissant',
                value: 'price_asc',
                current: _sort,
                onTap: () {
                  _setSort('price_asc');
                  Navigator.pop(ctx);
                },
              ),
              _SortOption(
                label: 'Prix décroissant',
                value: 'price_desc',
                current: _sort,
                onTap: () {
                  _setSort('price_desc');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    _focus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        ref.watch(categoriesProvider).asData?.value ?? const [];
    final recentSearches = ref.watch(recentSearchesProvider);

    return AppScaffold(
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: AppIconBox(
                      circle: true,
                      size: 40.r,
                      color: AppColors.surface,
                      shadow: AppShadows.sm,
                      child: AppIcon('arrow-left',
                          size: 18, color: AppColors.onSurface),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Hero(
                      tag: _searchHeroTag,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          height: 46.h,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: AppShadows.sm,
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 14.w),
                              AppIcon('search',
                                  size: 18,
                                  color: AppColors.onSurfaceVariant),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  focusNode: _focus,
                                  style: AppTextStyles.bodyMd
                                      .copyWith(color: AppColors.onSurface),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Salon, service, quartier…',
                                    hintStyle: AppTextStyles.bodyMd.copyWith(
                                        color: AppColors.onSurfaceVariant),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    filled: false,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              if (_query.isNotEmpty)
                                AppPressable(
                                  onTap: () {
                                    _controller.clear();
                                    _focus.requestFocus();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(10.r),
                                    child: AppIcon('close',
                                        size: 16,
                                        color: AppColors.onSurfaceVariant),
                                  ),
                                ),
                              gapW4,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: _openSortSheet,
                    child: Container(
                      height: 46.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: _sort != 'relevance'
                            ? AppColors.primary
                            : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: AppShadows.sm,
                      ),
                      child: AppIcon(
                        'filter',
                        size: 16,
                        color: _sort != 'relevance'
                            ? AppColors.white
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Debounce bar ────────────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _isDebouncing ? 2.h : 0,
            child: _isDebouncing
                ? LinearProgressIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.primaryLight,
                  )
                : const SizedBox.shrink(),
          ),

          // ── Filter chips (when searching) ──────────────────────────
          if (_hasSearched) _buildFilterChips(categories),

          // ── Content ─────────────────────────────────────────────────
          Expanded(
            child: _buildContent(categories, recentSearches),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(List<String> categories) {
    return SizedBox(
      height: 44.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        children: [
          _FilterChip(
            label: _sort == 'relevance' ? 'Trier' : _sortLabel(_sort),
            active: _sort != 'relevance',
            icon: 'filter',
            onTap: _openSortSheet,
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: 'Ouvert',
            active: _openNow,
            icon: 'clock',
            onTap: _toggleOpenNow,
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: 'Réserver bientôt',
            active: _bookableSoon,
            icon: 'calendar',
            onTap: _toggleBookableSoon,
          ),
          if (_facets != null) ...[
            for (final cat in _facets!.categories.take(5))
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: _FilterChip(
                  label: '${cat.value} (${cat.count})',
                  active: cat.active ?? false,
                  onTap: () => _applyFilter(category: cat.value),
                ),
              ),
            for (final city in _facets!.cities.take(3))
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: _FilterChip(
                  label: city.value,
                  active: city.active ?? false,
                  onTap: () => _applyFilter(city: city.value),
                ),
              ),
          ],
        ],
      ),
    );
  }

  String _sortLabel(String sort) {
    switch (sort) {
      case 'nearby':
        return 'Proche';
      case 'trending':
        return 'Tendance';
      case 'prestige':
        return 'Prestige';
      case 'price_asc':
        return 'Prix ↑';
      case 'price_desc':
        return 'Prix ↓';
      default:
        return 'Trier';
    }
  }

  Widget _buildContent(
      List<String> categories, List<String> recentSearches) {
    // Idle state
    if (_query.isEmpty && !_hasSearched) {
      return _IdleState(
        categories: categories,
        recentSearches: recentSearches,
        onCategoryTap: (cat) {
          _controller.text = cat;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: cat.length),
          );
          _focus.requestFocus();
        },
        onRecentTap: (term) {
          _controller.text = term;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: term.length),
          );
          _focus.requestFocus();
        },
        onRecentRemove: (term) =>
            ref.read(recentSearchesProvider.notifier).remove(term),
      );
    }

    // Loading state
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    // Error state
    if (_error != null && _results.isEmpty) {
      return _ErrorState(
        message: _error!,
        onRetry: () => _performSearch(reset: true),
      );
    }

    // Empty state
    if (_hasSearched && _results.isEmpty && _modules.isEmpty) {
      return _EmptyState(
        query: _debouncedQuery,
        correctedQuery: _correctedQuery,
        onCorrectedTap: _correctedQuery != null
            ? () {
                _controller.text = _correctedQuery!;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _correctedQuery!.length),
                );
                setState(() {
                  _debouncedQuery = _correctedQuery!;
                });
                _performSearch(reset: true);
              }
            : null,
      );
    }

    // Results state
    return RefreshIndicator.adaptive(
      color: AppColors.primary,
      onRefresh: () => _performSearch(reset: true),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // Did you mean
          if (_correctedQuery != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
                child: GestureDetector(
                  onTap: () {
                    _controller.text = _correctedQuery!;
                    _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _correctedQuery!.length),
                    );
                    setState(() {
                      _debouncedQuery = _correctedQuery!;
                    });
                    _performSearch(reset: true);
                  },
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMd,
                      children: [
                        const TextSpan(
                            text: 'Vouliez-vous dire: ',
                            style: TextStyle(color: AppColors.onSurfaceVariant)),
                        TextSpan(
                          text: _correctedQuery,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Results count
          if (_pageInfo != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
                child: Text(
                  '${_pageInfo!.totalApprox} résultat${_pageInfo!.totalApprox > 1 ? 's' : ''}',
                  style: AppTextStyles.bodySm
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            ),

          // Main results
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverList.separated(
              itemCount: _results.length,
              separatorBuilder: (_, _) => gapH12,
              itemBuilder: (context, i) {
                final salon = _results[i];
                return SalonListCard(
                  salon: salon,
                  onTap: () {
                    ref.read(searchEventTrackerProvider).track(
                      eventType:
                          SearchEventsRequestEventsInnerEventTypeEnum
                              .resultOpened,
                      query: _debouncedQuery,
                      salonId: salon.id,
                      position: i,
                    );
                    context.push(AppRoutes.salon(salon.id));
                  },
                  height: 88.h,
                  radius: 18.r,
                  trailing: Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: AppIcon('chevron-right',
                        size: 16, color: AppColors.outline),
                  ),
                );
              },
            ),
          ),

          // Loading more indicator
          if (_isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primary, strokeWidth: 2),
                ),
              ),
            ),

          // Discovery modules
          for (final module in _modules) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
                child: Text(
                  module.title,
                  style: AppTextStyles.headlineSm,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: module.items.length,
                  separatorBuilder: (_, _) => SizedBox(width: 12.w),
                  itemBuilder: (context, i) {
                    final salon = module.items.elementAt(i);
                    return _ModuleSalonCard(
                      salon: salon,
                      onTap: () {
                        ref.read(searchEventTrackerProvider).track(
                          eventType:
                              SearchEventsRequestEventsInnerEventTypeEnum
                                  .moduleItemOpened,
                          query: _debouncedQuery,
                          salonId: salon.id,
                        );
                        context.push(AppRoutes.salon(salon.id));
                      },
                    );
                  },
                ),
              ),
            ),
          ],

          // Bottom padding
          SliverToBoxAdapter(child: SizedBox(height: 120.h)),
        ],
      ),
    );
  }
}

// ── Idle state ──────────────────────────────────────────────────────────────

class _IdleState extends StatelessWidget {
  const _IdleState({
    required this.categories,
    required this.recentSearches,
    required this.onCategoryTap,
    required this.onRecentTap,
    required this.onRecentRemove,
  });

  final List<String> categories;
  final List<String> recentSearches;
  final void Function(String) onCategoryTap;
  final void Function(String) onRecentTap;
  final void Function(String) onRecentRemove;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recent searches
            if (recentSearches.isNotEmpty) ...[
              Text(
                'RÉCENTS',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: recentSearches.map((term) {
                  return GestureDetector(
                    onTap: () => onRecentTap(term),
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 12.w,
                        right: 6.w,
                        top: 8.h,
                        bottom: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: AppShadows.sm,
                        border: Border.all(
                            color: AppColors.outlineVariant, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppIcon('clock',
                              size: 13, color: AppColors.onSurfaceVariant),
                          SizedBox(width: 6.w),
                          Text(term,
                              style: AppTextStyles.labelMd
                                  .copyWith(color: AppColors.onSurface)),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () => onRecentRemove(term),
                            child: AppIcon('close',
                                size: 13,
                                color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 28.h),
            ] else ...[
              Center(
                child: AppIconBox(
                  circle: true,
                  size: 64.r,
                  color: AppColors.primaryLight,
                  child:
                      AppIcon('search', size: 26, color: AppColors.primary),
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: Text('Trouvez votre salon',
                    style: AppTextStyles.headlineSm,
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  'Tapez un nom, un service, un quartier…',
                  style: AppTextStyles.bodyMd
                      .copyWith(color: AppColors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 28.h),
            ],

            // Categories
            if (categories.isNotEmpty) ...[
              Text(
                'CATÉGORIES',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: categories.take(12).map((cat) {
                  return GestureDetector(
                    onTap: () => onCategoryTap(cat),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: AppShadows.sm,
                        border: Border.all(
                            color: AppColors.outlineVariant, width: 1),
                      ),
                      child: Text(cat,
                          style: AppTextStyles.labelMd
                              .copyWith(color: AppColors.onSurface)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Error state ─────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon('warning',
                size: 40, color: AppColors.onSurfaceVariant),
            gapH16,
            Text(message,
                style: AppTextStyles.bodyMd,
                textAlign: TextAlign.center),
            gapH16,
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text('Réessayer',
                    style: AppTextStyles.labelLg
                        .copyWith(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.query,
    this.correctedQuery,
    this.onCorrectedTap,
  });

  final String query;
  final String? correctedQuery;
  final VoidCallback? onCorrectedTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon('search',
                size: 40, color: AppColors.onSurfaceVariant),
            gapH16,
            Text(
              'Aucun résultat pour "$query"',
              style: AppTextStyles.headlineSm,
              textAlign: TextAlign.center,
            ),
            gapH8,
            Text(
              'Essayez un autre terme, une catégorie, ou élargissez votre recherche.',
              style: AppTextStyles.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (correctedQuery != null && onCorrectedTap != null) ...[
              gapH16,
              GestureDetector(
                onTap: onCorrectedTap,
                child: Text(
                  'Vouliez-vous dire: $correctedQuery ?',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Filter chip ─────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    this.icon,
    required this.onTap,
  });

  final String label;
  final bool active;
  final String? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: active ? null : AppShadows.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              AppIcon(
                icon!,
                size: 13,
                color: active ? AppColors.white : AppColors.onSurface,
              ),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: AppTextStyles.labelSm.copyWith(
                color: active ? AppColors.white : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sort option ─────────────────────────────────────────────────────────────

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });

  final String label;
  final String value;
  final String current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = value == current;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMd.copyWith(
                  color:
                      active ? AppColors.primary : AppColors.onSurface,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (active)
              AppIcon('check', size: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

// ── Module salon card (horizontal scroll) ───────────────────────────────────

class _ModuleSalonCard extends StatelessWidget {
  const _ModuleSalonCard({required this.salon, required this.onTap});

  final dynamic salon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = salon.name as String? ?? '';
    final category = salon.category as String? ?? '';
    final logoUrl = salon.logoUrl as String?;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16.r)),
              child: logoUrl != null && logoUrl.isNotEmpty
                  ? Image.network(
                      logoUrl,
                      height: 100.h,
                      width: 140.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 100.h,
                        width: 140.w,
                        color: AppColors.surfaceVariant,
                        child: AppIcon('image',
                            size: 24, color: AppColors.outline),
                      ),
                    )
                  : Container(
                      height: 100.h,
                      width: 140.w,
                      color: AppColors.surfaceVariant,
                      child: AppIcon('image',
                          size: 24, color: AppColors.outline),
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
