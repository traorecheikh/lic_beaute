import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/core/widgets/app_phone_field.dart';
import '../../test_harness.dart';

void main() {
  group('AppPhoneField - rendering', () {
    testWidgets('displays dial code prefix', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
            initialCountry: kPhoneCountries[0], // SN +221
          ),
        ),
      );

      expect(find.text('+221'), findsOneWidget);
    });

    testWidgets('defaults to Senegal when no initial country set', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
          ),
        ),
      );

      expect(find.text('+221'), findsOneWidget);
    });

    testWidgets('shows label text when provided', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
            labelText: 'Mon téléphone',
          ),
        ),
      );

      expect(find.text('Mon téléphone'), findsOneWidget);
    });
  });

  group('AppPhoneField - countries parameter', () {
    testWidgets('uses custom country list', (tester) async {
      final controller = TextEditingController();
      const customCountries = [
        PhoneCountry(code: 'ML', name: 'Mali', dialCode: '+223', flag: '🇲🇱', digits: 8),
        PhoneCountry(code: 'FR', name: 'France', dialCode: '+33', flag: '🇫🇷', digits: 9),
      ];

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
            countries: customCountries,
            initialCountry: customCountries[0],
          ),
        ),
      );

      expect(find.text('+223'), findsOneWidget);
    });
  });

  group('AppPhoneField - formatting', () {
    testWidgets('formats Senegal phone (9 digits) as XX XXX XX XX', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
            initialCountry: kPhoneCountries[0], // SN, 9 digits
          ),
        ),
      );

      // Find the TextFormField and enter digits
      await tester.enterText(find.byType(TextFormField), '771234567');
      await tester.pumpAndSettle();

      // Expect Senegal formatting: 77 123 45 67
      expect(controller.text, '77 123 45 67');
    });

    testWidgets('formats generic country (8 digits) as XX XX XX XX', (tester) async {
      const mali = PhoneCountry(code: 'ML', name: 'Mali', dialCode: '+223', flag: '🇲🇱', digits: 8);
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
            countries: [mali],
            initialCountry: mali,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '70123456');
      await tester.pumpAndSettle();

      // Generic formatting: groups of 2
      expect(controller.text, '70 12 34 56');
    });

    testWidgets('limits input to country digit count (max 9 for SN)', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
            initialCountry: kPhoneCountries[0], // SN, 9 digits
          ),
        ),
      );

      // Type 12 digits — only 9 should be kept
      await tester.enterText(find.byType(TextFormField), '123456789012');
      await tester.pumpAndSettle();

      expect(controller.text.replaceAll(' ', '').length, 9);
    });

    testWidgets('formats 10-digit country as XX XX XX XX XX', (tester) async {
      const ci = PhoneCountry(code: 'CI', name: "Côte d'Ivoire", dialCode: '+225', flag: '🇨🇮', digits: 10);
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
            countries: [ci],
            initialCountry: ci,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '0102030405');
      await tester.pumpAndSettle();

      // Generic 2-group formatting for 10 digits
      expect(controller.text, '01 02 03 04 05');
    });
  });

  group('AppPhoneField - validation', () {
    testWidgets('shows error for too-short phone number in Form', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          Form(
            key: formKey,
            child: AppPhoneField(
              controller: controller,
              initialCountry: kPhoneCountries[0], // SN, 9 digits
            ),
          ),
        ),
      );

      // Enter only 3 digits (too short for SN)
      await tester.enterText(find.byType(TextFormField), '771');
      await tester.pumpAndSettle();

      // Manually trigger validation
      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      // Error text should appear
      expect(find.text('Numéro invalide (9 chiffres attendus)'), findsOneWidget);
    });

    testWidgets('shows no error for valid-length phone number', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          Form(
            key: formKey,
            child: AppPhoneField(
              controller: controller,
              initialCountry: kPhoneCountries[0], // SN, 9 digits
            ),
          ),
        ),
      );

      // Enter 9 digits (valid for SN)
      await tester.enterText(find.byType(TextFormField), '771234567');
      await tester.pumpAndSettle();

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      // No error text
      expect(find.text('Numéro invalide (9 chiffres attendus)'), findsNothing);
    });

    testWidgets('accepts custom validator override', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          Form(
            key: formKey,
            child: AppPhoneField(
              controller: controller,
              initialCountry: kPhoneCountries[0],
              validator: (_) => 'Custom error',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '771234567');
      await tester.pumpAndSettle();

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Custom error'), findsOneWidget);
    });

    testWidgets('shows no error when validation passes', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          Form(
            key: formKey,
            child: AppPhoneField(
              controller: controller,
              initialCountry: kPhoneCountries[0],
              validator: (v) => (v?.length ?? 0) > 5 ? null : 'Trop court',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '771234567');
      await tester.pumpAndSettle();

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Trop court'), findsNothing);
    });
  });

  group('AppPhoneField - Semantics', () {
    testWidgets('includes Semantics widget as ancestor of TextFormField', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
            labelText: 'Numéro',
          ),
        ),
      );

      final semantics = find.ancestor(
        of: find.byType(TextFormField),
        matching: find.byType(Semantics),
      );
      expect(semantics, findsAtLeastNWidgets(1));
    });
  });

  group('AppPhoneField - country picker interaction', () {
    testWidgets('tapping prefix icon opens country picker bottom sheet', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
            initialCountry: kPhoneCountries[0],
          ),
        ),
      );

      // Tap the prefix icon (flag area) to open country picker
      await tester.tap(find.text('+221'));
      await tester.pumpAndSettle();

      // Bottom sheet should show "Choisir un pays" header
      expect(find.text('Choisir un pays'), findsOneWidget);
    });

    testWidgets('country picker shows all provided countries', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
            initialCountry: kPhoneCountries[0],
          ),
        ),
      );

      // Open country picker
      await tester.tap(find.text('+221'));
      await tester.pumpAndSettle();

      // All default countries should be listed
      for (final country in kPhoneCountries) {
        expect(find.textContaining(country.name), findsOneWidget);
      }
    });

    testWidgets('country picker shows selected country with check icon', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
            initialCountry: kPhoneCountries[0], // SN
          ),
        ),
      );

      // Open country picker
      await tester.tap(find.text('+221'));
      await tester.pumpAndSettle();

      // Selected country should have check icon
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('selecting a different country updates the dial code', (tester) async {
      final controller = TextEditingController();
      String? selectedCountryCode;

      await tester.pumpWidget(
        buildTestableWidget(
          AppPhoneField(
            controller: controller,
            initialCountry: kPhoneCountries[0], // SN +221
            onCountryChanged: (country) {
              selectedCountryCode = country.code;
            },
          ),
        ),
      );

      // Initially shows +221 (Senegal)
      expect(find.text('+221'), findsOneWidget);

      // Open country picker
      await tester.tap(find.text('+221'));
      await tester.pumpAndSettle();

      // CI is the second country in the default list
      // Tap Côte d'Ivoire
      await tester.tap(find.textContaining("Côte d'Ivoire"));
      await tester.pumpAndSettle();

      // Dial code should now be +225
      expect(find.text('+225'), findsOneWidget);
      expect(selectedCountryCode, 'CI');
    });
  });
}
