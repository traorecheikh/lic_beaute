import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/diagnostics/app_runtime_diagnostics.dart';
import '../../../core/location/location_service.dart';
import '../../../core/network/api_client_provider.dart';
import '../../../core/network/retry_with_backoff.dart';
import '../../../core/storage/app_model_cache.dart';
import 'cached_resource.dart';

final salonListProvider = FutureProvider<CachedResource<SearchSalonsResponse>>(
  retry: (retryCount, error) => null,
  (ref) async {
    final api = ref.read(apiClientProvider).getSearchApi();
    try {
      final response = await AppRuntimeDiagnostics.runWithInitiator(
        'salonListProvider',
        () => retryWithBackoff(() => api.apiV1SearchSalonsGet(q: '*')),
      );
      final data = response.data;
      DateTime? cachedAt;
      if (data != null) {
        await AppModelCache.putModel<SearchSalonsResponse>(
          StorageKeys.salonCacheBox,
          StorageKeys.salonListKey,
          data,
          const FullType(SearchSalonsResponse),
        );
        cachedAt = AppModelCache.getCachedAt(
          StorageKeys.salonCacheBox,
          StorageKeys.salonListKey,
        );
      }
      return CachedResource(data: data, isStale: false, cachedAt: cachedAt);
    } catch (_) {
      final cached = AppModelCache.getModel<SearchSalonsResponse>(
        StorageKeys.salonCacheBox,
        StorageKeys.salonListKey,
        const FullType(SearchSalonsResponse),
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
    FutureProvider<
      List<SearchSuggestionsResponseTopMatchesInner>?
    >(retry: (retryCount, error) => null, (ref) async {
      debugPrint('[Nearby] waiting for position…');
      final position = await ref.watch(locationProvider.future);
      debugPrint('[Nearby] position=$position');
      if (position == null) {
        debugPrint('[Nearby] → null position, skipping API call');
        return null;
      }

      debugPrint(
        '[Nearby] → calling search API lat=${position.latitude} lng=${position.longitude}',
      );
      final api = ref.read(apiClientProvider).getSearchApi();
      final response = await AppRuntimeDiagnostics.runWithInitiator(
        'nearbyProvider',
        () => retryWithBackoff(
          () => api.apiV1SearchSalonsGet(
            q: '*',
            lat: position.latitude,
            lng: position.longitude,
            sort: 'nearby',
            limit: 50,
          ),
        ),
      );
      final items = response.data?.results.toList() ?? [];
      debugPrint('[Nearby] → got ${items.length} results');
      return items;
    });

final topRatedProvider =
    FutureProvider<List<SearchSuggestionsResponseTopMatchesInner>>(
      retry: (retryCount, error) => null,
      (ref) async {
        final api = ref.read(apiClientProvider).getSearchApi();
        final response = await AppRuntimeDiagnostics.runWithInitiator(
          'topRatedProvider',
          () => retryWithBackoff(
            () => api.apiV1SearchSalonsGet(q: '*', sort: 'rating', limit: 6),
          ),
        );
        return response.data?.results.toList() ?? [];
      },
    );

final trendingProvider =
    FutureProvider<List<SearchSuggestionsResponseTopMatchesInner>>(
      retry: (retryCount, error) => null,
      (ref) async {
        final api = ref.read(apiClientProvider).getSearchApi();
        final response = await AppRuntimeDiagnostics.runWithInitiator(
          'trendingProvider',
          () => retryWithBackoff(
            () => api.apiV1SearchSalonsGet(q: '*', sort: 'trending', limit: 6),
          ),
        );
        return response.data?.results.toList() ?? [];
      },
    );

final prestigeProvider =
    FutureProvider<List<SearchSuggestionsResponseTopMatchesInner>>(
      retry: (retryCount, error) => null,
      (ref) async {
        final api = ref.read(apiClientProvider).getSearchApi();
        final response = await AppRuntimeDiagnostics.runWithInitiator(
          'prestigeProvider',
          () => retryWithBackoff(
            () => api.apiV1SearchSalonsGet(q: '*', sort: 'prestige', limit: 8),
          ),
        );
        return response.data?.results.toList() ?? [];
      },
    );

// Convenience: wraps a Position into a distance badge string
String? distanceBadge(SearchSuggestionsResponseTopMatchesInner salon) {
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
