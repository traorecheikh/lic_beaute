import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../router/app_router.dart';
import '../../discovery/widgets/stale_data_notice.dart';
import '../providers/bookings_list_provider.dart';
import '../widgets/booking_list_tile.dart';

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
          body: AppAsyncView(
            value: bookingsAsync,
            errorTitle: 'Impossible de charger les rendez-vous',
            serverTitle: 'Le suivi des rendez-vous est indisponible',
            onRetry: refreshBookings,
            builder: (resource) {
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
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppColors.surface, child: _tabBar);
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) =>
      _tabBar != oldDelegate._tabBar;
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
                child: AppEmptyState(
                  icon: 'calendar',
                  title: 'Aucun rendez-vous',
                  subtitle:
                      'Vos réservations à venir et passées apparaîtront ici.',
                  compact: true,
                ),
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
        separatorBuilder: (_, _) => gapH12,
        itemBuilder: (_, i) {
          if (staleAt != null) {
            if (i == 0) {
              return StaleDataNotice(cachedAt: staleAt!);
            }
            i -= 1;
          }
          final b = items[i];

          return GestureDetector(
            onTap: () => context.push(
              '${AppRoutes.bookingDetailPath(b.id)}${isUpcoming ? '' : '?past=true'}',
            ),
            child: BookingListTile(booking: b, isUpcoming: isUpcoming),
          );
        },
      ),
    );
  }
}
