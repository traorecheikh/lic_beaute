import 'dart:async';

import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../router/app_router.dart';
import '../providers/categories_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/search_sections/filter_bar.dart';
import '../widgets/search_sections/idle_state.dart';
import '../widgets/search_sections/search_bar.dart';
import '../widgets/search_sections/search_results.dart';
import '../widgets/search_sections/sort_sheet.dart';
import '../widgets/search_sections/states.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
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

  DateTime _lastNavTap = DateTime(0);

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
          _error = AppStrings.noResults;
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
        _error = AppStrings.searchErrorLoad;
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
    SearchSortSheet.show(
      context,
      currentSort: _sort,
      onSortSelected: _setSort,
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
    final categories = ref.watch(categoriesProvider).asData?.value ?? const [];
    final recentSearches = ref.watch(recentSearchesProvider);

    return AppScaffold(
      body: Column(
        children: [
          SearchAppBar(
            controller: _controller,
            focusNode: _focus,
            sort: _sort,
            isDebouncing: _isDebouncing,
            onSortChanged: _setSort,
            onOpenSortSheet: _openSortSheet,
          ),

          // ── Filter chips (when searching) ──────────────────────────
          if (_hasSearched)
            SearchFilterBar(
              sort: _sort,
              openNow: _openNow,
              bookableSoon: _bookableSoon,
              facets: _facets,
              onSortSheet: _openSortSheet,
              onToggleOpenNow: _toggleOpenNow,
              onToggleBookableSoon: _toggleBookableSoon,
              onApplyFilter: _applyFilter,
            ),

          // ── Content ─────────────────────────────────────────────────
          Expanded(child: _buildContent(categories, recentSearches)),
        ],
      ),
    );
  }

  Widget _buildContent(List<String> categories, List<String> recentSearches) {
    // Idle state
    if (_query.isEmpty && !_hasSearched) {
      return SearchIdleState(
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
    if (_isLoading) return const SearchLoadingState();

    // Error state
    if (_error != null && _results.isEmpty) {
      return SearchErrorState(
        message: _error!,
        onRetry: () => _performSearch(reset: true),
      );
    }

    // Empty state
    if (_hasSearched && _results.isEmpty && _modules.isEmpty) {
      return SearchEmptyState(
        query: _debouncedQuery,
        correctedQuery: _correctedQuery,
        onCorrectedTap: _correctedQuery != null
            ? () {
                _controller.text = _correctedQuery!;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _correctedQuery!.length),
                );
                setState(() => _debouncedQuery = _correctedQuery!);
                _performSearch(reset: true);
              }
            : null,
      );
    }

    // Results state
    return SearchResultsView(
      results: _results,
      modules: _modules,
      correctedQuery: _correctedQuery,
      isLoadingMore: _isLoadingMore,
      hasMore: _pageInfo?.hasMore ?? false,
      totalApprox: _pageInfo?.totalApprox ?? 0,
      query: _debouncedQuery,
      scrollController: _scrollController,
      onRefresh: () => _performSearch(reset: true),
      onCorrectedTap: () {
        _controller.text = _correctedQuery!;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _correctedQuery!.length),
        );
        setState(() => _debouncedQuery = _correctedQuery!);
        _performSearch(reset: true);
      },
      onResultTap: (salonId, tag, index) {
        ref.read(searchEventTrackerProvider).track(
          eventType: SearchEventsRequestEventsInnerEventTypeEnum.resultOpened,
          query: _debouncedQuery,
          salonId: salonId,
          position: index,
        );
        _navigateToSalon(
          salonId,
          tag,
          () => context.push(
            '${AppRoutes.salon(salonId)}?heroTag=${Uri.encodeComponent(tag)}',
          ),
        );
      },
      onModuleTap: (salonId, tag) {
        ref.read(searchEventTrackerProvider).track(
          eventType: SearchEventsRequestEventsInnerEventTypeEnum.moduleItemOpened,
          query: _debouncedQuery,
          salonId: salonId,
        );
        _navigateToSalon(
          salonId,
          tag,
          () => context.push(
            '${AppRoutes.salon(salonId)}?heroTag=${Uri.encodeComponent(tag)}',
          ),
        );
      },
    );
  }

  void _navigateToSalon(String salonId, String tag, VoidCallback navigate) {
    final now = DateTime.now();
    if (now.difference(_lastNavTap) < const Duration(milliseconds: 500)) return;
    _lastNavTap = now;
    navigate();
  }
}
