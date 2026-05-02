import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/network/api_client_provider.dart';
import '../../../core/session/session_store.dart';
import '../../../core/storage/app_model_cache.dart';
import '../../discovery/providers/cached_resource.dart';

final bookingsListProvider =
    FutureProvider<CachedResource<BookingSummaryListResponse>>((ref) async {
      final session = ref.watch(sessionProvider);
      if (!session.isAuthenticated) {
        return const CachedResource(data: null, isStale: false);
      }
      final cacheKey = '${StorageKeys.bookingsListKeyPrefix}${session.userId}';
      final api = ref.read(apiClientProvider).getBookingsApi();
      try {
        final response = await api.apiV1BookingsGet();
        final data = response.data;
        DateTime? cachedAt;
        if (data != null) {
          await AppModelCache.putModel<BookingSummaryListResponse>(
            StorageKeys.bookingCacheBox,
            cacheKey,
            data,
            const FullType(BookingSummaryListResponse),
          );
          cachedAt = AppModelCache.getCachedAt(
            StorageKeys.bookingCacheBox,
            cacheKey,
          );
        }
        return CachedResource(data: data, isStale: false, cachedAt: cachedAt);
      } catch (_) {
        final cached = AppModelCache.getModel<BookingSummaryListResponse>(
          StorageKeys.bookingCacheBox,
          cacheKey,
          const FullType(BookingSummaryListResponse),
        );
        if (cached != null) {
          return CachedResource(
            data: cached,
            isStale: true,
            cachedAt: AppModelCache.getCachedAt(
              StorageKeys.bookingCacheBox,
              cacheKey,
            ),
          );
        }
        rethrow;
      }
    });

final bookingDetailProvider = FutureProvider.family<Map<String, dynamic>?, String>((
  ref,
  bookingId,
) async {
  final result = await _fetchBookingDetail(ref, bookingId);
  return result.data;
});

final bookingDetailResourceProvider =
    FutureProvider.family<CachedResource<Map<String, dynamic>>, String>((
      ref,
      bookingId,
    ) async {
      final result = await _fetchBookingDetail(ref, bookingId);
      return CachedResource(
        data: result.data,
        isStale: result.isStale,
        cachedAt: result.cachedAt,
      );
    });

Future<({Map<String, dynamic>? data, DateTime? cachedAt, bool isStale})>
_fetchBookingDetail(Ref ref, String bookingId) async {
  final session = ref.watch(sessionProvider);
  final cacheKey =
      '${StorageKeys.bookingDetailKeyPrefix}${session.userId ?? 'anon'}:$bookingId';
  final dio = ref.read(dioProvider);
  try {
    final response = await dio.get<Map<String, dynamic>>(
      '/api/v1/bookings/$bookingId',
    );
    final data = response.data;
    DateTime? cachedAt;
    if (data != null) {
      await AppModelCache.putMap(StorageKeys.bookingCacheBox, cacheKey, data);
      cachedAt = AppModelCache.getCachedAt(
        StorageKeys.bookingCacheBox,
        cacheKey,
      );
    }
    return (data: data, cachedAt: cachedAt, isStale: false);
  } catch (_) {
    final cached = AppModelCache.getMap(StorageKeys.bookingCacheBox, cacheKey);
    if (cached != null) {
      return (
        data: cached,
        cachedAt: AppModelCache.getCachedAt(
          StorageKeys.bookingCacheBox,
          cacheKey,
        ),
        isStale: true,
      );
    }
    rethrow;
  }
}
