import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/storage_keys.dart';
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

final secureStorageProvider = Provider<SecureStorage>(
  (ref) => SecureStorage(),
);

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return createDio(storage);
});

final sessionProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier(
    storage: ref.watch(secureStorageProvider),
  );
});

// ── Notifier ──────────────────────────────────────────────────────────────

class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier({required this.storage}) : super(const SessionState());

  final SecureStorage storage;

  Future<void> restore() async {
    state = state.copyWith(isRestoring: true);
    try {
      final access  = await storage.read(StorageKeys.accessToken);
      final refresh = await storage.read(StorageKeys.refreshToken);
      final userId  = await storage.read(StorageKeys.userId);
      final role    = await storage.read(StorageKeys.userRole);

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
    await storage.deleteAll();
    state = const SessionState();
  }
}
