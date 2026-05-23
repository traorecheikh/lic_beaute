import 'dart:io';

import 'package:beauteavenue_mobile_client/src/core/network/app_network_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppNetworkError', () {
    DioException badResponse({
      int? statusCode,
      Object? data,
    }) {
      final requestOptions = RequestOptions(path: '/v1/test');
      return DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response<Object?>(
          requestOptions: requestOptions,
          statusCode: statusCode,
          data: data,
        ),
      );
    }

    test('marks offline and timeout errors as offline-like', () {
      const offline = AppNetworkError(
        type: AppNetworkErrorType.offline,
        title: 'Offline',
        message: 'offline',
      );
      const timeout = AppNetworkError(
        type: AppNetworkErrorType.timeout,
        title: 'Timeout',
        message: 'timeout',
      );
      const server = AppNetworkError(
        type: AppNetworkErrorType.server,
        title: 'Server',
        message: 'server',
      );

      expect(offline.isOfflineLike, isTrue);
      expect(timeout.isOfflineLike, isTrue);
      expect(server.isOfflineLike, isFalse);
    });

    test('maps SocketException to offline error', () {
      final result = resolveAppNetworkError(
        const SocketException('no internet'),
        isOnline: true,
        offlineTitle: 'Hors ligne',
        serverTitle: 'Serveur indisponible',
        fallbackTitle: 'Erreur',
      );

      expect(result.type, AppNetworkErrorType.offline);
      expect(result.title, 'Hors ligne');
      expect(
        result.message,
        'Votre appareil ne parvient pas à joindre Internet.',
      );
    });

    test('maps timeout Dio exceptions to timeout error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/v1/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = resolveAppNetworkError(
        error,
        isOnline: true,
        offlineTitle: 'Hors ligne',
        serverTitle: 'Serveur indisponible',
        fallbackTitle: 'Erreur',
      );

      expect(result.type, AppNetworkErrorType.timeout);
      expect(result.title, 'Erreur');
      expect(
        result.message,
        'La connexion est trop lente pour terminer le chargement.',
      );
    });

    test('maps connection error Dio exceptions to offline error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/v1/test'),
        type: DioExceptionType.connectionError,
      );

      final result = resolveAppNetworkError(
        error,
        isOnline: true,
        offlineTitle: 'Hors ligne',
        serverTitle: 'Serveur indisponible',
        fallbackTitle: 'Erreur',
      );

      expect(result.type, AppNetworkErrorType.offline);
      expect(result.title, 'Hors ligne');
    });

    test('maps 401/403 responses to unauthorized error', () {
      final result = resolveAppNetworkError(
        badResponse(statusCode: 401),
        isOnline: true,
        offlineTitle: 'Hors ligne',
        serverTitle: 'Serveur indisponible',
        fallbackTitle: 'Erreur',
      );

      expect(result.type, AppNetworkErrorType.unauthorized);
      expect(result.title, 'Session expirée');
      expect(result.message, 'Reconnectez-vous pour continuer.');
    });

    test('maps 5xx responses to server error', () {
      final result = resolveAppNetworkError(
        badResponse(statusCode: 503),
        isOnline: true,
        offlineTitle: 'Hors ligne',
        serverTitle: 'Serveur indisponible',
        fallbackTitle: 'Erreur',
      );

      expect(result.type, AppNetworkErrorType.server);
      expect(result.title, 'Serveur indisponible');
      expect(result.message, 'Nos services rencontrent un problème temporaire.');
    });

    test('maps bad response API message when available', () {
      final result = resolveAppNetworkError(
        badResponse(
          statusCode: 422,
          data: <String, dynamic>{'message': '  Message API précis  '},
        ),
        isOnline: true,
        offlineTitle: 'Hors ligne',
        serverTitle: 'Serveur indisponible',
        fallbackTitle: 'Erreur',
      );

      expect(result.type, AppNetworkErrorType.unknown);
      expect(result.title, 'Erreur');
      expect(result.message, 'Message API précis');
    });

    test('maps non-dio errors to offline when current network is offline', () {
      final result = resolveAppNetworkError(
        Exception('random'),
        isOnline: false,
        offlineTitle: 'Hors ligne',
        serverTitle: 'Serveur indisponible',
        fallbackTitle: 'Erreur',
      );

      expect(result.type, AppNetworkErrorType.offline);
      expect(result.title, 'Hors ligne');
      expect(result.message, 'Vérifiez votre connexion puis réessayez.');
    });

    test('maps unknown errors to fallback message when online', () {
      final result = resolveAppNetworkError(
        Exception('random'),
        isOnline: true,
        offlineTitle: 'Hors ligne',
        serverTitle: 'Serveur indisponible',
        fallbackTitle: 'Erreur',
      );

      expect(result.type, AppNetworkErrorType.unknown);
      expect(result.title, 'Erreur');
      expect(result.message, 'Une erreur est survenue pendant le chargement.');
    });

    test('extractApiMessage returns trimmed message from known payload shape', () {
      expect(
        extractApiMessage(<String, dynamic>{'message': '  hello  '}),
        'hello',
      );
    });

    test('extractApiMessage returns null for unsupported payloads', () {
      expect(extractApiMessage(<String, dynamic>{'message': ''}), isNull);
      expect(extractApiMessage(<String, dynamic>{'message': null}), isNull);
      expect(extractApiMessage(<String, dynamic>{'message': 12}), isNull);
      expect(extractApiMessage('plain text body'), isNull);
    });
  });
}
