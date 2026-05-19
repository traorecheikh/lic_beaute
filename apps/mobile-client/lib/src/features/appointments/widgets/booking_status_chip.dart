import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/status_labels.dart';

class BookingStatusChip extends StatelessWidget {
  const BookingStatusChip({
    required this.status,
    this.endsAt,
    this.isUpcoming = false,
    super.key,
  });

  final String status;
  final DateTime? endsAt;
  final bool isUpcoming;

  @override
  Widget build(BuildContext context) {
    final label = bookingStatusLabel(status, endsAt: endsAt);
    final isPending = status == 'pending';
    final isCancelled = status == 'cancelled';
    final isCompleted = status == 'completed';
    final isInProgress = status == 'in_progress';
    final isPastNotClosed = bookingIsPastNotClosed(
      status: status,
      endsAt: endsAt,
    );

    final background = isCancelled
        ? AppColors.errorContainer
        : (isPastNotClosed
              ? AppColors.statusPendingBg
              : (isPending
              ? AppColors.statusPendingBg
              : ((isCompleted || isInProgress || isUpcoming)
                    ? AppColors.statusConfirmedBg
                    : AppColors.surfaceVariant)));
    final textColor = isCancelled
        ? AppColors.error
        : (isPastNotClosed
              ? AppColors.statusPendingText
              : (isPending
              ? AppColors.statusPendingText
              : ((isCompleted || isInProgress || isUpcoming)
                    ? AppColors.statusConfirmedText
                    : AppColors.onSurfaceVariant)));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}
