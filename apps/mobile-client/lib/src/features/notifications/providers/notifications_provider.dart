import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_store.dart';

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
    return NotificationItem(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as String,
    );
  }
}

class NotificationsNotifier
    extends AsyncNotifier<List<NotificationItem>> {
  @override
  Future<List<NotificationItem>> build() async {
    final session = ref.watch(sessionProvider);
    if (!session.isAuthenticated) return [];
    return _fetch();
  }

  Future<List<NotificationItem>> _fetch() async {
    final dio = ref.read(dioProvider);
    final response =
        await dio.get<Map<String, dynamic>>('/api/v1/notifications');
    final items = (response.data?['items'] as List<dynamic>?) ?? [];
    return items
        .cast<Map<String, dynamic>>()
        .map(NotificationItem.fromJson)
        .toList();
  }

  Future<void> markRead(String notificationId) async {
    final dio = ref.read(dioProvider);
    await dio.patch('/api/v1/notifications/$notificationId/read');
    ref.invalidateSelf();
  }

  Future<void> markAllRead() async {
    final current = state.valueOrNull ?? [];
    if (current.isEmpty) return;
    final dio = ref.read(dioProvider);
    await Future.wait(
      current
          .where((n) => !n.isRead)
          .map((n) => dio.patch('/api/v1/notifications/${n.id}/read')),
    );
    ref.invalidateSelf();
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<NotificationItem>>(
        NotificationsNotifier.new);

final unreadCountProvider = Provider<int>((ref) {
  return ref
      .watch(notificationsProvider)
      .valueOrNull
      ?.where((n) => !n.isRead)
      .length ?? 0;
});
