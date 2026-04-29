import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';

class BookingReviewPage extends StatelessWidget {
  const BookingReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon('arrow-left', size: 22, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Étape 3 sur 4',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.primary),
            ),
            Text('Confirmation', style: AppTextStyles.headlineMd),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StepBar(current: 3),
            SizedBox(height: 24.h),
            _SummaryCard(),
            SizedBox(height: 16.h),
            _PriceCard(),
            SizedBox(height: 16.h),
            _CancellationCard(),
          ],
        ),
      ),
      bottomNavigationBar: _ConfirmBar(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _StepBar extends StatelessWidget {
  const _StepBar({required this.current});
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        return Expanded(
          child: Container(
            height: 3.h,
            margin: EdgeInsets.only(right: i < 3 ? 4.w : 0),
            decoration: BoxDecoration(
              color: i < current ? AppColors.primary : AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: AppIcon('sparkle', size: 24, color: AppColors.primary),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Maison Kinka", style: AppTextStyles.labelLg),
                    Text(
                      "Dakar, Point E",
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _SummaryRow(icon: 'sparkle', label: 'Shampoing + Brushing'),
          _SummaryRow(icon: 'calendar', label: 'Samedi 12 Juin · 14:30'),
          _SummaryRow(icon: 'user', label: 'Marie Ndiaye'),
          _SummaryRow(icon: 'clock', label: '45 min'),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.label});
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          AppIcon(icon, size: 16, color: AppColors.onSurfaceVariant),
          SizedBox(width: 10.w),
          Text(label, style: AppTextStyles.bodyMd),
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Détails du paiement', style: AppTextStyles.labelMd),
          SizedBox(height: 16.h),
          _PriceRow('Prestation', '15 000 XOF'),
          Divider(color: AppColors.outlineVariant, height: 24.h),
          _PriceRow(
            'Acompte à payer maintenant (20%)',
            '3 000 XOF',
            highlight: true,
          ),
          SizedBox(height: 6.h),
          _PriceRow(
            'Reste à payer sur place',
            '12 000 XOF',
            muted: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow(this.label, this.value, {this.highlight = false, this.muted = false});
  final String label;
  final String value;
  final bool highlight;
  final bool muted;

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
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMd.copyWith(color: color),
          ),
        ),
        Text(
          value,
          style: (highlight ? AppTextStyles.priceMd : AppTextStyles.bodyMd).copyWith(
            color: color,
            fontWeight: highlight ? FontWeight.w700 : null,
          ),
        ),
      ],
    );
  }
}

class _CancellationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 18.r, color: AppColors.onSurfaceVariant),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Politique d'annulation",
                  style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurface),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Annulation gratuite jusqu'à 24h avant le rendez-vous. L'acompte n'est pas remboursable en cas d'annulation tardive.",
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    context.push(AppRoutes.paymentHandoff('new-booking-123')),
                child: const Text('Confirmer et payer l\'acompte'),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Vous serez redirigé vers le paiement sécurisé',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
