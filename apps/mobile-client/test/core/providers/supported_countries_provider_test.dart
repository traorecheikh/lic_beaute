import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/core/providers/supported_countries_provider.dart';
import 'package:beauteavenue_mobile_client/src/core/session/session_store.dart';
import 'package:beauteavenue_mobile_client/src/core/widgets/app_phone_field.dart';
import 'package:beauteavenue_mobile_client/src/features/booking/providers/payment_methods_provider.dart';

/// A minimal SessionNotifier that always returns a fixed state.
class _FixedSessionNotifier extends Notifier<SessionState> {
  _FixedSessionNotifier(this._fixedState);

  final SessionState _fixedState;

  @override
  SessionState build() => _fixedState;
}

/// Override for sessionProvider — returns the given state.
Override _sessionOverride(SessionState state) {
  return sessionProvider.overrideWith(
    () => _FixedSessionNotifier(state),
  );
}

/// Override for availablePaydunyaMethodsProvider — returns a static list.
Override _methodsOverride(List<PaydunyaMethodRecord> methods) {
  return availablePaydunyaMethodsProvider.overrideWith(
    (_) async => methods,
  );
}

void main() {
  final authenticated = SessionState(
    accessToken: 'tok_test',
    refreshToken: 'refresh_test',
    userId: 'user_1',
  );

  group('supportedCountriesProvider', () {
    test('returns all countries when not authenticated', () async {
      final container = ProviderContainer(
        overrides: [
          _sessionOverride(const SessionState()),
        ],
      );
      addTearDown(container.dispose);

      final countries = await container.read(supportedCountriesProvider.future);
      expect(countries, unorderedEquals(kPhoneCountries));
    });

    test('returns all countries when API returns empty list', () async {
      final container = ProviderContainer(
        overrides: [
          _sessionOverride(authenticated),
          _methodsOverride([]),
        ],
      );
      addTearDown(container.dispose);

      final countries = await container.read(supportedCountriesProvider.future);
      expect(countries, unorderedEquals(kPhoneCountries));
    });

    test('filters countries to those returned by the API', () async {
      final container = ProviderContainer(
        overrides: [
          _sessionOverride(authenticated),
          _methodsOverride([
            PaydunyaMethodRecord(code: 'orange_senegal', country: 'sn', label: 'Orange Money', enabled: true),
            PaydunyaMethodRecord(code: 'wave_senegal', country: 'sn', label: 'Wave', enabled: true),
            PaydunyaMethodRecord(code: 'orange_cote', country: 'ci', label: 'Orange Money CI', enabled: true),
          ]),
        ],
      );
      addTearDown(container.dispose);

      final countries = await container.read(supportedCountriesProvider.future);

      expect(countries.length, 2);
      // SN inserted at 0 as default
      expect(countries[0].code, 'SN');
      expect(countries[1].code, 'CI');
    });

    test('always includes Senegal as default even when API returns other countries', () async {
      final container = ProviderContainer(
        overrides: [
          _sessionOverride(authenticated),
          _methodsOverride([
            PaydunyaMethodRecord(code: 'wave_cote', country: 'ci', label: 'Wave CI', enabled: true),
            PaydunyaMethodRecord(code: 'wave_mali', country: 'ml', label: 'Wave Mali', enabled: true),
          ]),
        ],
      );
      addTearDown(container.dispose);

      final countries = await container.read(supportedCountriesProvider.future);

      expect(countries.any((c) => c.code == 'SN'), isTrue);
      expect(countries.length, 3);
      expect(countries[0].code, 'SN');
    });

    test('falls back to all countries when API throws', () async {
      final container = ProviderContainer(
        overrides: [
          _sessionOverride(authenticated),
          availablePaydunyaMethodsProvider.overrideWith(
            (_) async => throw Exception('Network error'),
          ),
        ],
      );
      addTearDown(container.dispose);

      final countries = await container.read(supportedCountriesProvider.future);

      expect(countries, unorderedEquals(kPhoneCountries));
    });
  });
}
