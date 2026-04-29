import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/core/env/app_env.dart';
import 'src/core/storage/app_cache.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.load();
  await AppCache.init();
  try {
    await Firebase.initializeApp();
  } catch (error) {
    debugPrint('Firebase init skipped: $error');
  }
  runApp(const ProviderScope(child: ClientApp()));
}
