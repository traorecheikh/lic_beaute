import 'dart:async';

import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_client_provider.dart';
import '../../../core/network/app_network_error.dart';
import '../../../core/services/foreground_notification_service.dart';
import '../../../core/session/session_store.dart';
import '../../appointments/providers/bookings_list_provider.dart';
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

  Future<String?> reconcile(String paymentId) async {
    final dio = ref.read(dioProvider);
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/payments/$paymentId/reconcile',
      data: const {},
    );
    return response.data?['status'] as String?;
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

// ── Background polling (survives widget disposal) ─────────────────────────

enum BackgroundPollingStatus { idle, active, exhausted }

class BackgroundPollingService extends Notifier<BackgroundPollingStatus> {
  Timer? _timer;
  int _attempts = 0;
  String? _paymentId;
  String? _bookingId;
  static const _maxAttempts = 3;
  static const _interval = Duration(minutes: 15);

  @override
  BackgroundPollingStatus build() {
    ref.onDispose(() => _timer?.cancel());
    return BackgroundPollingStatus.idle;
  }

  /// Starts background polling. Shows local notifications on
  /// success/exhaustion independently of any widget lifecycle.
  void start({
    required String paymentId,
    required String bookingId,
  }) {
    _timer?.cancel();
    _paymentId = paymentId;
    _bookingId = bookingId;
    _attempts = 0;
    state = BackgroundPollingStatus.active;
    _scheduleNext();
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _paymentId = null;
    _bookingId = null;
    _attempts = 0;
    state = BackgroundPollingStatus.idle;
  }

  void _scheduleNext() {
    _timer?.cancel();
    _timer = Timer(_interval, _runCheck);
  }

  Future<void> _runCheck() async {
    final paymentId = _paymentId;
    final bookingId = _bookingId;
    if (paymentId == null || bookingId == null) return;

    _attempts++;
    try {
      final status = await ref
          .read(paymentInitiateProvider.notifier)
          .reconcile(paymentId);

      if (status == 'succeeded') {
        ref.invalidate(bookingDetailResourceProvider(bookingId));
        _showNotification(
          id: 0,
          title: AppStrings.paymentConfirmedNotifTitle,
          body: AppStrings.paymentConfirmedNotifBody,
          payload: 'type=payment_confirmed&bookingId=$bookingId',
        );
        state = BackgroundPollingStatus.idle;
        return;
      }

      if (status == 'failed' || status == 'refunded') {
        if (_attempts >= _maxAttempts) {
          _exhausted(bookingId);
          return;
        }
        _scheduleNext();
        return;
      }

      if (_attempts >= _maxAttempts) {
        _exhausted(bookingId);
        return;
      }

      _scheduleNext();
    } catch (_) {
      if (_attempts >= _maxAttempts) {
        _exhausted(bookingId);
      } else {
        _scheduleNext();
      }
    }
  }

  void _exhausted(String bookingId) {
    _timer?.cancel();
    _timer = null;
    state = BackgroundPollingStatus.exhausted;
    _showNotification(
      id: 1,
      title: AppStrings.paymentCheckFailedTitle,
      body: AppStrings.paymentCheckFailedSubtitle,
      payload: 'type=payment_failed&bookingId=$bookingId',
    );
  }

  void _showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) {
    ForegroundNotificationService.plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'Beauté Avenue',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }
}

final backgroundPollingProvider = NotifierProvider<BackgroundPollingService, BackgroundPollingStatus>(
  BackgroundPollingService.new,
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
