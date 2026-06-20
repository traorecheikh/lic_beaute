import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../services/media_upload_service.dart';

import '../constants/storage_keys.dart';
import '../session/session_store.dart';
import '../storage/app_cache.dart';

@immutable
class OutboxEntry {
  const OutboxEntry({
    required this.id,
    required this.type,
    required this.payload,
    required this.createdAt,
    this.localFilePath,
    this.error,
  });

  final String id;
  final String type;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final String? localFilePath;
  final String? error;

  factory OutboxEntry.fromJson(Map<String, dynamic> json) {
    return OutboxEntry(
      id: json['id'] as String,
      type: json['type'] as String,
      payload: Map<String, dynamic>.from(
        (json['payload'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      localFilePath: json['localFilePath'] as String?,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'payload': payload,
      'createdAt': createdAt.toIso8601String(),
      'localFilePath': localFilePath,
      'error': error,
    };
  }

  OutboxEntry copyWith({String? error}) {
    return OutboxEntry(
      id: id,
      type: type,
      payload: payload,
      createdAt: createdAt,
      localFilePath: localFilePath,
      error: error,
    );
  }
}

class OutboxNotifier extends Notifier<List<OutboxEntry>> {
  @override
  List<OutboxEntry> build() {
    final entries = _restoreEntries();
    // Clean up entries that have been in error for more than 24 hours
    // so a permanently failed entry doesn't block the UI forever.
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    final cleaned = [
      for (final entry in entries)
        if (entry.error == null || entry.createdAt.isAfter(cutoff)) entry,
    ];
    if (cleaned.length < entries.length) {
      // Persist the cleaned list asynchronously
      Future(() => _persistList(cleaned));
    }
    return cleaned;
  }

  bool _isFlushing = false;

  static List<OutboxEntry> _restoreEntries() {
    final raw = AppCache.outbox.get(StorageKeys.outboxItems);
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => OutboxEntry.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  Future<void> _persistList(List<OutboxEntry> entries) async {
    await AppCache.outbox.put(
      StorageKeys.outboxItems,
      entries.map((entry) => entry.toJson()).toList(growable: false),
    );
    state = entries;
  }

  Future<void> enqueue({
    required String type,
    required Map<String, dynamic> payload,
    String? localFilePath,
  }) async {
    final entry = OutboxEntry(
      id: _generateId(),
      type: type,
      payload: payload,
      createdAt: DateTime.now(),
      localFilePath: localFilePath,
    );
    state = [...state, entry];
    await _persist();
  }

  Future<void> clearAll() async {
    state = const [];
    await _persist();
  }

  Future<void> clearByTypePrefix(String typePrefix) async {
    state = [
      for (final entry in state)
        if (!entry.type.startsWith(typePrefix)) entry,
    ];
    await _persist();
  }

  Future<void> remove(String id) async {
    state = [
      for (final entry in state)
        if (entry.id != id) entry,
    ];
    await _persist();
  }

  Future<void> flush() async {
    if (_isFlushing || state.isEmpty) return;
    _isFlushing = true;
    try {
      final dio = ref.read(dioProvider);
      final current = [...state];
      for (final entry in current) {
        try {
          await _dispatch(dio, entry);
          await remove(entry.id);
        } on DioException catch (error) {
          final status = error.response?.statusCode ?? 0;
          final isClientError = status >= 400 && status < 500;
          final isTransient = status == 408 || status == 429;

          if (isClientError && !isTransient) {
            // Non-retryable client error (400, 404, 409, 422, etc.) —
            // the server will never accept this payload.
            // Remove the entry entirely instead of keeping it stuck forever.
            await remove(entry.id);
            continue;
          }
          // Transient network/server error — keep the entry for retry but
          // continue processing the rest of the queue instead of blocking.
          continue;
        } catch (error) {
          // Non-DioException (StateError, etc.) — mark and skip.
          state = [
            for (final item in state)
              if (item.id == entry.id)
                item.copyWith(error: error.toString())
              else
                item,
          ];
          await _persist();
          continue;
        }
      }
    } finally {
      _isFlushing = false;
    }
  }

  Future<void> _dispatch(Dio dio, OutboxEntry entry) async {
    switch (entry.type) {
      case 'profile_patch':
        await dio.patch('/api/v1/me', data: entry.payload);
        return;
      case 'payment_method_create':
        await dio.post(
          '/api/v1/me/payment-methods',
          data: entry.payload,
          options: Options(
            headers: {
              if (entry.payload['idempotencyKey'] != null)
                'X-Idempotency-Key': entry.payload['idempotencyKey'],
            },
          ),
        );
        return;
      case 'payment_method_update':
        await dio.patch(
          '/api/v1/me/payment-methods/${entry.payload['paymentMethodId']}',
          data: entry.payload['data'],
        );
        return;
      case 'payment_method_delete':
        await dio.delete(
          '/api/v1/me/payment-methods/${entry.payload['paymentMethodId']}',
        );
        return;
      case 'payment_method_default':
        await dio.post(
          '/api/v1/me/payment-methods/${entry.payload['paymentMethodId']}/default',
        );
        return;
      case 'notification_read':
        await dio.post(
          '/api/v1/notifications/${entry.payload['notificationId']}/read',
        );
        return;
      case 'notifications_read_all':
        await dio.post('/api/v1/notifications/read-all');
        return;
      case 'profile_avatar_upload':
        final path = entry.localFilePath;
        if (path == null || !File(path).existsSync()) {
          throw StateError('Avatar file unavailable');
        }
        final mediaId = await MediaUploadService(dio).uploadAvatar(
          file: XFile(path),
        );
        await dio.patch('/api/v1/me', data: {'avatarMediaId': mediaId});
        return;
      default:
        throw UnsupportedError('Unknown outbox entry type: ${entry.type}');
    }
  }

  Future<void> _persist() async {
    await AppCache.outbox.put(
      StorageKeys.outboxItems,
      state.map((entry) => entry.toJson()).toList(growable: false),
    );
  }

  String _generateId() {
    final random = Random();
    return '${DateTime.now().microsecondsSinceEpoch}-${random.nextInt(1 << 32)}';
  }

}

final outboxProvider = NotifierProvider<OutboxNotifier, List<OutboxEntry>>(
  OutboxNotifier.new,
);

final pendingSyncCountProvider = Provider<int>((ref) {
  return ref.watch(outboxProvider).length;
});
