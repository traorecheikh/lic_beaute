import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_booking_async_scaffold.dart';
import '../../../core/widgets/app_bottom_bar.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_icon_box.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';
import '../../discovery/providers/cached_resource.dart';
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
        return [
          if (resource.isStale && resource.cachedAt != null)
            AppSliverStaleNotice(cachedAt: resource.cachedAt!),

          // Header with status color accent
          SliverToBoxAdapter(
            child: _DetailHeader(
              salonName: resource.salonName,
              status: resource.status,
              isPast: isPast,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 140.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // Date & time card
                  if (resource.startsAt != null)
                    _InfoCard(
                      rows: [
                        _InfoRow(
                          icon: 'calendar',
                          label: 'Date',
                          value: resource.fullFormattedDate,
                        ),
                        _InfoRow(
                          icon: 'clock',
                          label: 'Heure',
                          value: resource.formattedTime,
                        ),
                      ],
                    ),
                  gapH12,
                  // Service & staff card
                  _InfoCard(
                    rows: [
                      _InfoRow(
                        icon: 'sparkle',
                        label: 'Prestation',
                        value: resource.serviceName,
                      ),
                      _InfoRow(
                        icon: 'user',
                        label: 'Prestataire',
                        value: resource.employeeName,
                      ),
                    ],
                  ),
                  // Price card
                  if (resource.priceXof != null || resource.depositXof != null) ...[
                    gapH12,
                    _InfoCard(
                      rows: [
                        if (resource.priceXof != null)
                          _InfoRow(
                            icon: 'star',
                            label: 'Total',
                            value: '${resource.priceXof} XOF',
                            valueStyle: AppTextStyles.priceMd
                                .copyWith(color: AppColors.onSurface),
                          ),
                        if (resource.depositXof != null)
                          _InfoRow(
                            icon: 'check',
                            label: 'Acompte',
                            value: '${resource.depositXof} XOF',
                            valueStyle: AppTextStyles.priceMd
                                .copyWith(color: AppColors.success),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ];
      },
      bottomNavigationBar: Consumer(
        builder: (context, ref, _) {
          // Access status from provider to avoid duplication in build method
          final detailAsync = ref.watch(bookingDetailResourceProvider(bookingId));
          return detailAsync.maybeWhen(
            data: (res) => _ActionBar(
              bookingId: bookingId,
              isPast: isPast,
              status: res.status,
              ref: ref,
              context: context,
            ),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.salonName,
    required this.status,
    required this.isPast,
  });

  final String salonName, status;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = _statusColors(status);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bg.withValues(alpha: 0.35), bg.withValues(alpha: 0.12)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: AppIconBox(
                      circle: true,
                      color: AppColors.surface.withValues(alpha: 0.8),
                      child: AppIcon(
                        'arrow-left',
                        size: 18,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      label,
                      style: AppTextStyles.labelSm.copyWith(
                        color: fg,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                'Rendez-vous',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              gapH4,
              Text(salonName, style: AppTextStyles.displaySm),
            ],
          ),
        ),
      ),
    );
  }

  static (Color, Color, String) _statusColors(String status) {
    return switch (status) {
      'confirmed' => (
        AppColors.statusConfirmedBg,
        AppColors.statusConfirmedText,
        'Confirmé',
      ),
      'in_progress' => (
        AppColors.statusCheckedInBg,
        AppColors.statusCheckedInText,
        'En cours',
      ),
      'completed' => (AppColors.successContainer, AppColors.success, 'Terminé'),
      'cancelled' => (AppColors.errorContainer, AppColors.error, 'Annulé'),
      _ => (
        AppColors.statusPendingBg,
        AppColors.statusPendingText,
        'En attente',
      ),
    };
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});
  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: rows
            .asMap()
            .entries
            .map(
              (e) => Column(
                children: [
                  e.value,
                  if (e.key < rows.length - 1)
                    Divider(height: 1, color: AppColors.outlineVariant),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String icon, label, value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          AppIconBox(child: AppIcon(icon, size: 16, color: AppColors.primary)),
          SizedBox(width: 14.w),
          Text(label, style: AppTextStyles.bodySm),
          const Spacer(),
          Text(value, style: valueStyle ?? AppTextStyles.labelLg),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.bookingId,
    required this.isPast,
    required this.status,
    required this.ref,
    required this.context,
  });

  final String bookingId, status;
  final bool isPast;
  final WidgetRef ref;
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    final isCancelled = status == 'cancelled' || status == 'completed';

    return AppBottomBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            if (isPast) ...[
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () => context.push(AppRoutes.review(bookingId)),
                  child: const Text('Laisser un avis'),
                ),
              ),
            ] else if (!isCancelled) ...[
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () =>
                      context.push(AppRoutes.bookingManagePath(bookingId)),
                  child: const Text('Modifier le rendez-vous'),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error, width: 1.5),
                  ),
                  onPressed: () async {
                    AppHaptics.medium();
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        title: const Text('Annuler le RDV ?'),
                        content: const Text('Cette action est irréversible.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Non'),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.error,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Annuler'),
                          ),
                        ],
                      ),
                    );
                    if (confirm != true) return;
                    await ref.read(bookingActionsProvider).cancel(bookingId);
                    if (!context.mounted) return;
                    AppSnackbar.success(context, 'Rendez-vous annulé.');
                    context.pop();
                  },
                  child: const Text('Annuler le rendez-vous'),
                ),
              ),
            ],
            gapH8,
          ],
        ),
    );
  }
}
