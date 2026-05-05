import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/storage_keys.dart';
import '../network/connectivity_provider.dart';
import '../network/dio_client.dart';
import '../storage/secure_storage.dart';

// ── State ─────────────────────────────────────────────────────────────────

@immutable
class SessionState {
  const SessionState({
    this.accessToken,
    this.refreshToken,
    this.userId,
    this.role,
    this.isRestoring = false,
  });

  final String? accessToken;
  final String? refreshToken;
  final String? userId;
  final String? role;
  final bool isRestoring;

  bool get isAuthenticated => accessToken != null && userId != null;

  SessionState copyWith({
    String? accessToken,
    String? refreshToken,
    String? userId,
    String? role,
    bool? isRestoring,
    bool clearAuth = false,
  }) {
    if (clearAuth) {
      return const SessionState();
    }
    return SessionState(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      isRestoring: isRestoring ?? this.isRestoring,
    );
  }
}

// ── Providers ─────────────────────────────────────────────────────────────

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final dio = createDio(storage);
  final reachability = ref.read(networkReachabilityProvider.notifier);
  dio.interceptors.add(_ReachabilityInterceptor(reachability));
  return dio;
});

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(
  SessionNotifier.new,
);

// ── Notifier ──────────────────────────────────────────────────────────────

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() => const SessionState();

  Future<void> restore() async {
    state = state.copyWith(isRestoring: true);
    final storage = ref.read(secureStorageProvider);
    try {
      final access = await storage.read(StorageKeys.accessToken);
      final refresh = await storage.read(StorageKeys.refreshToken);
      final userId = await storage.read(StorageKeys.userId);
      final role = await storage.read(StorageKeys.userRole);

      if (access != null && userId != null) {
        state = SessionState(
          accessToken: access,
          refreshToken: refresh,
          userId: userId,
          role: role,
        );
      } else {
        state = const SessionState();
      }
    } catch (_) {
      state = const SessionState();
    }
  }

  Future<void> login({
    required String accessToken,
    required String refreshToken,
    required String userId,
    String? role,
  }) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(StorageKeys.accessToken, accessToken);
    await storage.write(StorageKeys.refreshToken, refreshToken);
    await storage.write(StorageKeys.userId, userId);
    if (role != null) await storage.write(StorageKeys.userRole, role);

    state = SessionState(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      role: role,
    );
  }

  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.deleteAll();
    state = const SessionState();
  }
}

class _ReachabilityInterceptor extends Interceptor {
  _ReachabilityInterceptor(this._reachability);

  final NetworkReachabilityNotifier _reachability;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _reachability.markReachable();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        _reachability.markConnectionFailure();
        break;
      case DioExceptionType.badResponse:
        _reachability.markReachable();
        break;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        break;
    }
    handler.next(err);
  }
}
