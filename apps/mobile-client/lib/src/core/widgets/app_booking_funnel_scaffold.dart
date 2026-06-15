import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  AsyncValue<SalonDetail?> _salonAsync = const AsyncLoading();

  @override
  void initState() {
    super.initState();
    // Read current value (if already loaded) without subscribing.
    final current = ref.read(salonDetailProvider(widget.salonId));
    if (current.hasValue) {
      _salonAsync = current;
    }
    // Listen for changes but apply them after the frame to avoid
    // setState-during-build when two scaffolds mount simultaneously.
    ref.listen(salonDetailProvider(widget.salonId), (_, next) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _salonAsync = next);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '[BOOKING_SCAFFOLD] salonId=${widget.salonId} '
      'loading=${_salonAsync.isLoading} hasError=${_salonAsync.hasError} '
      'hasValue=${_salonAsync.hasValue}',
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
        value: _salonAsync,
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
