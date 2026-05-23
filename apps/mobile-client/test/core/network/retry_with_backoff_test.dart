import 'dart:io';

import 'package:beauteavenue_mobile_client/src/core/network/retry_with_backoff.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('retryWithBackoff', () {
    DioException dioError(DioExceptionType type) {
      return DioException(
        requestOptions: RequestOptions(path: '/v1/test'),
        type: type,
        error: type == DioExceptionType.connectionError
            ? const SocketException('offline')
            : null,
      );
    }

    test('retries connection failures and eventually succeeds', () async {
      var attempts = 0;

      final result = await retryWithBackoff<String>(
        () async {
          attempts += 1;
          if (attempts < 3) {
            throw dioError(DioExceptionType.connectionError);
          }
          return 'ok';
        },
        maxAttempts: 3,
        initialDelay: Duration.zero,
      );

      expect(result, 'ok');
      expect(attempts, 3);
    });

    test('does not retry non retryable Dio errors', () async {
      var attempts = 0;

      await expectLater(
        () => retryWithBackoff<void>(
          () async {
            attempts += 1;
            throw dioError(DioExceptionType.badResponse);
          },
          maxAttempts: 3,
          initialDelay: Duration.zero,
        ),
        throwsA(isA<DioException>()),
      );

      expect(attempts, 1);
    });

    test('rethrows retryable errors when attempts are exhausted', () async {
      var attempts = 0;

      await expectLater(
        () => retryWithBackoff<void>(
          () async {
            attempts += 1;
            throw dioError(DioExceptionType.connectionTimeout);
          },
          maxAttempts: 2,
          initialDelay: Duration.zero,
        ),
        throwsA(isA<DioException>()),
      );

      expect(attempts, 2);
    });
  });
}
