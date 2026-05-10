import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_booking_async_scaffold.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';
import '../../booking/utils/booking_format.dart';
import '../../discovery/providers/cached_resource.dart';
import '../../discovery/providers/salon_detail_provider.dart';
import '../../discovery/widgets/stale_data_notice.dart';
import '../providers/booking_actions_provider.dart';
import '../providers/bookings_list_provider.dart';

class BookingDetailPage extends ConsumerWidget {
  const BookingDetailPage({
    super.key,
    required this.bookingId,
    this.isPast = false,
  });

  final String bookingId;
  final bool isPast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBookingAsyncScaffold<Map<String, dynamic>>(
      bookingId: bookingId,
      provider: bookingDetailResourceProvider,
      errorTitle: 'Impossible de charger le rendez-vous',
      serverTitle: 'Le détail du rendez-vous est indisponible',
      sliverBuilder: (resource) {
        final salonId = resource.salonId;
        final serviceId = resource.serviceId;
        final salonDetail = salonId.isEmpty
            ? null
            : ref.watch(salonDetailProvider(salonId)).asData?.value;
        final service = (salonDetail == null || serviceId.isEmpty)
            ? null
            : salonDetail.services.where((s) => s.id == serviceId).firstOrNull;

        final fallbackPrice = service?.priceXof.toInt();
        final fallbackDeposit = service?.depositRequiredXof?.toInt() ?? 0;
        final totalAmountXof = resource.priceXof ?? fallbackPrice;
        final depositAmountXof = resource.depositXof ?? fallbackDeposit;
        final hasDeposit = depositAmountXof > 0;
        final isDepositPaid =
            hasDeposit &&
            (resource.depositPaymentStatus == 'authorized' ||
                resource.depositPaymentStatus == 'succeeded' ||
                resource.depositPaymentStatus == 'refunded');
        final depositLabel = !hasDeposit
            ? 'Aucun acompte'
            : (isDepositPaid ? 'Acompte payé' : 'Acompte requis');
        final remainingXof = totalAmountXof == null
            ? null
            : (totalAmountXof - (isDepositPaid ? depositAmountXof : 0)).clamp(
                0,
                999999999,
              );

        final isCancelled =
            resource.status == 'cancelled' || resource.status == 'completed';

        return [
          if (resource.isStale && resource.cachedAt != null)
            AppSliverStaleNotice(cachedAt: resource.cachedAt!),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 40.h),
              child: Column(
                children: [
                  _StatusHeader(status: resource.status, bookingId: bookingId),
                  gapH20,
                  _InfoSection(
                    title: 'Où et quand',
                    children: [
                      _DetailRow(
                        icon: 'map-pin',
                        title: resource.salonName,
                        subtitle:
                            resource.data?['salonAddress'] as String? ?? '',
                      ),
                      _DetailRow(
                        icon: 'calendar',
                        title: resource.fullFormattedDate,
                        subtitle:
                            '${resource.formattedTime} (${resource.data?['durationMinutes'] ?? 45} min)',
                      ),
                      _DetailRow(
                        icon: 'user',
                        title: resource.employeeName,
                        subtitle: 'Spécialiste',
                      ),
                    ],
                  ),
                  gapH20,
                  _InfoSection(
                    title: 'Prestation',
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          children: [
                            AppIcon(
                              'sparkle',
                              size: 18,
                              color: AppColors.onSurface,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                resource.serviceName,
                                style: AppTextStyles.labelLg,
                              ),
                            ),
                            if (totalAmountXof != null)
                              Text(
                                xof(totalAmountXof),
                                style: AppTextStyles.labelLg,
                              ),
                          ],
                        ),
                      ),
                      if (totalAmountXof != null || depositAmountXof > 0) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: AppDivider(),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                          child: Column(
                            children: [
                              _PriceRow(
                                label: depositLabel,
                                value: xof(depositAmountXof),
                                isDeposit: hasDeposit,
                              ),
                              if (remainingXof != null) ...[
                                SizedBox(height: 12.h),
                                _PriceRow(
                                  label: resource.status == 'completed'
                                      ? 'Payé sur place'
                                      : 'Reste à payer sur place',
                                  value: xof(remainingXof),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 24.h),
                  if (isPast || resource.status == 'completed') ...[
                    Row(
                      children: [
                        Expanded(
                          child: AppButton.outline(
                            onPressed: () =>
                                context.push(AppRoutes.bookingService),
                            label: 'Réserver à nouveau',
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: AppButton.primary(
                            onPressed: () =>
                                context.push(AppRoutes.review(bookingId)),
                            label: 'Laisser un avis',
                          ),
                        ),
                      ],
                    ),
                  ] else if (!isCancelled) ...[
                    Row(
                      children: [
                        Expanded(
                          child: AppButton.outline(
                            onPressed: () => context.push(
                              AppRoutes.bookingManagePath(bookingId),
                            ),
                            label: 'Modifier',
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: AppButton.primary(
                            onPressed: () {}, // Action itinéraire placeholder
                            label: 'Itinéraire',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    Center(
                      child: AppPressable(
                        onTap: () async {
                          AppHaptics.medium();
                          bool? confirm;
                          await AppDialog.show<void>(
                            context,
                            title: 'Annuler le RDV ?',
                            body: 'Cette action est irréversible.',
                            actions: [
                              AppDialogAction(
                                label: 'Non',
                                onPressed: () {
                                  confirm = false;
                                },
                              ),
                              AppDialogAction(
                                label: 'Annuler',
                                onPressed: () {
                                  confirm = true;
                                },
                                isDestructive: true,
                              ),
                            ],
                          );
                          if (confirm != true) return;
                          await ref
                              .read(bookingActionsProvider)
                              .cancel(bookingId);
                          if (!context.mounted) return;
                          AppSnackbar.success(context, 'Rendez-vous annulé.');
                          context.pop();
                        },
                        child: Text(
                          'Annuler le rendez-vous',
                          style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ];
      },
    );
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({required this.status, required this.bookingId});

  final String status;
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final isSuccess = status == 'confirmed' || status == 'completed';
    final isCancelled = status == 'cancelled';

    final iconColor = isSuccess
        ? AppColors.success
        : (isCancelled ? AppColors.error : AppColors.secondary);
    final bgColor = isSuccess
        ? AppColors.successContainer
        : (isCancelled
              ? AppColors.errorContainer
              : AppColors.secondaryContainer);
    final icon = isSuccess
        ? 'check'
        : (isCancelled ? 'close' : 'clock');

    final title = switch (status) {
      'confirmed' => 'Rendez-vous confirmé',
      'completed' => 'Rendez-vous terminé',
      'cancelled' => 'Rendez-vous annulé',
      _ => 'En attente de confirmation',
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: AppIcon(icon, size: 28, color: iconColor),
          ),
          SizedBox(height: 16.h),
          Text(title, style: AppTextStyles.headlineSm),
          SizedBox(height: 4.h),
          Text(
            'Réf. #${bookingId.split('-').first}',
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(title, style: AppTextStyles.labelMd),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: AppShadows.card,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.neutral,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppIcon(icon, size: 18, color: AppColors.onSurfaceVariant),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLg),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.isDeposit = false,
  });

  final String label;
  final String value;
  final bool isDeposit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMd.copyWith(
            color: isDeposit ? AppColors.success : AppColors.onSurface,
            fontWeight: isDeposit ? FontWeight.w600 : null,
          ),
        ),
      ],
    );
  }
}
