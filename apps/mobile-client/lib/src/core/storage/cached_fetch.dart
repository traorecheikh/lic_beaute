import 'package:dio/dio.dart';

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
}) async {
  final cached = AppModelCache.getMap(boxName, cacheKey);
  List<dynamic> items;
  try {
    final response = await dio.get<Map<String, dynamic>>(path);
    final payload = response.data ?? const <String, dynamic>{'items': []};
    await AppModelCache.putMap(boxName, cacheKey, payload);
    items = (payload['items'] as List<dynamic>?) ?? const [];
  } on DioException catch (error) {
    if (!fallbackOnAnyError && !isConnectionLikeDioException(error)) {
      rethrow;
    }
    items = (cached?['items'] as List<dynamic>?) ?? const [];
  } catch (_) {
    if (!fallbackOnAnyError) rethrow;
    items = (cached?['items'] as List<dynamic>?) ?? const [];
  }

  return items.cast<Map<String, dynamic>>().map(fromJson).toList();
}
