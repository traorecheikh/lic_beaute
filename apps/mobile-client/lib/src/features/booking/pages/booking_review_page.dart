import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../profile/widgets/profile_card_shell.dart';
import '../../profile/providers/payment_methods_provider.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_bottom_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/session/session_store.dart';
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

    return AppScaffold(
      appBar: AppTopBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: const AppBackButton(),
        showBackButton: false,
        titleWidget: const FunnelStepTitle(
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
          SizedBox(height: 12.h),
          const AppDivider(),
          SizedBox(height: 12.h),
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
          AppIcon('info', size: 18, color: AppColors.onSurfaceVariant),
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

class _ConfirmBar extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ConfirmBar> createState() => _ConfirmBarState();
}

class _ConfirmBarState extends ConsumerState<_ConfirmBar> {
  bool _isProcessingPayment = false;
  static const Map<String, String> _channelLabels = {
    'wave': 'Wave',
    'orange_money': 'Orange Money',
    'free_money': 'Free Money',
  };

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(bookingCreateProvider);
    final loading = createState.isLoading || _isProcessingPayment;
    final currentDeposit = ref.watch(bookingFunnelProvider).depositAmount ?? 0;
    final requiresDepositPayment = currentDeposit > 0;

    final methodsAsync = ref.watch(paymentMethodsProvider);
    final defaultMethod = methodsAsync.asData?.value
        .where((m) => m.isDefault)
        .firstOrNull;
    final defaultChannel = _channelFromMethod(defaultMethod);
    final hasStoredPaymentMethod = (methodsAsync.asData?.value.isNotEmpty ?? false);
    final hasDefault = defaultMethod != null;

    return AppBottomBar(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton.primary(
            onPressed: loading
                ? null
                : () async {
                    final booking = await ref
                        .read(bookingCreateProvider.notifier)
                        .create();
                    if (!context.mounted) return;
                    if (booking == null) {
                      final error = ref.read(bookingCreateProvider).error;
                      if (error is DioException) {
                        final statusCode = error.response?.statusCode;
                        final code =
                            (error.response?.data as Map<String, dynamic>?)?['code'] as String?;

                        if (statusCode == 401 || statusCode == 403 || code == 'invalid_token') {
                          await ref.read(sessionProvider.notifier).logout();
                          if (!context.mounted) return;
                          context.go(AppRoutes.auth);
                          AppSnackbar.info(
                            context,
                            'Session expirée. Reconnectez-vous pour confirmer la réservation.',
                          );
                          return;
                        }

                        if (statusCode != null && statusCode >= 500) {
                          AppSnackbar.error(
                            context,
                            "Erreur serveur lors de la confirmation. Vérifiez 'Mes rendez-vous' avant de réessayer.",
                          );
                          return;
                        }
                      }
                      AppSnackbar.error(
                        context,
                        bookingCreateErrorMessage(
                          error,
                        ),
                      );
                      return;
                    }
                    ref
                        .read(bookingFunnelProvider.notifier)
                        .setDepositAmount(booking.depositAmountXof.toInt());
                    final depositAmount = booking.depositAmountXof.toInt();

                    if (depositAmount <= 0) {
                      context.pushReplacement(AppRoutes.success(booking.id));
                      return;
                    }

                    if (!hasStoredPaymentMethod) {
                      AppSnackbar.info(
                        context,
                        'Aucun compte de paiement configuré. Réservation envoyée, confirmation manuelle par le salon.',
                      );
                      context.pushReplacement(AppRoutes.bookingDetailPath(booking.id));
                      return;
                    }

                    if (defaultChannel != null) {
                      setState(() => _isProcessingPayment = true);
                      try {
                        final paymentResult = await ref
                            .read(paymentInitiateProvider.notifier)
                            .initiate(
                              bookingId: booking.id,
                              channel: defaultChannel,
                            );
                        final url = paymentResult?['redirectUrl'] as String?;
                        final paymentId = paymentResult?['paymentId'] as String?;
                        if (!context.mounted) return;
                        if (url != null) {
                          final uri = Uri.parse(url);
                          if (uri.scheme == 'mock') {
                            if (paymentId != null && paymentId.isNotEmpty) {
                              await ref
                                  .read(paymentInitiateProvider.notifier)
                                  .reconcile(paymentId);
                            }
                            if (!context.mounted) return;
                            context.pushReplacement(AppRoutes.success(booking.id));
                            return;
                          }
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                            if (context.mounted) {
                              context.pushReplacement(
                                AppRoutes.success(booking.id),
                              );
                            }
                            return;
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          AppSnackbar.error(context, 'Paiement échoué. Réessayez sur la page suivante.');
                        }
                      } finally {
                        if (mounted) {
                          setState(() => _isProcessingPayment = false);
                        }
                      }
                    }
                    if (context.mounted) {
                      context.pushReplacement(
                        AppRoutes.paymentHandoff(booking.id),
                      );
                    }
                  },
            isLoading: loading,
            label: !requiresDepositPayment
                ? 'Confirmer la réservation'
                : !hasStoredPaymentMethod
                ? 'Confirmer (validation manuelle)'
                : defaultChannel != null
                ? "Payer avec ${_channelLabels[defaultChannel] ?? defaultChannel}"
                : "Confirmer & Payer l'acompte",
          ),
          if (hasDefault && requiresDepositPayment) ...[
            gapH8,
            GestureDetector(
              onTap: () {
                // To allow changing, we just let them go to handoff after booking creation
                // But since booking isn't created yet, we can't just push handoff.
                // It's simpler to instruct them to tap the button, or they can change default in profile.
                AppSnackbar.info(
                  context,
                  "Vous pouvez modifier votre compte principal dans le profil.",
                );
              },
              child: Text(
                'Modifier le compte principal',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String? _channelFromMethod(dynamic method) {
    if (method == null) return null;
    final provider = method.provider as String? ?? '';
    if (_channelLabels.containsKey(provider)) return provider;
    final label = (method.label as String?)?.toLowerCase() ?? '';
    if (label.contains('orange')) return 'orange_money';
    if (label.contains('free')) return 'free_money';
    if (label.contains('wave')) return 'wave';
    if (provider == 'om') return 'orange_money';
    return null;
  }
}
