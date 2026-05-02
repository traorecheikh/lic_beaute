import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../features/discovery/providers/salon_detail_provider.dart';
import '../../../router/app_router.dart';
import '../providers/booking_funnel_provider.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final salonAsync = ref.watch(salonDetailProvider(widget.salonId));
    Future<void> refreshSalon() =>
        ref.refresh(salonDetailProvider(widget.salonId).future);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Étape 1 / 4',
              style: AppTextStyles.labelSm.copyWith(color: colorScheme.primary),
            ),
            Text('Choisir une prestation', style: AppTextStyles.headlineMd),
          ],
        ),
      ),
      body: salonAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: EdgeInsets.all(24.r),
          child: AppErrorState(
            error: error,
            fallbackTitle: 'Impossible de charger les prestations',
            serverTitle: 'Les prestations sont indisponibles',
            onRetry: refreshSalon,
          ),
        ),
        data: (salon) {
          final services = salon?.services.toList() ?? const [];
          if (services.isEmpty) {
            return const Center(child: Text('Aucune prestation disponible.'));
          }

          final grouped = <String, List<dynamic>>{
            salon?.category ?? 'Prestations': services,
          };

          return RefreshIndicator.adaptive(
            color: colorScheme.primary,
            onRefresh: refreshSalon,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.all(24.w),
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryHeader(entry.key),
                    ...entry.value.map(
                      (service) => _buildServiceItem(
                        context,
                        id: service.id,
                        name: service.name,
                        duration: '${service.durationMinutes} min',
                        price: _xof(service.priceXof),
                        description: service.depositRequiredXof != null
                            ? 'Acompte: ${_xof(service.depositRequiredXof!)}'
                            : null,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: ElevatedButton(
            onPressed: _selectedServiceId == null
                ? null
                : () {
                    final salon = ref
                        .read(salonDetailProvider(widget.salonId))
                        .value;
                    final selected = salon?.services
                        .where((s) => s.id == _selectedServiceId)
                        .firstOrNull;
                    if (selected == null) {
                      AppSnackbar.error(context, 'Service introuvable.');
                      return;
                    }
                    ref
                        .read(bookingFunnelProvider.notifier)
                        .startFunnel(widget.salonId);
                    ref
                        .read(bookingFunnelProvider.notifier)
                        .selectService(
                          serviceId: selected.id,
                          serviceName: selected.name,
                          price: selected.priceXof.toInt(),
                          durationMinutes: selected.durationMinutes,
                        );
                    context.push(
                      '${AppRoutes.bookingStaff}?serviceId=$_selectedServiceId&salonId=${widget.salonId}',
                    );
                  },
            child: const Text('Continuer'),
          ),
        ),
      ),
    );
  }

  String _xof(int amount) {
    final thousands = amount ~/ 1000;
    final remainder = amount % 1000;
    return remainder == 0 ? '$thousands 000 XOF' : '$amount XOF';
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        title,
        style: AppTextStyles.labelLg.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context, {
    required String id,
    required String name,
    required String duration,
    required String price,
    String? description,
  }) {
    final isSelected = _selectedServiceId == id;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _selectedServiceId = id),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: AppTextStyles.bodyLg.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  price,
                  style: AppTextStyles.bodyLg.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              duration,
              style: AppTextStyles.bodySm.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (description != null) ...[
              SizedBox(height: 8.h),
              Text(description, style: AppTextStyles.bodySm),
            ],
          ],
        ),
      ),
    );
  }
}
