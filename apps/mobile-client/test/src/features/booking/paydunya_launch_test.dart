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
  });
}
