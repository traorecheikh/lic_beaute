import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/retry_with_backoff.dart';
import '../../../core/session/session_store.dart';
import '../../../core/storage/app_cache.dart';

const _categoriesTTL = Duration(hours: 1);
const _cachedCategoriesKey = 'cached_categories';

final categoriesProvider = FutureProvider<List<String>>(
  retry: (_, _) => null,
  (ref) async {
    // Try cached categories first
    final cached = _readCachedCategories();
    if (cached != null) return cached;

    final dio = ref.read(dioProvider);
    final response = await retryWithBackoff(
      () => dio.get<List<dynamic>>('/api/v1/platform/categories'),
    );
    final raw = response.data ?? [];
    final categories = raw
        .whereType<Map<String, dynamic>>()
        .where((c) => c['enabled'] == true)
        .map((c) => c['name'] as String)
        .toList();

    // Cache with TTL
    await _cacheCategories(categories);
    return categories;
  },
);

List<String>? _readCachedCategories() {
  final box = AppCache.settings;
  final raw = box.get(_cachedCategoriesKey);
  if (raw is! Map) return null;
  final cachedAt = raw['cached_at'] as String?;
  if (cachedAt == null) return null;
  final age = DateTime.now().difference(DateTime.parse(cachedAt));
  if (age > _categoriesTTL) return null;
  final data = raw['data'] as List<dynamic>?;
  if (data == null) return null;
  return data.whereType<String>().toList();
}

Future<void> _cacheCategories(List<String> categories) async {
  await AppCache.settings.put(_cachedCategoriesKey, {
    'cached_at': DateTime.now().toIso8601String(),
    'data': categories,
  });
}
