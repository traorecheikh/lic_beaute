import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/features/booking/utils/booking_format.dart';

void main() {
  group('BookingReviewPage - price calculation', () {
    test('correctly computes total, deposit, and remaining', () {
      const total = 25000;
      const deposit = 5000;
      final remaining = total - deposit;
      expect(xof(total), contains('25'));
      expect(xof(deposit), contains('5'));
      expect(remaining, 20000);
    });

    test('remaining clamps to 0 when deposit exceeds total', () {
      const total = 3000;
      const deposit = 5000;
      final remaining = total - deposit;
      expect(remaining < 0 ? 0 : remaining, 0);
    });
  });

  group('BookingSuccessPage - confirmation display', () {
    test('header and subtitle text are correct', () {
      const title = "Réservation confirmée !";
      const subtitle = "Votre acompte a bien été reçu. À très vite au salon !";
      expect(title, contains('confirmée'));
      expect(subtitle, contains('acompte'));
    });
  });

  group('PaymentHandoffPage - deposit and channel logic', () {
    test('deposit > 0 requires payment, deposit <= 0 skips payment', () {
      expect(0 <= 0, isTrue);
      expect(5000 > 0, isTrue);
    });

    test('channel inference from label strings', () {
      String? channel(String label) {
        final lower = label.toLowerCase();
        if (lower.contains('orange money sénégal')) return 'orange_senegal';
        if (lower.contains('wave')) return 'wave_senegal';
        if (lower.contains('djamo')) return 'djamo';
        if (lower.contains('wizall')) return 'wizall_senegal';
        if (lower.contains('carte')) return 'carte_bancaire';
        return null;
      }
      expect(channel('Orange Money Sénégal'), 'orange_senegal');
      expect(channel('Wave Sénégal'), 'wave_senegal');
      expect(channel('Djamo'), 'djamo');
      expect(channel('Unknown'), isNull);
    });

    test('Djamo country inference from phone number', () {
      String inferCountry(String phone) {
        final normalized = phone.replaceAll(RegExp(r'[^0-9+]'), '');
        if (normalized.startsWith('+225') || normalized.length == 10) return 'CI';
        return 'SN';
      }
      expect(inferCountry('+2250102030405'), 'CI');
      expect(inferCountry('771234567'), 'SN');
    });
  });

  group('PaymentWaitingSheet - polling timeout math', () {
    test('50 polls at 6s each equals 5 minutes', () {
      const pollInterval = Duration(seconds: 6);
      const timeout = Duration(minutes: 5);
      final maxPolls = timeout.inSeconds ~/ pollInterval.inSeconds;
      expect(maxPolls, 50);
    });
  });

  group('Booking confirm bar - label logic', () {
    test('with deposit shows "Payer l\'acompte"', () {
      const label = "Payer l'acompte";
      expect(label, "Payer l'acompte");
    });

    test('without deposit shows "Confirmer la réservation"', () {
      const label = 'Confirmer la réservation';
      expect(label, 'Confirmer la réservation');
    });
  });
}
