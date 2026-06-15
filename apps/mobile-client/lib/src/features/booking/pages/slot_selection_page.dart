import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../widgets/slot_variants.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../features/appointments/providers/booking_actions_provider.dart';
import '../../../features/discovery/providers/salon_detail_provider.dart';
import '../../../router/app_router.dart';
import '../providers/booking_funnel_provider.dart';
import '../widgets/funnel_step_bar.dart';

class SlotSelectionPage extends ConsumerStatefulWidget {
  const SlotSelectionPage({
    required this.serviceId,
    required this.salonId,
    this.employeeId,
    this.rescheduleBookingId,
    super.key,
  });

  final String serviceId;
  final String salonId;
  final String? employeeId;
  // When set, the confirm action calls reschedule API instead of navigating to review.
  final String? rescheduleBookingId;

  @override
  ConsumerState<SlotSelectionPage> createState() => _SlotSelectionPageState();
}

class _SlotSelectionPageState extends ConsumerState<SlotSelectionPage> {
  DateTime _selected = DateTime.now().add(const Duration(days: 1));
  Map<String, dynamic>? _selectedSlot;
  bool _isRescheduling = false;

  static const _weekDays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  ({String salonId, String date, String serviceId, String? employeeId})
  get _availabilityParams => (
    salonId: widget.salonId,
    date: _ymd(_selected),
    serviceId: widget.serviceId,
    employeeId: widget.employeeId?.isEmpty == true ? null : widget.employeeId,
  );

  Future<void> _refreshCurrentAvailability() async {
    final params = _availabilityParams;
    ref.invalidate(salonAvailabilityProvider(params));
    await ref.read(salonAvailabilityProvider(params).future);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.serviceId.isEmpty) {
      return AppScaffold(
        appBar: AppTopBar(
          showBackButton: true,
          onBack: () => context.pop(),
          titleWidget: const FunnelStepTitle(
            step: 3,
            total: 4,
            title: 'Choisir un créneau',
            separator: 'sur',
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Prestation manquante. Reprenez la réservation depuis la sélection des services.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ),
      );
    }

    final availabilityAsync = ref.watch(
      salonAvailabilityProvider(_availabilityParams),
    );

    return AppScaffold(
      appBar: AppTopBar(
        showBackButton: true,
        onBack: () => context.pop(),
        titleWidget: const FunnelStepTitle(
          step: 3,
          total: 4,
          title: 'Choisir un créneau',
          separator: 'sur',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateStrip(),
          Expanded(
            child: AppAsyncView(
              value: availabilityAsync,
              errorTitle: 'Impossible de charger les disponibilités',
              serverTitle: 'Les disponibilités sont indisponibles',
              onRetry: _refreshCurrentAvailability,
              builder: _buildSlotGrid,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
          child: AppButton.primary(
            onPressed: _selectedSlot == null ? null : _onConfirm,
            isLoading: _isRescheduling,
            label: widget.rescheduleBookingId != null
                ? 'Déplacer au ${_selectedSlotLabel()}'
                : 'Confirmer · ${_selectedSlotLabel()}',
            icon: AppIcon('chevron-right', size: 16, color: AppColors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _onConfirm() async {
    final slot = _selectedSlot;
    if (slot == null) return;
    final rescheduleId = widget.rescheduleBookingId;

    if (rescheduleId != null) {
      setState(() => _isRescheduling = true);
      try {
        final startsAt = DateTime.parse(slot['startsAt'] as String).toLocal();
        final date = _ymd(startsAt);
        final hh = startsAt.hour.toString().padLeft(2, '0');
        final mm = startsAt.minute.toString().padLeft(2, '0');
        await ref.read(bookingActionsProvider).reschedule(
          bookingId: rescheduleId,
          date: date,
          time: '$hh:$mm',
        );
        if (!mounted) return;
        AppSnackbar.success(context, 'Rendez-vous déplacé avec succès.');
        context.pop();
        context.pop();
      } catch (_) {
        if (!mounted) return;
        AppSnackbar.error(context, 'Impossible de déplacer le rendez-vous.');
      } finally {
        if (mounted) setState(() => _isRescheduling = false);
      }
    } else {
      ref.read(bookingFunnelProvider.notifier).selectSlot(
        startsAtIso: slot['startsAt'] as String,
        employeeId: slot['employeeId'] as String?,
      );
      context.push(AppRoutes.bookingReview);
    }
  }

  String _ymd(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Widget _buildDateStrip() {
    return SizedBox(
      height: 86.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        itemCount: 14,
        itemBuilder: (_, i) {
          final date = DateTime.now().add(Duration(days: i + 1));
          final isSelected =
              _selected.day == date.day &&
              _selected.month == date.month &&
              _selected.year == date.year;

          return GestureDetector(
            onTap: () => setState(() {
              _selected = date;
              _selectedSlot = null;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 52.w,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.onSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: isSelected ? null : AppShadows.sm,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekDays[date.weekday - 1],
                    style: AppTextStyles.bodyXs.copyWith(
                      color: isSelected
                          ? AppColors.surface.withValues(alpha: 0.7)
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${date.day}',
                    style: AppTextStyles.headlineSm.copyWith(
                      color: isSelected
                          ? AppColors.surface
                          : AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _skipToNextDay() {
    setState(() {
      _selectedSlot = null;
      _selected = _selected.add(const Duration(days: 1));
    });
  }

  Widget _buildSlotGrid(List<dynamic> slots) {
    if (slots.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.22),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon('calendar-x', size: 48, color: AppColors.outlineVariant),
                  SizedBox(height: 16.h),
                  Text(
                    'Salon fermé ce jour',
                    style: AppTextStyles.headlineSm,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Aucun créneau disponible pour la date sélectionnée.',
                    style: AppTextStyles.bodySm
                        .copyWith(color: AppColors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  AppButton.outline(
                    onPressed: _skipToNextDay,
                    label: 'Essayer le lendemain',
                    icon: AppIcon('arrow-right', size: 16, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final typed = slots.whereType<Map<String, dynamic>>().toList();
    return buildSlotVariant(
      variant: SlotVariant.v5Accordion,
      slots: typed,
      selected: _selectedSlot,
      onSelect: (s) => setState(() => _selectedSlot = s),
      variantKey: ValueKey('${_ymd(_selected)}-v5'),
    );
  }

  String _selectedSlotLabel() {
    if (_selectedSlot == null) return '-';
    final startsAt = DateTime.parse(
      _selectedSlot!['startsAt'] as String,
    ).toLocal();
    final hh = startsAt.hour.toString().padLeft(2, '0');
    final mm = startsAt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}
