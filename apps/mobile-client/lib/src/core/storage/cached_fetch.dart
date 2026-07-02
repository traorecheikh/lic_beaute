import 'package:dio/dio.dart';

import '../diagnostics/app_runtime_diagnostics.dart';
import '../network/dio_exception_utils.dart';
import 'app_model_cache.dart';

typedef JsonDecoder<T> = T Function(Map<String, dynamic> json);

Future<List<T>> fetchCachedItemList<T>({
  required Dio dio,
  required String path,
  required String boxName,
  required String cacheKey,
  required JsonDecoder<T> fromJson,
  bool fallbackOnAnyError = false,
  String? initiator,
}) async {
  final cached = AppModelCache.getMap(boxName, cacheKey);
  List<dynamic> items;
  try {
    final response = await (initiator == null
        ? dio.get<Map<String, dynamic>>(path)
        : AppRuntimeDiagnostics.runWithInitiator(
            initiator,
            () => dio.get<Map<String, dynamic>>(path),
          ));
    final payload = response.data ?? const <String, dynamic>{'items': []};
    await AppModelCache.putMap(boxName, cacheKey, payload);
    items = (payload['items'] as List<dynamic>?) ?? const [];
  } on DioException catch (error) {
    if (!fallbackOnAnyError && !isConnectionLikeDioException(error)) {
      rethrow;
    }
    AppRuntimeDiagnostics.markCacheHit('GET', path, const <String, dynamic>{});
    items = (cached?['items'] as List<dynamic>?) ?? const [];
  } catch (_) {
    if (!fallbackOnAnyError) rethrow;
    AppRuntimeDiagnostics.markCacheHit('GET', path, const <String, dynamic>{});
    items = (cached?['items'] as List<dynamic>?) ?? const [];
  }

  return AppModelCache.normalizeMapList(items).map(fromJson).toList();
}
