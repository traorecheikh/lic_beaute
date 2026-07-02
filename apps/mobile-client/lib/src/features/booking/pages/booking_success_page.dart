import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/utils/app_share.dart';
import '../../../core/widgets/app_booking_async_scaffold.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';
import '../../appointments/models/booking_detail.dart';
import '../../appointments/providers/bookings_list_provider.dart';
import '../../discovery/providers/cached_resource.dart';
import '../../discovery/widgets/stale_data_notice.dart';

class BookingSuccessPage extends ConsumerStatefulWidget {
  const BookingSuccessPage({super.key, required this.bookingId});
  final String bookingId;

  @override
  ConsumerState<BookingSuccessPage> createState() => _BookingSuccessPageState();
}

class _BookingSuccessPageState extends ConsumerState<BookingSuccessPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  final _shareKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppHaptics.medium();
      _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBookingAsyncScaffold<BookingDetail>(
      bookingId: widget.bookingId,
      provider: bookingDetailResourceProvider,
      errorTitle: AppStrings.loadConfirmationError,
      serverTitle: AppStrings.confirmationServerTitle,
      sliverBuilder: (resource) {
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: _SuccessBody(
              shareKey: _shareKey,
              salonName: resource.salonName,
              serviceName: resource.serviceName,
              dateLabel: resource.formattedDate,
              bookingId: widget.bookingId,
              scale: _scale,
              fade: _fade,
              staleAt: resource.isStale ? resource.cachedAt : null,
              hasDeposit: (resource.depositXof ?? 0) > 0,
              bookingStatus: resource.status,
              depositPaymentStatus: resource.depositPaymentStatus,
            ),
          ),
        ];
      },
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({
    required this.shareKey,
    required this.salonName,
    required this.serviceName,
    required this.dateLabel,
    required this.bookingId,
    required this.scale,
    required this.fade,
    required this.staleAt,
    required this.hasDeposit,
    required this.bookingStatus,
    required this.depositPaymentStatus,
  });

  final GlobalKey shareKey;
  final String salonName, serviceName, dateLabel, bookingId;
  final Animation<double> scale, fade;
  final DateTime? staleAt;
  final bool hasDeposit;
  final String bookingStatus;
  final String depositPaymentStatus;

  @override
  Widget build(BuildContext context) {
    final isPendingVerification =
        bookingStatus == 'pending' && depositPaymentStatus == 'authorized';
    final heroBg = isPendingVerification
        ? AppColors.warningContainer
        : AppColors.successContainer;
    final heroIcon = isPendingVerification ? 'clock' : 'check';
    final heroIconColor = isPendingVerification
        ? AppColors.warning
        : AppColors.success;
    final title = isPendingVerification
        ? AppStrings.bookingPendingVerificationTitle
        : AppStrings.bookingSuccessTitle;
    final subtitle = isPendingVerification
        ? AppStrings.bookingPendingVerificationBody
        : (hasDeposit
              ? AppStrings.depositReceived
              : AppStrings.bookingConfirmed);
    return Stack(
      children: [
        // Off-screen share card (pre-rendered via RepaintBoundary)
        Positioned(
          left: -9999,
          top: 0,
          width: 380,
          child: RepaintBoundary(
            key: shareKey,
            child: BookingShareCard(
              salonName: salonName,
              service: serviceName,
              date: dateLabel,
              time: '',
              staffName: 'Beauté Avenue',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              ScaleTransition(
                scale: scale,
                child: Container(
                  width: 100.r,
                  height: 100.r,
                  decoration: BoxDecoration(
                    color: heroBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppIcon(heroIcon, size: 48, color: heroIconColor),
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              FadeTransition(
                opacity: fade,
                child: Column(
                  children: [
                    if (staleAt != null) ...[
                      StaleDataNotice(cachedAt: staleAt!),
                      SizedBox(height: 20.h),
                    ],
                    Text(
                      title,
                      style: AppTextStyles.displaySm,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isPendingVerification) ...[
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(AppRadius.lg.r),
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: Text(
                          AppStrings.bookingPendingVerificationDetail,
                          style: AppTextStyles.bodySm,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              FadeTransition(
                opacity: fade,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.xl.r),
                    boxShadow: AppShadows.card,
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(icon: "sparkle", label: salonName),
                      SizedBox(height: 12.h),
                      const AppDivider(),
                      SizedBox(height: 12.h),
                      _SummaryRow(icon: "star", label: serviceName),
                      if (dateLabel.isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        const AppDivider(),
                        SizedBox(height: 12.h),
                        _SummaryRow(icon: "calendar", label: dateLabel),
                      ],
                    ],
                  ),
                ),
              ),
              const Spacer(),
              FadeTransition(
                opacity: fade,
                child: Column(
                  children: [
                    AppButton.primary(
                      onPressed: () =>
                          context.go(AppRoutes.bookingDetailPath(bookingId)),
                      label: AppStrings.viewBookingCta,
                    ),
                    SizedBox(height: 12.h),
                    AppButton.outline(
                      onPressed: () {
                        AppHaptics.light();
                        AppShare.card(
                          context: context,
                          repaintKey: shareKey,
                          text: "Je viens de réserver chez $salonName !",
                        );
                      },
                      label: AppStrings.shareBookingCta,
                    ),
                    SizedBox(height: 12.h),
                    AppButton.text(
                      onPressed: () => context.go(AppRoutes.home),
                      label: AppStrings.backToHomeCta,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.label});

  final String icon, label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppRadius.sm.r),
          ),
          child: Center(
            child: AppIcon(icon, size: 14, color: AppColors.primary),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.labelLg,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
