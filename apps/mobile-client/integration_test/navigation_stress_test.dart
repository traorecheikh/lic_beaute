import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';

import 'package:beauteavenue_mobile_client/src/core/session/session_store.dart';
import 'package:beauteavenue_mobile_client/src/router/app_router.dart';
import 'package:beauteavenue_mobile_client/src/router/shell_scaffold.dart';

class _FixedSessionNotifier extends SessionNotifier {
  _FixedSessionNotifier(this._fixedState);

  final SessionState _fixedState;

  @override
  SessionState build() => _fixedState;
}

class _RootObserver extends NavigatorObserver {
  int pushCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushCount++;
  }
}

Future<void> _pumpShellApp(
  WidgetTester tester, {
  required GoRouter router,
  required SessionState session,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sessionProvider.overrideWith(() => _FixedSessionNotifier(session)),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, _) => MaterialApp.router(routerConfig: router),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('50 rapid bottom-tab switches stay responsive on iOS runtime', (
    tester,
  ) async {
    final rootObserver = _RootObserver();
    final authenticated = SessionState(
      accessToken: 'tok_test',
      refreshToken: 'refresh_test',
      userId: 'user_1',
    );

    final shellKey = GlobalKey<StatefulNavigationShellState>();
    final router = GoRouter(
      initialLocation: '/profile/edit',
      observers: [rootObserver],
      routes: [
        StatefulShellRoute.indexedStack(
          key: shellKey,
          notifyRootObserver: false,
          builder: (context, state, navigationShell) =>
              ShellScaffold(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  builder: (_, _) => const Scaffold(
                    body: Center(child: Text('Discover page')),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.bookingsList,
                  builder: (_, _) => const Scaffold(
                    body: Center(child: Text('Bookings page')),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.profile,
                  builder: (_, _) =>
                      const Scaffold(body: Center(child: Text('Profile page'))),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      builder: (_, _) => const Scaffold(
                        body: Center(child: Text('Profile edit page')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );

    await _pumpShellApp(tester, router: router, session: authenticated);

    expect(find.text('Profile edit page'), findsOneWidget);
    final rootPushesBefore = rootObserver.pushCount;

    const taps = ['Découvrir', 'Mes RDV', 'Profil'];
    const expectedPrefixes = ['/', '/bookings', '/profile'];

    for (var i = 0; i < 50; i++) {
      final tapLabel = taps[i % taps.length];
      final expectedPrefix = expectedPrefixes[i % expectedPrefixes.length];
      await tester.tap(find.text(tapLabel));
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 120));

      expect(
        router.routeInformationProvider.value.uri.toString(),
        startsWith(expectedPrefix),
      );
      expect(tester.takeException(), isNull);
    }

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(rootObserver.pushCount, rootPushesBefore);
    expect(shellKey.currentState?.currentIndex, 1);
  });
}
