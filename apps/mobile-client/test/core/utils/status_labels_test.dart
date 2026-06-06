import 'package:beauteavenue_mobile_client/src/core/utils/status_labels.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('bookingIsPastNotClosed', () {
    test('returns false when no end date is provided', () {
      expect(
        bookingIsPastNotClosed(status: 'confirmed', endsAt: null),
        isFalse,
      );
    });

    test('returns false for future bookings', () {
      final future = DateTime.now().add(const Duration(days: 1));
      expect(
        bookingIsPastNotClosed(status: 'confirmed', endsAt: future),
        isFalse,
      );
    });

    test('returns true for past bookings that are not closed', () {
      final past = DateTime.now().subtract(const Duration(hours: 2));
      expect(
        bookingIsPastNotClosed(status: 'confirmed', endsAt: past),
        isTrue,
      );
    });

    test('returns false for past bookings already closed', () {
      final past = DateTime.now().subtract(const Duration(hours: 2));
      expect(
        bookingIsPastNotClosed(status: 'completed', endsAt: past),
        isFalse,
      );
    });

    test('returns false for cancelled past bookings', () {
      final past = DateTime.now().subtract(const Duration(hours: 2));
      expect(
        bookingIsPastNotClosed(status: 'cancelled', endsAt: past),
        isFalse,
      );
    });

    test('returns false for pending booking that ended', () {
      final past = DateTime.now().subtract(const Duration(hours: 2));
      expect(
        bookingIsPastNotClosed(status: 'pending', endsAt: past),
        isTrue,
      );
    });

    test('returns true for in_progress past booking', () {
      final past = DateTime.now().subtract(const Duration(hours: 2));
      expect(
        bookingIsPastNotClosed(status: 'in_progress', endsAt: past),
        isTrue,
      );
    });

    test('allows custom now parameter', () {
      final customNow = DateTime(2025, 6, 15, 14, 0);
      final endsAt = DateTime(2025, 6, 15, 13, 0);
      expect(
        bookingIsPastNotClosed(status: 'confirmed', endsAt: endsAt, now: customNow),
        isTrue,
      );
    });
  });

  group('bookingStatusLabel', () {
    test('returns Passé for past bookings not closed', () {
      final past = DateTime.now().subtract(const Duration(hours: 2));
      expect(bookingStatusLabel('confirmed', endsAt: past), 'Passé');
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
    test('returns past headline for expired active bookings', () {
      final past = DateTime.now().subtract(const Duration(hours: 2));
      expect(bookingStatusHeadline('confirmed', endsAt: past), 'Rendez-vous passé');
    });

    test('maps known states to detailed headlines', () {
      expect(bookingStatusHeadline('confirmed'), 'Rendez-vous confirmé');
      expect(bookingStatusHeadline('in_progress'), 'Rendez-vous en cours');
      expect(bookingStatusHeadline('completed'), 'Rendez-vous terminé');
      expect(bookingStatusHeadline('cancelled'), 'Rendez-vous annulé');
    });

    test('falls back for unknown status', () {
      expect(bookingStatusHeadline('unknown'), 'En attente de confirmation');
    });

    test('returns pending headline for pending status', () {
      expect(bookingStatusHeadline('pending'), 'En attente de confirmation');
    });
  });
}
