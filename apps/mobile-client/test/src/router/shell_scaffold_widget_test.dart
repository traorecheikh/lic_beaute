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

class _RecordingNavigatorObserver extends NavigatorObserver {
  int pushCount = 0;
  int popCount = 0;
  int replaceCount = 0;
  final List<String> events = <String>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushCount++;
    events.add('push:${route.settings.name ?? route.runtimeType}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    popCount++;
    events.add('pop:${route.settings.name ?? route.runtimeType}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    replaceCount++;
    events.add(
      'replace:${oldRoute?.settings.name ?? oldRoute.runtimeType}->${newRoute?.settings.name ?? newRoute.runtimeType}',
    );
  }
}

class _LifecycleCounterPage extends StatefulWidget {
  const _LifecycleCounterPage({
    required this.label,
    required this.counter,
    this.child,
  });

  final String label;
  final ValueNotifier<int> counter;
  final Widget? child;

  @override
  State<_LifecycleCounterPage> createState() => _LifecycleCounterPageState();
}

class _LifecycleCounterPageState extends State<_LifecycleCounterPage> {
  @override
  void initState() {
    super.initState();
    widget.counter.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text(widget.label), if (widget.child != null) widget.child!],
      ),
    );
  }
}

Future<void> _pumpNavSettle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

GoRouter _buildRouter({
  required String initialLocation,
  required _RecordingNavigatorObserver rootObserver,
  required ValueNotifier<int> discoverCount,
  required ValueNotifier<int> bookingsCount,
  required ValueNotifier<int> profileCount,
  required GlobalKey<StatefulNavigationShellState> shellKey,
}) {
  return GoRouter(
    initialLocation: initialLocation,
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
                builder: (context, _) => _LifecycleCounterPage(
                  label: 'Discover page',
                  counter: discoverCount,
                  child: ElevatedButton(
                    onPressed: () => showDialog<void>(
                      context: context,
                      useRootNavigator: true,
                      builder: (context) => AlertDialog(
                        title: const Text('Test dialog'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                    child: const Text('Open dialog'),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.bookingsList,
                builder: (context, _) => _LifecycleCounterPage(
                  label: 'Bookings page',
                  counter: bookingsCount,
                  child: ElevatedButton(
                    onPressed: () => context.push('/bookings/detail'),
                    child: const Text('Open booking detail'),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'detail',
                    builder: (_, _) =>
                        const Center(child: Text('Booking detail page')),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, _) => _LifecycleCounterPage(
                  label: 'Profile page',
                  counter: profileCount,
                  child: ElevatedButton(
                    onPressed: () => context.push(AppRoutes.profileEdit),
                    child: const Text('Open profile edit'),
                  ),
                ),
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
      ),
    ],
  );
}

void main() {
  final authenticated = SessionState(
    accessToken: 'tok_test',
    refreshToken: 'refresh_test',
    userId: 'user_1',
  );
  const unauthenticated = SessionState();

  Future<void> pumpHarness(
    WidgetTester tester, {
    required GoRouter router,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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
          builder: (_, _) => MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'rapid bottom-tab switching preserves branch state and does not push root pages',
    (tester) async {
      final rootObserver = _RecordingNavigatorObserver();
      final discoverCount = ValueNotifier<int>(0);
      final bookingsCount = ValueNotifier<int>(0);
      final profileCount = ValueNotifier<int>(0);
      final shellKey = GlobalKey<StatefulNavigationShellState>();

      final router = _buildRouter(
        initialLocation: '/profile/edit',
        rootObserver: rootObserver,
        discoverCount: discoverCount,
        bookingsCount: bookingsCount,
        profileCount: profileCount,
        shellKey: shellKey,
      );

      await pumpHarness(tester, router: router);

      expect(find.text('Profile edit page'), findsOneWidget);
      final rootPushesBeforeSwitching = rootObserver.pushCount;

      const labels = ['Découvrir', 'Mes RDV', 'Profil'];
      const expectedPrefixes = {
        'Découvrir': '/',
        'Mes RDV': '/bookings',
        'Profil': '/profile',
      };

      for (var i = 0; i < 50; i++) {
        final label = labels[i % labels.length];
        await tester.tap(find.text(label));
        await _pumpNavSettle(tester);
        expect(
          router.routeInformationProvider.value.uri.toString(),
          startsWith(expectedPrefixes[label]!),
        );
        expect(tester.takeException(), isNull);
      }

      expect(rootObserver.pushCount, rootPushesBeforeSwitching);
      expect(discoverCount.value, greaterThanOrEqualTo(1));
      expect(bookingsCount.value, greaterThanOrEqualTo(1));
      expect(profileCount.value, greaterThanOrEqualTo(1));
      expect(shellKey.currentState?.currentIndex, 1);
    },
  );

  testWidgets('reselecting a tab returns that branch to its root', (
    tester,
  ) async {
    final router = _buildRouter(
      initialLocation: '/bookings/detail',
      rootObserver: _RecordingNavigatorObserver(),
      discoverCount: ValueNotifier<int>(0),
      bookingsCount: ValueNotifier<int>(0),
      profileCount: ValueNotifier<int>(0),
      shellKey: GlobalKey<StatefulNavigationShellState>(),
    );

    await pumpHarness(tester, router: router);

    expect(find.text('Booking detail page'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await _pumpNavSettle(tester);
    expect(find.text('Profile page'), findsOneWidget);

    await tester.tap(find.text('Open profile edit'));
    await tester.pumpAndSettle();
    expect(find.text('Profile edit page'), findsOneWidget);

    await tester.tap(find.text('Mes RDV'));
    await _pumpNavSettle(tester);
    expect(find.text('Booking detail page'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.toString(),
      '/bookings/detail',
    );

    await tester.tap(find.text('Mes RDV'));
    await _pumpNavSettle(tester);
    expect(find.text('Bookings page'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.toString(), '/bookings');

    await tester.tap(find.text('Profil'));
    await _pumpNavSettle(tester);
    expect(find.text('Profile edit page'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await _pumpNavSettle(tester);
    expect(find.text('Profile page'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.toString(), '/profile');
  });

  testWidgets(
    'closing a root dialog does not leave tab switching blocked by a modal barrier',
    (tester) async {
      final rootObserver = _RecordingNavigatorObserver();
      final router = _buildRouter(
        initialLocation: '/',
        rootObserver: rootObserver,
        discoverCount: ValueNotifier<int>(0),
        bookingsCount: ValueNotifier<int>(0),
        profileCount: ValueNotifier<int>(0),
        shellKey: GlobalKey<StatefulNavigationShellState>(),
      );

      await pumpHarness(tester, router: router);

      await tester.tap(find.text('Open dialog'));
      await tester.pumpAndSettle();
      expect(find.text('Test dialog'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Test dialog'), findsNothing);

      for (final label in const ['Mes RDV', 'Profil', 'Découvrir', 'Mes RDV']) {
        await tester.tap(find.text(label));
        await _pumpNavSettle(tester);
        expect(tester.takeException(), isNull);
      }

      expect(rootObserver.pushCount, greaterThanOrEqualTo(2));
      expect(rootObserver.popCount, greaterThanOrEqualTo(1));
      expect(find.text('Bookings page'), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.toString(), '/bookings');
    },
  );

  testWidgets('unauthenticated protected tabs open the auth sheet', (
    tester,
  ) async {
    final router = _buildRouter(
      initialLocation: '/',
      rootObserver: _RecordingNavigatorObserver(),
      discoverCount: ValueNotifier<int>(0),
      bookingsCount: ValueNotifier<int>(0),
      profileCount: ValueNotifier<int>(0),
      shellKey: GlobalKey<StatefulNavigationShellState>(),
    );

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith(
            () => _FixedSessionNotifier(unauthenticated),
          ),
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

    await tester.tap(find.text('Mes RDV'));
    await tester.pumpAndSettle();

    expect(find.text('Connexion requise'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.toString(), '/');
  });

  testWidgets('shell reserves space for the bottom navigation bar', (
    tester,
  ) async {
    final router = _buildRouter(
      initialLocation: '/',
      rootObserver: _RecordingNavigatorObserver(),
      discoverCount: ValueNotifier<int>(0),
      bookingsCount: ValueNotifier<int>(0),
      profileCount: ValueNotifier<int>(0),
      shellKey: GlobalKey<StatefulNavigationShellState>(),
    );

    await pumpHarness(tester, router: router);

    final shellScaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(shellScaffold.extendBody, isFalse);
  });

}
