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
        case 'payment_confirmed':
          final bookingId = data['bookingId'];
          if (bookingId != null && bookingId.isNotEmpty) {
            router.go(AppRoutes.success(bookingId));
          } else {
            router.go(AppRoutes.bookingsList);
          }
        case 'payment_failed':
          final bookingId = data['bookingId'];
          if (bookingId != null && bookingId.isNotEmpty) {
            router.go(AppRoutes.bookingDetailPath(bookingId));
          } else {
            router.go(AppRoutes.bookingsList);
          }
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
          // ── Dark mode placeholder ───────────────────────────────────
          // Dark mode is not ready yet. Colours and text styles have been
          // defined in AppTheme.dark (app_theme.dart) with contrasting
          // pairs against images and surfaces, but the full implementation
          // is incomplete. A contributor picking this up must:
          //   1. Audit every screen for dark background + text legibility.
          //   2. Verify that images over dark surfaces have adequate contrast.
          //   3. Remove this hardcoded .light and restore ThemeMode.system
          //      (or add a manual toggle) once verified.
          // Until then the app stays in light mode only.
          theme: AppTheme.light,
          themeMode: ThemeMode.light,
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
