import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_of/any_of.dart';

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

class ClientOnlyAuthException implements Exception {
  const ClientOnlyAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthActions {
  AuthActions(this._ref);

  final Ref _ref;

  Future<void> loginEmail({
    required String email,
    required String password,
  }) async {
    final api = _ref.read(apiClientProvider).getAuthApi();
    final sessionResponse = await api.apiV1AuthLoginPost(
      emailLoginInput: EmailLoginInput(
        (b) => b
          ..email = email
          ..password = password,
      ),
    );
    await _hydrateSession(sessionResponse.data!);
  }

  Future<void> requestEmailOtp({required String email}) async {
    final dio = _ref.read(dioProvider);
    await dio.post(
      '/api/v1/auth/otp/email/request',
      data: {'email': email},
    );
  }

  Future<void> verifyEmailOtp({
    required String email,
    required String code,
  }) async {
    final dio = _ref.read(dioProvider);
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/auth/otp/email/verify',
      data: {'email': email, 'code': code},
    );
    final data = response.data!;
    await _hydrateSessionFromRaw(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  Future<void> registerEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final api = _ref.read(apiClientProvider).getAuthApi();
    final clientData = RegisterInputAnyOf(
      (b) => b
        ..type = RegisterInputAnyOfTypeEnum.client
        ..fullName = fullName
        ..email = email
        ..password = password,
    );
    final sessionResponse = await api.apiV1AuthRegisterPost(
      registerInput: RegisterInput(
        (b) => b
          ..anyOf = AnyOf2<RegisterInputAnyOf, RegisterInputAnyOf1>(
            values: {0: clientData},
          ),
      ),
    );
    await _hydrateSession(sessionResponse.data!);
  }

  Future<void> requestOtp({required String phone}) async {
    final api = _ref.read(apiClientProvider).getAuthApi();
    await api.apiV1AuthOtpRequestPost(
      otpRequestInput: OtpRequestInput((b) => b..phone = phone),
    );
  }

  Future<void> verifyOtp({required String phone, required String code}) async {
    final api = _ref.read(apiClientProvider).getAuthApi();
    final sessionResponse = await api.apiV1AuthOtpVerifyPost(
      otpVerifyInput: OtpVerifyInput(
        (b) => b
          ..phone = phone
          ..code = code,
      ),
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
    if (user.role.name != 'client') {
      await notifier.logout();
      throw const ClientOnlyAuthException(
        'Ce compte professionnel ne peut pas utiliser l’application cliente.',
      );
    }
    await notifier.login(
      accessToken: authSession.accessToken,
      refreshToken: authSession.refreshToken,
      userId: user.id,
      role: user.role.name,
    );

    _ref.read(fcmRegistrationServiceProvider).register();
  }

  Future<void> _hydrateSessionFromRaw({
    required String accessToken,
    required String refreshToken,
  }) async {
    final notifier = _ref.read(sessionProvider.notifier);
    await notifier.login(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: '',
    );
    final api = _ref.read(apiClientProvider).getAuthApi();
    final meResponse = await api.apiV1MeGet();
    final user = meResponse.data!;
    if (user.role.name != 'client') {
      await notifier.logout();
      throw const ClientOnlyAuthException(
        'Ce compte professionnel ne peut pas utiliser l’application cliente.',
      );
    }
    await notifier.login(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: user.id,
      role: user.role.name,
    );
    _ref.read(fcmRegistrationServiceProvider).register();
  }
}
