import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import 'app_async_view.dart';
import 'app_scaffold.dart';
import '../../features/discovery/providers/cached_resource.dart';

/// A family provider that takes a [String] argument (e.g. booking ID) and
/// returns a [CachedResource]<T>. This is the typed contract for the
/// [AppBookingAsyncScaffold.provider] parameter.
/// Uses a function type because [FutureProviderFamily] is not part of the
/// public Riverpod API (not exported via `show` list).
typedef BookingDetailResourceProvider<T>
    = FutureProvider<CachedResource<T>> Function(String bookingId);

class AppBookingAsyncScaffold<T> extends ConsumerWidget {
  final String bookingId;
  final String errorTitle;
  final String serverTitle;
  final String? pageTitle;
  final String? pageSubtitle;
  final List<Widget> Function(CachedResource<T> resource) sliverBuilder;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final BookingDetailResourceProvider<T> provider;

  const AppBookingAsyncScaffold({
    required this.bookingId,
    required this.errorTitle,
    required this.serverTitle,
    this.pageTitle,
    this.pageSubtitle,
    required this.sliverBuilder,
    this.bottomNavigationBar,
    this.appBar,
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(provider(bookingId));
    Future<void> refresh() => ref.refresh(provider(bookingId).future);

    return AppScaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        top: appBar == null,
        bottom: false,
        child: AppAsyncView<CachedResource<T>>(
          value: detailAsync,
          errorTitle: errorTitle,
          serverTitle: serverTitle,
          onRetry: refresh,
          builder: (resource) {
            if (resource.data == null) {
              return const Center(child: Text('Indisponible'));
            }
            return RefreshIndicator.adaptive(
              color: AppColors.primary,
              onRefresh: refresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  if (pageTitle != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pageTitle!, style: AppTextStyles.displaySm),
                            if (pageSubtitle != null) ...[
                              gapH4,
                              Text(
                                pageSubtitle!,
                                style: AppTextStyles.bodyMd.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ...sliverBuilder(resource),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
