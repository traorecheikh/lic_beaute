import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();
const _deviceIdKey = 'fcm_device_id';

class FcmRegistrationService {
  final Dio _dio;
  bool _registered = false;

  FcmRegistrationService(this._dio);

  Future<void> register() async {
    if (_registered) return;
    _registered = true;

    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    final token = await messaging.getToken();
    if (token == null) return;

    await _sendToken(token);

    messaging.onTokenRefresh.listen(_sendToken);
  }

  Future<void> _sendToken(String token) async {
    try {
      await _dio.post<void>(
        '/api/v1/push-tokens',
        data: {
          'token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'deviceId': await _getDeviceId(),
        },
      );
    } on DioException {
      // best-effort — do not propagate
    }
  }

  static Future<String> _getDeviceId() async {
    final existing = await _storage.read(key: _deviceIdKey);
    if (existing != null) return existing;
    final id = '${Platform.operatingSystem}-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999999)}';
    await _storage.write(key: _deviceIdKey, value: id);
    return id;
  }
}
