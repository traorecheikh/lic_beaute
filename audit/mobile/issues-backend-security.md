# Audit Backend / Mobile Boundary — Security & Reliability

Current status: only verified findings remain in this file.

## S1 — Non-validation Fastify errors still fall through to `reply.send(error)`

**File**
- `apps/api/src/app.ts`

The custom error handler special-cases validation failures, then still forwards all other errors with `reply.send(error)`. That keeps raw framework or application errors in the response path instead of normalizing them to a safe envelope.

## S2 — Play-review OTP bypass is enabled by default and not rejected in prod validation

**File**
- `apps/api/src/config.ts`

`PLAY_REVIEW_ENABLED` defaults to effectively on unless explicitly set to `false`, and `validateConfig()` does not reject that mode in production. That is too permissive for an auth bypass path.

## S3 — Refresh rotation does not bump `tokenVersion`

**File**
- `apps/api/src/modules/auth/index.ts`

Refresh deletes the current session row and creates a new one, but signs the new access token with the existing `user.tokenVersion`. That means previously-issued access tokens stay valid until their natural expiry.

## S4 — FCM registration bypasses the app’s secure-storage wrapper

**Files**
- `apps/mobile-client/lib/src/core/storage/secure_storage.dart`
- `apps/mobile-client/lib/src/core/services/fcm_registration_service.dart`

Most auth/session storage uses the wrapper configured with `IOSOptions(accessibility: KeychainAccessibility.first_unlock)`. FCM registration creates a separate raw `FlutterSecureStorage()` instance instead.

## S5 — Mobile logout does not revoke push-token registration

**Files**
- `apps/mobile-client/lib/src/features/auth/providers/auth_provider.dart`
- `apps/api/src/modules/routes.ts`

The backend exposes `DELETE /api/v1/push-tokens/:tokenId`, but the mobile logout flow never calls it. Local auth is cleared while the server registration remains orphaned.

## S6 — iOS encryption declaration is still set to `false`

**File**
- `apps/mobile-client/ios/Runner/Info.plist`

`ITSAppUsesNonExemptEncryption` is still declared as `false`.

## Notes removed from the old audit

The earlier version of this file also carried weaker or stale claims. In particular:
- `pretty_dio_logger` does not currently log in release builds because the interceptor is gated behind `kDebugMode`
- version-only package drift items were removed from this security file unless they pointed to a current concrete risk
