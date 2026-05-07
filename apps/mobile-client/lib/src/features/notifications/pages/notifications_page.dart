import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/utils/app_http_error_handler.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notification_tile.dart';

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
              } catch (error) {
                await context.handleHttpError(
                  error,
                  'Mise à jour impossible.',
                );
              }
            },
            child: const Text('Tout marquer lu'),
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
                  icon: Icons.notifications_none_rounded,
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
              separatorBuilder: (_, _) =>
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
