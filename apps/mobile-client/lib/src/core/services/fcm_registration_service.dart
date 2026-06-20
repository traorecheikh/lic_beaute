import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../storage/secure_storage.dart';

const _deviceIdKey = 'fcm_device_id';
const _maxRetries = 3;

class FcmRegistrationService {
  final Dio _dio;
  final SecureStorage _secureStorage;
  bool _registered = false;
  StreamSubscription<String>? _tokenRefreshSub;

  FcmRegistrationService(this._dio, this._secureStorage);

  Future<void> register() async {
    if (_registered) return;

    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      // Permission denied — not an error, just nothing to do
      return;
    }

    var token = await messaging.getToken();
    if (token == null) {
      // Token not yet available — try again after a short delay
      await Future.delayed(const Duration(seconds: 3));
      token = await messaging.getToken();
      if (token == null) return;
    }

    final ok = await _sendTokenWithRetry(token);
    if (!ok) return; // all retries exhausted, will retry on next app start

    _registered = true;

    // Listen for token refresh — re-register automatically
    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = messaging.onTokenRefresh.listen((newToken) {
      _sendTokenWithRetry(newToken);
    });
  }

  void reset() {
    _registered = false;
    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
  }

  /// Sends the push token to the server with up to [_maxRetries] retries
  /// and exponential backoff. Returns `true` if at least one attempt succeeded.
  Future<bool> _sendTokenWithRetry(String token) async {
    for (var attempt = 0; attempt < _maxRetries; attempt++) {
      if (attempt > 0) {
        // Exponential backoff: 1s, 3s, 7s
        await Future.delayed(Duration(seconds: (pow(2, attempt) - 1).toInt()));
      }
      try {
        await _dio.post<void>(
          '/api/v1/push-tokens',
          data: {
            'token': token,
            'platform': Platform.isIOS ? 'ios' : 'android',
            'deviceId': await _getDeviceId(),
          },
        );
        return true;
      } on DioException {
        // Will retry unless it's the last attempt
      }
    }
    return false;
  }

  Future<String> _getDeviceId() async {
    final existing = await _secureStorage.read(_deviceIdKey);
    if (existing != null) return existing;
    final id =
        '${Platform.operatingSystem}-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999999)}';
    await _secureStorage.write(_deviceIdKey, id);
    return id;
  }
}
