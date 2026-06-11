import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/location/location_service.dart';
import '../../../core/network/api_client_provider.dart';
import '../../../core/network/retry_with_backoff.dart';
import '../../../core/storage/app_model_cache.dart';
import 'cached_resource.dart';

final salonListProvider =
    FutureProvider<CachedResource<SalonSummaryListResponse>>(
      retry: (retryCount, error) => null,
      (ref) async {
  final api = ref.read(apiClientProvider).getSalonsApi();
  try {
    final response = await retryWithBackoff(() => api.apiV1SalonsGet());
        final data = response.data;
        DateTime? cachedAt;
        if (data != null) {
          await AppModelCache.putModel<SalonSummaryListResponse>(
            StorageKeys.salonCacheBox,
            StorageKeys.salonListKey,
            data,
            const FullType(SalonSummaryListResponse),
          );
          cachedAt = AppModelCache.getCachedAt(
            StorageKeys.salonCacheBox,
            StorageKeys.salonListKey,
          );
        }
        return CachedResource(data: data, isStale: false, cachedAt: cachedAt);
      } catch (_) {
        final cached = AppModelCache.getModel<SalonSummaryListResponse>(
          StorageKeys.salonCacheBox,
          StorageKeys.salonListKey,
          const FullType(SalonSummaryListResponse),
        );
        if (cached != null) {
          return CachedResource(
            data: cached,
            isStale: true,
            cachedAt: AppModelCache.getCachedAt(
              StorageKeys.salonCacheBox,
              StorageKeys.salonListKey,
            ),
          );
        }
        rethrow;
      }
    },
    );

// Returns salons within 5 km of the current position, sorted by distance.
// Returns null if location is unavailable.
final nearbyProvider =
    FutureProvider<List<SalonSummaryListResponseItemsInner>?>(
      retry: (retryCount, error) => null,
      (ref) async {
      debugPrint('[Nearby] waiting for position…');
      final position = await ref.watch(locationProvider.future);
      debugPrint('[Nearby] position=$position');
      if (position == null) {
        debugPrint('[Nearby] → null position, skipping API call');
        return null;
      }

      debugPrint('[Nearby] → calling API lat=${position.latitude} lng=${position.longitude}');
      final api = ref.read(apiClientProvider).getSalonsApi();
      final response = await retryWithBackoff(
        () => api.apiV1SalonsGet(
          lat: position.latitude,
          lng: position.longitude,
          sort: 'nearby',
          pageSize: '50',
        ),
      );
      final items = response.data?.items.toList() ?? [];
      debugPrint('[Nearby] → got ${items.length} results');
      return items;
    },
    );

final topRatedProvider =
    FutureProvider<List<SalonSummaryListResponseItemsInner>>(
      retry: (retryCount, error) => null,
      (ref) async {
  final api = ref.read(apiClientProvider).getSalonsApi();
  final response = await retryWithBackoff(
    () => api.apiV1SalonsGet(sort: 'rating', pageSize: '50'),
  );
  return response.data?.items.toList() ?? [];
},
    );

final trendingProvider =
    FutureProvider<List<SalonSummaryListResponseItemsInner>>(
      retry: (retryCount, error) => null,
      (ref) async {
  final api = ref.read(apiClientProvider).getSalonsApi();
  final response = await retryWithBackoff(
    () => api.apiV1SalonsGet(
      sort: 'trending',
      pageSize: '50',
    ),
  );
  return response.data?.items.toList() ?? [];
},
    );

final prestigeProvider =
    FutureProvider<List<SalonSummaryListResponseItemsInner>>(
      retry: (retryCount, error) => null,
      (ref) async {
        final api = ref.read(apiClientProvider).getSalonsApi();
        final response = await retryWithBackoff(
          () => api.apiV1SalonsGet(sort: 'prestige', pageSize: '8'),
        );
        return response.data?.items.toList() ?? [];
      },
    );

/// Server-side search: delegates filtering to the API to avoid loading all
/// salons on device. Uses [FutureProviderFamily] keyed by (query, category).
final salonSearchProvider = FutureProvider.family<
    List<SalonSummaryListResponseItemsInner>,
    ({String query, String? category})>(
  retry: (_, _) => null,
  (ref, params) async {
    final api = ref.read(apiClientProvider).getSalonsApi();
    final response = await retryWithBackoff(
      () => api.apiV1SalonsGet(
        search: params.query.isEmpty ? null : params.query,
        category: params.category,
        pageSize: '50',
      ),
    );
    return response.data?.items.toList() ?? [];
  },
);

// Convenience: wraps a Position into a distance badge string
String? distanceBadge(SalonSummaryListResponseItemsInner salon) {
  final d = salon.distanceKm;
  if (d == null) return null;
  if (d < 1) return '${(d * 1000).round()} m';
  return '${d.toStringAsFixed(1)} km';
}

// Resolves LocationPermission without requesting — used to show banner.
Future<bool> hasLocationPermission() async {
  final perm = await Geolocator.checkPermission();
  return perm == LocationPermission.always ||
      perm == LocationPermission.whileInUse;
}
