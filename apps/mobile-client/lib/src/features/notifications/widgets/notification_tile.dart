import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_icon_box.dart';
import '../providers/notifications_provider.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({required this.item, super.key});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(item.createdAt);
    final formatter = DateFormat('dd/MM · HH:mm');

    return Container(
      color: item.isRead
          ? AppColors.transparent
          : AppColors.primaryContainer.withValues(alpha: 0.05),
      padding: EdgeInsets.all(20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBox(
            size: 40.r,
            color: item.isRead
                ? AppColors.surfaceVariant
                : AppColors.primaryContainer,
            circle: true,
            child: AppIcon(
              'bell',
              size: 20,
              color: item.isRead
                  ? AppColors.onSurfaceVariant
                  : AppColors.primary,
            ),
          ),
          gapW16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppTextStyles.labelLg.copyWith(
                          fontWeight: item.isRead
                              ? FontWeight.w600
                              : FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      date == null ? '' : formatter.format(date),
                      style: AppTextStyles.bodySm.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                gapH4,
                Text(
                  item.body,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: item.isRead
                        ? AppColors.onSurfaceVariant
                        : AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
