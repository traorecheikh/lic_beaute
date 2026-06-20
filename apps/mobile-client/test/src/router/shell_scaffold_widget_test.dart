import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/session/session_store.dart';
import 'package:beauteavenue_mobile_client/src/router/app_router.dart';
import 'package:beauteavenue_mobile_client/src/router/shell_scaffold.dart';

class _FixedSessionNotifier extends SessionNotifier {
  _FixedSessionNotifier(this._fixedState);

  final SessionState _fixedState;

  @override
  SessionState build() => _fixedState;
}

void main() {
  testWidgets('shell tab switching replaces route and stays responsive', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final authenticated = SessionState(
      accessToken: 'tok_test',
      refreshToken: 'refresh_test',
      userId: 'user_1',
    );

    final router = GoRouter(
      initialLocation: '/profile/edit',
      routes: [
        ShellRoute(
          builder: (context, state, child) => ShellScaffold(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (_, _) => const Center(child: Text('Discover page')),
            ),
            GoRoute(
              path: AppRoutes.bookingsList,
              builder: (_, _) => const Center(child: Text('Bookings page')),
              routes: [
                GoRoute(
                  path: 'detail',
                  builder: (_, _) =>
                      const Center(child: Text('Booking detail page')),
                ),
              ],
            ),
            GoRoute(
              path: AppRoutes.profile,
              builder: (_, _) => const Center(child: Text('Profile page')),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (_, _) =>
                      const Center(child: Text('Profile edit page')),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith(
            () => _FixedSessionNotifier(authenticated),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, _) {
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profile edit page'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.toString(),
      '/profile/edit',
    );

    await tester.tap(find.text('Découvrir'));
    await tester.pumpAndSettle();
    expect(find.text('Discover page'), findsOneWidget);
    expect(find.text('Profile edit page'), findsNothing);
    expect(router.routeInformationProvider.value.uri.toString(), '/');

    await tester.tap(find.text('Mes RDV'));
    await tester.pumpAndSettle();
    expect(find.text('Bookings page'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.toString(), '/bookings');

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Profile page'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.toString(), '/profile');

    for (final label in const ['Découvrir', 'Mes RDV', 'Profil']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    expect(find.text('Profile page'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.toString(), '/profile');
  });
}
