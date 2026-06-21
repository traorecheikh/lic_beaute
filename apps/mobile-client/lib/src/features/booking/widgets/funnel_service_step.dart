import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/constants/app_strings.dart';
import '../../discovery/providers/salon_detail_provider.dart';

class FunnelServiceStep extends ConsumerWidget {
  const FunnelServiceStep({
    required this.salonId,
    required this.scrollCtrl,
    required this.selectedId,
    required this.onSelect,
    super.key,
  });

  final String salonId;
  final ScrollController scrollCtrl;
  final String? selectedId;
  final void Function(String id, dynamic service) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salonAsync = ref.watch(salonDetailProvider(salonId));
    return salonAsync.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (_, _) => Center(child: Text(AppStrings.loadServicesError)),
      data: (salon) {
        final services = salon?.services.toList() ?? [];
        if (services.isEmpty) {
          return Center(
            child: Text(
              AppStrings.noServicesAvailable,
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
            return FunnelServiceCard(
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

class FunnelServiceCard extends StatelessWidget {
  const FunnelServiceCard({
    required this.name,
    required this.duration,
    required this.price,
    this.deposit,
    required this.selected,
    required this.onTap,
    super.key,
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
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.labelLg),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      AppIcon('clock', size: 11, color: AppColors.onSurfaceVariant),
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
