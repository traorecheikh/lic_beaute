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
  final _controller = TextEditingController();
  final _focus = FocusNode();
  String _query = '';
  String? _activeCategory;

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
                ],
              ),
            ),
          ),
          gapH12,

          // Category chips
          salonsAsync.maybeWhen(
            data: (resource) {
              final categories =
                  (resource.data?.items.toList() ?? const [])
                      .map((s) => s.category)
                      .toSet()
                      .toList()
                    ..sort();
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
}
