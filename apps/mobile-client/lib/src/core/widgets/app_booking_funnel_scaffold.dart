import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/discovery/providers/salon_detail_provider.dart';
import 'app_async_view.dart';
import '../../features/booking/widgets/funnel_step_bar.dart';

class AppBookingFunnelScaffold extends ConsumerWidget {
  final String salonId;
  final int step;
  final String title;
  final Widget Function(dynamic salon) builder;
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
  Widget build(BuildContext context, WidgetRef ref) {
    final salonAsync = ref.watch(salonDetailProvider(salonId));
    Future<void> refresh() => ref.refresh(salonDetailProvider(salonId).future);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: FunnelStepTitle(
          step: step,
          total: 4,
          title: title,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
      body: AppAsyncView(
        value: salonAsync,
        errorTitle: "Impossible de charger le salon",
        serverTitle: "Le salon est indisponible",
        onRetry: refresh,
        builder: builder,
      ),
    );
  }
}
