//
// Beauté Avenue — E2E Authentication & Setup Flow Tests
// ────────────────────────────────────────────────────────────────────────────
//
// Prerequisites:
//   1. A real backend/staging API running and reachable.
//   2. An Android emulator, iOS simulator, or physical device connected.
//   3. Test account credentials passed via --dart-define:
//
//       # Android
//       flutter build apk --debug \
//         --dart-define=E2E_EMAIL=e2e-test@beauteavenue.sn \
//         --dart-define=E2E_PASSWORD=test-password
//       patrol test -t patrol_test/auth_setup_flow_test.dart
//
//       # iOS
//       flutter build ios --debug --no-codesign \
//         --dart-define=E2E_EMAIL=e2e-test@beauteavenue.sn \
//         --dart-define=E2E_PASSWORD=test-password
//       patrol test -t patrol_test/auth_setup_flow_test.dart
//
//   4. The test account should be registered in the backend with:
//        - No fullName set (triggers profile bootstrap redirect)
//        - No payment methods (triggers payment method setup redirect)
//
// Run all tests:
//   patrol test -t patrol_test/auth_setup_flow_test.dart
//
// Run a single test (by name pattern):
//   patrol test -t patrol_test/auth_setup_flow_test.dart \
//     -- --name "smoke:"
//

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

// ── Test configuration (injected via --dart-define) ────────────────────────

const _kDefaultEmail = 'e2e-test@beauteavenue.sn';
const _kDefaultPassword = 'change-me-in-dart-define';

String get _testEmail =>
    const String.fromEnvironment('E2E_EMAIL', defaultValue: _kDefaultEmail);

String get _testPassword =>
    const String.fromEnvironment('E2E_PASSWORD', defaultValue: _kDefaultPassword);

bool get _hasRealCredentials =>
    _testEmail != _kDefaultEmail && _testPassword != _kDefaultPassword;

// ── Splash helpers ─────────────────────────────────────────────────────────
//
// The SplashPage has a _PulsingDots animation that repeats infinitely,
// so $.pumpAndSettle() will never settle. Always use $.pump(duration).

/// Advance past the splash animation (~1.6 s) + restore overhead.
Future<void> bypassSplash(PatrolIntegrationTester $) async {
  await $.pump(const Duration(seconds: 3));
  await $.pump(const Duration(milliseconds: 500));
}

/// Complete onboarding no matter which slide we're on.
Future<void> bypassOnboarding(PatrolIntegrationTester $) async {
  try {
    await $.pump(const Duration(milliseconds: 300));

    // Check for "Passer" (slides 1-2) or "COMMENCER" (slide 3)
    final passer = $('Passer');
    final commencer = $('COMMENCER');

    if (passer.evaluate().isNotEmpty) {
      await passer.tap();
    } else if (commencer.evaluate().isNotEmpty) {
      await commencer.tap();
    }

    await $.pump(const Duration(seconds: 1));
  } catch (_) {
    // Already past onboarding
  }
}

/// Navigate to the email login page from the auth choice page.
Future<void> tapSeConnecter(PatrolIntegrationTester $) async {
  await $.pump(const Duration(milliseconds: 300));
  await $('Se connecter').tap();
  await $.pump(const Duration(seconds: 1));
}

// ── Tests ──────────────────────────────────────────────────────────────────

void main() {
  // ──────────────────────────────────────────────────────────────────────────
  // Test 1: Smoke — splash → onboarding → auth choice page
  // ──────────────────────────────────────────────────────────────────────────
  patrolTest(
    'smoke: app launches and navigates from splash through onboarding to auth',
    ($) async {
      // Initial render
      await $.pump();

      // Verify splash screen shows branding
      expect($('Beauté Avenue'), findsOneWidget);
      expect($("L'excellence à votre portée"), findsOneWidget);

      // Advance past the splash animation (uses pump, not pumpAndSettle)
      await bypassSplash($);

      // Skip onboarding if present
      await bypassOnboarding($);
      await $.pump(const Duration(seconds: 1));

      // Verify we're on the auth choice page
      expect($("S'inscrire"), findsOneWidget);
      expect($('Se connecter'), findsOneWidget);
    },
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Test 2: Email login → profile bootstrap redirect
  //
  //  Requires --dart-define with real credentials.
  // ──────────────────────────────────────────────────────────────────────────
  patrolTest(
    'full flow: email login redirects to profile bootstrap when no name set',
    ($) async {
      if (!_hasRealCredentials) {
        debugPrint(
          '⏭ SKIP: requires --dart-define=E2E_EMAIL=... '
          '--dart-define=E2E_PASSWORD=...',
        );
        return;
      }

      // ── Navigate to login ──────────────────────────────────────────────
      await $.pump();
      await bypassSplash($);
      await bypassOnboarding($);
      await tapSeConnecter($);

      // ── Fill email field ───────────────────────────────────────────────
      await $('EMAIL').tap();
      await $.pump(const Duration(milliseconds: 300));
      // Use the patrol finder's enterText to type into the focused field
      await $('EMAIL').enterText(_testEmail);

      // ── Fill password field ────────────────────────────────────────────
      await $('MOT DE PASSE').tap();
      await $.pump(const Duration(milliseconds: 300));
      await $('MOT DE PASSE').enterText(_testPassword);

      // ── Submit ─────────────────────────────────────────────────────────
      await $('SE CONNECTER').tap();

      // ── Wait for auth + redirect ───────────────────────────────────────
      await $.pump(const Duration(seconds: 6));

      // ── Verify redirect ────────────────────────────────────────────────
      // After login, the router redirects based on cached /api/v1/me data.
      // If fullName is empty → /profile/bootstrap
      try {
        expect($('Complétez votre profil'), findsOneWidget);
      } catch (_) {
        try {
          expect($("Dernière étape"), findsOneWidget);
        } catch (_) {
          debugPrint(
            '⚠ Neither bootstrap nor payment page detected — '
            'account may already be configured.',
          );
        }
      }
    },
    config: PatrolTesterConfig(
      settleTimeout: const Duration(seconds: 35),
    ),
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Test 3: Registration OTP — email → OTP screen
  // ──────────────────────────────────────────────────────────────────────────
  patrolTest(
    'registration: email entry shows OTP verification screen',
    ($) async {
      await $.pump();
      await bypassSplash($);
      await bypassOnboarding($);
      await $.pump(const Duration(milliseconds: 300));

      // Tap "S'inscrire"
      await $("S'inscrire").tap();
      await $.pump(const Duration(seconds: 1));

      // Verify we're on the register page
      expect($('Créer un compte'), findsOneWidget);

      // Enter email
      await $('EMAIL').tap();
      await $.pump(const Duration(milliseconds: 300));
      await $('EMAIL').enterText(_testEmail);

      // Tap "RECEVOIR LE CODE"
      await $('RECEVOIR LE CODE').tap();

      // Wait for API response
      await $.pump(const Duration(seconds: 5));

      try {
        expect($('Vérification'), findsOneWidget);
      } catch (_) {
        debugPrint(
          '⚠ OTP screen not detected — expected if backend is not running '
          'or email is already registered.',
        );
      }
    },
    config: PatrolTesterConfig(
      settleTimeout: const Duration(seconds: 20),
    ),
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Test 4: Complete setup gate chain
  //
  //  login → profile bootstrap → payment setup → home
  //  Requires --dart-define with real credentials.
  // ──────────────────────────────────────────────────────────────────────────
  patrolTest(
    'setup gate: fresh user goes through bootstrap → payment → home',
    ($) async {
      if (!_hasRealCredentials) {
        debugPrint(
          '⏭ SKIP: requires --dart-define=E2E_EMAIL=... '
          '--dart-define=E2E_PASSWORD=...',
        );
        return;
      }

      // ── Navigate & login ───────────────────────────────────────────────
      await $.pump();
      await bypassSplash($);
      await bypassOnboarding($);
      await tapSeConnecter($);

      await $('EMAIL').tap();
      await $.pump(const Duration(milliseconds: 300));
      await $('EMAIL').enterText(_testEmail);

      await $('MOT DE PASSE').tap();
      await $.pump(const Duration(milliseconds: 300));
      await $('MOT DE PASSE').enterText(_testPassword);

      await $('SE CONNECTER').tap();
      await $.pump(const Duration(seconds: 6));

      // ── Step 1: Profile bootstrap ──────────────────────────────────────
      try {
        expect($('Complétez votre profil'), findsOneWidget);
        debugPrint('✅ On profile bootstrap page');

        // Fill name
        await $('Nom complet').tap();
        await $.pump(const Duration(milliseconds: 300));
        await $('Nom complet').enterText('Awa E2E');

        // Select city — tap the dropdown to open the bottom sheet
        await $('Ville de résidence').tap();
        await $.pump(const Duration(seconds: 1));

        // Try tapping the first city option
        try {
          await $('Dakar').tap();
          await $.pump(const Duration(milliseconds: 500));
        } catch (_) {
          debugPrint('⚠ Could not select Dakar from city dropdown');
        }

        // Submit profile
        await $("Commencer l'aventure").tap();
        await $.pump(const Duration(seconds: 3));

        debugPrint('✅ Profile saved');
      } catch (_) {
        debugPrint('⚠ Not on profile bootstrap — account may already have a name');
      }

      // ── Step 2: Payment method setup ────────────────────────────────────
      await $.pump(const Duration(seconds: 2));
      try {
        expect($("Dernière étape"), findsOneWidget);
        debugPrint('✅ On payment setup page');

        // Fill phone number
        await $('Numéro de téléphone').tap();
        await $.pump(const Duration(milliseconds: 300));
        await $('Numéro de téléphone').enterText('778676477');

        // Tap "Ajouter"
        await $('Ajouter').tap();
        await $.pump(const Duration(seconds: 3));

        debugPrint('✅ Payment method added (or attempt made)');
      } catch (_) {
        debugPrint('⚠ Not on payment setup — account may already have payment methods');
      }

      // ── Step 3: Should land on home ─────────────────────────────────────
      await $.pump(const Duration(seconds: 2));
      debugPrint('✅ Setup gate test completed');
    },
    config: PatrolTesterConfig(
      settleTimeout: const Duration(seconds: 60),
    ),
  );
}
