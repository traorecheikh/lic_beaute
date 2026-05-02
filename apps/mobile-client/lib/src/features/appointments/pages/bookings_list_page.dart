import 'package:beauteavenue_api/beauteavenue_api.dart';
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
import '../../discovery/widgets/stale_data_notice.dart';
import '../providers/bookings_list_provider.dart';

class BookingsListPage extends ConsumerWidget {
  const BookingsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsListProvider);
    Future<void> refreshBookings() => ref.refresh(bookingsListProvider.future);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.neutral,
        body: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverSafeArea(
              bottom: false,
              sliver: SliverToBoxAdapter(
                child: Container(
                  color: AppColors.surface,
                  padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
                  child: Text(
                    'Mes Rendez-vous',
                    style: AppTextStyles.headlineMd,
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.onSurfaceVariant,
                  labelStyle: AppTextStyles.labelLg,
                  tabs: const [
                    Tab(text: 'À VENIR'),
                    Tab(text: 'PASSÉS'),
                  ],
                ),
              ),
            ),
          ],
          body: bookingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Padding(
            padding: EdgeInsets.all(24.r),
            child: AppErrorState(
              error: error,
              fallbackTitle: 'Impossible de charger les rendez-vous',
              serverTitle: 'Le suivi des rendez-vous est indisponible',
              onRetry: refreshBookings,
            ),
          ),
          data: (resource) {
            final all =
                resource.data?.items.toList() ??
                const <BookingSummaryListResponseItemsInner>[];
            final now = DateTime.now();
            final upcoming = all
                .where(
                  (b) =>
                      b.startsAt.isAfter(now) &&
                      b.status !=
                          BookingSummaryListResponseItemsInnerStatusEnum
                              .cancelled,
                )
                .toList();
            final past = all
                .where(
                  (b) =>
                      b.startsAt.isBefore(now) ||
                      b.status ==
                          BookingSummaryListResponseItemsInnerStatusEnum
                              .completed,
                )
                .toList();

            return TabBarView(
              children: [
                _BookingTab(
                  items: upcoming,
                  isUpcoming: true,
                  onRefresh: refreshBookings,
                  staleAt: resource.isStale ? resource.cachedAt : null,
                ),
                _BookingTab(
                  items: past,
                  isUpcoming: false,
                  onRefresh: refreshBookings,
                  staleAt: resource.isStale ? resource.cachedAt : null,
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => _tabBar != oldDelegate._tabBar;
}

class _BookingTab extends StatelessWidget {
  const _BookingTab({
    required this.items,
    required this.isUpcoming,
    required this.onRefresh,
    required this.staleAt,
  });

  final List<BookingSummaryListResponseItemsInner> items;
  final bool isUpcoming;
  final Future<void> Function() onRefresh;
  final DateTime? staleAt;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return RefreshIndicator.adaptive(
        color: AppColors.primary,
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            if (staleAt != null)
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                child: StaleDataNotice(cachedAt: staleAt!),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Center(
                child: Text('Aucun rendez-vous', style: AppTextStyles.bodyMd),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator.adaptive(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.all(20.w),
        itemCount: items.length + (staleAt != null ? 1 : 0),
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, i) {
          if (staleAt != null) {
            if (i == 0) {
              return StaleDataNotice(cachedAt: staleAt!);
            }
            i -= 1;
          }
          final b = items[i];
          final date = b.startsAt.toLocal();
          final dateLabel =
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
          final timeLabel =
              '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

          return GestureDetector(
            onTap: () => context.push(
              '${AppRoutes.bookingDetailPath(b.id)}${isUpcoming ? '' : '?past=true'}',
            ),
            child: Container(
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: AppShadows.card,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: AppIcon(
                        'calendar',
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.salonName, style: AppTextStyles.labelLg),
                        SizedBox(height: 2.h),
                        Text(b.serviceName, style: AppTextStyles.bodySm),
                        SizedBox(height: 6.h),
                        Text(
                          '$dateLabel · $timeLabel',
                          style: AppTextStyles.labelSm,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isUpcoming
                          ? AppColors.statusConfirmedBg
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      b.status.name,
                      style: AppTextStyles.labelSm.copyWith(
                        color: isUpcoming
                            ? AppColors.statusConfirmedText
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
