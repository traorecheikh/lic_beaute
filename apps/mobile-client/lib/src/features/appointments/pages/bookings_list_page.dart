import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/debounced_action.dart';
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

    return DefaultTabController(
      length: 2,
      child: AppScaffold(
        backgroundColor: AppColors.neutral,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.surface,
              padding: EdgeInsets.fromLTRB(
                24.w,
                MediaQuery.paddingOf(context).top + 20.h,
                20.w,
                12.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.bookingsPageHeading,
                    style: AppTextStyles.headlineMd,
                  ),
                  SizedBox(height: 16.h),
                  const _AdaptiveBookingsSegments(),
                ],
              ),
            ),
            Expanded(
              child: AppAsyncView(
                value: bookingsAsync,
                keepDataOnReload: true,
                errorTitle: AppStrings.loadBookingsError,
                serverTitle: AppStrings.bookingsServerTitle,
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
                                    .completed ||
                            b.status ==
                                BookingSummaryListResponseItemsInnerStatusEnum
                                    .cancelled,
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
          ],
        ),
      ),
    );
  }
}

class _AdaptiveBookingsSegments extends StatelessWidget {
  const _AdaptiveBookingsSegments();

  @override
  Widget build(BuildContext context) {
    final controller = DefaultTabController.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final selectedIndex = controller.index;
        if (Theme.of(context).platform == TargetPlatform.android) {
          return SizedBox(
            width: double.infinity,
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment<int>(
                  value: 0,
                  label: Text(AppStrings.bookingsTabUpcoming),
                  icon: Icon(Icons.upcoming_rounded),
                ),
                ButtonSegment<int>(
                  value: 1,
                  label: Text(AppStrings.bookingsTabPast),
                  icon: Icon(Icons.history_rounded),
                ),
              ],
              selected: {selectedIndex},
              showSelectedIcon: false,
              onSelectionChanged: (selection) {
                controller.animateTo(selection.first);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.comfortable,
                minimumSize: WidgetStatePropertyAll(Size(0, 48.h)),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.selected)
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant;
                }),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.selected)
                      ? AppColors.primaryLight
                      : AppColors.surface;
                }),
                side: WidgetStatePropertyAll(
                  BorderSide(color: AppColors.outlineVariant),
                ),
              ),
            ),
          );
        }

        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.lg.r),
          ),
          child: TabBar(
            controller: controller,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            indicator: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.md.r),
              boxShadow: AppShadows.sm,
            ),
            indicatorPadding: EdgeInsets.all(4.r),
            labelColor: AppColors.onPrimary,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            labelStyle: AppTextStyles.labelMd,
            unselectedLabelStyle: AppTextStyles.labelMd,
            tabs: const [
              Tab(text: AppStrings.bookingsTabUpcoming),
              Tab(text: AppStrings.bookingsTabPast),
            ],
          ),
        );
      },
    );
  }
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
          padding: EdgeInsets.only(
            bottom: 28.h,
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
                      title: AppStrings.bookingsEmptyTitle,
                      subtitle: AppStrings.bookingsEmptySubtitle,
                      compact: false,
                    ),
                    gapH16,
                    AppButton.primary(
                      label: AppStrings.discoverSalonsCta,
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
        padding: EdgeInsets.fromLTRB(
          20.w,
          20.w,
          20.w,
          28.h,
        ),
        itemCount: items.length + (staleAt != null ? 1 : 0),
        separatorBuilder: (_, _) => gapH16,
        itemBuilder: (_, i) {
          if (staleAt != null) {
            if (i == 0) {
              return StaleDataNotice(cachedAt: staleAt!);
            }
            i -= 1;
          }
          final b = items[i];

          return AppPressable(
            onTap: debouncedAction(
              () => context.push(
                '${AppRoutes.bookingDetailPath(b.id)}${isUpcoming ? '' : '?past=true'}',
              ),
            ),
            child: BookingListTile(booking: b, isUpcoming: isUpcoming),
          );
        },
      ),
    );
  }
}
