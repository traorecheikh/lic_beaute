import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';

class SlotSelectionPage extends StatefulWidget {
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
  State<SlotSelectionPage> createState() => _SlotSelectionPageState();
}

class _SlotSelectionPageState extends State<SlotSelectionPage> {
  DateTime _selected = DateTime.now().add(const Duration(days: 1));
  String? _selectedSlot;

  static const _slots = [
    '09:00', '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00',
    '17:00', '18:00',
  ];

  static const _unavailable = {'12:00', '16:00'};

  static const _weekDays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcon('arrow-left', size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Étape 2 sur 4',
              style: AppTextStyles.overline.copyWith(color: AppColors.primary),
            ),
            Text('Choisir un créneau', style: AppTextStyles.headlineMd),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateStrip(),
          Expanded(child: _buildSlotGrid()),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
          child: ElevatedButton(
            onPressed: _selectedSlot == null
                ? null
                : () => context.push(AppRoutes.bookingReview),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Confirmer · ${_selectedSlot ?? '–'}'),
                SizedBox(width: 8.w),
                AppIcon('chevron-right', size: 16, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
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
          final isSelected = _selected.day == date.day &&
              _selected.month == date.month;

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
                          ? AppColors.surface.withOpacity(0.7)
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${date.day}',
                    style: AppTextStyles.headlineSm.copyWith(
                      color: isSelected ? AppColors.surface : AppColors.onSurface,
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

  Widget _buildSlotGrid() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: _slots.length,
      itemBuilder: (_, i) {
        final slot = _slots[i];
        final isUnavailable = _unavailable.contains(slot);
        final isSelected = _selectedSlot == slot;

        return GestureDetector(
          onTap: isUnavailable ? null : () => setState(() => _selectedSlot = slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isUnavailable
                      ? AppColors.surfaceVariant
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
                slot,
                style: AppTextStyles.labelMd.copyWith(
                  color: isSelected
                      ? Colors.white
                      : isUnavailable
                          ? AppColors.outline
                          : AppColors.onSurface,
                  decoration: isUnavailable
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
