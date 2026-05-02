import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppEnv {
  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get apiBaseUrl {
    final fromEnv = dotenv.env['API_BASE_URL'];
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    // Android emulator reaches host via 10.0.2.2; iOS simulator uses localhost.
    final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    return 'http://$host:3000';
  }
}
