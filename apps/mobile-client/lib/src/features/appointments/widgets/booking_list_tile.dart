import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_icon_box.dart';
import '../../discovery/providers/salon_detail_provider.dart';
import 'booking_status_chip.dart';

class BookingListTile extends ConsumerWidget {
  const BookingListTile({
    required this.booking,
    required this.isUpcoming,
    super.key,
  });

  final BookingSummaryListResponseItemsInner booking;
  final bool isUpcoming;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = booking.startsAt.toLocal();
    final dateLabel =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    final timeLabel =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    final salonDetail = ref
        .watch(salonDetailProvider(booking.salonId))
        .asData
        ?.value;
    final salonImageUrl =
        (salonDetail?.logoUrl != null && salonDetail!.logoUrl!.isNotEmpty)
        ? salonDetail.logoUrl
        : ((salonDetail?.gallery.isNotEmpty ?? false)
              ? salonDetail!.gallery.first
              : null);
    final hasImage = salonImageUrl != null && salonImageUrl.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: hasImage
                ? CachedNetworkImage(
                    imageUrl: salonImageUrl,
                    width: 48.r,
                    height: 48.r,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => AppIconBox(
                      size: 48.r,
                      color: AppColors.primaryLight,
                      radius: BorderRadius.circular(12.r),
                      child: AppIcon(
                        'calendar',
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : AppIconBox(
                    size: 48.r,
                    color: AppColors.primaryLight,
                    radius: BorderRadius.circular(12.r),
                    child: AppIcon(
                      'calendar',
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
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
