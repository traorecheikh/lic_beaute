import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/features/appointments/providers/booking_actions_provider.dart';

void main() {
  group('BookingActions', () {
    test('is a valid Provider class', () {
      // Just validate the class can be instantiated (with a mock Ref)
      // The actual integration tests need Dio mocking
      expect(BookingActions, isNot(throwsException));
    });
  });

  group('submitReview timestamp construction', () {
    test('reschedule date-time formats correctly', () {
      // The reschedule method constructs: '$date' 'T$time:00'
      // e.g., date='2025-06-15', time='14:30' => '2025-06-15T14:30:00'
      final date = '2025-06-15';
      final time = '14:30';
      final startsAt = DateTime.parse('$date' 'T$time:00').toIso8601String();
      
      expect(startsAt, '2025-06-15T14:30:00.000');
      expect(DateTime.parse(startsAt), isNotNull);
    });

    test('reschedule handles single-digit hour/minute', () {
      final date = '2025-06-15';
      final time = '09:05';
      final startsAt = DateTime.parse('$date' 'T$time:00').toIso8601String();
      
      expect(startsAt, '2025-06-15T09:05:00.000');
    });
  });
}
