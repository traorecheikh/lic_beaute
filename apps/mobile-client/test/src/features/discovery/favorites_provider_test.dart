import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:beauteavenue_mobile_client/src/core/network/connectivity_provider.dart';
import 'package:beauteavenue_mobile_client/src/core/session/session_store.dart';
import 'package:beauteavenue_mobile_client/src/core/storage/app_cache.dart';
import 'package:beauteavenue_mobile_client/src/core/constants/storage_keys.dart';
import 'package:beauteavenue_mobile_client/src/features/discovery/providers/favorites_provider.dart';

/// A never-resolving future used to suppress [favoritesListProvider] so the
/// [FavoritesNotifier.build] listener never fires during toggle tests.
final _favoritesListNeverResolve = Completer<Never>().future;

/// A minimal notifier that always returns a fixed SessionState.
class _FixedSessionNotifier extends SessionNotifier {
  _FixedSessionNotifier(this._fixedState);

  final SessionState _fixedState;

  @override
  SessionState build() => _fixedState;
}

/// Builds a minimal [ProviderContainer] for testing [favoritesProvider].
ProviderContainer _makeContainer({
  required Dio dio,
  required SessionState session,
  required bool online,
  bool suppressFavoritesList = false,
}) {
  return ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(dio),
      sessionProvider.overrideWith(() => _FixedSessionNotifier(session)),
      isOnlineProvider.overrideWith((ref) => online),
      if (suppressFavoritesList)
        favoritesListProvider.overrideWith((ref) => _favoritesListNeverResolve),
    ],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final authenticated = SessionState(
    accessToken: 'tok_test',
    refreshToken: 'refresh_test',
    userId: 'user_1',
  );

  setUpAll(() async {
    final tempDir = await Directory.systemTemp.createTemp(
      'beauteavenue-favorites-test',
    );
    Hive.init(tempDir.path);
    await Future.wait([
      Hive.openBox<dynamic>(StorageKeys.salonCacheBox),
      Hive.openBox<dynamic>(StorageKeys.bookingCacheBox),
      Hive.openBox<dynamic>(StorageKeys.notificationBox),
      Hive.openBox<dynamic>(StorageKeys.profileBox),
      Hive.openBox<dynamic>(StorageKeys.settingsBox),
      Hive.openBox<dynamic>(StorageKeys.outboxBox),
      Hive.openBox<dynamic>(StorageKeys.favoritesBox),
    ]);
  });

  setUp(() async {
    await AppCache.favorites.clear();
  });

  group('FavoritesNotifier.toggle()', () {
    test(
      '_pendingToggles guard prevents concurrent toggle for same salonId',
      () async {
        // ── Slow Dio: first toggle stays in-flight ────────────────────────
        final slowResponseCompleter = Completer<void>.sync();
        final slowDio = Dio()
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                slowResponseCompleter.future.then((_) {
                  handler.resolve(
                    Response<Map<String, dynamic>>(
                      requestOptions: options,
                      data: const <String, dynamic>{},
                    ),
                  );
                });
              },
            ),
          );

        final container = _makeContainer(
          dio: slowDio,
          session: authenticated,
          online: true,
          suppressFavoritesList: true,
        );
        addTearDown(container.dispose);

        final notifier = container.read(favoritesProvider.notifier);

        expect(notifier.state.contains('salon_1'), isFalse);

        // Fire first toggle — starts async, suspends at the Dio await
        notifier.toggle('salon_1');
        await Future<void>.delayed(Duration.zero);

        // State optimistically updated
        expect(notifier.state.contains('salon_1'), isTrue);

        // Fire second toggle for same salonId — guard prevents (no-op)
        await notifier.toggle('salon_1');

        // Guard worked: state still has salon_1 exactly once
        expect(notifier.state.contains('salon_1'), isTrue);
        expect(notifier.state.salonIds.length, 1);

        // ── Drain pending async work before test ends ────────────────────
        slowResponseCompleter.complete();
        // Multiple rounds to flush Dio response chain + toggle's ref.invalidate
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
      },
    );

    test('toggle two different salonIds both proceed (guard is per-salon)', () async {
      final slowResponseCompleter = Completer<void>.sync();
      final slowDio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              slowResponseCompleter.future.then((_) {
                handler.resolve(
                  Response<Map<String, dynamic>>(
                    requestOptions: options,
                    data: const <String, dynamic>{},
                  ),
                );
              });
            },
          ),
        );

      final container = _makeContainer(
        dio: slowDio,
        session: authenticated,
        online: true,
        suppressFavoritesList: true,
      );
      addTearDown(container.dispose);

      final notifier = container.read(favoritesProvider.notifier);

      // Fire both without awaiting — both start concurrently
      notifier.toggle('salon_a');
      notifier.toggle('salon_b');
      await Future<void>.delayed(Duration.zero);

      // Both accepted (different salonIds)
      expect(notifier.state.salonIds, contains('salon_a'));
      expect(notifier.state.salonIds, contains('salon_b'));

      // ── Drain pending async work before test ends ──────────────────────
      slowResponseCompleter.complete();
      // Multiple rounds to flush Dio response chain + toggle's ref.invalidate
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
    });

    test('rollback restores state on API failure (add → fail)', () async {
      final failingDio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                  response: Response<Map<String, dynamic>>(
                    statusCode: 500,
                    requestOptions: options,
                  ),
                ),
              );
            },
          ),
        );

      final container = _makeContainer(dio: failingDio, session: authenticated, online: true);
      addTearDown(container.dispose);

      final notifier = container.read(favoritesProvider.notifier);
      notifier.state = FavoritesState(
        salonIds: {'salon_1', 'salon_2'},
        loading: false,
      );

      await notifier.toggle('salon_3');

      expect(notifier.state.salonIds, contains('salon_1'));
      expect(notifier.state.salonIds, contains('salon_2'));
      expect(notifier.state.salonIds, isNot(contains('salon_3')));
      expect(notifier.state.salonIds.length, 2);
    });

    test('rollback restores state on API failure (remove → fail)', () async {
      final failingDio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                  response: Response<Map<String, dynamic>>(
                    statusCode: 500,
                    requestOptions: options,
                  ),
                ),
              );
            },
          ),
        );

      final container = _makeContainer(dio: failingDio, session: authenticated, online: true);
      addTearDown(container.dispose);

      final notifier = container.read(favoritesProvider.notifier);
      notifier.state = FavoritesState(
        salonIds: {'salon_1', 'salon_2'},
        loading: false,
      );

      await notifier.toggle('salon_1');

      expect(notifier.state.salonIds, contains('salon_1'));
      expect(notifier.state.salonIds, contains('salon_2'));
      expect(notifier.state.salonIds.length, 2);
    });

    test('guard releases after successful toggle (re-toggle works)', () async {
      final successDio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  data: const <String, dynamic>{},
                ),
              );
            },
          ),
        );

      final container = _makeContainer(
        dio: successDio,
        session: authenticated,
        online: true,
        suppressFavoritesList: true,
      );
      addTearDown(container.dispose);

      final notifier = container.read(favoritesProvider.notifier);
      notifier.state = FavoritesState(
        salonIds: {'salon_1'},
        loading: false,
      );

      // Add salon_2 — succeeds, guard releases after finally block
      await notifier.toggle('salon_2');
      expect(notifier.state.salonIds, contains('salon_2'));

      // Toggle salon_2 again (remove) — succeeds, guard was released
      await notifier.toggle('salon_2');
      expect(notifier.state.salonIds, isNot(contains('salon_2')));
    });

    test('successful toggle updates state and stays consistent', () async {
      final successDio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  data: const <String, dynamic>{},
                ),
              );
            },
          ),
        );

      final container = _makeContainer(dio: successDio, session: authenticated, online: true);
      addTearDown(container.dispose);

      final notifier = container.read(favoritesProvider.notifier);
      notifier.state = FavoritesState(
        salonIds: {'salon_1'},
        loading: false,
      );

      await notifier.toggle('salon_2');
      expect(notifier.state.salonIds, contains('salon_1'));
      expect(notifier.state.salonIds, contains('salon_2'));
      expect(notifier.state.salonIds.length, 2);

      await notifier.toggle('salon_1');
      expect(notifier.state.salonIds, isNot(contains('salon_1')));
      expect(notifier.state.salonIds, contains('salon_2'));
      expect(notifier.state.salonIds.length, 1);
    });

    test('toggle works when not authenticated (fallback state)', () async {
      final successDio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  data: const <String, dynamic>{},
                ),
              );
            },
          ),
        );

      final container = _makeContainer(
        dio: successDio,
        session: const SessionState(),
        online: true,
      );
      addTearDown(container.dispose);

      final notifier = container.read(favoritesProvider.notifier);

      expect(notifier.state.salonIds, isEmpty);
      await notifier.toggle('salon_1');
      expect(notifier.state.salonIds, contains('salon_1'));
    });
  });
}
