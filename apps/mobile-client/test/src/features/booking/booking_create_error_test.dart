import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/features/booking/providers/booking_create_provider.dart';

Map<String, dynamic> _responseData(String? message) {
  return message != null ? {'message': message} : {};
}

DioException _dioError({
  int? statusCode,
  DioExceptionType type = DioExceptionType.badResponse,
  Map<String, dynamic>? data,
}) {
  return DioException(
    type: type,
    requestOptions: RequestOptions(path: '/api/v1/bookings'),
    response: Response(
      statusCode: statusCode,
      requestOptions: RequestOptions(path: '/api/v1/bookings'),
      data: data ?? {},
    ),
  );
}

void main() {
  group('bookingCreateErrorMessage', () {
    test('returns session expired message for 401', () {
      final error = _dioError(statusCode: 401);
      expect(
        bookingCreateErrorMessage(error),
        'Votre session a expiré. Reconnectez-vous pour continuer.',
      );
    });

    test('returns session expired message for 403', () {
      final error = _dioError(statusCode: 403);
      expect(
        bookingCreateErrorMessage(error),
        'Votre session a expiré. Reconnectez-vous pour continuer.',
      );
    });

    test('returns API message when present in response data', () {
      final error = _dioError(
        statusCode: 422,
        data: {'message': 'Créneau déjà réservé.'},
      );
      expect(bookingCreateErrorMessage(error), 'Créneau déjà réservé.');
    });

    test('prefers API message over default error for 400 with message', () {
      final error = _dioError(
        statusCode: 400,
        data: {'message': 'Service indisponible à cette heure.'},
      );
      expect(
        bookingCreateErrorMessage(error),
        'Service indisponible à cette heure.',
      );
    });

    test('returns connection timeout message', () {
      final error = _dioError(type: DioExceptionType.connectionTimeout);
      expect(
        bookingCreateErrorMessage(error),
        'La connexion est trop lente. Réessayez.',
      );
    });

    test('returns send timeout message', () {
      final error = _dioError(type: DioExceptionType.sendTimeout);
      expect(
        bookingCreateErrorMessage(error),
        'La connexion est trop lente. Réessayez.',
      );
    });

    test('returns receive timeout message', () {
      final error = _dioError(type: DioExceptionType.receiveTimeout);
      expect(
        bookingCreateErrorMessage(error),
        'La connexion est trop lente. Réessayez.',
      );
    });

    test('returns connection error message', () {
      final error = _dioError(type: DioExceptionType.connectionError);
      expect(
        bookingCreateErrorMessage(error),
        'Connexion indisponible. Vérifiez votre réseau puis réessayez.',
      );
    });

    test('returns server error message for 5xx', () {
      final error = _dioError(statusCode: 503);
      expect(
        bookingCreateErrorMessage(error),
        'Nos services rencontrent un problème temporaire.',
      );
    });

    test('returns fallback for unknown status code 409', () {
      final error = _dioError(statusCode: 409);
      expect(
        bookingCreateErrorMessage(error),
        'Impossible de confirmer la réservation pour le moment.',
      );
    });

    test('returns fallback for non-DioException errors', () {
      expect(
        bookingCreateErrorMessage('some string error'),
        'Impossible de confirmer la réservation pour le moment.',
      );
    });

    test('returns fallback for DioException cancel type', () {
      final error = _dioError(type: DioExceptionType.cancel);
      expect(
        bookingCreateErrorMessage(error),
        'Impossible de confirmer la réservation pour le moment.',
      );
    });

    test('returns fallback when response data has no message', () {
      final error = _dioError(
        statusCode: 400,
        data: {'other': 'no message here'},
      );
      expect(
        bookingCreateErrorMessage(error),
        'Impossible de confirmer la réservation pour le moment.',
      );
    });
  });
}
