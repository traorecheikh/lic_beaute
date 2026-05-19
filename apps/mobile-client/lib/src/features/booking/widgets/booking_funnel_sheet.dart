import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../router/app_router.dart';
import '../../discovery/providers/salon_detail_provider.dart';
import '../providers/booking_create_provider.dart';
import '../providers/booking_funnel_provider.dart';

const _kStepTitles = ['Prestation', 'Prestataire', 'Créneau', 'Confirmation'];
const _kWeekDays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

class BookingFunnelSheet extends ConsumerStatefulWidget {
  const BookingFunnelSheet({super.key, required this.salonId});
  final String salonId;

  @override
  ConsumerState<BookingFunnelSheet> createState() => _BookingFunnelSheetState();
}

class _BookingFunnelSheetState extends ConsumerState<BookingFunnelSheet> {
  final _pageCtrl = PageController();
  int _step = 0;

  String? _serviceId;
  String _staffId = 'any';
  bool _isResolvingAnyStaff = false;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int? _selectedHour;
  Map<String, dynamic>? _selectedSlot;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  bool get _canAdvance {
    if (_step == 0) return _serviceId != null;
    if (_step == 2) return _selectedSlot != null;
    return true;
  }

  Future<void> _advance() async {
    if (!_canAdvance || _isResolvingAnyStaff) return;
    AppHaptics.medium();
    if (_step == 1) {
      final salon = ref.read(salonDetailProvider(widget.salonId)).value;
      final serviceId = _serviceId;
      String? staffId = _staffId == 'any' ? null : _staffId;

      if (_staffId == 'any' &&
          salon != null &&
          serviceId != null &&
          serviceId.isNotEmpty) {
        setState(() => _isResolvingAnyStaff = true);
        try {
          staffId = await _resolveBestStaffId(
            salon: salon,
            serviceId: serviceId,
          );
          if (!mounted) return;
          if (staffId != null && staffId.isNotEmpty) {
            setState(() => _staffId = staffId!);
          }
        } finally {
          if (mounted) setState(() => _isResolvingAnyStaff = false);
        }
      }

      final staff = salon?.staff.where((s) => s.id == staffId).firstOrNull;
      ref
          .read(bookingFunnelProvider.notifier)
          .selectEmployee(
            employeeId: staffId,
            employeeName: staff?.displayName ?? 'Sans préférence',
          );
    } else if (_step == 2) {
      ref
          .read(bookingFunnelProvider.notifier)
          .selectSlot(
            startsAtIso: _selectedSlot!['startsAt'] as String,
            employeeId: _selectedSlot!['employeeId'] as String?,
          );
    }

    if (_step < 3) {
      setState(() => _step++);
      _pageCtrl.animateToPage(
        _step,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    } else {
      _confirm();
    }
  }

  Future<String?> _resolveBestStaffId({
    required SalonDetail salon,
    required String serviceId,
  }) async {
    final candidates = salon.staff
        .where((s) => s.serviceIds.contains(serviceId))
        .toList();
    if (candidates.isEmpty) return null;

    final scores = <String, _StaffLoadScore>{
      for (final s in candidates) s.id: _StaffLoadScore(staffId: s.id),
    };

    const horizonDays = 5;
    for (var dayOffset = 1; dayOffset <= horizonDays; dayOffset++) {
      final probeDate = DateTime.now().add(Duration(days: dayOffset));
      final date = _ymd(probeDate);

      final daySamples = await Future.wait(
        candidates.map((staff) async {
          final params = (
            salonId: widget.salonId,
            date: date,
            serviceId: serviceId,
            employeeId: staff.id,
          );
          try {
            final slots = await ref.read(
              salonAvailabilityProvider(params).future,
            );
            return (staffId: staff.id, slots: slots);
          } catch (_) {
            return (staffId: staff.id, slots: const <dynamic>[]);
          }
        }),
      );

      for (final sample in daySamples) {
        final slotMaps = sample.slots
            .whereType<Map<String, dynamic>>()
            .toList();
        final score = scores[sample.staffId];
        if (score == null || slotMaps.isEmpty) continue;

        score.totalSlots += slotMaps.length;
        score.availableDays += 1;
        final dayEarliest = slotMaps
            .map((slot) => slot['startsAt'] as String?)
            .whereType<String>()
            .fold<DateTime?>(null, (earliest, startsAt) {
              final parsed = DateTime.tryParse(startsAt);
              if (parsed == null) return earliest;
              if (earliest == null || parsed.isBefore(earliest)) return parsed;
              return earliest;
            });
        if (dayEarliest != null &&
            (score.earliest == null || dayEarliest.isBefore(score.earliest!))) {
          score.earliest = dayEarliest;
        }
      }
    }

    final ranked = scores.values.toList()
      ..sort((a, b) {
        final byDays = b.availableDays.compareTo(a.availableDays);
        if (byDays != 0) return byDays;
        final bySlots = b.totalSlots.compareTo(a.totalSlots);
        if (bySlots != 0) return bySlots;
        final aEarliest = a.earliest;
        final bEarliest = b.earliest;
        if (aEarliest != null && bEarliest != null) {
          final byEarliest = aEarliest.compareTo(bEarliest);
          if (byEarliest != 0) return byEarliest;
        } else if (aEarliest != null) {
          return -1;
        } else if (bEarliest != null) {
          return 1;
        }
        return a.staffId.compareTo(b.staffId);
      });

    return ranked.firstOrNull?.staffId;
  }

  String _ymd(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      setState(() => _step--);
      _pageCtrl.animateToPage(
        _step,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _confirm() async {
    final rootNav = Navigator.of(context, rootNavigator: true);
    final router = GoRouter.of(context);

    final booking = await ref.read(bookingCreateProvider.notifier).create();
    if (!mounted) return;

    if (booking == null) {
      final err = ref.read(bookingCreateProvider).error;
      setState(() => _errorMsg = bookingCreateErrorMessage(err));
      return;
    }

    ref
        .read(bookingFunnelProvider.notifier)
        .setDepositAmount(booking.depositAmountXof.toInt());
    rootNav.pop();
    router.push(AppRoutes.success(booking.id));
  }

  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(bookingCreateProvider);
    final isConfirming = createState.isLoading && _step == 3;
    final isResolvingStaff = _isResolvingAnyStaff && _step == 1;
    final isBusy = isConfirming || isResolvingStaff;

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.96,
      expand: false,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.neutral,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: AppShadows.sheet,
          ),
          child: Column(
            children: [
              _Handle(),
              _Header(step: _step, onBack: _back),
              gapH4,
              Expanded(
                child: PageView(
                  controller: _pageCtrl,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _ServiceStep(
                      salonId: widget.salonId,
                      scrollCtrl: scrollCtrl,
                      selectedId: _serviceId,
                      onSelect: (id, service) {
                        AppHaptics.select();
                        setState(() => _serviceId = id);
                        final n = ref.read(bookingFunnelProvider.notifier);
                        n.startFunnel(widget.salonId);
                        n.selectService(
                          serviceId: service.id,
                          serviceName: service.name,
                          price: service.priceXof.toInt(),
                          durationMinutes: service.durationMinutes,
                          depositAmount: service.depositRequiredXof?.toInt() ?? 0,
                        );
                      },
                    ),
                    _StaffStep(
                      salonId: widget.salonId,
                      serviceId: _serviceId ?? '',
                      scrollCtrl: scrollCtrl,
                      selectedId: _staffId,
                      onSelect: (id) {
                        AppHaptics.select();
                        setState(() => _staffId = id);
                      },
                    ),
                    _SlotStep(
                      salonId: widget.salonId,
                      serviceId: _serviceId ?? '',
                      employeeId: _staffId == 'any' ? null : _staffId,
                      scrollCtrl: scrollCtrl,
                      selectedDate: _selectedDate,
                      selectedHour: _selectedHour,
                      selectedSlot: _selectedSlot,
                      onDateChange: (d) => setState(() {
                        _selectedDate = d;
                        _selectedHour = null;
                        _selectedSlot = null;
                      }),
                      onHourSelect: (h) => setState(() {
                        _selectedHour = h;
                        _selectedSlot = null;
                      }),
                      onSlotSelect: (slot) {
                        AppHaptics.select();
                        setState(() => _selectedSlot = slot);
                      },
                    ),
                    _ReviewStep(scrollCtrl: scrollCtrl),
                  ],
                ),
              ),
              if (_errorMsg != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      _errorMsg!,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              _Cta(
                label: isResolvingStaff
                    ? 'Recherche du meilleur prestataire...'
                    : (_step == 3 ? 'Confirmer la réservation' : 'Continuer'),
                enabled: _canAdvance && !isBusy,
                loading: isBusy,
                onTap: () {
                  setState(() => _errorMsg = null);
                  _advance();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StaffLoadScore {
  _StaffLoadScore({required this.staffId});

  final String staffId;
  int totalSlots = 0;
  int availableDays = 0;
  DateTime? earliest;
}

// ─── Shell widgets ────────────────────────────────────────────────────────────

class _Handle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 4.h,
      margin: EdgeInsets.only(top: 10.h, bottom: 4.h),
      decoration: BoxDecoration(
        color: AppColors.outline,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.step, required this.onBack});
  final int step;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar — edge-to-edge
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 0),
          child: Row(
            children: List.generate(
              4,
              (i) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  height: 3.h,
                  margin: EdgeInsets.only(right: i < 3 ? 4.w : 0),
                  decoration: BoxDecoration(
                    color: i <= step
                        ? AppColors.primary
                        : AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Back button + title row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppPressable(
              onTap: onBack,
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: AppIcon(
                  step == 0 ? 'close' : 'arrow-left',
                  size: 20,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            Expanded(
              child: Text(_kStepTitles[step], style: AppTextStyles.headlineLg),
            ),
          ],
        ),
      ],
    );
  }
}

class _Cta extends StatelessWidget {
  const _Cta({
    required this.label,
    required this.enabled,
    required this.loading,
    required this.onTap,
  });
  final String label;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutral,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: SafeArea(
        top: false,
        child: AppButton.primary(
          onPressed: enabled ? onTap : null,
          isLoading: loading,
          label: label,
        ),
      ),
    );
  }
}

// ─── Step 1: Service ──────────────────────────────────────────────────────────

class _ServiceStep extends ConsumerWidget {
  const _ServiceStep({
    required this.salonId,
    required this.scrollCtrl,
    required this.selectedId,
    required this.onSelect,
  });
  final String salonId;
  final ScrollController scrollCtrl;
  final String? selectedId;
  final void Function(String id, dynamic service) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salonAsync = ref.watch(salonDetailProvider(salonId));
    return salonAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) =>
          const Center(child: Text('Impossible de charger les services.')),
      data: (salon) {
        final services = salon?.services.toList() ?? [];
        if (services.isEmpty) {
          return Center(
            child: Text(
              'Aucune prestation disponible.',
              style: AppTextStyles.bodyMd,
            ),
          );
        }
        return ListView.separated(
          controller: scrollCtrl,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
          itemCount: services.length,
          separatorBuilder: (_, _) => SizedBox(height: 10.h),
          itemBuilder: (_, i) {
            final s = services[i];
            return _ServiceCard(
              name: s.name,
              duration: '${s.durationMinutes} min',
              price: '${s.priceXof.toInt()} XOF',
              deposit: s.depositRequiredXof != null
                  ? 'Acompte ${s.depositRequiredXof!.toInt()} XOF'
                  : null,
              selected: selectedId == s.id,
              onTap: () => onSelect(s.id, s),
            );
          },
        );
      },
    );
  }
}

// ─── Step 2: Staff ────────────────────────────────────────────────────────────

class _StaffStep extends ConsumerWidget {
  const _StaffStep({
    required this.salonId,
    required this.serviceId,
    required this.scrollCtrl,
    required this.selectedId,
    required this.onSelect,
  });
  final String salonId, serviceId;
  final ScrollController scrollCtrl;
  final String selectedId;
  final void Function(String id) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salonAsync = ref.watch(salonDetailProvider(salonId));
    return salonAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) =>
          const Center(child: Text("Impossible de charger l'équipe.")),
      data: (salon) {
        final staff = (salon?.staff.toList() ?? [])
            .where((e) => e.serviceIds.contains(serviceId))
            .toList();

        final items =
            <(String id, String name, String role, String? image, bool isAny)>[
              ('any', 'Peu importe', 'Premier disponible', null, true),
              ...staff.map(
                (e) => (
                  e.id,
                  e.displayName,
                  e.description ?? 'Spécialiste',
                  e.avatarUrl,
                  false,
                ),
              ),
            ];

        return ListView.separated(
          controller: scrollCtrl,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
          itemCount: items.length,
          separatorBuilder: (_, _) => SizedBox(height: 10.h),
          itemBuilder: (_, i) {
            final (id, name, role, image, isAny) = items[i];
            final isSelected = selectedId == id;
            return _StaffCard(
              name: name,
              role: role,
              image: image,
              isAny: isAny,
              selected: isSelected,
              onTap: () => onSelect(id),
            );
          },
        );
      },
    );
  }
}

// ─── Step 3: Slot ─────────────────────────────────────────────────────────────

class _SlotStep extends ConsumerWidget {
  const _SlotStep({
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

  // Returns {blockStart: [{label, startsAt, employeeId}, ...]} grouped by 2-hour blocks
  static Map<int, List<Map<String, dynamic>>> _groupSlots(List<dynamic> raw) {
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
            'Choisissez d’abord une prestation.',
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
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(
              child: Text(
                'Impossible de charger les disponibilités.',
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
                      gapH12,
                      Text(
                        'Aucun créneau ce jour',
                        style: AppTextStyles.headlineSm,
                      ),
                      gapH4,
                      Text(
                        'Essayez une autre date.',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final grouped = _groupSlots(raw);
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
                      'Plage horaire',
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
                                  'Sélectionnez une plage horaire',
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
                                    'Créneau',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  gapH12,
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

// ─── Step 4: Review ───────────────────────────────────────────────────────────

class _ReviewStep extends ConsumerWidget {
  const _ReviewStep({required this.scrollCtrl});
  final ScrollController scrollCtrl;

  static const _months = [
    'jan',
    'fév',
    'mar',
    'avr',
    'mai',
    'juin',
    'juil',
    'aoû',
    'sep',
    'oct',
    'nov',
    'déc',
  ];

  static String _fmtDate(String ymd) {
    final parts = ymd.split('-');
    if (parts.length != 3) return ymd;
    final day = int.tryParse(parts[2]) ?? 0;
    final month = int.tryParse(parts[1]) ?? 1;
    return '$day ${_months[month - 1]}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final funnel = ref.watch(bookingFunnelProvider);
    final slotText = funnel.slotDate != null && funnel.slotTime != null
        ? '${_fmtDate(funnel.slotDate!)} · ${funnel.slotTime}'
        : '—';
    final total = funnel.servicePrice ?? 0;
    final deposit = funnel.depositAmount ?? 0;
    final remaining = (total - deposit).clamp(0, total);

    return ListView(
      controller: scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
      children: [
        // Summary card
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Résumé', style: AppTextStyles.labelLg),
              gapH16,
              _ReviewRow(icon: 'sparkle', label: funnel.serviceName ?? '—'),
              _ReviewRow(icon: 'calendar', label: slotText),
              _ReviewRow(
                icon: 'user',
                label: funnel.employeeName ?? 'Premier disponible',
              ),
              _ReviewRow(
                icon: 'clock',
                label: '${funnel.serviceDurationMinutes ?? 0} min',
              ),
            ],
          ),
        ),
        gapH12,
        // Price card
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Paiement', style: AppTextStyles.labelMd),
              SizedBox(height: 14.h),
              _PriceLine('Total prestation', '$total XOF'),
              SizedBox(height: 10.h),
              const AppDivider(),
              SizedBox(height: 10.h),
              _PriceLine('Acompte maintenant', '$deposit XOF', highlight: true),
              gapH4,
              _PriceLine('Reste sur place', '$remaining XOF', muted: true),
            ],
          ),
        ),
        gapH12,
        // Cancellation note
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIcon('info', size: 16, color: AppColors.onSurfaceVariant),
              gapW8,
              Expanded(
                child: Text(
                  "Annulation gratuite jusqu'à 24h avant le rendez-vous.",
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.icon, required this.label});
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: AppIcon(icon, size: 12, color: AppColors.primary),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMd,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine(
    this.label,
    this.value, {
    this.highlight = false,
    this.muted = false,
  });
  final String label, value;
  final bool highlight, muted;

  @override
  Widget build(BuildContext context) {
    final color = highlight
        ? AppColors.primary
        : muted
        ? AppColors.onSurfaceVariant
        : AppColors.onSurface;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMd.copyWith(color: color)),
        Text(
          value,
          style: (highlight ? AppTextStyles.priceMd : AppTextStyles.bodyMd)
              .copyWith(
                color: color,
                fontWeight: highlight ? FontWeight.w700 : null,
              ),
        ),
      ],
    );
  }
}

// ─── Card components ──────────────────────────────────────────────────────────

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.name,
    required this.duration,
    required this.price,
    this.deposit,
    required this.selected,
    required this.onTap,
  });
  final String name, duration, price;
  final String? deposit;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
            width: selected ? 1.8 : 1,
          ),
          boxShadow: selected ? null : AppShadows.card,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : AppColors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.outline,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Center(
                      child: AppIcon('check', size: 13, color: AppColors.white),
                    )
                  : null,
            ),
            gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.labelLg),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      AppIcon(
                        'clock',
                        size: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                      SizedBox(width: 3.w),
                      Text(duration, style: AppTextStyles.bodySm),
                    ],
                  ),
                  if (deposit != null) ...[
                    SizedBox(height: 3.h),
                    Text(
                      deposit!,
                      style: AppTextStyles.bodyXs.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              price,
              style: AppTextStyles.priceMd.copyWith(
                color: selected ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard({
    required this.name,
    required this.role,
    this.image,
    required this.isAny,
    required this.selected,
    required this.onTap,
  });
  final String name, role;
  final String? image;
  final bool isAny, selected;
  final VoidCallback onTap;

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
            width: selected ? 1.8 : 1,
          ),
          boxShadow: selected ? null : AppShadows.card,
        ),
        child: Row(
          children: [
            if (isAny)
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '···',
                    style: AppTextStyles.labelLg.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              )
            else
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: (image != null && image!.isNotEmpty)
                    ? CachedNetworkImageProvider(image!)
                    : null,
                child: (image == null || image!.isEmpty)
                    ? Text(
                        _initials(name),
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.labelLg),
                  Text(
                    role,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : AppColors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.outline,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Center(
                      child: AppIcon('check', size: 13, color: AppColors.white),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
