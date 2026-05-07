import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/network/connectivity_provider.dart';
import '../../../core/storage/cached_fetch.dart';
import '../../../core/session/session_store.dart';
import '../../../core/sync/app_outbox.dart';
import '../models/account_models.dart';

class PaymentMethodsNotifier extends AsyncNotifier<List<PaymentMethodRecord>> {
  @override
  Future<List<PaymentMethodRecord>> build() async {
    final session = ref.watch(sessionProvider);
    if (!session.isAuthenticated) return const [];
    final items = await fetchCachedItemList(
      dio: ref.read(dioProvider),
      path: '/api/v1/me/payment-methods',
      boxName: StorageKeys.profileBox,
      cacheKey: StorageKeys.paymentMethods,
      fromJson: PaymentMethodRecord.fromJson,
    );
    return _mergePending(items);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> add({
    required String provider,
    required String phoneNumber,
    String? label,
  }) async {
    final idempotencyKey = _idempotencyKey();
    final payload = {
      'provider': provider,
      'phoneNumber': phoneNumber,
      if (label != null && label.trim().isNotEmpty) 'label': label.trim(),
    };
    final isOnline = ref.read(isOnlineProvider);
    if (!isOnline) {
      await ref
          .read(outboxProvider.notifier)
          .enqueue(
            type: 'payment_method_create',
            payload: {...payload, 'idempotencyKey': idempotencyKey},
          );
      await refresh();
      return;
    }

    final dio = ref.read(dioProvider);
    await dio.post(
      '/api/v1/me/payment-methods',
      data: payload,
      options: Options(headers: {'X-Idempotency-Key': idempotencyKey}),
    );
    await refresh();
  }

  Future<void> updateMethod(
    String paymentMethodId, {
    String? phoneNumber,
    String? label,
  }) async {
    final payload = {
      'phoneNumber': ?phoneNumber,
      'label': label,
    };
    final isOnline = ref.read(isOnlineProvider);
    if (!isOnline) {
      await ref
          .read(outboxProvider.notifier)
          .enqueue(
            type: 'payment_method_update',
            payload: {'paymentMethodId': paymentMethodId, 'data': payload},
          );
      await refresh();
      return;
    }
    final dio = ref.read(dioProvider);
    await dio.patch(
      '/api/v1/me/payment-methods/$paymentMethodId',
      data: payload,
    );
    await refresh();
  }

  Future<void> remove(String paymentMethodId) async {
    final isOnline = ref.read(isOnlineProvider);
    if (!isOnline) {
      await ref
          .read(outboxProvider.notifier)
          .enqueue(
            type: 'payment_method_delete',
            payload: {'paymentMethodId': paymentMethodId},
          );
      await refresh();
      return;
    }
    final dio = ref.read(dioProvider);
    await dio.delete('/api/v1/me/payment-methods/$paymentMethodId');
    await refresh();
  }

  Future<void> setDefault(String paymentMethodId) async {
    final isOnline = ref.read(isOnlineProvider);
    if (!isOnline) {
      await ref
          .read(outboxProvider.notifier)
          .enqueue(
            type: 'payment_method_default',
            payload: {'paymentMethodId': paymentMethodId},
          );
      await refresh();
      return;
    }
    final dio = ref.read(dioProvider);
    await dio.post('/api/v1/me/payment-methods/$paymentMethodId/default');
    await refresh();
  }

  List<PaymentMethodRecord> _mergePending(
    List<PaymentMethodRecord> serverItems,
  ) {
    final pending = ref.watch(outboxProvider);
    var items = [...serverItems];
    for (final entry in pending) {
      switch (entry.type) {
        case 'payment_method_create':
          items = [
            PaymentMethodRecord(
              id: 'pending-${entry.id}',
              provider: entry.payload['provider'] as String? ?? 'intech',
              phoneNumber: entry.payload['phoneNumber'] as String? ?? '',
              label: entry.payload['label'] as String?,
              isDefault: items.every((item) => !item.isDefault),
              lastUsedAt: null,
              pendingSync: true,
            ),
            ...items,
          ];
          break;
        case 'payment_method_update':
          items = items.map((item) {
            if (item.id != entry.payload['paymentMethodId']) return item;
            final data = Map<String, dynamic>.from(
              entry.payload['data'] as Map? ?? const {},
            );
            return item.copyWith(
              phoneNumber: data['phoneNumber'] as String?,
              label: data['label'] as String?,
              pendingSync: true,
            );
          }).toList();
          break;
        case 'payment_method_delete':
          items = items
              .where((item) => item.id != entry.payload['paymentMethodId'])
              .toList();
          break;
        case 'payment_method_default':
          items = items
              .map(
                (item) => item.copyWith(
                  isDefault: item.id == entry.payload['paymentMethodId'],
                  pendingSync: item.id == entry.payload['paymentMethodId'],
                ),
              )
              .toList();
          break;
      }
    }
    return items;
  }

  String _idempotencyKey() {
    final random = Random();
    return '${DateTime.now().microsecondsSinceEpoch}-${random.nextInt(1 << 32)}';
  }
}

final paymentMethodsProvider =
    AsyncNotifierProvider<PaymentMethodsNotifier, List<PaymentMethodRecord>>(
      PaymentMethodsNotifier.new,
    );
