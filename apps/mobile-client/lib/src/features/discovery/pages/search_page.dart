import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive_ce.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_icon_box.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/app_salon_list_view.dart';
import '../../../router/app_router.dart';
import '../providers/categories_provider.dart';
import '../providers/salon_list_provider.dart';
import '../widgets/empty_search_state.dart';
import '../widgets/salon_list_card.dart';

List<String> _loadRecentSearches() {
  try {
    final box = Hive.box<dynamic>(StorageKeys.settingsBox);
    final raw = box.get(StorageKeys.recentSearches);
    if (raw is List) return List<String>.from(raw);
  } catch (_) {}
  return [];
}

void _persistRecentSearches(List<String> searches) {
  try {
    final box = Hive.box<dynamic>(StorageKeys.settingsBox);
    box.put(StorageKeys.recentSearches, searches);
  } catch (_) {}
}

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  static const _searchHeroTag = 'home-search-hero';
  static const _filterHeroTag = 'home-filter-hero';
  final _controller = TextEditingController();
  final _focus = FocusNode();
  String _query = '';
  String _debouncedQuery = '';
  String? _activeCategory;
  bool _filterPromptHandled = false;
  bool _isDebouncing = false;
  Timer? _debounce;
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _recentSearches = _loadRecentSearches();
    _controller.addListener(_onQueryChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
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
      if (raw.length >= 2) _saveSearch(raw);
    });
  }

  void _saveSearch(String term) {
    final trimmed = term.trim();
    if (trimmed.length < 2) return;
    final updated = [
      trimmed,
      ..._recentSearches.where((s) => s.toLowerCase() != trimmed.toLowerCase()),
    ].take(6).toList();
    setState(() => _recentSearches = updated);
    _persistRecentSearches(updated);
  }

  void _removeRecentSearch(String term) {
    final updated = _recentSearches.where((s) => s != term).toList();
    setState(() => _recentSearches = updated);
    _persistRecentSearches(updated);
  }

  void _applyRecentSearch(String term) {
    _controller.text = term;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: term.length),
    );
    _focus.requestFocus();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchKey = (query: _debouncedQuery, category: _activeCategory);
    final salonsAsync = ref.watch(salonSearchProvider(searchKey));
    Future<void> refreshSalons() =>
        ref.refresh(salonSearchProvider(searchKey).future);

    final categories = ref.watch(categoriesProvider).asData?.value ?? const [];

    _maybeOpenFiltersFromRoute(context, categories);

    final isIdle = _query.isEmpty && _activeCategory == null;

    return AppScaffold(
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────
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
                      child: AppIcon(
                        'arrow-left',
                        size: 18,
                        color: AppColors.onSurface,
                      ),
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
                              AppIcon(
                                'search',
                                size: 18,
                                color: AppColors.onSurfaceVariant,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  focusNode: _focus,
                                  style: AppTextStyles.bodyMd.copyWith(
                                    color: AppColors.onSurface,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Salon, catégorie, quartier…',
                                    hintStyle: AppTextStyles.bodyMd.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
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
                                    child: AppIcon(
                                      'close',
                                      size: 16,
                                      color: AppColors.onSurfaceVariant,
                                    ),
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
                    onTap: () => _openFilterSheet(categories),
                    child: Hero(
                      tag: _filterHeroTag,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          height: 46.h,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: _activeCategory != null
                                ? AppColors.primary
                                : AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: AppShadows.sm,
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final showLabel = constraints.maxWidth >= 88.w;
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppIcon(
                                    'filter',
                                    size: 16,
                                    color: _activeCategory != null
                                        ? AppColors.white
                                        : AppColors.primary,
                                  ),
                                  if (showLabel) ...[
                                    SizedBox(width: 6.w),
                                    Flexible(
                                      child: Text(
                                        _activeCategory ?? 'Filtrer',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.labelSm.copyWith(
                                          color: _activeCategory != null
                                              ? AppColors.white
                                              : AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Debounce loading bar ─────────────────────────────────────────
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
          // ── Content ──────────────────────────────────────────────────────
          Expanded(
            child: isIdle
                ? _SearchIdleState(
                    categories: categories,
                    recentSearches: _recentSearches,
                    onCategoryTap: (cat) =>
                        setState(() => _activeCategory = cat),
                    onRecentTap: _applyRecentSearch,
                    onRecentRemove: _removeRecentSearch,
                  )
                : Column(
                    children: [
                      if (categories.isNotEmpty) ...[
                        SizedBox(
                          height: 40.h,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder: (_, _) => gapW8,
                            itemBuilder: (_, i) {
                              final cat = categories[i];
                              final active = _activeCategory == cat;
                              return GestureDetector(
                                onTap: () => setState(
                                  () => _activeCategory =
                                      active ? null : cat,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 160),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: active
                                        ? AppColors.primary
                                        : AppColors.surface,
                                    borderRadius:
                                        BorderRadius.circular(12.r),
                                    boxShadow:
                                        active ? null : AppShadows.sm,
                                  ),
                                  child: Text(
                                    cat,
                                    style: AppTextStyles.labelMd.copyWith(
                                      color: active
                                          ? AppColors.white
                                          : AppColors.onSurface,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        gapH12,
                      ],
                      Expanded(
                        child: AppAsyncView(
                          value: salonsAsync,
                          keepDataOnReload: true,
                          errorTitle: 'Impossible de charger les salons',
                          serverTitle: 'La recherche est indisponible',
                          onRetry: refreshSalons,
                          builder: (results) {
                            // Only show salons that have a real photo.
                            final visible = results
                                .where((s) =>
                                    s.logoUrl != null &&
                                    s.logoUrl!.isNotEmpty)
                                .toList();
                            return RefreshIndicator.adaptive(
                              color: AppColors.primary,
                              onRefresh: refreshSalons,
                              child: AppSalonListView(
                                items: visible,
                                isStale: false,
                                cachedAt: null,
                                emptyState: SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.55,
                                  child: const Center(
                                    child: EmptySearchState(
                                      icon: 'search',
                                      title: 'Aucun résultat',
                                      subtitle:
                                          'Essayez un autre terme ou une autre catégorie.',
                                    ),
                                  ),
                                ),
                                itemBuilder: (context, i, salon) =>
                                    SalonListCard(
                                  salon: salon,
                                  onTap: () => context
                                      .push(AppRoutes.salon(salon.id)),
                                  height: 88.h,
                                  radius: 18.r,
                                  trailing: Padding(
                                    padding: EdgeInsets.only(right: 14.w),
                                    child: AppIcon(
                                      'chevron-right',
                                      size: 16,
                                      color: AppColors.outline,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _maybeOpenFiltersFromRoute(
      BuildContext context, List<String> categories) {
    if (_filterPromptHandled) return;
    final openFilters =
        GoRouterState.of(context).uri.queryParameters['openFilters'] == '1';
    if (!openFilters) return;
    _filterPromptHandled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _openFilterSheet(categories);
    });
  }

  Future<void> _openFilterSheet(List<String> categories) async {
    final options = categories;
    String? draftCategory = _activeCategory;
    final selected = await AppSheet.show<String?>(
      context,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filtrer par catégorie', style: AppTextStyles.headlineSm),
                gapH12,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _FilterChoiceChip(
                      label: 'Toutes',
                      active: draftCategory == null,
                      onTap: () =>
                          setSheetState(() => draftCategory = null),
                    ),
                    for (final c in options)
                      _FilterChoiceChip(
                        label: c,
                        active: draftCategory == c,
                        onTap: () =>
                            setSheetState(() => draftCategory = c),
                      ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: AppButton.outline(
                        label: 'Annuler',
                        onPressed: () => Navigator.of(
                          sheetContext,
                          rootNavigator: true,
                        ).pop(),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: AppButton.primary(
                        label: 'Appliquer',
                        onPressed: () => Navigator.of(
                          sheetContext,
                          rootNavigator: true,
                        ).pop(draftCategory ?? ''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (!mounted || selected == null) return;
    setState(() => _activeCategory = selected.isEmpty ? null : selected);
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SearchIdleState extends StatelessWidget {
  const _SearchIdleState({
    this.categories = const [],
    this.recentSearches = const [],
    this.onCategoryTap,
    this.onRecentTap,
    this.onRecentRemove,
  });

  final List<String> categories;
  final List<String> recentSearches;
  final void Function(String)? onCategoryTap;
  final void Function(String)? onRecentTap;
  final void Function(String)? onRecentRemove;

  @override
  Widget build(BuildContext context) {
    final suggestions = categories.take(8).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Recent searches ──────────────────────────────────────────
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
                    onTap: () => onRecentTap?.call(term),
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
                          color: AppColors.outlineVariant,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppIcon(
                            'clock',
                            size: 13,
                            color: AppColors.onSurfaceVariant,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            term,
                            style: AppTextStyles.labelMd.copyWith(
                              color: AppColors.onSurface,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () => onRecentRemove?.call(term),
                            child: AppIcon(
                              'close',
                              size: 13,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 28.h),
            ] else ...[
              // ── Prompt (only when no history) ──────────────────────────
              Center(
                child: AppIconBox(
                  circle: true,
                  size: 64.r,
                  color: AppColors.primaryLight,
                  child: AppIcon('search', size: 26, color: AppColors.primary),
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  'Trouvez votre salon',
                  style: AppTextStyles.headlineSm,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  'Tapez un nom, un quartier, ou choisissez une catégorie.',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 28.h),
            ],
            // ── Category chips ───────────────────────────────────────────
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
              children: suggestions.map((cat) {
                return GestureDetector(
                  onTap: () => onCategoryTap?.call(cat),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: AppShadows.sm,
                      border: Border.all(
                        color: AppColors.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _FilterChoiceChip extends StatelessWidget {
  const _FilterChoiceChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
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
        child: Text(
          label,
          style: AppTextStyles.labelMd.copyWith(
            color: active ? AppColors.white : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
