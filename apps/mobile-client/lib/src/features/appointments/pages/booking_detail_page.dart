import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_booking_async_scaffold.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../router/app_router.dart';
import '../../booking/utils/booking_format.dart';
import '../../../core/utils/status_labels.dart';
import '../../discovery/providers/cached_resource.dart';
import '../../discovery/widgets/stale_data_notice.dart';
import '../models/booking_detail.dart';
import '../providers/booking_actions_provider.dart';
import '../providers/bookings_list_provider.dart';
import '../widgets/review_sheet.dart';

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
    return AppBookingAsyncScaffold<BookingDetail>(
      bookingId: bookingId,
      provider: bookingDetailResourceProvider,
      errorTitle: AppStrings.bookingDetailError,
      serverTitle: AppStrings.bookingDetailServer,
      appBar: AppTopBar(
        showBackButton: true,
      ),
      sliverBuilder: (resource) {
        final salonId = resource.salonId;
        final totalAmountXof = resource.priceXof;
        final depositAmountXof = resource.depositXof ?? 0;
        final hasDeposit = depositAmountXof > 0;
        final depositPaidXof = (resource.depositPaidXof ?? 0).clamp(
          0,
          depositAmountXof,
        );
        final isDepositPaid = hasDeposit && depositPaidXof > 0;
        final remainingXof = totalAmountXof == null
            ? null
            : (totalAmountXof - depositPaidXof).clamp(
                0,
                999999999,
              );

        final isPastNotClosed = bookingIsPastNotClosed(
          status: resource.status,
          endsAt: resource.endsAt,
        );
        final isCancelled =
            resource.status == 'cancelled' || resource.status == 'completed';

        return [
          if (resource.isStale && resource.cachedAt != null)
            AppSliverStaleNotice(cachedAt: resource.cachedAt!),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, MediaQuery.of(context).padding.bottom + 120.h),
              child: Column(
                children: [
                  _StatusHeader(
                    status: resource.status,
                    bookingId: bookingId,
                    endsAt: resource.endsAt,
                  ),
                  gapH20,
                  _InfoSection(
                    title: AppStrings.whereAndWhen,
                    children: [
                      _DetailRow(
                        icon: 'map-pin',
                        title: resource.salonName,
                        subtitle: resource.data?.salonAddress ?? '',
                      ),
                      _DetailRow(
                        icon: 'calendar',
                        title: resource.fullFormattedDate,
                        subtitle:
                            '${resource.formattedTime} (${resource.data?.durationMinutes ?? 45} min)',
                      ),
                      _DetailRow(
                        icon: 'user',
                        title: resource.employeeName,
                        subtitle: AppStrings.funnelSpecialist,
                      ),
                    ],
                  ),
                  gapH20,
                  _InfoSection(
                    title: AppStrings.serviceLabel,
                    children: [
                      _DetailRow(
                        icon: 'sparkle',
                        title: resource.serviceName,
                        subtitle: AppStrings.serviceLabel,
                        trailing: totalAmountXof != null
                            ? Text(
                                xof(totalAmountXof),
                                style: AppTextStyles.labelLg,
                              )
                            : null,
                      ),
                      if (totalAmountXof != null || depositAmountXof > 0) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: AppDivider(),
                        ),
                        _DetailRow(
                          icon: 'wallet',
                          title: AppStrings.depositLabel,
                          subtitle: isDepositPaid ? AppStrings.paid : AppStrings.required,
                          trailing: Text(
                            xof(isDepositPaid ? depositPaidXof : depositAmountXof),
                            style: AppTextStyles.bodyMd.copyWith(
                              color: hasDeposit && isDepositPaid ? AppColors.success : AppColors.onSurface,
                              fontWeight: hasDeposit && isDepositPaid ? FontWeight.w600 : null,
                            ),
                          ),
                        ),
                        if (remainingXof != null) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: AppDivider(),
                          ),
                          _DetailRow(
                            icon: 'info',
                            title: resource.status == 'completed'
                                ? AppStrings.paidOnSite
                                : AppStrings.remainingPayOnSite,
                            subtitle: resource.status == 'completed'
                                ? AppStrings.settled
                                : AppStrings.toPayOnSite,
                            trailing: Text(
                              xof(remainingXof),
                              style: AppTextStyles.bodyMd,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                  gapH24,
                  if (resource.status == 'completed') ...[
                    _RatingPromptCard(
                      bookingId: bookingId,
                      salonName: resource.salonName,
                      serviceName: resource.serviceName,
                      logoUrl: resource.data?.salonLogoUrl,
                    ),
                    gapH16,
                  ],
                  if (isPast || resource.status == 'completed' || isPastNotClosed) ...[
                    Row(
                      children: [
                        Expanded(
                          child: AppButton.outline(
                            onPressed: () {
                              if (salonId.isEmpty) {
                                AppSnackbar.error(
                                  context,
                                  AppStrings.salonNotFoundOnBooking,
                                );
                                return;
                              }
                              context.push(
                                '${AppRoutes.bookingService}?salonId=$salonId',
                              );
                            },
                            label: AppStrings.bookAgain,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: AppButton.primary(
                            onPressed: () => showReviewSheet(
                              context,
                              bookingId: bookingId,
                              salonName: resource.salonName,
                              serviceName: resource.serviceName,
                              logoUrl: resource.data?.salonLogoUrl,
                            ),
                            label: AppStrings.leaveReview,
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
                            label: AppStrings.modifyAction,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: AppButton.primary(
                            onPressed: () async {
                              final addr = Uri.encodeComponent(
                                resource.data?.salonAddress ?? '',
                              );
                              final appleUrl = Uri.parse('maps://?q=$addr');
                              final googleUrl = Uri.parse(
                                'https://maps.google.com/?q=$addr',
                              );
                              if (await canLaunchUrl(appleUrl)) {
                                await launchUrl(appleUrl);
                              } else {
                                await launchUrl(
                                  googleUrl,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            label: AppStrings.directions,
                          ),
                        ),
                      ],
                    ),
                    gapH32,
                    Center(
                      child: AppPressable(
                        onTap: () async {
                          AppHaptics.medium();
                          bool? confirm;
                          await AppDialog.show<void>(
                            context,
                            title: AppStrings.cancelRdvQuestion,
                            body: AppStrings.cancelIrreversible,
                            actions: [
                              AppDialogAction(
                                label: AppStrings.no,
                                onPressed: () {
                                  confirm = false;
                                },
                              ),
                              AppDialogAction(
                                label: AppStrings.cancelRdvAction,
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
                          AppSnackbar.success(context, AppStrings.bookingCancelled);
                          context.pop();
                        },
                        child: Text(
                          AppStrings.cancelRdvAction,
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
  const _StatusHeader({
    required this.status,
    required this.bookingId,
    this.endsAt,
  });

  final String status;
  final String bookingId;
  final DateTime? endsAt;

  @override
  Widget build(BuildContext context) {
    final isPastNotClosed = bookingIsPastNotClosed(status: status, endsAt: endsAt);
    final isSuccess = (status == 'confirmed' || status == 'completed') && !isPastNotClosed;
    final isCancelled = status == 'cancelled';

    final iconColor = isSuccess
        ? AppColors.success
        : (isCancelled ? AppColors.error : AppColors.secondary);
    final bgColor = isSuccess
        ? AppColors.successContainer
        : (isCancelled
              ? AppColors.errorContainer
              : AppColors.secondaryContainer);
    final icon = isSuccess ? 'check' : (isCancelled ? 'close' : 'clock');

    final title = bookingStatusHeadline(status, endsAt: endsAt);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl.r),
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
          gapH16,
          Text(title, style: AppTextStyles.headlineSm),
          gapH4,
          Text(
            '${AppStrings.refPrefix}${bookingId.split('-').first}',
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
            borderRadius: BorderRadius.circular(AppRadius.xl.r),
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
    this.trailing,
  });

  final String icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

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
          if (trailing != null) ...[
            SizedBox(width: 12.w),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _RatingPromptCard extends StatefulWidget {
  const _RatingPromptCard({
    required this.bookingId,
    required this.salonName,
    required this.serviceName,
    this.logoUrl,
  });

  final String bookingId;
  final String salonName;
  final String serviceName;
  final String? logoUrl;

  @override
  State<_RatingPromptCard> createState() => _RatingPromptCardState();
}

class _RatingPromptCardState extends State<_RatingPromptCard> {
  int _hovered = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [            Text(
            AppStrings.giveReview,
            style: AppTextStyles.labelLg,
            textAlign: TextAlign.center,
          ),
          gapH4,
          Text(
            AppStrings.howWasRdv,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          gapH16,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final star = i + 1;
              final active = star <= _hovered;
              return AppPressable(
                onTap: () {
                  AppHaptics.medium();
                  showReviewSheet(
                    context,
                    bookingId: widget.bookingId,
                    salonName: widget.salonName,
                    serviceName: widget.serviceName,
                    logoUrl: widget.logoUrl,
                  );
                },
                child: MouseRegion(
                  onEnter: (_) => setState(() => _hovered = star),
                  onExit: (_) => setState(() => _hovered = 0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: AnimatedScale(
                      scale: active ? 1.12 : 1.0,
                      duration: const Duration(milliseconds: 140),
                      curve: Curves.easeOutBack,
                      child: Icon(
                        active
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 32.r,
                        color: active
                            ? AppColors.secondary
                            : AppColors.outlineVariant,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          gapH8,
          Text(
            AppStrings.tapStarToReview,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

