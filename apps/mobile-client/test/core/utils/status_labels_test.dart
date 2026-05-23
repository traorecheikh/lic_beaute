import 'package:beauteavenue_mobile_client/src/core/utils/status_labels.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('bookingIsPastNotClosed', () {
    final now = DateTime(2026, 1, 1, 12, 0, 0);
    final past = now.subtract(const Duration(hours: 2));
    final future = now.add(const Duration(hours: 2));

    test('returns false when no end date is provided', () {
      expect(
        bookingIsPastNotClosed(status: 'confirmed', endsAt: null, now: now),
        isFalse,
      );
    });

    test('returns false for future bookings', () {
      expect(
        bookingIsPastNotClosed(
          status: 'confirmed',
          endsAt: future,
          now: now,
        ),
        isFalse,
      );
    });

    test('returns true for past bookings that are not closed', () {
      expect(
        bookingIsPastNotClosed(status: 'confirmed', endsAt: past, now: now),
        isTrue,
      );
      expect(
        bookingIsPastNotClosed(status: 'pending', endsAt: past, now: now),
        isTrue,
      );
      expect(
        bookingIsPastNotClosed(status: 'in_progress', endsAt: past, now: now),
        isTrue,
      );
    });

    test('returns false for past bookings already closed', () {
      expect(
        bookingIsPastNotClosed(status: 'completed', endsAt: past, now: now),
        isFalse,
      );
      expect(
        bookingIsPastNotClosed(status: 'cancelled', endsAt: past, now: now),
        isFalse,
      );
    });
  });

  group('bookingStatusLabel', () {
    final now = DateTime(2026, 1, 1, 12, 0, 0);
    final past = now.subtract(const Duration(hours: 1));

    test('returns Passé for past bookings not closed', () {
      expect(bookingStatusLabel('pending', endsAt: past), 'Passé');
    });

    test('maps known states', () {
      expect(bookingStatusLabel('confirmed'), 'Confirmé');
      expect(bookingStatusLabel('pending'), 'En attente');
      expect(bookingStatusLabel('in_progress'), 'En cours');
      expect(bookingStatusLabel('completed'), 'Terminé');
      expect(bookingStatusLabel('cancelled'), 'Annulé');
    });

    test('falls back to En attente for unknown status', () {
      expect(bookingStatusLabel('unknown_status'), 'En attente');
    });
  });

  group('bookingStatusHeadline', () {
    final past = DateTime.now().subtract(const Duration(hours: 3));

    test('returns past headline for expired active bookings', () {
      expect(
        bookingStatusHeadline('confirmed', endsAt: past),
        'Rendez-vous passé',
      );
    });

    test('maps known states to detailed headlines', () {
      expect(bookingStatusHeadline('confirmed'), 'Rendez-vous confirmé');
      expect(bookingStatusHeadline('in_progress'), 'Rendez-vous en cours');
      expect(bookingStatusHeadline('completed'), 'Rendez-vous terminé');
      expect(bookingStatusHeadline('cancelled'), 'Rendez-vous annulé');
    });

    test('falls back for unknown status', () {
      expect(
        bookingStatusHeadline('unknown_status'),
        'En attente de confirmation',
      );
    });
  });
}
