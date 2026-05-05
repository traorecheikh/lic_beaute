import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_icon_box.dart';
import 'booking_status_chip.dart';

class BookingListTile extends StatelessWidget {
  const BookingListTile({
    required this.booking,
    required this.isUpcoming,
    super.key,
  });

  final BookingSummaryListResponseItemsInner booking;
  final bool isUpcoming;

  @override
  Widget build(BuildContext context) {
    final date = booking.startsAt.toLocal();
    final dateLabel =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    final timeLabel =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          AppIconBox(
            size: 48.r,
            color: AppColors.primaryLight,
            radius: BorderRadius.circular(12.r),
            child: AppIcon('calendar', size: 20, color: AppColors.primary),
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.salonName, style: AppTextStyles.labelLg),
                SizedBox(height: 2.h),
                Text(booking.serviceName, style: AppTextStyles.bodySm),
                SizedBox(height: 6.h),
                Text('$dateLabel · $timeLabel', style: AppTextStyles.labelSm),
              ],
            ),
          ),
          BookingStatusChip(label: booking.status.name, isUpcoming: isUpcoming),
        ],
      ),
    );
  }
}
