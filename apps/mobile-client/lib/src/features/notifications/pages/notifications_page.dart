import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/notifications_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Notifications', style: AppTextStyles.headlineMd),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                AppHaptics.select();
                await ref.read(notificationsProvider.notifier).markAllRead();
                if (!context.mounted) return;
                AppSnackbar.success(
                  context,
                  'Toutes les notifications sont marquées comme lues.',
                );
              } on DioException catch (error) {
                if (!context.mounted) return;
                final data = error.response?.data;
                final message = data is Map<String, dynamic>
                    ? data['message'] as String? ?? 'Mise à jour impossible.'
                    : 'Mise à jour impossible.';
                AppSnackbar.error(context, message);
              }
            },
            child: const Text('Tout marquer lu'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          title: 'Impossible de charger les notifications',
          message: error.toString(),
          onRetry: () => ref.refresh(notificationsProvider.future),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 48.r,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 12.h),
                    Text('Aucune notification', style: AppTextStyles.labelLg),
                    SizedBox(height: 6.h),
                    Text(
                      'Vos rappels et confirmations apparaîtront ici.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMd.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(notificationsProvider.future),
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: colorScheme.outlineVariant),
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: item.isRead
                      ? null
                      : () async {
                          try {
                            await ref
                                .read(notificationsProvider.notifier)
                                .markRead(item.id);
                          } on DioException catch (error) {
                            if (!context.mounted) return;
                            final data = error.response?.data;
                            final message = data is Map<String, dynamic>
                                ? data['message'] as String? ??
                                      'Mise à jour impossible.'
                                : 'Mise à jour impossible.';
                            AppSnackbar.error(context, message);
                          }
                        },
                  child: _NotificationTile(item: item),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final date = DateTime.tryParse(item.createdAt);
    final formatter = DateFormat('dd/MM · HH:mm');
    return Container(
      color: item.isRead
          ? Colors.transparent
          : colorScheme.primaryContainer.withValues(alpha: 0.05),
      padding: EdgeInsets.all(20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: item.isRead
                  ? colorScheme.surfaceContainerHighest
                  : colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
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
          SizedBox(width: 16.w),
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
                SizedBox(height: 4.h),
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
