import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../features/discovery/providers/salon_detail_provider.dart';
import '../../../router/app_router.dart';
import '../providers/booking_funnel_provider.dart';
import '../widgets/funnel_step_bar.dart';

class SlotSelectionPage extends ConsumerStatefulWidget {
  const SlotSelectionPage({
    required this.serviceId,
    required this.salonId,
    this.employeeId,
    super.key,
  });

  final String serviceId;
  final String salonId;
  final String? employeeId;

  @override
  ConsumerState<SlotSelectionPage> createState() => _SlotSelectionPageState();
}

class _SlotSelectionPageState extends ConsumerState<SlotSelectionPage> {
  DateTime _selected = DateTime.now().add(const Duration(days: 1));
  Map<String, dynamic>? _selectedSlot;

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
    final availabilityAsync = ref.watch(
      salonAvailabilityProvider(_availabilityParams),
    );

    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcon('arrow-left', size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const FunnelStepTitle(
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
          child: ElevatedButton(
            onPressed: _selectedSlot == null
                ? null
                : () {
                    ref
                        .read(bookingFunnelProvider.notifier)
                        .selectSlot(
                          startsAtIso: _selectedSlot!['startsAt'] as String,
                          employeeId: _selectedSlot!['employeeId'] as String?,
                        );
                    context.push(AppRoutes.bookingReview);
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Confirmer · ${_selectedSlotLabel()}'),
                gapW8,
                AppIcon('chevron-right', size: 16, color: AppColors.white),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _buildSlotGrid(List<dynamic> slots) {
    if (slots.isEmpty) {
      return RefreshIndicator.adaptive(
        color: AppColors.primary,
        onRefresh: _refreshCurrentAvailability,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: const Center(
                child: Text('Aucun créneau disponible ce jour.'),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator.adaptive(
      color: AppColors.primary,
      onRefresh: _refreshCurrentAvailability,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.4,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
        ),
        itemCount: slots.length,
        itemBuilder: (_, i) {
          final item = slots[i] as Map<String, dynamic>;
          final startsAt = DateTime.parse(item['startsAt'] as String).toLocal();
          final hh = startsAt.hour.toString().padLeft(2, '0');
          final mm = startsAt.minute.toString().padLeft(2, '0');
          final slot = '$hh:$mm';
          final isSelected = _selectedSlot?['startsAt'] == item['startsAt'];

          return GestureDetector(
            onTap: () => setState(() => _selectedSlot = item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                  width: isSelected ? 1.5 : 1,
                ),
                boxShadow: isSelected ? null : AppShadows.sm,
              ),
              child: Center(
                child: Text(
                  slot,
                  style: AppTextStyles.labelMd.copyWith(
                    color: isSelected ? AppColors.white : AppColors.onSurface,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _selectedSlotLabel() {
    if (_selectedSlot == null) return '–';
    final startsAt = DateTime.parse(
      _selectedSlot!['startsAt'] as String,
    ).toLocal();
    final hh = startsAt.hour.toString().padLeft(2, '0');
    final mm = startsAt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}
