import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_icon_box.dart';
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
  String? _activeCategory;
  bool _filterPromptHandled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () => setState(() => _query = _controller.text.trim()),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final salonsAsync = ref.watch(salonListProvider);
    Future<void> refreshSalons() => ref.refresh(salonListProvider.future);
    final categories =
        (salonsAsync.asData?.value.data?.items.toList() ?? const [])
            .map((s) => s.category)
            .toSet()
            .toList()
          ..sort();

    _maybeOpenFiltersFromRoute(context, categories);

    return Scaffold(
      backgroundColor: AppColors.neutral,
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
                                GestureDetector(
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
          gapH12,

          // Category chips
          salonsAsync.maybeWhen(
            data: (resource) {
              if (categories.isEmpty) return const SizedBox.shrink();
              return SizedBox(
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
                      onTap: () =>
                          setState(() => _activeCategory = active ? null : cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.surface,
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
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          gapH12,

          // Results
          Expanded(
            child: AppAsyncView(
              value: salonsAsync,
              errorTitle: 'Impossible de charger les salons',
              serverTitle: 'La recherche est indisponible',
              onRetry: refreshSalons,
              builder: (resource) {
                final all =
                    resource.data?.items.toList() ??
                    const <SalonSummaryListResponseItemsInner>[];
                final results = all.where((s) {
                  final q = _query.toLowerCase();
                  final matchQ =
                      q.isEmpty ||
                      s.name.toLowerCase().contains(q) ||
                      s.category.toLowerCase().contains(q) ||
                      (s.neighborhood ?? '').toLowerCase().contains(q) ||
                      s.city.toLowerCase().contains(q);
                  final matchCat =
                      _activeCategory == null || s.category == _activeCategory;

                  return matchQ && matchCat;
                }).toList();

                return RefreshIndicator.adaptive(
                  color: AppColors.primary,
                  onRefresh: refreshSalons,
                  child: AppSalonListView(
                    items: results,
                    isStale: resource.isStale,
                    cachedAt: resource.cachedAt,
                    emptyState: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
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
                      onTap: () => context.push(AppRoutes.salon(salon.id)),
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
    final selected = await showModalBottomSheet<String?>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
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
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        child: const Text('Annuler'),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(
                          sheetContext,
                          draftCategory ?? '',
                        ),
                        child: const Text('Appliquer'),
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
