import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum MediaUploadStrategy { directR2Presigned, apiMultipart }

abstract final class AppEnv {
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  static const MediaUploadStrategy mediaUploadStrategy =
      MediaUploadStrategy.apiMultipart;

  static String get apiBaseUrl {
    final override = dotenv.env['API_BASE_URL'];
    if (override != null && override.isNotEmpty) return override;
    // Android emulator reaches host via 10.0.2.2; iOS simulator uses localhost.
    final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    return 'http://$host:3000';
  }
}
