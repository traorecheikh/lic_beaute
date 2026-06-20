import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../features/discovery/providers/salon_detail_provider.dart';
import 'app_async_view.dart';
import 'app_scaffold.dart';
import 'app_top_bar.dart';
import '../../features/booking/widgets/funnel_step_bar.dart';

class AppBookingFunnelScaffold extends ConsumerStatefulWidget {
  final String salonId;
  final int step;
  final String title;
  final Widget Function(SalonDetail salon) builder;
  final Widget? bottomNavigationBar;

  const AppBookingFunnelScaffold({
    required this.salonId,
    required this.step,
    required this.title,
    required this.builder,
    this.bottomNavigationBar,
    super.key,
  });

  @override
  ConsumerState<AppBookingFunnelScaffold> createState() =>
      _AppBookingFunnelScaffoldState();
}

class _AppBookingFunnelScaffoldState
    extends ConsumerState<AppBookingFunnelScaffold> {
  @override
  Widget build(BuildContext context) {
    final salonAsync = ref.watch(salonDetailProvider(widget.salonId));

    debugPrint(
      '[BOOKING_SCAFFOLD] salonId=${widget.salonId} '
      'loading=${salonAsync.isLoading} hasError=${salonAsync.hasError} '
      'hasValue=${salonAsync.hasValue}',
    );

    Future<void> refresh() =>
        ref.refresh(salonDetailResourceProvider(widget.salonId).future);

    return AppScaffold(
      appBar: AppTopBar(
        showBackButton: true,
        onBack: () => context.pop(),
        titleWidget: FunnelStepTitle(
          step: widget.step,
          total: 4,
          title: widget.title,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(68.h),
          child: BookingFunnelProgressMeta(
            step: widget.step,
            total: 4,
            salon: salonAsync.value,
          ),
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
      body: AppAsyncView(
        value: salonAsync,
        errorTitle: "Impossible de charger le salon",
        serverTitle: "Le salon est indisponible",
        onRetry: refresh,
        builder: (salon) {
          if (salon == null) {
            return const Center(child: Text("Salon introuvable."));
          }
          return widget.builder(salon);
        },
      ),
    );
  }
}

class BookingFunnelProgressMeta extends StatelessWidget {
  const BookingFunnelProgressMeta({
    required this.step,
    required this.total,
    this.salon,
    super.key,
  });

  final int step;
  final int total;
  final SalonDetail? salon;

  @override
  Widget build(BuildContext context) {
    final photoUrl = salon != null && salon!.gallery.isNotEmpty
        ? salon!.gallery.first
        : salon?.logoUrl;

    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: List.generate(
              total,
              (i) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: 3.h,
                  margin: EdgeInsets.only(right: i < total - 1 ? 4.w : 0),
                  decoration: BoxDecoration(
                    color: i < step ? AppColors.primary : AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                clipBehavior: Clip.antiAlias,
                child: photoUrl != null && photoUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: photoUrl,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text(
                          ((salon?.name.isNotEmpty ?? false)
                                  ? salon!.name.substring(0, 1).toUpperCase()
                                  : 'S'),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  salon?.name ?? 'Chargement du salon...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
