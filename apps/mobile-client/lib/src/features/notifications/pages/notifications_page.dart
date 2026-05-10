import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/utils/app_http_error_handler.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notification_tile.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return AppScaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppTopBar(
        title: 'Notifications',
        actions: [
          AppPressable(
            onTap: () async {
              try {
                AppHaptics.select();
                await ref.read(notificationsProvider.notifier).markAllRead();
                if (!context.mounted) return;
                AppSnackbar.success(
                  context,
                  'Toutes les notifications sont marquées comme lues.',
                );
              } catch (error) {
                await context.handleHttpError(
                  error,
                  'Mise à jour impossible.',
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                'Tout marquer lu',
                style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
      body: AppAsyncView(
        value: notificationsAsync,
        errorTitle: 'Impossible de charger les notifications',
        onRetry: () => ref.refresh(notificationsProvider.future),
        builder: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: AppEmptyState(
                  icon: 'bell',
                  title: 'Aucune notification',
                  subtitle: 'Vos rappels et confirmations apparaîtront ici.',
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(notificationsProvider.future),
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const AppDivider(),
              itemBuilder: (context, index) {
                final item = items[index];
                return AppPressable(
                  onTap: item.isRead
                      ? null
                      : () async {
                          try {
                            await ref
                                .read(notificationsProvider.notifier)
                                .markRead(item.id);
                          } catch (error) {
                            if (!context.mounted) return;
                            await context.handleHttpError(
                              error,
                              'Mise à jour impossible.',
                            );
                          }
                        },
                  child: NotificationTile(item: item),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
