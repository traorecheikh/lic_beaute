import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../discovery/providers/salon_detail_provider.dart';

const _kWeekDays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

class FunnelSlotStep extends ConsumerWidget {
  const FunnelSlotStep({
    required this.salonId,
    required this.serviceId,
    this.employeeId,
    required this.scrollCtrl,
    required this.selectedDate,
    required this.selectedHour,
    required this.selectedSlot,
    required this.onDateChange,
    required this.onHourSelect,
    required this.onSlotSelect,
    super.key,
  });

  final String salonId, serviceId;
  final String? employeeId;
  final ScrollController scrollCtrl;
  final DateTime selectedDate;
  final int? selectedHour;
  final Map<String, dynamic>? selectedSlot;
  final void Function(DateTime) onDateChange;
  final void Function(int) onHourSelect;
  final void Function(Map<String, dynamic>) onSlotSelect;

  static String _ymd(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Returns {blockStart: [{label, startsAt, employeeId}, ...]} grouped by 2-hour blocks
  static Map<int, List<Map<String, dynamic>>> groupSlots(List<dynamic> raw) {
    final map = <int, List<Map<String, dynamic>>>{};
    for (final e in raw) {
      final item = e as Map<String, dynamic>;
      final dt = DateTime.parse(item['startsAt'] as String).toLocal();
      final block = (dt.hour ~/ 2) * 2;
      map.putIfAbsent(block, () => []).add({
        'label':
            '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}',
        'startsAt': item['startsAt'],
        'employeeId': item['employeeId'],
      });
    }
    for (final v in map.values) {
      v.sort(
        (a, b) => (a['startsAt'] as String).compareTo(b['startsAt'] as String),
      );
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (serviceId.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            AppStrings.slotChooseServiceFirst,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final params = (
      salonId: salonId,
      date: _ymd(selectedDate),
      serviceId: serviceId,
      employeeId: employeeId?.isEmpty == true ? null : employeeId,
    );
    final availabilityAsync = ref.watch(salonAvailabilityProvider(params));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Date strip ──────────────────────────────────────────────────────
        SizedBox(
          height: 72.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
            itemCount: 14,
            itemBuilder: (_, i) {
              final date = DateTime.now().add(Duration(days: i + 1));
              final isSelected =
                  selectedDate.day == date.day &&
                  selectedDate.month == date.month &&
                  selectedDate.year == date.year;
              return GestureDetector(
                onTap: () => onDateChange(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 52.w,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(14.r),
                    border: isSelected
                        ? null
                        : Border.all(color: AppColors.outlineVariant),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _kWeekDays[date.weekday - 1],
                        style: AppTextStyles.bodyXs.copyWith(
                          color: isSelected
                              ? AppColors.white.withValues(alpha: 0.75)
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${date.day}',
                        style: AppTextStyles.labelLg.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // ── Hour rail + minute grid ─────────────────────────────────────────
        Expanded(
          child: availabilityAsync.when(
            loading: () => const Center(child: CircularProgressIndicator.adaptive()),
            error: (_, _) => Center(
              child: Text(
                AppStrings.loadAvailabilityError,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            data: (raw) {
              if (raw.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIcon('calendar', size: 32, color: AppColors.outline),
                      const SizedBox(height: 12),
                      Text(
                        AppStrings.noSlotsDate,
                        style: AppTextStyles.headlineSm,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.tryAnotherDate,
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final grouped = groupSlots(raw);
              final blocks = grouped.keys.toList();
              final activeBlock =
                  selectedHour != null && grouped.containsKey(selectedHour)
                  ? selectedHour
                  : null;
              final activeSlots = activeBlock != null
                  ? grouped[activeBlock]!
                  : <Map<String, dynamic>>[];

              return Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.timeRangeLabel,
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // 2-hour block rail
                    SizedBox(
                      height: 58.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: blocks.length,
                        itemBuilder: (_, i) {
                          final b = blocks[i];
                          final isSelected = activeBlock == b;
                          final label =
                              '${b.toString().padLeft(2, '0')}-${(b + 2).toString().padLeft(2, '0')}h';
                          return GestureDetector(
                            onTap: () => onHourSelect(b),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              width: 74.w,
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.surface,
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
                                  label,
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Slot grid (animated in)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                      child: activeBlock == null
                          ? Padding(
                              key: const ValueKey('hint'),
                              padding: EdgeInsets.only(top: 40.h),
                              child: Center(
                                child: Text(
                                  AppStrings.selectTimeRange,
                                  style: AppTextStyles.bodyMd.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              key: ValueKey(activeBlock),
                              padding: EdgeInsets.only(top: 24.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.slotLabel,
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  GridView.count(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12.w,
                                    mainAxisSpacing: 12.h,
                                    childAspectRatio: 2.8,
                                    children: activeSlots.map((slot) {
                                      final label = slot['label'] as String;
                                      final isSelected =
                                          selectedSlot?['startsAt'] ==
                                          slot['startsAt'];
                                      return GestureDetector(
                                        onTap: () => onSlotSelect(slot),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 160,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.surface,
                                            borderRadius: BorderRadius.circular(
                                              14.r,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : AppColors.outlineVariant,
                                              width: isSelected ? 1.5 : 1,
                                            ),
                                            boxShadow: isSelected
                                                ? null
                                                : AppShadows.card,
                                          ),
                                          child: Center(
                                            child: Text(
                                              label,
                                              style: AppTextStyles.headlineSm
                                                  .copyWith(
                                                    color: isSelected
                                                        ? AppColors.white
                                                        : AppColors.onSurface,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
