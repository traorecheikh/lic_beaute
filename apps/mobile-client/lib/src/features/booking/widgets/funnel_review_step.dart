import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/app_icon.dart';
import '../providers/booking_funnel_provider.dart';

const _months = [
  'jan', 'fév', 'mar', 'avr', 'mai', 'juin',
  'juil', 'aoû', 'sep', 'oct', 'nov', 'déc',
];

String _fmtDate(String ymd) {
  final parts = ymd.split('-');
  if (parts.length != 3) return ymd;
  final day = int.tryParse(parts[2]) ?? 0;
  final month = int.tryParse(parts[1]) ?? 1;
  return '$day ${_months[month - 1]}';
}

class FunnelReviewStep extends ConsumerWidget {
  const FunnelReviewStep({required this.scrollCtrl, super.key});

  final ScrollController scrollCtrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final funnel = ref.watch(bookingFunnelProvider);
    final slotText = funnel.slotDate != null && funnel.slotTime != null
        ? '${_fmtDate(funnel.slotDate!)} · ${funnel.slotTime}'
        : '-';
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
              Text(AppStrings.reviewSummary, style: AppTextStyles.labelLg),
              const SizedBox(height: 16),
              FunnelReviewRow(icon: 'sparkle', label: funnel.serviceName ?? '-'),
              FunnelReviewRow(icon: 'calendar', label: slotText),
              FunnelReviewRow(
                icon: 'user',
                label: funnel.employeeName ?? AppStrings.funnelFirstAvailable,
              ),
              FunnelReviewRow(
                icon: 'clock',
                label: '${funnel.serviceDurationMinutes ?? 0} min',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
              Text(AppStrings.paymentTitle, style: AppTextStyles.labelMd),
              SizedBox(height: 14.h),
              FunnelPriceLine(AppStrings.totalService, '$total XOF'),
              SizedBox(height: 10.h),
              const AppDivider(),
              SizedBox(height: 10.h),
              FunnelPriceLine(AppStrings.depositNow, '$deposit XOF', highlight: true),
              const SizedBox(height: 4),
              FunnelPriceLine(AppStrings.remainingOnSite, '$remaining XOF', muted: true),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppStrings.cancellationFree,
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

class FunnelReviewRow extends StatelessWidget {
  const FunnelReviewRow({required this.icon, required this.label, super.key});

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

class FunnelPriceLine extends StatelessWidget {
  const FunnelPriceLine(
    this.label,
    this.value, {
    this.highlight = false,
    this.muted = false,
    super.key,
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
