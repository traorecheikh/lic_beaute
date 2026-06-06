import 'package:beauteavenue_mobile_client/src/features/booking/paydunya_launch.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('paydunyaLaunchCandidates', () {
    test('keeps om deeplink first, maxit second, hosted fallback last', () {
      expect(
        paydunyaLaunchCandidates(
          omUrl: 'https://orangemoneysn.page.link/abc',
          maxitUrl: 'https://sugu.orange-sonatel.com/mp/abc',
          hostedUrl: 'https://app.paydunya.com/recharge-orange-sn?token=abc',
        ),
        [
          'https://orangemoneysn.page.link/abc',
          'https://sugu.orange-sonatel.com/mp/abc',
          'https://app.paydunya.com/recharge-orange-sn?token=abc',
        ],
      );
    });

    test('drops blanks and duplicates', () {
      expect(
        paydunyaLaunchCandidates(
          omUrl: ' https://orangemoneysn.page.link/abc ',
          maxitUrl: 'https://orangemoneysn.page.link/abc',
          hostedUrl: '',
        ),
        ['https://orangemoneysn.page.link/abc'],
      );
    });

    test('handles all null inputs', () {
      expect(
        paydunyaLaunchCandidates(),
        isEmpty,
      );
    });

    test('returns only non-empty trimmed values', () {
      expect(
        paydunyaLaunchCandidates(
          omUrl: '  ',
          maxitUrl: '',
          hostedUrl: 'https://app.paydunya.com/test',
        ),
        ['https://app.paydunya.com/test'],
      );
    });

    test('preserves unique order when no duplicates', () {
      expect(
        paydunyaLaunchCandidates(
          omUrl: 'https://orangemoneysn.page.link/a',
          maxitUrl: 'https://sugu.orange-sonatel.com/mp/b',
          hostedUrl: 'https://app.paydunya.com/c',
        ),
        [
          'https://orangemoneysn.page.link/a',
          'https://sugu.orange-sonatel.com/mp/b',
          'https://app.paydunya.com/c',
        ],
      );
    });

    test('drops duplicate when all three are identical after trim', () {
      expect(
        paydunyaLaunchCandidates(
          omUrl: '  https://same.url  ',
          maxitUrl: 'https://same.url',
          hostedUrl: 'https://same.url',
        ),
        ['https://same.url'],
      );
    });

    test('handles multiple trailing whitespace', () {
      expect(
        paydunyaLaunchCandidates(
          omUrl: 'https://orangemoneysn.page.link/abc   ',
        ),
        ['https://orangemoneysn.page.link/abc'],
      );
    });
  });

  group('paydunyaLaunchLabel', () {
    test('maps known deeplinks and hosted urls', () {
      expect(paydunyaLaunchLabel('https://orangemoneysn.page.link/abc'), 'Orange Money');
      expect(paydunyaLaunchLabel('https://sugu.orange-sonatel.com/mp/abc'), 'Maxit');
      expect(paydunyaLaunchLabel('https://pay.wave.com/c/abc'), 'Wave');
      expect(
        paydunyaLaunchLabel('https://app.paydunya.com/recharge-orange-sn?token=abc'),
        'la page PayDunya',
      );
    });

    test('is case-insensitive', () {
      expect(
        paydunyaLaunchLabel('https://ORANGEMONEYSN.PAGE.LINK/ABC'),
        'Orange Money',
      );
      expect(
        paydunyaLaunchLabel('HTTPS://APP.PAYDUNYA.COM/test'),
        'la page PayDunya',
      );
    });

    test('returns generic label for unknown urls', () {
      expect(paydunyaLaunchLabel('https://unknown-payment.com/test'), 'le moyen de paiement');
    });

    test('handles null input', () {
      expect(paydunyaLaunchLabel(null), 'le moyen de paiement');
    });

    test('handles empty string', () {
      expect(paydunyaLaunchLabel(''), 'le moyen de paiement');
    });

    test('matches paydunya.com without subdomain', () {
      expect(
        paydunyaLaunchLabel('https://paydunya.com/recharge'),
        'la page PayDunya',
      );
    });
  });
}
