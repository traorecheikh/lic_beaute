import 'package:hive_ce_flutter/hive_flutter.dart';

import '../constants/storage_keys.dart';

class AppCache {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<dynamic>(StorageKeys.salonCacheBox),
      Hive.openBox<dynamic>(StorageKeys.bookingCacheBox),
      Hive.openBox<dynamic>(StorageKeys.notificationBox),
      Hive.openBox<dynamic>(StorageKeys.profileBox),
      Hive.openBox<dynamic>(StorageKeys.settingsBox),
      Hive.openBox<dynamic>(StorageKeys.outboxBox),
    ]);
  }

  static Box<dynamic> get salons =>
      Hive.box<dynamic>(StorageKeys.salonCacheBox);
  static Box<dynamic> get bookings =>
      Hive.box<dynamic>(StorageKeys.bookingCacheBox);
  static Box<dynamic> get notifications =>
      Hive.box<dynamic>(StorageKeys.notificationBox);
  static Box<dynamic> get profile => Hive.box<dynamic>(StorageKeys.profileBox);
  static Box<dynamic> get settings =>
      Hive.box<dynamic>(StorageKeys.settingsBox);
  static Box<dynamic> get outbox => Hive.box<dynamic>(StorageKeys.outboxBox);
}
