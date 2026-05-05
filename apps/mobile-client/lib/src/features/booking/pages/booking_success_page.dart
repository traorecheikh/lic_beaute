import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_booking_async_scaffold.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';
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
    return AppBookingAsyncScaffold<Map<String, dynamic>>(
      bookingId: widget.bookingId,
      provider: bookingDetailResourceProvider,
      errorTitle: 'Impossible de charger la confirmation',
      serverTitle: 'La confirmation est indisponible',
      sliverBuilder: (resource) {
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: _SuccessBody(
              salonName: resource.salonName,
              serviceName: resource.serviceName,
              dateLabel: resource.formattedDate,
              bookingId: widget.bookingId,
              scale: _scale,
              fade: _fade,
              staleAt: resource.isStale ? resource.cachedAt : null,
            ),
          ),
        ];
      },
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({
    required this.salonName,
    required this.serviceName,
    required this.dateLabel,
    required this.bookingId,
    required this.scale,
    required this.fade,
    required this.staleAt,
  });

  final String salonName, serviceName, dateLabel, bookingId;
  final Animation<double> scale, fade;
  final DateTime? staleAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              decoration: const BoxDecoration(
                color: AppColors.successContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.check_rounded,
                  color: AppColors.success,
                  size: 48.r,
                ),
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
                  "C'est réservé !",
                  style: AppTextStyles.displaySm,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  "Votre rendez-vous a bien été enregistré.",
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
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
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                children: [
                  _SummaryRow(icon: "sparkle", label: salonName),
                  SizedBox(height: 12.h),
                  Divider(height: 1, color: AppColors.outlineVariant),
                  SizedBox(height: 12.h),
                  _SummaryRow(icon: "star", label: serviceName),
                  if (dateLabel.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Divider(height: 1, color: AppColors.outlineVariant),
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
                  onPressed: () => context.go(AppRoutes.bookingDetailPath(bookingId)),
                  label: "Voir mon rendez-vous",
                ),
                SizedBox(height: 12.h),
                AppButton.outline(
                  onPressed: () => context.go(AppRoutes.home),
                  label: "Retour à l'accueil",
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
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
            borderRadius: BorderRadius.circular(8.r),
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
