import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class OutboxNotifier extends StateNotifier<List<OutboxEntry>> {
  OutboxNotifier(this._ref) : super(_restoreEntries());

  final Ref _ref;
  bool _isFlushing = false;

  static List<OutboxEntry> _restoreEntries() {
    final raw = AppCache.outbox.get(StorageKeys.outboxItems);
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => OutboxEntry.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
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
      final dio = _ref.read(dioProvider);
      final current = [...state];
      for (final entry in current) {
        try {
          await _dispatch(dio, entry);
          await remove(entry.id);
        } on DioException catch (error) {
          final status = error.response?.statusCode ?? 0;
          if (status >= 400 && status < 500 && status != 408 && status != 429) {
            state = [
              for (final item in state)
                if (item.id == entry.id)
                  item.copyWith(error: _extractErrorMessage(error))
                else
                  item,
            ];
            await _persist();
            continue;
          }
          break;
        } catch (error) {
          state = [
            for (final item in state)
              if (item.id == entry.id)
                item.copyWith(error: error.toString())
              else
                item,
          ];
          await _persist();
          break;
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
        final fileName = path.split(Platform.pathSeparator).last;
        final upload = await dio.post<Map<String, dynamic>>(
          '/api/v1/media/upload',
          data: FormData.fromMap({
            'file': await MultipartFile.fromFile(path, filename: fileName),
          }),
        );
        final mediaId = upload.data?['id'] as String?;
        if (mediaId == null) {
          throw StateError('Missing uploaded media id');
        }
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

  String? _extractErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String?;
    }
    if (data is Map) {
      return data['message']?.toString();
    }
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          return decoded['message'] as String?;
        }
      } catch (_) {
        return data;
      }
    }
    return error.message;
  }
}

final outboxProvider = StateNotifierProvider<OutboxNotifier, List<OutboxEntry>>(
  (ref) => OutboxNotifier(ref),
);

final pendingSyncCountProvider = Provider<int>((ref) {
  return ref.watch(outboxProvider).length;
});
