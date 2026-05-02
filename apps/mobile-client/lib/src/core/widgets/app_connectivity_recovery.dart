import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/appointments/providers/bookings_list_provider.dart';
import '../../features/discovery/providers/salon_detail_provider.dart';
import '../../features/discovery/providers/salon_list_provider.dart';
import '../../features/notifications/providers/notifications_provider.dart';
import '../../features/profile/providers/benefits_provider.dart';
import '../../features/profile/providers/payment_methods_provider.dart';
import '../../features/profile/providers/profile_provider.dart';
import '../../features/profile/providers/vouchers_provider.dart';
import '../network/connectivity_provider.dart';
import '../sync/app_outbox.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppConnectivityRecovery extends ConsumerStatefulWidget {
  const AppConnectivityRecovery({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppConnectivityRecovery> createState() =>
      _AppConnectivityRecoveryState();
}

class _AppConnectivityRecoveryState
    extends ConsumerState<AppConnectivityRecovery> {
  bool _isRecovering = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() => ref.read(outboxProvider.notifier).flush());
    ref.listenManual<bool>(isOnlineProvider, (previous, next) {
      if (previous == false && next == true) {
        _showRecoveryCue();
        ref.read(outboxProvider.notifier).flush();
        ref.invalidate(salonListProvider);
        ref.invalidate(bookingsListProvider);
        ref.invalidate(salonDetailProvider);
        ref.invalidate(salonDetailResourceProvider);
        ref.invalidate(salonAvailabilityProvider);
        ref.invalidate(salonReviewsProvider);
        ref.invalidate(bookingDetailProvider);
        ref.invalidate(bookingDetailResourceProvider);
        ref.invalidate(profileProvider);
        ref.invalidate(paymentMethodsProvider);
        ref.invalidate(benefitsProvider);
        ref.invalidate(vouchersProvider);
        ref.invalidate(notificationsProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRecovering) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          child: ExcludeSemantics(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  offset: const Offset(0, 0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: 1,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 340.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4FAF7),
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(color: const Color(0xFFBFE4D0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 18.r,
                              height: 18.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.success,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Connexion rétablie',
                                    style: AppTextStyles.labelMd.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'Actualisation des données…',
                                    style: AppTextStyles.bodyXs.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showRecoveryCue() {
    if (!mounted) return;
    setState(() => _isRecovering = true);
    Future<void>.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() => _isRecovering = false);
      }
    });
  }
}
