import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client_provider.dart';
import '../../../core/session/session_store.dart';
import 'booking_funnel_provider.dart';

// ── Create booking ────────────────────────────────────────────────────────

class BookingCreateNotifier extends AsyncNotifier<BookingSummary?> {
  @override
  Future<BookingSummary?> build() async => null;

  Future<BookingSummary?> create() async {
    final funnel = ref.read(bookingFunnelProvider);
    if (!funnel.canReview) return null;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api = ref.read(apiClientProvider).getBookingsApi();
      final startsAt = DateTime.parse('${funnel.slotDate!}T${funnel.slotTime!}:00');
      final response = await api.apiV1BookingsPost(
        bookingCreateInput: BookingCreateInput((b) => b
          ..salonId = funnel.salonId!
          ..serviceId = funnel.serviceId!
          ..employeeId = funnel.employeeId
          ..startsAt = startsAt),
      );
      return response.data;
    });
    return state.valueOrNull;
  }
}

final bookingCreateProvider =
    AsyncNotifierProvider<BookingCreateNotifier, BookingSummary?>(
        BookingCreateNotifier.new);

// ── Initiate deposit payment ──────────────────────────────────────────────

class PaymentInitiateNotifier extends AsyncNotifier<Map<String, dynamic>?> {
  @override
  Future<Map<String, dynamic>?> build() async => null;

  Future<String?> initiate({required String bookingId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dio = ref.read(dioProvider);
      final response = await dio.post<Map<String, dynamic>>(
        '/api/v1/payments/deposits/initiate',
        data: {'bookingId': bookingId},
      );
      return response.data;
    });
    return state.valueOrNull?['paymentUrl'] as String?;
  }
}

final paymentInitiateProvider =
    AsyncNotifierProvider<PaymentInitiateNotifier, Map<String, dynamic>?>(
        PaymentInitiateNotifier.new);
