import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:built_value/serializer.dart';

import '../constants/storage_keys.dart';
import 'app_cache.dart';

class AppModelCache {
  const AppModelCache._();

  static Future<void> putModel<T>(
    String boxName,
    String key,
    T value,
    FullType type,
  ) async {
    final box = _boxFor(boxName);
    final serialized = standardSerializers.serialize(
      value,
      specifiedType: type,
    );
    await box.put(key, {
      'cachedAt': DateTime.now().toIso8601String(),
      'data': serialized,
    });
  }

  static T? getModel<T>(String boxName, String key, FullType type) {
    final data = _dataFor(boxName, key);
    if (data == null) return null;
    final deserialized = standardSerializers.deserialize(
      data,
      specifiedType: type,
    );
    return deserialized as T?;
  }

  static Future<void> putMap(
    String boxName,
    String key,
    Map<String, dynamic> value,
  ) async {
    final box = _boxFor(boxName);
    await box.put(key, {
      'cachedAt': DateTime.now().toIso8601String(),
      'data': value,
    });
  }

  static Map<String, dynamic>? getMap(String boxName, String key) {
    final data = _dataFor(boxName, key);
    if (data is! Map) return null;
    return Map<String, dynamic>.from(data);
  }

  static DateTime? getCachedAt(String boxName, String key) {
    final box = _boxFor(boxName);
    final cached = box.get(key);
    if (cached is! Map) return null;
    final raw = cached['cachedAt'];
    if (raw is! String) return null;
    return DateTime.tryParse(raw);
  }

  static Object? _dataFor(String boxName, String key) {
    final box = _boxFor(boxName);
    final cached = box.get(key);
    if (cached is! Map) return null;
    return cached['data'];
  }

  static dynamic _boxFor(String boxName) {
    switch (boxName) {
      case StorageKeys.salonCacheBox:
        return AppCache.salons;
      case StorageKeys.bookingCacheBox:
        return AppCache.bookings;
      case StorageKeys.notificationBox:
        return AppCache.notifications;
      case StorageKeys.profileBox:
        return AppCache.profile;
      case StorageKeys.settingsBox:
        return AppCache.settings;
      case StorageKeys.outboxBox:
        return AppCache.outbox;
      default:
        throw ArgumentError.value(boxName, 'boxName', 'Unknown cache box');
    }
  }
}
