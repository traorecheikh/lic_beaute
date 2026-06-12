import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/core/env/app_env.dart';
import 'src/core/services/foreground_notification_service.dart';
import 'src/core/storage/app_cache.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.load();
  await AppCache.init();
  try {
    await Firebase.initializeApp();
    await ForegroundNotificationService.init();
  } catch (error) {
    debugPrint('Firebase init skipped: $error');
  }
  runApp(const ProviderScope(child: ClientApp()));
}
