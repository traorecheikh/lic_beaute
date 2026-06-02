import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/retry_with_backoff.dart';
import '../../../core/session/session_store.dart';

final categoriesProvider = FutureProvider<List<String>>(
  retry: (_, _) => null,
  (ref) async {
    final dio = ref.read(dioProvider);
    final response = await retryWithBackoff(
      () => dio.get<List<dynamic>>('/api/v1/platform/categories'),
    );
    final raw = response.data ?? [];
    return raw
        .whereType<Map<String, dynamic>>()
        .where((c) => c['enabled'] == true)
        .map((c) => c['name'] as String)
        .toList();
  },
);
