import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client_provider.dart';
import '../../../core/network/app_network_error.dart';
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
      final startsAt = DateTime.parse(funnel.slotStartsAtIso!);
      final response = await api.apiV1BookingsPost(
        bookingCreateInput: BookingCreateInput(
          (b) => b
            ..salonId = funnel.salonId!
            ..serviceId = funnel.serviceId!
            ..employeeId = funnel.employeeId
            ..startsAt = startsAt,
        ),
      );
      return response.data;
    });
    return state.asData?.value;
  }
}

final bookingCreateProvider =
    AsyncNotifierProvider<BookingCreateNotifier, BookingSummary?>(
      BookingCreateNotifier.new,
    );

// ── Initiate deposit payment ──────────────────────────────────────────────

class PaymentInitiateNotifier extends AsyncNotifier<Map<String, dynamic>?> {
  @override
  Future<Map<String, dynamic>?> build() async => null;

  Future<Map<String, dynamic>?> initiate({
    required String bookingId,
    required String channel,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dio = ref.read(dioProvider);
      final response = await dio.post<Map<String, dynamic>>(
        '/api/v1/payments/deposits/initiate',
        data: {
          'bookingId': bookingId,
          'provider': 'paydunya',
          'channel': channel,
        },
      );
      return response.data;
    });
    return state.asData?.value;
  }

  Future<void> reconcile(String paymentId) async {
    final dio = ref.read(dioProvider);
    await dio.post('/api/v1/payments/$paymentId/reconcile', data: const {});
  }

  Future<Map<String, dynamic>?> execute({
    required String paymentId,
    required String method,
    Map<String, dynamic>? details,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dio = ref.read(dioProvider);
      final response = await dio.post<Map<String, dynamic>>(
        '/api/v1/payments/deposits/execute',
        data: {
          'paymentId': paymentId,
          'method': method,
          if (details != null) 'details': details,
        },
      );
      return response.data;
    });
    return state.asData?.value;
  }
}

final paymentInitiateProvider =
    AsyncNotifierProvider<PaymentInitiateNotifier, Map<String, dynamic>?>(
      PaymentInitiateNotifier.new,
    );

String bookingCreateErrorMessage(Object? error) {
  if (error is DioException) {
    final statusCode = error.response?.statusCode;
    final apiMessage = extractApiMessage(error.response?.data);

    if (statusCode == 401 || statusCode == 403) {
      return 'Votre session a expiré. Reconnectez-vous pour continuer.';
    }
    if (apiMessage != null) {
      return apiMessage;
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'La connexion est trop lente. Réessayez.';
      case DioExceptionType.connectionError:
        return 'Connexion indisponible. Vérifiez votre réseau puis réessayez.';
      case DioExceptionType.badResponse:
        if (statusCode != null && statusCode >= 500) {
          return 'Nos services rencontrent un problème temporaire.';
        }
        break;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        break;
    }
  }

  return 'Impossible de confirmer la réservation pour le moment.';
}
