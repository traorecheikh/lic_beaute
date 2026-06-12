import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Shows local notifications for foreground FCM messages and handles taps
/// from all app life-cycle states (terminated, background, foreground).
class ForegroundNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  /// Called when the user taps a notification.
  /// Receives the FCM data payload as `Map<String, String>`.
  static void Function(Map<String, String> data)? onNotificationTap;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          _handlePayload(payload);
        }
      },
    );

    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'Beauté Avenue',
      description: 'Réservations et actualités salon',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Background tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Terminated → app launch
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Foreground → show local notification
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      final data = message.data;
      String? payload;
      if (data.isNotEmpty) {
        payload = data.entries.map((e) => '${e.key}=${e.value}').join('&');
      }

      _plugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            androidChannel.id,
            androidChannel.name,
            channelDescription: androidChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );
    });
  }

  static void _handleMessage(RemoteMessage message) {
    final data = message.data;
    if (data.isEmpty) return;
    _notify(data);
  }

  static void _handlePayload(String payload) {
    final data = <String, String>{};
    for (final part in payload.split('&')) {
      final eq = part.indexOf('=');
      if (eq > 0 && eq < part.length - 1) {
        data[part.substring(0, eq)] = part.substring(eq + 1);
      }
    }
    if (data.isNotEmpty) {
      _notify(data);
    }
  }

  static void _notify(Map<String, dynamic> data) {
    final stringMap = data.map((k, v) => MapEntry(k, v.toString()));
    developer.log('[NOTIFICATION] tapped with data: $stringMap', name: 'push');
    onNotificationTap?.call(stringMap);
  }
}
