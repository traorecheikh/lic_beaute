import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/utils/app_share.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';

class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({
    super.key,
    required this.bookingId,
    this.isPast = false,
  });

  final String bookingId;
  final bool isPast;

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
        title: Text('Détails du RDV', style: AppTextStyles.headlineMd),
        actions: [
          IconButton(
            icon: AppIcon('share', size: 20, color: AppColors.onSurface),
            onPressed: () async {
              AppHaptics.light();
              await AppShare.card(
                context: context,
                card: const BookingShareCard(
                  salonName: 'Maison Kinka',
                  service: 'Shampoing + Brushing',
                  date: 'Samedi 12 Juin 2024',
                  time: '14:30',
                  staffName: 'Marie Ndiaye',
                  price: '7 500 XOF',
                ),
                filename: 'rdv_maison_kinka.png',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusCard(isPast: isPast, bookingId: bookingId),
            SizedBox(height: 16.h),
            _WhereWhenCard(),
            SizedBox(height: 16.h),
            _PrestationCard(isPast: isPast),
            SizedBox(height: 32.h),
            _ActionsBar(isPast: isPast, bookingId: bookingId),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.isPast, required this.bookingId});
  final bool isPast;
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final bgColor = isPast ? AppColors.surfaceVariant : AppColors.successContainer;
    final iconColor = isPast ? AppColors.onSurfaceVariant : AppColors.success;
    final iconName = isPast ? 'check' : 'check';
    final label = isPast ? 'Rendez-vous terminé' : 'Rendez-vous confirmé';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Center(
              child: AppIcon(iconName, size: 26, color: iconColor),
            ),
          ),
          SizedBox(height: 14.h),
          Text(label, style: AppTextStyles.headlineMd),
          SizedBox(height: 4.h),
          Text(
            'Réf. #$bookingId',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _WhereWhenCard extends StatelessWidget {
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
          Text('Où et quand', style: AppTextStyles.labelMd),
          SizedBox(height: 16.h),
          _DetailRow(icon: 'map-pin', title: 'Maison Kinka', subtitle: 'Rue 12, Point E, Dakar'),
          _DetailRow(icon: 'calendar', title: 'Samedi 12 Juin 2024', subtitle: '14:30 — 15:15 (45 min)'),
          _DetailRow(
            icon: 'user',
            title: 'Marie Ndiaye',
            subtitle: 'Coiffeuse Senior',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _PrestationCard extends StatelessWidget {
  const _PrestationCard({required this.isPast});
  final bool isPast;

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
          Text('Prestation', style: AppTextStyles.labelMd),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AppIcon('sparkle', size: 16, color: AppColors.onSurfaceVariant),
                  SizedBox(width: 8.w),
                  Text('Shampoing + Brushing', style: AppTextStyles.bodyMd),
                ],
              ),
              Text('7 500 XOF', style: AppTextStyles.priceMd),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.outlineVariant),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Acompte payé',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
              Text(
                '1 500 XOF',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isPast ? 'Payé sur place' : 'Reste à payer sur place',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
              Text(
                '6 000 XOF',
                style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionsBar extends StatelessWidget {
  const _ActionsBar({required this.isPast, required this.bookingId});
  final bool isPast;
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    if (isPast) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: OutlinedButton(
                  onPressed: () {
                    AppHaptics.medium();
                    context.go(AppRoutes.home);
                  },
                  child: const Text('Réserver à nouveau'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    AppHaptics.medium();
                    context.push(AppRoutes.review(bookingId));
                  },
                  child: const Text('Laisser un avis'),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  AppHaptics.light();
                  context.push(AppRoutes.bookingManagePath(bookingId));
                },
                child: const Text('Modifier'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  AppHaptics.light();
                  final uri = Uri.parse(
                    'https://maps.google.com/?q=Maison+Kinka,Point+E,Dakar',
                  );
                  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                    if (context.mounted) {
                      AppSnackbar.error(context, "Impossible d'ouvrir Maps.");
                    }
                  }
                },
                child: const Text('Itinéraire'),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Center(
          child: TextButton(
            onPressed: () => _showCancelDialog(context),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Annuler le rendez-vous'),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) async {
    final confirmed = await AppSnackbar.confirmDestructive(
      context,
      title: 'Annuler le rendez-vous ?',
      body: "Cette action est irréversible. Des frais d'annulation peuvent s'appliquer si le RDV est dans moins de 24h.",
      confirmLabel: 'Confirmer l\'annulation',
    );
    if (confirmed && context.mounted) {
      AppSnackbar.success(context, 'Rendez-vous annulé.');
      context.pop();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  final String icon;
  final String title;
  final String subtitle;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: AppIcon(icon, size: 18, color: AppColors.onSurfaceVariant),
            ),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.labelLg),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
