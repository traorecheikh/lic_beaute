import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_store.dart';
import 'bookings_list_provider.dart';

final bookingActionsProvider = Provider<BookingActions>(
  (ref) => BookingActions(ref),
);

class BookingActions {
  BookingActions(this._ref);

  final Ref _ref;

  Future<void> cancel(String bookingId) async {
    final dio = _ref.read(dioProvider);
    await dio.post('/api/v1/bookings/$bookingId/cancel');
    _ref.invalidate(bookingsListProvider);
    _ref.invalidate(bookingDetailProvider(bookingId));
  }

  Future<void> reschedule({
    required String bookingId,
    required String date,
    required String time,
  }) async {
    final dio = _ref.read(dioProvider);
    await dio.post(
      '/api/v1/bookings/$bookingId/reschedule',
      data: {'date': date, 'time': time},
    );
    _ref.invalidate(bookingsListProvider);
    _ref.invalidate(bookingDetailProvider(bookingId));
  }

  Future<void> submitReview({
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    final dio = _ref.read(dioProvider);
    await dio.post(
      '/api/v1/bookings/$bookingId/review',
      data: {'rating': rating, if (comment != null) 'comment': comment},
    );
    _ref.invalidate(bookingDetailProvider(bookingId));
  }
}
