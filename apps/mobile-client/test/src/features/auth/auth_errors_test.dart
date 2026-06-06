import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/features/auth/utils/auth_errors.dart';

DioException _dioError({
  int? statusCode,
  Map<String, dynamic>? data,
  DioExceptionType type = DioExceptionType.badResponse,
}) {
  return DioException(
    type: type,
    requestOptions: RequestOptions(path: '/api/v1/auth'),
    response: Response(
      statusCode: statusCode,
      requestOptions: RequestOptions(path: '/api/v1/auth'),
      data: data,
    ),
  );
}

void main() {
  group('parseDioAuthError', () {
    test('returns API message when present in response data', () {
      final error = _dioError(data: {'message': 'Email déjà utilisé.'});
      expect(parseDioAuthError(error, 'Erreur inconnue'), 'Email déjà utilisé.');
    });

    test('returns fallback when no message in response', () {
      final error = _dioError(data: {});
      expect(parseDioAuthError(error, 'Erreur inconnue'), 'Erreur inconnue');
    });

    test('returns fallback when no response data', () {
      final error = _dioError();
      expect(parseDioAuthError(error, 'Erreur inconnue'), 'Erreur inconnue');
    });

    test('returns fallback for non-Map response data', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/api/v1/auth'),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: '/api/v1/auth'),
          data: 'just a string',
        ),
      );
      expect(parseDioAuthError(error, 'Erreur inconnue'), 'Erreur inconnue');
    });
  });

  group('parseOtpError', () {
    test('returns rate limited message for otp_rate_limited code', () {
      final error = _dioError(data: {'code': 'otp_rate_limited'});
      expect(
        parseOtpError(error, 'Erreur inconnue'),
        'Trop de tentatives. Réessayez dans quelques minutes.',
      );
    });

    test('returns invalid phone message for invalid_phone code', () {
      final error = _dioError(data: {'code': 'invalid_phone'});
      expect(
        parseOtpError(error, 'Erreur inconnue'),
        'Numéro de téléphone invalide.',
      );
    });

    test('returns expired code message for otp_expired code', () {
      final error = _dioError(data: {'code': 'otp_expired'});
      expect(
        parseOtpError(error, 'Erreur inconnue'),
        'Code expiré. Demandez un nouveau code.',
      );
    });

    test('returns invalid OTP message for invalid_otp code', () {
      final error = _dioError(data: {'code': 'invalid_otp'});
      expect(
        parseOtpError(error, 'Erreur inconnue'),
        'Code incorrect. Vérifiez et réessayez.',
      );
    });

    test('falls back to parseDioAuthError for unknown codes', () {
      final error = _dioError(data: {'message': 'Erreur serveur.'});
      expect(
        parseOtpError(error, 'Erreur inconnue'),
        'Erreur serveur.',
      );
    });

    test('falls back for non-Map response data in parseOtpError', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/api/v1/auth'),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: '/api/v1/auth'),
          data: 'string data',
        ),
      );
      expect(
        parseOtpError(error, 'Fallback message'),
        'Fallback message',
      );
    });

    test('falls back to fallback when no response data at all', () {
      final error = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/api/v1/auth'),
      );
      expect(
        parseOtpError(error, 'Fallback OTP'),
        'Fallback OTP',
      );
    });
  });

  group('ClientOnlyAuthException', () {
    test('stores and displays message', () {
      final exception = ClientOnlyAuthException(
        'Ce compte professionnel ne peut pas utiliser l\'application cliente.',
      );
      expect(
        exception.message,
        "Ce compte professionnel ne peut pas utiliser l'application cliente.",
      );
      expect(
        exception.toString(),
        "Ce compte professionnel ne peut pas utiliser l'application cliente.",
      );
    });
  });
}
