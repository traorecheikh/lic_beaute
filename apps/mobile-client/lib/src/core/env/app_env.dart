import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppEnv {
  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:3000';
}
