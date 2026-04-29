import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client_provider.dart';
import '../../../core/session/session_store.dart';

// ── Current user ──────────────────────────────────────────────────────────

final currentUserProvider = FutureProvider<CurrentUser?>((ref) async {
  final session = ref.watch(sessionProvider);
  if (!session.isAuthenticated) return null;
  final api = ref.read(apiClientProvider).getAuthApi();
  final response = await api.apiV1MeGet();
  return response.data;
});

// ── Async auth actions ────────────────────────────────────────────────────

final authActionsProvider = Provider<AuthActions>((ref) => AuthActions(ref));

class AuthActions {
  AuthActions(this._ref);

  final Ref _ref;

  Future<void> loginEmail({
    required String email,
    required String password,
  }) async {
    final api = _ref.read(apiClientProvider).getAuthApi();
    final sessionResponse = await api.apiV1AuthLoginPost(
      emailLoginInput: EmailLoginInput((b) => b
        ..email = email
        ..password = password),
    );
    await _hydrateSession(sessionResponse.data!);
  }

  Future<void> requestOtp({required String phone}) async {
    final api = _ref.read(apiClientProvider).getAuthApi();
    await api.apiV1AuthOtpRequestPost(
      otpRequestInput: OtpRequestInput((b) => b..phone = phone),
    );
  }

  Future<void> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final api = _ref.read(apiClientProvider).getAuthApi();
    final sessionResponse = await api.apiV1AuthOtpVerifyPost(
      otpVerifyInput: OtpVerifyInput((b) => b
        ..phone = phone
        ..code = code),
    );
    await _hydrateSession(sessionResponse.data!);
  }

  Future<void> logout() async {
    try {
      final api = _ref.read(apiClientProvider).getAuthApi();
      await api.apiV1AuthLogoutPost();
    } finally {
      await _ref.read(sessionProvider.notifier).logout();
    }
  }

  Future<void> _hydrateSession(AuthSession authSession) async {
    // Store tokens first so apiV1MeGet gets a valid Authorization header
    final notifier = _ref.read(sessionProvider.notifier);
    await notifier.login(
      accessToken: authSession.accessToken,
      refreshToken: authSession.refreshToken,
      userId: '',
    );
    // Fetch userId + role from /me
    final api = _ref.read(apiClientProvider).getAuthApi();
    final meResponse = await api.apiV1MeGet();
    final user = meResponse.data!;
    await notifier.login(
      accessToken: authSession.accessToken,
      refreshToken: authSession.refreshToken,
      userId: user.id,
      role: user.role.name,
    );
  }
}
