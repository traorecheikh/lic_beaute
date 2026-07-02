import 'dart:async';

import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:cupertino_native_better/components/bottom_sheet.dart';
import 'package:cupertino_native_better/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/diagnostics/app_runtime_diagnostics.dart';
import '../../../core/platform/ios_version.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
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
  const SearchPage({
    this.initialQuery,
    this.openFilters = false,
    super.key,
  });

  final String? initialQuery;
  final bool openFilters;

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  final _scrollController = ScrollController();
  final _nativeSearchController = CNSearchBarController();

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

  bool get _useNativeIOSSearch =>
      IOSVersion.supportsNativeGlass &&
      (AppRuntimeDiagnostics.config.enableIOSNativeSearchBar ||
          AppRuntimeDiagnostics.config.enableIOSNativeGlass);

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(searchEventTrackerProvider).setSessionKey(_sessionKey!);

      final initialQuery = widget.initialQuery?.trim() ?? '';
      if (initialQuery.isNotEmpty) {
        await _setSearchText(initialQuery);
      } else if (!widget.openFilters && _useNativeIOSSearch) {
        await _nativeSearchController.focus();
      } else if (!widget.openFilters) {
        _focus.requestFocus();
      }

      if (widget.openFilters && mounted) {
        await _openQuickFiltersSheet();
      }
    });
  }

  Future<void> _setSearchText(String text) async {
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    if (_useNativeIOSSearch) {
      await _nativeSearchController.setText(text);
      await _nativeSearchController.focus();
    } else {
      _focus.requestFocus();
    }
  }

  void _onNativeSearchChanged(String text) {
    if (_controller.text == text) return;
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _onNativeSearchSubmitted(String text) {
    _onNativeSearchChanged(text);
    if (text.trim().length >= 2) {
      _debounce?.cancel();
      setState(() {
        _debouncedQuery = text.trim();
        _isDebouncing = false;
      });
      _performSearch(reset: true);
    }
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

  String get _sortLabel {
    switch (_sort) {
      case 'nearby':
        return AppStrings.sortProximity;
      case 'trending':
        return AppStrings.sortTrending;
      case 'prestige':
        return AppStrings.sortPrestige;
      case 'price_asc':
        return AppStrings.sortPriceAsc;
      case 'price_desc':
        return AppStrings.sortPriceDesc;
      default:
        return AppStrings.sortRelevance;
    }
  }

  Future<void> _openQuickFiltersSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => CNSheetGeometryProbe(
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            void updateSheet(VoidCallback update) {
              update();
              setSheetState(() {});
            }

            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filtres de recherche',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(AppStrings.filterOpenNow),
                      value: _openNow,
                      onChanged: (_) => updateSheet(_toggleOpenNow),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(AppStrings.filterBookableSoon),
                      value: _bookableSoon,
                      onChanged: (_) => updateSheet(_toggleBookableSoon),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(AppStrings.sortByLabel),
                      subtitle: Text(_sortLabel),
                      trailing: const AppIcon('chevron-right', size: 16),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        _openSortSheet();
                      },
                    ),
                    const SizedBox(height: 8),
                    AppButton.primary(
                      label: 'Afficher les résultats',
                      onPressed: () => Navigator.of(sheetContext).pop(),
                    ),
                  ],
                ),
              ),
            );
          },
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
    final categories = ref.watch(categoriesProvider).asData?.value ?? const [];
    final recentSearches = ref.watch(recentSearchesProvider);

    return AppScaffold(
      body: Column(
        children: [
          SearchAppBar(
            controller: _controller,
            focusNode: _focus,
            nativeController: _nativeSearchController,
            sort: _sort,
            isDebouncing: _isDebouncing,
            onSortChanged: _setSort,
            onOpenSortSheet: _openQuickFiltersSheet,
            onNativeChanged: _onNativeSearchChanged,
            onNativeSubmitted: _onNativeSearchSubmitted,
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
        onCategoryTap: (cat) => _setSearchText(cat),
        onRecentTap: (term) => _setSearchText(term),
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
            ? () async {
                await _setSearchText(_correctedQuery!);
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
      onCorrectedTap: () async {
        await _setSearchText(_correctedQuery!);
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
