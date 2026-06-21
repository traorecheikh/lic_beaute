import '../../../core/widgets/debounced_action.dart';
import '../widgets/booking_funnel_shared.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';
import '../../../core/widgets/app_icon.dart';

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
  void initState() {
    super.initState();
    debugPrint('[BOOKING_SERVICE] open salonId=${widget.salonId}');
  }

  @override
  Widget build(BuildContext context) {
    return AppBookingFunnelScaffold(
      salonId: widget.salonId,
      step: 1,
      title: 'Choisir une prestation',
      bottomNavigationBar: AppBottomBar(
        child: AppButton.primary(
          onPressed: _selectedServiceId == null ? null : debouncedAction(_onContinue),
          label: 'Continuer',
        ),
      ),
      builder: (salon) {
        final services = salon.services.toList();
        debugPrint(
          '[BOOKING_SERVICE] render salonId=${widget.salonId} services=${services.length}',
        );
        if (services.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Aucune prestation disponible pour ce salon.',
                    style: AppTextStyles.bodyMd
                        .copyWith(color: AppColors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  gapH16,
                  AppButton.outline(
                    label: 'Retour',
                    onPressed: () => Navigator.of(context).pop(),
                    isFullWidth: false,
                  ),
                ],
              ),
            ),
          );
        }

        // Single service → hero layout, auto-select
        if (services.length == 1) {
          return _buildHero(services.first);
        }

        // Group by category
        final byCategory = <String, List<SalonDetailServicesInner>>{};
        for (final s in services) {
          byCategory.putIfAbsent(s.category, () => []).add(s);
        }

        if (byCategory.length == 1 && services.length <= 4) {
          // All same category, few items → 2-col grid
          return _buildGrid(services);
        }

        // Multiple categories or many items → grouped list
        return _buildGroupedList(byCategory);
      },
    );
  }

  // ─── Hero: single service auto-selected ────────────────────────────────────

  Widget _buildHero(SalonDetailServicesInner s) {
    // Auto-select on first build
    if (_selectedServiceId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedServiceId = s.id);
      });
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  s.category,
                  style: AppTextStyles.labelSm
                      .copyWith(color: AppColors.white, letterSpacing: 0.8),
                ),
              ),
              SizedBox(height: 14.h),
              Text(s.name, style: AppTextStyles.headlineMd),
              SizedBox(height: 6.h),
              Row(children: [
                Text(
                  '${s.durationMinutes} min',
                  style: AppTextStyles.bodyMd
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                SizedBox(width: 12.w),
                Text(
                  '${s.priceXof.toInt()} XOF',
                  style: AppTextStyles.priceMd,
                ),
              ]),
              if (s.depositRequiredXof != null &&
                  s.depositRequiredXof! > 0) ...[
                SizedBox(height: 10.h),
                _depositBadge(s.depositRequiredXof!.toInt()),
              ],
              SizedBox(height: 16.h),
              Row(children: [
                AppIcon('check-circle', size: 18, color: AppColors.primary),
                SizedBox(width: 6.w),
                Text(
                  'Sélectionnée automatiquement',
                  style: AppTextStyles.bodySm
                      .copyWith(color: AppColors.primary),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // ─── 2-col grid: same category, ≤4 items ───────────────────────────────────

  Widget _buildGrid(List<SalonDetailServicesInner> services) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 100.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.05,
      ),
      itemCount: services.length,
      itemBuilder: (context, i) {
        final s = services[i];
        final isSelected = _selectedServiceId == s.id;
        return GestureDetector(
          onTap: () {
            AppHaptics.light();
            setState(() => _selectedServiceId = s.id);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryLight : AppColors.surface,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected ? null : AppShadows.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    s.name,
                    style: AppTextStyles.labelLg.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.onSurface,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${s.durationMinutes} min',
                  style: AppTextStyles.bodySm
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${s.priceXof.toInt()} XOF',
                  style: AppTextStyles.priceMd.copyWith(
                    color: isSelected ? AppColors.primary : null,
                  ),
                ),
                if (s.depositRequiredXof != null &&
                    s.depositRequiredXof! > 0) ...[
                  SizedBox(height: 6.h),
                  _depositBadge(s.depositRequiredXof!.toInt()),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Grouped list: multiple categories or many items ───────────────────────

  Widget _buildGroupedList(Map<String, List<SalonDetailServicesInner>> byCategory) {
    final sections = byCategory.entries.toList();
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 100.h),
      itemCount: sections.fold<int>(0, (sum, e) => sum + e.value.length + 1),
      itemBuilder: (context, flatIdx) {
        // compute section + item index from flatIdx
        int offset = 0;
        for (final entry in sections) {
          final count = entry.value.length + 1; // 1 header + items
          if (flatIdx < offset + count) {
            final localIdx = flatIdx - offset;
            if (localIdx == 0) {
              // section header
              return Padding(
                padding: EdgeInsets.only(
                    top: offset == 0 ? 8.h : 20.h, bottom: 10.h),
                child: Text(
                  entry.key.toUpperCase(),
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
              );
            }
            final s = entry.value[localIdx - 1];
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _serviceListCard(s),
            );
          }
          offset += count;
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _serviceListCard(SalonDetailServicesInner s) {
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
                  style: AppTextStyles.bodySm
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                if (s.depositRequiredXof != null &&
                    s.depositRequiredXof! > 0) ...[
                  gapH8,
                  _depositBadge(s.depositRequiredXof!.toInt()),
                ],
              ],
            ),
          ),
          Text('${s.priceXof.toInt()} XOF', style: AppTextStyles.priceMd),
        ],
      ),
    );
  }

  Widget _depositBadge(int amount) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'Dépôt $amount XOF',
          style: AppTextStyles.labelSm.copyWith(
            color: AppColors.onSecondaryContainer,
          ),
        ),
      );

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
      depositAmount: selected.depositRequiredXof?.toInt() ?? 0,
    );
    context.push(
      '${AppRoutes.bookingStaff}?serviceId=$_selectedServiceId&salonId=${widget.salonId}',
    );
  }
}
