import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

import '../../../core/constants/app_strings.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../profile/widgets/profile_card_shell.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_bottom_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_booking_funnel_scaffold.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/session/session_store.dart';
import '../../../router/app_router.dart';
import '../providers/booking_create_provider.dart';
import '../providers/booking_funnel_provider.dart';
import '../utils/booking_format.dart';
import '../widgets/funnel_step_bar.dart';
import '../../discovery/providers/salon_detail_provider.dart';
class BookingReviewPage extends ConsumerWidget {
  const BookingReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final funnel = ref.watch(bookingFunnelProvider);
    final salonAsync = funnel.salonId != null
        ? ref.watch(salonDetailProvider(funnel.salonId!))
        : const AsyncValue<Never>.loading();

    if (!funnel.canReview) {
      // Funnel state is missing — user likely navigated directly or state
      // was cleared. Show a meaningful error rather than a broken summary.
      return AppScaffold(
        appBar: AppTopBar(showBackButton: true),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon('alert-circle', size: 48, color: AppColors.error),
                SizedBox(height: 20.h),
                Text(
                  'Réservation incomplète',
                  style: AppTextStyles.displaySm,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Les informations de réservation sont manquantes. Reprenez la réservation depuis la fiche salon.',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                AppButton.primary(
                  label: "Retour à l'accueil",
                  onPressed: () => context.go(AppRoutes.home),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AppScaffold(
      appBar: AppTopBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: const AppBackButton(),
        showBackButton: false,
        titleWidget: const FunnelStepTitle(
          step: 4,
          total: 4,
          title: AppStrings.bookingReviewTitle,
          separator: 'sur',
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(68.h),
          child: BookingFunnelProgressMeta(
            step: 4,
            total: 4,
            salon: salonAsync.asData?.value,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.funnel});

  final BookingFunnelState funnel;

  @override
  Widget build(BuildContext context) {
    final slotText = funnel.slotDate != null && funnel.slotTime != null
        ? '${funnel.slotDate} · ${funnel.slotTime}'
        : AppStrings.slotNotSet;

    return ProfileCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.reviewSummary, style: AppTextStyles.labelLg),
          gapH16,
          _SummaryRow(
            icon: 'sparkle',
            label: funnel.serviceName ?? AppStrings.serviceLabel,
          ),
          _SummaryRow(icon: 'calendar', label: slotText),
          _SummaryRow(
            icon: 'user',
            label: funnel.employeeName ?? AppStrings.funnelFirstAvailable,
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
          Text(AppStrings.paymentDetails, style: AppTextStyles.labelMd),
          gapH16,
          _PriceRow(AppStrings.serviceLabel, xof(total)),
          SizedBox(height: 12.h),
          const AppDivider(),
          SizedBox(height: 12.h),
          _PriceRow(
            AppStrings.depositToPayNow,
            xof(deposit),
            highlight: true,
          ),
          SizedBox(height: 6.h),
          _PriceRow(
            AppStrings.remainingToPayOnSite,
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
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon('info', size: 18, color: AppColors.onSurfaceVariant),
          SizedBox(width: 10.w),
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
    );
  }
}

class _ConfirmBar extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ConfirmBar> createState() => _ConfirmBarState();
}

class _ConfirmBarState extends ConsumerState<_ConfirmBar> {
  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(bookingCreateProvider);
    final loading = createState.isLoading;
    final currentDeposit = ref.watch(bookingFunnelProvider).depositAmount ?? 0;
    final requiresDepositPayment = currentDeposit > 0;

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
                            (error.response?.data as Map<String, dynamic>?)?[
                                'code'] as String?;

                        if (statusCode == 401 ||
                            statusCode == 403 ||
                            code == 'invalid_token') {
                          await ref
                              .read(sessionProvider.notifier)
                              .logout();
                          if (!context.mounted) return;
                          context.go(AppRoutes.auth);
                          AppSnackbar.info(
                            context,
                            AppStrings.sessionExpiredMsg,
                          );
                          return;
                        }

                        if (statusCode != null && statusCode >= 500) {
                          AppSnackbar.error(
                            context,
                            AppStrings.serverErrorMsg,
                          );
                          return;
                        }
                      }
                      AppSnackbar.error(
                        context,
                        bookingCreateErrorMessage(error),
                      );
                      return;
                    }
                    ref
                        .read(bookingFunnelProvider.notifier)
                        .setDepositAmount(booking.depositAmountXof.toInt());
                    final depositAmount = booking.depositAmountXof.toInt();

                    if (depositAmount <= 0) {
                      context.pushReplacement(
                          AppRoutes.success(booking.id));
                      return;
                    }

                    // Go to payment handoff — handles two-step flow (initiate + execute)
                    // with profile data pre-filled and stored payment method pre-selected
                    context.pushReplacement(
                      AppRoutes.paymentHandoff(booking.id),
                    );
                  },
            isLoading: loading,
            label: !requiresDepositPayment
                ? AppStrings.confirmBookingCta
                : AppStrings.payDepositCta,
          ),
        ],
      ),
    );
  }
}
