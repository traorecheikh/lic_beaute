import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';
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
        ref.refresh(salonDetailProvider(widget.salonId).future);

    return AppScaffold(
      appBar: AppTopBar(
        showBackButton: true,
        onBack: () => context.pop(),
        titleWidget: FunnelStepTitle(
          step: widget.step,
          total: 4,
          title: widget.title,
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
