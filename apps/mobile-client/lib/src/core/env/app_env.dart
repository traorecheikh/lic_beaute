import 'dart:io';

enum MediaUploadStrategy { directR2Presigned, apiMultipart }

abstract final class AppEnv {
  static Future<void> load() async {}

  // App-level config (no .env): set this per build flavor/profile.
  static const String apiBaseUrlOverride = 'http://h255qm4nj3i832xhkls5270z.159.65.122.15.sslip.io';
  static const MediaUploadStrategy mediaUploadStrategy =
      MediaUploadStrategy.apiMultipart;

  static String get apiBaseUrl {
    if (apiBaseUrlOverride.isNotEmpty) return apiBaseUrlOverride;
    // Android emulator reaches host via 10.0.2.2; iOS simulator uses localhost.
    final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    return 'http://$host:3000';
  }
}
