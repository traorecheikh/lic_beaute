import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';

/// tests for BookingsApi
void main() {
  final instance = BeauteavenueApi().getBookingsApi();

  group(BookingsApi, () {
    // List bookings
    //
    //Future<BookingSummaryListResponse> apiV1BookingsGet() async
    test('test apiV1BookingsGet', () async {
      // TODO
    });

    // Create booking
    //
    //Future<BookingSummary> apiV1BookingsPost(BookingCreateInput bookingCreateInput) async
    test('test apiV1BookingsPost', () async {
      // TODO
    });
  });
}
