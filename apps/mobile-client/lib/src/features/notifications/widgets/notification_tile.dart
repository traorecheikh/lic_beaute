import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

import '../../../core/widgets/app_icon_box.dart';
import '../providers/notifications_provider.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({required this.item, super.key});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final date = DateTime.tryParse(item.createdAt);
    final formatter = DateFormat('dd/MM · HH:mm');

    return Container(
      color: item.isRead
          ? AppColors.transparent
          : colorScheme.primaryContainer.withValues(alpha: 0.05),
      padding: EdgeInsets.all(20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBox(
            size: 40.r,
            color: item.isRead
                ? colorScheme.surfaceContainerHighest
                : colorScheme.primaryContainer,
            circle: true,
            child: Icon(
              item.isRead
                  ? Icons.notifications_none
                  : Icons.notifications_active,
              color: item.isRead
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.primary,
              size: 20.w,
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
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                gapH4,
                Text(
                  item.body,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: item.isRead
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurface,
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
