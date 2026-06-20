import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../router/app_router.dart';
import '../../discovery/providers/salon_detail_provider.dart';
import '../providers/booking_create_provider.dart';
import '../providers/booking_funnel_provider.dart';
import '../utils/funnel_staff_scorer.dart';
import 'funnel_review_step.dart';
import 'funnel_service_step.dart';
import 'funnel_shell.dart';
import 'funnel_slot_step.dart';
import 'funnel_staff_step.dart';

class BookingFunnelSheet extends ConsumerStatefulWidget {
  const BookingFunnelSheet({super.key, required this.salonId});

  final String salonId;

  @override
  ConsumerState<BookingFunnelSheet> createState() =>
      _BookingFunnelSheetState();
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
  String? _errorMsg;

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
          staffId = await resolveBestStaffId(
            ref: ref,
            salonId: widget.salonId,
            serviceId: serviceId,
            salon: salon,
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
            employeeName: staff?.displayName ?? AppStrings.noPreference,
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
              const FunnelHandle(),
              FunnelHeader(step: _step, onBack: _back),
              gapH4,
              Expanded(
                child: PageView(
                  controller: _pageCtrl,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    FunnelServiceStep(
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
                          depositAmount:
                              service.depositRequiredXof?.toInt() ?? 0,
                        );
                      },
                    ),
                    FunnelStaffStep(
                      salonId: widget.salonId,
                      serviceId: _serviceId ?? '',
                      scrollCtrl: scrollCtrl,
                      selectedId: _staffId,
                      onSelect: (id) {
                        AppHaptics.select();
                        setState(() => _staffId = id);
                      },
                    ),
                    FunnelSlotStep(
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
                    FunnelReviewStep(scrollCtrl: scrollCtrl),
                  ],
                ),
              ),
              if (_errorMsg != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
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
              FunnelCta(
                label: isResolvingStaff
                    ? AppStrings.funnelResolvingBestStaff
                    : (_step == 3
                        ? AppStrings.confirmBookingCta
                        : AppStrings.funnelContinue),
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
