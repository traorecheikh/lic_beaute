import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/debounced_action.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../router/app_router.dart';
import '../providers/booking_actions_provider.dart';
import '../providers/bookings_list_provider.dart';

class BookingManagePage extends ConsumerWidget {
  const BookingManagePage({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(bookingDetailProvider(bookingId));

    return AppScaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppTopBar(title: AppStrings.manageBookingTitle, showBackButton: true),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (_, _) => Center(
          child: Text(
            AppStrings.loadBookingInfoError,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ),
        data: (detail) {
          final salonId = detail?.salonId ?? '';
          final serviceId = detail?.serviceId ?? '';

          return Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 28.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _OptionCard(
                  icon: 'calendar',
                  title: AppStrings.moveRdv,
                  subtitle: AppStrings.moveRdvSubtitle,
                  onTap: debouncedAction(() {
                    if (salonId.isEmpty || serviceId.isEmpty) {
                      AppSnackbar.error(context, AppStrings.missingInfo);
                      return;
                    }
                    context.push(
                      '${AppRoutes.bookingSlot}?salonId=$salonId'
                      '&serviceId=$serviceId'
                      '&rescheduleBookingId=$bookingId',
                    );
                  }),
                ),
                gapH16,
                _OptionCard(
                  icon: 'close',
                  title: AppStrings.cancelRdvAction,
                  subtitle: AppStrings.cancelRdvSubtitle,
                  isDestructive: true,
                  onTap: () => _confirmCancel(context, ref),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    AppHaptics.medium();
    final confirmed = await AppSnackbar.confirmDestructive(
      context,
      title: AppStrings.cancelRdvConfirmTitle,
      body: AppStrings.cancelRdvConfirmBody,
      confirmLabel: AppStrings.cancelRdvConfirmLabel,
    );
    if (!confirmed || !context.mounted) return;

    try {
      await ref.read(bookingActionsProvider).cancel(bookingId);
      if (!context.mounted) return;
      AppSnackbar.success(context, AppStrings.bookingCancelled);
      context.pop();
      context.pop();
    } catch (_) {
      if (!context.mounted) return;
      AppSnackbar.error(context, AppStrings.cancelBookingError);
    }
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl.r),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDestructive ? AppColors.errorContainer : AppColors.neutral,
                borderRadius: BorderRadius.circular(AppRadius.lg.r),
              ),
              child: AppIcon(
                icon,
                size: 24,
                color: isDestructive ? AppColors.error : AppColors.primary,
              ),
            ),
            gapW16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLg.copyWith(
                      color: isDestructive ? AppColors.error : AppColors.onSurface,
                    ),
                  ),
                  gapH4,
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            AppIcon('chevron-right', size: 20, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
