import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/core/session/session_store.dart';
import 'package:beauteavenue_mobile_client/src/features/booking/providers/payment_methods_provider.dart'
    as booking_payment_methods;
import 'package:beauteavenue_mobile_client/src/features/profile/models/account_models.dart';
import 'package:beauteavenue_mobile_client/src/features/profile/pages/payment_methods_page.dart';
import 'package:beauteavenue_mobile_client/src/features/profile/providers/payment_methods_provider.dart';
import 'package:beauteavenue_mobile_client/src/features/profile/providers/profile_provider.dart';

import '../../../test_harness.dart' show buildTestableWidget;

class _FixedSessionNotifier extends SessionNotifier {
  _FixedSessionNotifier(this._fixedState);

  final SessionState _fixedState;

  @override
  SessionState build() => _fixedState;
}

class _FixedProfileNotifier extends ProfileNotifier {
  _FixedProfileNotifier(this._profile);

  final ClientAccountProfile? _profile;

  @override
  Future<ClientAccountProfile?> build() async => _profile;
}

class _FixedPaymentMethodsNotifier extends PaymentMethodsNotifier {
  _FixedPaymentMethodsNotifier(this._items);

  final List<PaymentMethodRecord> _items;

  @override
  Future<List<PaymentMethodRecord>> build() async => _items;
}

void main() {
  final authenticated = SessionState(
    accessToken: 'tok_test',
    refreshToken: 'refresh_test',
    userId: 'user_1',
  );

  final profile = ClientAccountProfile.fromJson({
    'id': 'user_1',
    'fullName': 'Awa Ndiaye',
    'phone': '+221771234567',
    'preferredContactChannel': 'phone',
    'pushOptIn': true,
    'marketingOptIn': false,
    'preferredLanguage': 'fr',
  });

  final storedMethod = PaymentMethodRecord.fromJson({
    'id': 'pm_1',
    'provider': 'paydunya',
    'phoneNumber': '771234567',
    'label': 'Wave',
    'method': 'wave_senegal',
    'country': 'sn',
    'isDefault': true,
  });

  testWidgets('shows 1/2 clue and a single add button before opening modal', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith(
            () => _FixedSessionNotifier(authenticated),
          ),
          profileProvider.overrideWith(() => _FixedProfileNotifier(profile)),
          paymentMethodsProvider.overrideWith(
            () => _FixedPaymentMethodsNotifier([storedMethod]),
          ),
          booking_payment_methods.availablePaydunyaMethodsProvider.overrideWith(
            (_) async => const [
              booking_payment_methods.PaydunyaMethodRecord(
                code: 'wave_senegal',
                country: 'sn',
                label: 'Wave',
                enabled: true,
              ),
            ],
          ),
        ],
        child: buildTestableWidget(const PaymentMethodsPage(), scaffold: false),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1/2 enregistrés'), findsOneWidget);
    expect(find.text('Ajouter un numéro'), findsOneWidget);
    expect(find.byType(Form), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajouter un numéro'));
    await tester.pumpAndSettle();

    expect(
      find.text('Ajoutez jusqu à 2 numéros pour payer plus vite.'),
      findsOneWidget,
    );
    expect(find.byType(Form), findsOneWidget);
    expect(find.text('Numéro de téléphone'), findsOneWidget);
  });
}
