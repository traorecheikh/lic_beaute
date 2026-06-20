import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/connectivity_provider.dart';
import '../../../core/session/session_store.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/cached_fetch.dart';
import '../../../core/sync/app_outbox.dart';

@immutable
class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final bool isRead;
  final String createdAt;

  static NotificationItem fromJson(Map<String, dynamic> json) {
    final readAt = json['readAt'] as String?;
    return NotificationItem(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: readAt != null,
      createdAt: json['createdAt'] as String,
    );
  }
}

class NotificationsNotifier extends AsyncNotifier<List<NotificationItem>> {
  @override
  Future<List<NotificationItem>> build() async {
    final session = ref.watch(sessionProvider);
    if (!session.isAuthenticated) return [];
    return _fetch();
  }

  Future<List<NotificationItem>> _fetch() async {
    return fetchCachedItemList(
      dio: ref.read(dioProvider),
      path: '/api/v1/notifications',
      boxName: StorageKeys.notificationBox,
      cacheKey: StorageKeys.notificationsList,
      fromJson: NotificationItem.fromJson,
      fallbackOnAnyError: true,
    );
  }

  Future<void> markRead(String notificationId) async {
    if (!ref.read(isOnlineProvider)) {
      // Optimistically update local state so the UI reflects the read
      // immediately. The server sync happens later via the outbox.
      final current = [...(state.asData?.value ?? [])];
      state = AsyncData(
        current
            .map((n) => n.id == notificationId
                ? NotificationItem(
                    id: n.id,
                    title: n.title,
                    body: n.body,
                    isRead: true,
                    createdAt: n.createdAt,
                  )
                : n)
            .cast<NotificationItem>()
            .toList(),
      );

      await ref
          .read(outboxProvider.notifier)
          .enqueue(
            type: 'notification_read',
            payload: {'notificationId': notificationId},
          );
      return;
    }
    final dio = ref.read(dioProvider);
    await dio.post('/api/v1/notifications/$notificationId/read');
    ref.invalidateSelf();
  }

  Future<void> markAllRead() async {
    if (!ref.read(isOnlineProvider)) {
      // Optimistically mark all as read in local state.
      final current = [...(state.asData?.value ?? [])];
      state = AsyncData(
        current
            .map((n) => NotificationItem(
                  id: n.id,
                  title: n.title,
                  body: n.body,
                  isRead: true,
                  createdAt: n.createdAt,
                ))
            .cast<NotificationItem>()
            .toList(),
      );

      await ref
          .read(outboxProvider.notifier)
          .enqueue(type: 'notifications_read_all', payload: const {});
      return;
    }
    final dio = ref.read(dioProvider);
    await dio.post('/api/v1/notifications/read-all');
    ref.invalidateSelf();
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<NotificationItem>>(
      NotificationsNotifier.new,
    );

final unreadCountProvider = Provider<int>((ref) {
  return ref
          .watch(notificationsProvider)
          .asData?.value
          .where((n) => !n.isRead)
          .length ??
      0;
});
