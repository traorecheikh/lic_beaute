import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/core/diagnostics/app_runtime_diagnostics.dart';
import 'src/core/diagnostics/provider_diagnostics_observer.dart';
import 'src/core/env/app_env.dart';
import 'src/core/services/engagement_notification_service.dart';
import 'src/core/services/foreground_notification_service.dart';
import 'src/core/storage/app_cache.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enabled by default for iOS releases. Individual widgets still gate on
  // iOS 26+, so older iOS versions keep the existing Flutter fallback.
  // BA_IOS_NATIVE_GLASS=false remains available as an emergency kill switch.
  final enableIosNativeGlass = const bool.hasEnvironment(
        'BA_IOS_NATIVE_GLASS',
      )
      ? const bool.fromEnvironment('BA_IOS_NATIVE_GLASS')
      : Platform.isIOS;

  // ── Android 15+ edge-to-edge ────────────────────────────────────────
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  await AppEnv.load();
  await AppCache.init();
  await ForegroundNotificationService.init();
  await EngagementNotificationService.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await ForegroundNotificationService.bindFirebase();
  } catch (error) {
    debugPrint('Firebase init skipped: $error');
  }
  AppRuntimeDiagnostics.updateConfig(
    DiagnosticsConfig(
      label: enableIosNativeGlass ? 'ios-glass-enabled' : 'default',
      enableIOSNativeGlass: enableIosNativeGlass,
    ),
  );
  runApp(
    const ProviderScope(
      observers: [ProviderDiagnosticsObserver()],
      child: ClientApp(),
    ),
  );
}
