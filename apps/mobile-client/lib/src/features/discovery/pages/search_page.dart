import 'dart:async';

import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_icon_box.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../router/app_router.dart';
import '../providers/categories_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/salon_list_card.dart';
import '../widgets/search_sections/filter_chip.dart';
import '../widgets/search_sections/idle_state.dart';
import '../widgets/search_sections/module_salon_card.dart';
import '../widgets/search_sections/sort_sheet.dart';
import '../widgets/search_sections/states.dart';

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
      setState(() { _isLoading = true; _error = null; _results = []; _modules = []; _pageInfo = null; });
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
        if (response == null) { _error = AppStrings.noResults; return; }
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
      setState(() { _isLoading = false; _isLoadingMore = false; _error = AppStrings.searchErrorLoad; });
    }
  }

  Future<void> _loadMore() async {
    if (_pageInfo == null || !_pageInfo!.hasMore) return;
    setState(() => _isLoadingMore = true);
    await _performSearch(reset: false);
  }

  void _applyFilter({String? category, String? city, String? neighborhood}) {
    setState(() {
      if (category != null) _activeCategory = _activeCategory == category ? null : category;
      if (city != null) _activeCity = _activeCity == city ? null : city;
      if (neighborhood != null) _activeNeighborhood = _activeNeighborhood == neighborhood ? null : neighborhood;
    });
    ref.read(searchEventTrackerProvider).track(
      eventType: SearchEventsRequestEventsInnerEventTypeEnum.filterApplied,
      query: _debouncedQuery, category: _activeCategory, city: _activeCity,
    );
    if (_debouncedQuery.length >= 2) _performSearch(reset: true);
  }

  void _setSort(String sort) {
    setState(() => _sort = sort);
    if (_debouncedQuery.length >= 2) _performSearch(reset: true);
  }

  void _toggleOpenNow() {
    setState(() => _openNow = !_openNow);
    if (_debouncedQuery.length >= 2) _performSearch(reset: true);
  }

  void _toggleBookableSoon() {
    setState(() => _bookableSoon = !_bookableSoon);
    if (_debouncedQuery.length >= 2) _performSearch(reset: true);
  }

  void _openSortSheet() {
    SearchSortSheet.show(context, currentSort: _sort, onSortSelected: _setSort);
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

  String _sortLabel(String sort) {
    switch (sort) {
      case 'nearby': return AppStrings.sortProximity;
      case 'trending': return AppStrings.sortTrending;
      case 'prestige': return AppStrings.sortPrestige;
      case 'price_asc': return AppStrings.sortPriceAsc;
      case 'price_desc': return AppStrings.sortPriceDesc;
      default: return AppStrings.sortLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).asData?.value ?? const [];
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
                      circle: true, size: 40.r,
                      color: AppColors.surface, shadow: AppShadows.sm,
                      child: AppIcon('arrow-left', size: 18, color: AppColors.onSurface),
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
                            borderRadius: BorderRadius.circular(AppRadius.md.r),
                            boxShadow: AppShadows.sm,
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 14.w),
                              AppIcon('search', size: 18, color: AppColors.onSurfaceVariant),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: TextField(
                                  controller: _controller, focusNode: _focus,
                                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface),
                                  decoration: InputDecoration(
                                    hintText: AppStrings.searchHintDetailed,
                                    hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                                    border: InputBorder.none, enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none, isDense: true, filled: false,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              if (_query.isNotEmpty)
                                AppPressable(
                                  onTap: () { _controller.clear(); _focus.requestFocus(); },
                                  child: Padding(
                                    padding: EdgeInsets.all(10.r),
                                    child: AppIcon('close', size: 16, color: AppColors.onSurfaceVariant),
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
                        color: _sort != 'relevance' ? AppColors.primary : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.md.r),
                        boxShadow: AppShadows.sm,
                      ),
                      child: AppIcon('filter', size: 16,
                        color: _sort != 'relevance' ? AppColors.white : AppColors.primary),
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
                ? LinearProgressIndicator(color: AppColors.primary, backgroundColor: AppColors.primaryLight)
                : const SizedBox.shrink(),
          ),

          // ── Filter chips (when searching) ──────────────────────────
          if (_hasSearched) _buildFilterChips(categories),

          // ── Content ─────────────────────────────────────────────────
          Expanded(child: _buildContent(categories, recentSearches)),
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
          SearchFilterChip(                        label: _sort == 'relevance' ? AppStrings.sortLabel : _sortLabel(_sort),
            active: _sort != 'relevance', icon: 'filter', onTap: _openSortSheet,
          ),
          SizedBox(width: 8.w),
          SearchFilterChip(label: AppStrings.filterOpenNow, active: _openNow, icon: 'clock', onTap: _toggleOpenNow),
          SizedBox(width: 8.w),
          SearchFilterChip(label: AppStrings.filterBookableSoon, active: _bookableSoon, icon: 'calendar', onTap: _toggleBookableSoon),
          if (_facets != null) ...[
            for (final cat in _facets!.categories.take(5))
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: SearchFilterChip(
                  label: '${cat.value} (${cat.count})',
                  active: cat.active ?? false,
                  onTap: () => _applyFilter(category: cat.value),
                ),
              ),
            for (final city in _facets!.cities.take(3))
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: SearchFilterChip(
                  label: city.value, active: city.active ?? false,
                  onTap: () => _applyFilter(city: city.value),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(List<String> categories, List<String> recentSearches) {
    // Idle state
    if (_query.isEmpty && !_hasSearched) {
      return SearchIdleState(
        categories: categories, recentSearches: recentSearches,
        onCategoryTap: (cat) {
          _controller.text = cat;
          _controller.selection = TextSelection.fromPosition(TextPosition(offset: cat.length));
          _focus.requestFocus();
        },
        onRecentTap: (term) {
          _controller.text = term;
          _controller.selection = TextSelection.fromPosition(TextPosition(offset: term.length));
          _focus.requestFocus();
        },
        onRecentRemove: (term) => ref.read(recentSearchesProvider.notifier).remove(term),
      );
    }

    // Loading state
    if (_isLoading) return const SearchLoadingState();

    // Error state
    if (_error != null && _results.isEmpty) {
      return SearchErrorState(message: _error!, onRetry: () => _performSearch(reset: true));
    }

    // Empty state
    if (_hasSearched && _results.isEmpty && _modules.isEmpty) {
      return SearchEmptyState(
        query: _debouncedQuery, correctedQuery: _correctedQuery,
        onCorrectedTap: _correctedQuery != null ? () {
          _controller.text = _correctedQuery!;
          _controller.selection = TextSelection.fromPosition(TextPosition(offset: _correctedQuery!.length));
          setState(() => _debouncedQuery = _correctedQuery!);
          _performSearch(reset: true);
        } : null,
      );
    }

    // Results state
    return RefreshIndicator.adaptive(
      color: AppColors.primary,
      onRefresh: () => _performSearch(reset: true),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          // Did you mean
          if (_correctedQuery != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
                child: GestureDetector(
                  onTap: () {
                    _controller.text = _correctedQuery!;
                    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _correctedQuery!.length));
                    setState(() => _debouncedQuery = _correctedQuery!);
                    _performSearch(reset: true);
                  },
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMd,
                      children: [
                        TextSpan(text: AppStrings.didYouMean, style: TextStyle(color: AppColors.onSurfaceVariant)),
                        TextSpan(text: _correctedQuery, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
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
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
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
                final tag = 'search_salon_image_${salon.id}';
                return SalonListCard(
                  salon: salon, heroTag: tag,
                  onTap: () {
                    ref.read(searchEventTrackerProvider).track(
                      eventType: SearchEventsRequestEventsInnerEventTypeEnum.resultOpened,
                      query: _debouncedQuery, salonId: salon.id, position: i,
                    );
                    context.push('${AppRoutes.salon(salon.id)}?heroTag=${Uri.encodeComponent(tag)}');
                  },
                  height: 88.h, radius: AppRadius.xl.r,
                  trailing: Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: AppIcon('chevron-right', size: 16, color: AppColors.outline),
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
                child: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
              ),
            ),

          // Discovery modules
          for (final module in _modules) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
                child: Text(module.title, style: AppTextStyles.headlineSm),
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
                    final mTag = 'module_salon_image_${salon.id}';
                    return SearchModuleSalonCard(
                      salon: salon, heroTag: mTag,
                      onTap: () {
                        ref.read(searchEventTrackerProvider).track(
                          eventType: SearchEventsRequestEventsInnerEventTypeEnum.moduleItemOpened,
                          query: _debouncedQuery, salonId: salon.id,
                        );
                        context.push('${AppRoutes.salon(salon.id)}?heroTag=${Uri.encodeComponent(mTag)}');
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
