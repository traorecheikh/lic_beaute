import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import 'core/reactivity/app_reactivity.dart';
import 'core/services/foreground_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_connectivity_banner.dart';
import 'core/widgets/app_connectivity_recovery.dart';
import 'router/app_router.dart';

class ClientApp extends ConsumerWidget {
  const ClientApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // Wire notification tap handler — runs once
    ForegroundNotificationService.onNotificationTap = (data) {
      developer.log('[NOTIFICATION] tapped with type=${data['type']}', name: 'push');
      final type = data['type'];
      if (type == null) {
        router.go(AppRoutes.bookingsList);
        return;
      }
      switch (type) {
        case 'booking_reminder':
        case 'new_booking_salon':
          router.go(AppRoutes.bookingsList);
        default:
          router.go(AppRoutes.notifications);
      }
    };

    return ToastificationWrapper(
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Beauté Avenue',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: router,
          builder: (context, routedChild) {
            return _AppLifecycleRefresh(
              child: AppConnectivityRecovery(
                child: Stack(
                  children: [
                    routedChild ?? const SizedBox.shrink(),
                    const AppConnectivityBanner(),
                  ],
                ),
              ),
            );
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr', 'SN')],
        ),
      ),
    );
  }
}

class _AppLifecycleRefresh extends ConsumerStatefulWidget {
  const _AppLifecycleRefresh({required this.child});

  final Widget child;

  @override
  ConsumerState<_AppLifecycleRefresh> createState() =>
      _AppLifecycleRefreshState();
}

class _AppLifecycleRefreshState extends ConsumerState<_AppLifecycleRefresh>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(appReactivityProvider).refreshAll();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
