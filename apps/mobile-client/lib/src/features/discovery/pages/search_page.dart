import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
import '../providers/salon_list_provider.dart';
import '../widgets/empty_search_state.dart';
import '../widgets/salon_list_card.dart';

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
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onQueryChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _onQueryChanged() {
    final raw = _controller.text.trim();
    setState(() => _query = raw);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _debouncedQuery = raw);
    });
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

    // Category suggestions come from the full list (idle state) or are static
    final categories = const [
      'Coiffure',
      'Esthétique',
      'Ongles',
      'Spa',
      'Maquillage',
      'Barbier',
    ];

    _maybeOpenFiltersFromRoute(context, categories);

    return AppScaffold(
      body: Column(
        children: [
          // Search bar header
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
                            color: AppColors.primaryLight,
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
                                    color: AppColors.primary,
                                  ),
                                  if (showLabel) ...[
                                    SizedBox(width: 6.w),
                                    Flexible(
                                      child: Text(
                                        _activeCategory ?? 'Filtrer',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.labelSm.copyWith(
                                          color: AppColors.primary,
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
          // Results — only show when the user has typed or selected a filter
          Expanded(
            child: _query.isEmpty && _activeCategory == null
                ? _SearchIdleState(
                    categories: categories,
                    onCategoryTap: (cat) => setState(() => _activeCategory = cat),
                  )
                : Column(
                    children: [
                      // Category chips — only shown when actively searching
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
                                    () => _activeCategory = active ? null : cat),
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
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: active ? null : AppShadows.sm,
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
                            return RefreshIndicator.adaptive(
                              color: AppColors.primary,
                              onRefresh: refreshSalons,
                              child: AppSalonListView(
                                items: results,
                                isStale: false,
                                cachedAt: null,
                                emptyState: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.55,
                                  child: const Center(
                                    child: EmptySearchState(
                                      icon: 'search',
                                      title: 'Aucun résultat',
                                      subtitle:
                                          'Essayez un autre terme ou une autre catégorie.',
                                    ),
                                  ),
                                ),
                                itemBuilder: (context, i, salon) => SalonListCard(
                                  salon: salon,
                                  onTap: () =>
                                      context.push(AppRoutes.salon(salon.id)),
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

  void _maybeOpenFiltersFromRoute(BuildContext context, List<String> categories) {
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
    final options = categories.isNotEmpty
        ? categories
        : const ['Coiffure', 'Esthétique', 'Spa', 'Ongles', 'Maquillage'];
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
                      onTap: () => setSheetState(() => draftCategory = null),
                    ),
                    for (final c in options)
                      _FilterChoiceChip(
                        label: c,
                        active: draftCategory == c,
                        onTap: () => setSheetState(() => draftCategory = c),
                      ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: AppButton.outline(
                        label: 'Annuler',
                        onPressed: () => Navigator.of(sheetContext, rootNavigator: true).pop(),
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

class _SearchIdleState extends StatelessWidget {
  const _SearchIdleState({
    this.categories = const [],
    this.onCategoryTap,
  });

  final List<String> categories;
  final void Function(String)? onCategoryTap;

  static const _popularCategories = [
    'Coiffure',
    'Esthétique',
    'Ongles',
    'Spa',
    'Maquillage',
    'Barbier',
  ];

  @override
  Widget build(BuildContext context) {
    final suggestions = categories.isNotEmpty
        ? categories.take(8).toList()
        : _popularCategories;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AppIconBox(
                circle: true,
                size: 64.r,
                color: AppColors.primaryLight,
                child: AppIcon('search', size: 26, color: AppColors.primary),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Trouvez votre salon',
              style: AppTextStyles.headlineSm,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Tapez un nom, un quartier, ou choisissez une catégorie ci-dessous.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            Text(
              'CATÉGORIES POPULAIRES',
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
