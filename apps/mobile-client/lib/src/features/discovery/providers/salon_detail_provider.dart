import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/network/api_client_provider.dart';
import '../../../core/storage/app_model_cache.dart';
import '../../../core/session/session_store.dart';
import 'cached_resource.dart';

Future<CachedResource<SalonDetail>> _fetchSalonDetail(
  Ref ref,
  String salonId,
) async {
  final api = ref.read(apiClientProvider).getSalonsApi();
  final cacheKey = '${StorageKeys.salonDetailKeyPrefix}$salonId';
  try {
    final response = await api.apiV1SalonsIdGet(id: salonId);
    final data = response.data;
    DateTime? cachedAt;
    if (data != null) {
      await AppModelCache.putModel<SalonDetail>(
        StorageKeys.salonCacheBox,
        cacheKey,
        data,
        const FullType(SalonDetail),
      );
      cachedAt = AppModelCache.getCachedAt(StorageKeys.salonCacheBox, cacheKey);
    }
    return CachedResource(data: data, isStale: false, cachedAt: cachedAt);
  } catch (_) {
    final cached = AppModelCache.getModel<SalonDetail>(
      StorageKeys.salonCacheBox,
      cacheKey,
      const FullType(SalonDetail),
    );
    if (cached != null) {
      return CachedResource(
        data: cached,
        isStale: true,
        cachedAt: AppModelCache.getCachedAt(StorageKeys.salonCacheBox, cacheKey),
      );
    }
    rethrow;
  }
}

/// Single source of truth for salon detail. Returns the full CachedResource.
final salonDetailResourceProvider =
    FutureProvider.autoDispose.family<CachedResource<SalonDetail>, String>((
      ref,
      salonId,
    ) async {
      return _fetchSalonDetail(ref, salonId);
    });

/// Convenience accessor that extracts just the SalonDetail data.
/// Delegates to [salonDetailResourceProvider] so both share the same cache.
final salonDetailProvider = FutureProvider.autoDispose.family<SalonDetail?, String>((
  ref,
  salonId,
) async {
  final resource = await ref.watch(salonDetailResourceProvider(salonId).future);
  return resource.data;
});

final salonAvailabilityProvider =
    FutureProvider.autoDispose.family<
      List<dynamic>,
      ({String salonId, String date, String serviceId, String? employeeId})
    >((ref, params) async {
      final dio = ref.read(dioProvider);
      final response = await dio.get<List<dynamic>>(
        '/api/v1/salons/${params.salonId}/availability',
        queryParameters: {
          'date': params.date,
          'serviceId': params.serviceId,
          if (params.employeeId != null && params.employeeId!.isNotEmpty)
            'employeeId': params.employeeId,
        },
      );
      return response.data ?? [];
    });

final salonReviewsProvider = FutureProvider.family<List<dynamic>, String>((
  ref,
  salonId,
) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '/api/v1/salons/$salonId/reviews',
  );
  final items = (response.data?['items'] as List<dynamic>?) ?? [];
  return items;
});
