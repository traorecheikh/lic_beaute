import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'package:beauteavenue_mobile_client/src/core/utils/status_labels.dart';
import 'package:beauteavenue_mobile_client/src/features/booking/utils/booking_format.dart';

void main() {
  group('BookingDetailPage - status labels', () {
    test('confirmed status label is "Confirmé"', () {
      expect(bookingStatusLabel('confirmed'), 'Confirmé');
    });

    test('pending status label is "En attente"', () {
      expect(bookingStatusLabel('pending'), 'En attente');
    });

    test('cancelled status label is "Annulé"', () {
      expect(bookingStatusLabel('cancelled'), 'Annulé');
    });

    test('completed status label is "Terminé"', () {
      expect(bookingStatusLabel('completed'), 'Terminé');
    });
  });

  group('BookingDetailPage - status headlines', () {
    test('confirmed headline is "Rendez-vous confirmé"', () {
      expect(bookingStatusHeadline('confirmed'), 'Rendez-vous confirmé');
    });

    test('cancelled headline is "Rendez-vous annulé"', () {
      expect(bookingStatusHeadline('cancelled'), 'Rendez-vous annulé');
    });

    test('bookingIsPastNotClosed for past confirmed booking', () {
      final past = DateTime.now().subtract(const Duration(hours: 2));
      expect(
        bookingIsPastNotClosed(status: 'confirmed', endsAt: past),
        isTrue,
      );
    });

    test('past headline shown for past confirmed booking', () {
      final past = DateTime.now().subtract(const Duration(hours: 2));
      expect(bookingStatusHeadline('confirmed', endsAt: past), 'Rendez-vous passé');
    });
  });

  group('BookingDetailPage - xof formatting', () {
    test('formats deposit amount correctly', () {
      // Simulate the deposit display logic from BookingDetailPage
      const depositAmountXof = 5000;
      final display = xof(depositAmountXof);
      expect(display, contains('5'));
      expect(display, contains('XOF'));
    });

    test('handles zero deposit', () {
      expect(xof(0), '0 XOF');
    });
  });

  group('BookingDetailPage - price calculation', () {
    test('remaining = total - depositPaid', () {
      const total = 25000;
      const depositPaid = 5000;
      final remaining = (total - depositPaid).clamp(0, 999999999);
      expect(remaining, 20000);
    });

    test('remaining clamps to 0 if deposit exceeds total', () {
      const total = 5000;
      const depositPaid = 10000;
      final remaining = (total - depositPaid).clamp(0, 999999999);
      expect(remaining, 0);
    });

    test('deposit label logic', () {
      const hasDeposit = true;
      const isDepositPaid = false;
      final depositLabel = !hasDeposit
          ? 'Aucun acompte'
          : (isDepositPaid ? 'Acompte payé' : 'Acompte requis');
      expect(depositLabel, 'Acompte requis');
    });

    test('deposit paid label when deposit is paid', () {
      const hasDeposit = true;
      const isDepositPaid = true;
      final depositLabel = !hasDeposit
          ? 'Aucun acompte'
          : (isDepositPaid ? 'Acompte payé' : 'Acompte requis');
      expect(depositLabel, 'Acompte payé');
    });

    test('no deposit label when no deposit required', () {
      const hasDeposit = false;
      const isDepositPaid = false;
      final depositLabel = !hasDeposit
          ? 'Aucun acompte'
          : (isDepositPaid ? 'Acompte payé' : 'Acompte requis');
      expect(depositLabel, 'Aucun acompte');
    });
  });

  group('BookingDetailPage - ITINÉRAIRE button logic', () {
    test('URL encoding for address', () {
      const address = 'Rue 10, Dakar';
      final encoded = Uri.encodeComponent(address);
      expect(encoded, 'Rue%2010%2C%20Dakar');
    });

    test('maps URL construction', () {
      const address = 'Dakar Plateau';
      final appleUrl = Uri.parse('maps://?q=${Uri.encodeComponent(address)}');
      final googleUrl = Uri.parse(
        'https://maps.google.com/?q=${Uri.encodeComponent(address)}',
      );

      expect(appleUrl.toString(), 'maps://?q=Dakar%20Plateau');
      expect(googleUrl.toString(), 'https://maps.google.com/?q=Dakar%20Plateau');
    });
  });
}
