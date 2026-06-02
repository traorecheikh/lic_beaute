import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
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

    final innerTabBar = TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      indicator: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(11.r),
        boxShadow: AppShadows.sm,
      ),
      indicatorPadding: EdgeInsets.all(4.r),
      labelColor: AppColors.onSurface,
      unselectedLabelColor: AppColors.onSurfaceVariant,
      labelStyle: AppTextStyles.labelMd,
      unselectedLabelStyle: AppTextStyles.labelMd,
      tabs: const [
        Tab(text: 'À VENIR'),
        Tab(text: 'PASSÉS'),
      ],
    );

    return DefaultTabController(
      length: 2,
      child: AppScaffold(
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
                innerTabBar,
                extent: innerTabBar.preferredSize.height + 20.h,
              ),
            ),
          ],
          body: AppAsyncView(
            value: bookingsAsync,
            keepDataOnReload: true,
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
  _TabBarDelegate(this._tabBar, {required this.extent});

  final Widget _tabBar;
  final double extent;

  @override
  double get minExtent => extent;
  @override
  double get maxExtent => extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: _tabBar,
      ),
    );
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppEmptyState(
                      icon: 'calendar',
                      title: 'Aucun rendez-vous',
                      subtitle:
                          'Vos réservations à venir et passées apparaîtront ici.',
                      compact: false,
                    ),
                    gapH16,
                    AppButton.primary(
                      label: 'Découvrir des salons',
                      onPressed: () => context.go(AppRoutes.home),
                      isFullWidth: false,
                      width: 220.w,
                    ),
                  ],
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

          return AppPressable(
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
