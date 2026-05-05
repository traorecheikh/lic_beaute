import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../profile/widgets/profile_card_shell.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_bottom_bar.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';
import '../providers/booking_create_provider.dart';
import '../providers/booking_funnel_provider.dart';
import '../utils/booking_format.dart';
import '../widgets/funnel_step_bar.dart';

class BookingReviewPage extends ConsumerWidget {
  const BookingReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final funnel = ref.watch(bookingFunnelProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: const AppBackButton(),
        title: const FunnelStepTitle(
          step: 4,
          total: 4,
          title: 'Confirmation',
          separator: 'sur',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StepBar(current: 4),
            gapH24,
            _SummaryCard(funnel: funnel),
            gapH16,
            _PriceCard(funnel: funnel),
            gapH16,
            _CancellationCard(),
          ],
        ),
      ),
      bottomNavigationBar: _ConfirmBar(),
    );
  }
}

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
  const _SummaryCard({required this.funnel});

  final BookingFunnelState funnel;

  @override
  Widget build(BuildContext context) {
    final slotText = funnel.slotDate != null && funnel.slotTime != null
        ? '${funnel.slotDate} · ${funnel.slotTime}'
        : 'Créneau non défini';

    return ProfileCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Résumé', style: AppTextStyles.labelLg),
          gapH16,
          _SummaryRow(
            icon: 'sparkle',
            label: funnel.serviceName ?? 'Prestation',
          ),
          _SummaryRow(icon: 'calendar', label: slotText),
          _SummaryRow(
            icon: 'user',
            label: funnel.employeeName ?? 'Premier disponible',
          ),
          _SummaryRow(
            icon: 'clock',
            label: '${funnel.serviceDurationMinutes ?? 0} min',
          ),
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
  const _PriceCard({required this.funnel});

  final BookingFunnelState funnel;

  @override
  Widget build(BuildContext context) {
    final total = funnel.servicePrice ?? 0;
    final deposit = funnel.depositAmount ?? 0;
    final remaining = total - deposit;

    return ProfileCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Détails du paiement', style: AppTextStyles.labelMd),
          gapH16,
          _PriceRow('Prestation', xof(total)),
          Divider(color: AppColors.outlineVariant, height: 24.h),
          _PriceRow(
            'Acompte à payer maintenant',
            xof(deposit),
            highlight: true,
          ),
          SizedBox(height: 6.h),
          _PriceRow(
            'Reste à payer sur place',
            xof(remaining < 0 ? 0 : remaining),
            muted: true,
          ),
        ],
      ),
    );
  }

}

class _PriceRow extends StatelessWidget {
  const _PriceRow(
    this.label,
    this.value, {
    this.highlight = false,
    this.muted = false,
  });
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
          Icon(
            Icons.info_outline_rounded,
            size: 18.r,
            color: AppColors.onSurfaceVariant,
          ),
          SizedBox(width: 10.w),
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
    );
  }
}

class _ConfirmBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createState = ref.watch(bookingCreateProvider);
    final loading = createState.isLoading;

    return AppBottomBar(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      final booking = await ref
                          .read(bookingCreateProvider.notifier)
                          .create();
                      if (!context.mounted) return;
                      if (booking == null) {
                        AppSnackbar.error(
                          context,
                          bookingCreateErrorMessage(
                            ref.read(bookingCreateProvider).error,
                          ),
                        );
                        return;
                      }
                      ref
                          .read(bookingFunnelProvider.notifier)
                          .setDepositAmount(booking.depositAmountXof.toInt());
                      context.push(AppRoutes.success(booking.id));
                    },
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Confirmer la réservation'),
            ),
          ),
          gapH8,
          Text(
            'Paiement sera activé dans une prochaine étape.',
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          gapH4,
        ],
      ),
    );
  }
}
