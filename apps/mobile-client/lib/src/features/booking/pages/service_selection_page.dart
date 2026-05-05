import '../widgets/booking_funnel_shared.dart';

class ServiceSelectionPage extends ConsumerStatefulWidget {
  final String salonId;
  const ServiceSelectionPage({super.key, required this.salonId});

  @override
  ConsumerState<ServiceSelectionPage> createState() =>
      _ServiceSelectionPageState();
}

class _ServiceSelectionPageState extends ConsumerState<ServiceSelectionPage> {
  String? _selectedServiceId;

  @override
  Widget build(BuildContext context) {
    return AppBookingFunnelScaffold(
      salonId: widget.salonId,
      step: 1,
      title: 'Choisir une prestation',
      bottomNavigationBar: AppBottomBar(
        child: AppButton.primary(
          onPressed: _selectedServiceId == null ? null : _onContinue,
          label: 'Continuer',
        ),
      ),
      builder: (salon) => ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 100.h),
        itemCount: salon.services.length,
        separatorBuilder: (_, __) => gapH12,
        itemBuilder: (context, i) {
          final s = salon.services[i];
          final isSelected = _selectedServiceId == s.id;
          return AppSelectableCard(
            selected: isSelected,
            onTap: () {
              AppHaptics.light();
              setState(() => _selectedServiceId = s.id);
            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name, style: AppTextStyles.labelLg),
                      gapH4,
                      Text(
                        '${s.durationMinutes} min',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${s.priceXof.toInt()} XOF',
                  style: AppTextStyles.priceMd,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onContinue() {
    final salon = ref.read(salonDetailProvider(widget.salonId)).value;
    final selected =
        salon?.services.where((s) => s.id == _selectedServiceId).firstOrNull;
    if (selected == null) {
      AppSnackbar.error(context, 'Service introuvable.');
      return;
    }
    ref.read(bookingFunnelProvider.notifier).startFunnel(widget.salonId);
    ref.read(bookingFunnelProvider.notifier).selectService(
      serviceId: selected.id,
      serviceName: selected.name,
      price: selected.priceXof.toInt(),
      durationMinutes: selected.durationMinutes,
    );
    context.push(
      '${AppRoutes.bookingStaff}?serviceId=$_selectedServiceId&salonId=${widget.salonId}',
    );
  }
}
