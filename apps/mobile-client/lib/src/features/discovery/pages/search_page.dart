import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';
import '../providers/salon_list_provider.dart';
import '../widgets/stale_data_notice.dart';

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
                    child: Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.sm,
                      ),
                      child: Center(
                        child: AppIcon(
                          'arrow-left',
                          size: 18,
                          color: AppColors.onSurface,
                        ),
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
                          SizedBox(width: 4.w),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),

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
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
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
                            color: active ? Colors.white : AppColors.onSurface,
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
          SizedBox(height: 12.h),

          // Results
          Expanded(
            child: salonsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Padding(
                padding: EdgeInsets.all(24.r),
                child: AppErrorState(
                  error: error,
                  fallbackTitle: 'Impossible de charger les salons',
                  serverTitle: 'La recherche est indisponible',
                  onRetry: refreshSalons,
                ),
              ),
              data: (resource) {
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
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 120.h),
                    itemCount: results.isEmpty
                        ? 1
                        : results.length +
                              (resource.isStale && resource.cachedAt != null
                                  ? 1
                                  : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (_, i) {
                      if (resource.isStale && resource.cachedAt != null) {
                        if (i == 0) {
                          return StaleDataNotice(cachedAt: resource.cachedAt!);
                        }
                        i -= 1;
                      }
                      if (results.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppIcon(
                                  'search',
                                  size: 36,
                                  color: AppColors.outline,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Aucun résultat',
                                  style: AppTextStyles.headlineSm,
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  'Essayez un autre terme ou une autre catégorie.',
                                  style: AppTextStyles.bodyMd.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      final salon = results[i];
                      return _SearchResultCard(
                        name: salon.name,
                        category: salon.category,
                        location: '${salon.neighborhood ?? ''} ${salon.city}'
                            .trim(),
                        rating: salon.averageRating.toStringAsFixed(1),
                        imageUrl: salon.logoUrl ?? '',
                        onTap: () => context.push(AppRoutes.salon(salon.id)),
                      );
                    },
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

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    required this.name,
    required this.category,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.onTap,
  });

  final String name, category, location, rating, imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 88.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(18.r),
              ),
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 88.r,
                      height: 88.h,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 88.r,
                      height: 88.h,
                      color: AppColors.primaryLight,
                      child: Center(
                        child: AppIcon(
                          'sparkle',
                          size: 24,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.labelLg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      category,
                      style: AppTextStyles.bodySm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        AppIcon(
                          'map-pin',
                          size: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            location,
                            style: AppTextStyles.bodyXs,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppIcon('star', size: 11, color: AppColors.secondary),
                        SizedBox(width: 3.w),
                        Text(rating, style: AppTextStyles.labelSm),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 14.w),
              child: AppIcon(
                'chevron-right',
                size: 16,
                color: AppColors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
