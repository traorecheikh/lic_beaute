import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/features/auth/pages/auth_choice_page.dart';
import '../../../test_harness.dart';

/// Sets the test surface to a phone-like size so [AuthChoicePage] content
/// (which uses Spacer widgets and SafeArea) doesn't overflow.
extension on WidgetTester {
  Future<void> setPhoneSurface() async {
    final originalSize = view.physicalSize;
    final originalRatio = view.devicePixelRatio;
    addTearDown(() {
      view.physicalSize = originalSize;
      view.devicePixelRatio = originalRatio;
    });
    // Set physical size at 1x DPR so logical size matches the AppScaffold design.
    // 390×844 logical pixels is what AuthChoicePage's Spacer-based layout expects.
    view.physicalSize = const Size(390, 844);
    view.devicePixelRatio = 1.0;
  }
}

void main() {
  group('AuthChoicePage', () {
    testWidgets('renders brand name and tagline', (tester) async {
      await tester.setPhoneSurface();
      await tester.pumpWidget(
        buildTestableRouterWidget(
          (_) => const AuthChoicePage(),
          path: '/auth',
          initialLocation: '/auth',
        ),
      );

      // Allow animations and image loading to settle
      await tester.pumpAndSettle();

      expect(find.text('Beauté Avenue'), findsOneWidget);
      expect(
        find.text(
          'Réservez les meilleurs salons\nde beauté autour de vous.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders primary sign-up button', (tester) async {
      await tester.setPhoneSurface();
      await tester.pumpWidget(
        buildTestableRouterWidget(
          (_) => const AuthChoicePage(),
          path: '/auth',
          initialLocation: '/auth',
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text("S'inscrire"), findsOneWidget);
    });

    testWidgets('renders login button and divider text', (tester) async {
      await tester.setPhoneSurface();
      await tester.pumpWidget(
        buildTestableRouterWidget(
          (_) => const AuthChoicePage(),
          path: '/auth',
          initialLocation: '/auth',
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Se connecter'), findsOneWidget);
      // The divider text uses proper French accents: "Déjà un compte ?"
      expect(find.text('Déjà un compte ?'), findsOneWidget);
    });

    testWidgets('renders continue without account link', (tester) async {
      await tester.setPhoneSurface();
      await tester.pumpWidget(
        buildTestableRouterWidget(
          (_) => const AuthChoicePage(),
          path: '/auth',
          initialLocation: '/auth',
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Continuer sans compte'), findsOneWidget);
    });

    testWidgets('renders logo image', (tester) async {
      await tester.setPhoneSurface();
      await tester.pumpWidget(
        buildTestableRouterWidget(
          (_) => const AuthChoicePage(),
          path: '/auth',
          initialLocation: '/auth',
        ),
      );

      await tester.pumpAndSettle();

      // The page renders Image.asset('assets/logo.png')
      expect(find.byType(Image), findsAtLeast(1));
    });
  });
}
