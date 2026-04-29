import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';

class ServiceSelectionSheet extends StatefulWidget {
  const ServiceSelectionSheet({super.key, required this.salonId});

  final String salonId;

  @override
  State<ServiceSelectionSheet> createState() => _ServiceSelectionSheetState();
}

class _ServiceSelectionSheetState extends State<ServiceSelectionSheet> {
  final Set<String> _selected = {};

  static const _services = [
    _Service('svc-0', 'Shampoing + Brushing', '45 min', '7 500 XOF', 7500),
    _Service('svc-1', 'Soin Visage Hydratant', '60 min', '15 000 XOF', 15000),
    _Service('svc-2', 'Manucure Complète', '45 min', '5 000 XOF', 5000),
    _Service('svc-3', 'Épilation Sourcils', '15 min', '2 500 XOF', 2500),
    _Service('svc-4', 'Massage Relaxant', '90 min', '25 000 XOF', 25000),
  ];

  int get _total => _services
      .where((s) => _selected.contains(s.id))
      .fold(0, (sum, s) => sum + s.rawPrice);

  String get _totalFormatted {
    final t = _total;
    if (t == 0) return '0 XOF';
    final thousands = t ~/ 1000;
    final remainder = t % 1000;
    if (remainder == 0) return '$thousands 000 XOF';
    return '${(t / 1000).toStringAsFixed(1)} 000 XOF';
  }

  void _toggle(String id) => setState(() {
    _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
  });

  void _continue() {
    final router = GoRouter.of(context);
    final primaryServiceId = _selected.first;
    Navigator.of(context).pop();
    router.push(
      '${AppRoutes.bookingStaff}?salonId=${widget.salonId}&serviceId=$primaryServiceId',
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.94,
      expand: false,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: AppShadows.sheet,
          ),
          child: Column(
            children: [
              _SheetHandle(),
              _SheetHeader(onClose: () => Navigator.pop(context)),
              _StepIndicator(current: 1, total: 4),
              Expanded(
                child: ListView.separated(
                  controller: scrollCtrl,
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                  itemCount: _services.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (_, i) {
                    final svc = _services[i];
                    return _ServiceCard(
                      service: svc,
                      isSelected: _selected.contains(svc.id),
                      onTap: () => _toggle(svc.id),
                    );
                  },
                ),
              ),
              _SheetFooter(
                selectedCount: _selected.length,
                total: _totalFormatted,
                enabled: _selected.isNotEmpty,
                onContinue: _continue,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 6.h),
      child: Container(
        width: 36.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppColors.outline,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 8.w, 4.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Maison Kinka', style: AppTextStyles.bodySm),
                SizedBox(height: 2.h),
                Text('Choisir les prestations', style: AppTextStyles.headlineMd),
              ],
            ),
          ),
          IconButton(
            icon: AppIcon('close', size: 20, color: AppColors.onSurfaceVariant),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: List.generate(total, (i) {
          final isActive = i < current;
          return Expanded(
            child: Container(
              height: 3.h,
              margin: EdgeInsets.only(right: i < total - 1 ? 4.w : 0),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  final _Service service;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.outline,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(child: AppIcon('check', size: 12, color: Colors.white))
                  : null,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: AppTextStyles.labelLg.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      AppIcon('clock', size: 12, color: AppColors.onSurfaceVariant),
                      SizedBox(width: 3.w),
                      Text(service.duration, style: AppTextStyles.bodySm),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              service.price,
              style: AppTextStyles.priceMd.copyWith(
                color: isSelected ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetFooter extends StatelessWidget {
  const _SheetFooter({
    required this.selectedCount,
    required this.total,
    required this.enabled,
    required this.onContinue,
  });

  final int selectedCount;
  final String total;
  final bool enabled;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (enabled) ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$selectedCount prestation${selectedCount > 1 ? 's' : ''}',
                      style: AppTextStyles.bodySm,
                    ),
                    Text(
                      total,
                      style: AppTextStyles.priceMd.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
            ],
            Expanded(
              flex: enabled ? 1 : 2,
              child: ElevatedButton(
                onPressed: enabled ? onContinue : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Continuer'),
                    SizedBox(width: 8.w),
                    AppIcon('chevron-right', size: 16, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _Service {
  const _Service(this.id, this.name, this.duration, this.price, this.rawPrice);
  final String id, name, duration, price;
  final int rawPrice;
}
