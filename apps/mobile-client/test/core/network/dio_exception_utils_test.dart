import 'package:beauteavenue_mobile_client/src/core/network/dio_exception_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isConnectionLikeDioException', () {
    DioException makeError(DioExceptionType type) {
      return DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: type,
      );
    }

    test('returns true for connection-like failures', () {
      expect(
        isConnectionLikeDioException(makeError(DioExceptionType.connectionError)),
        isTrue,
      );
      expect(
        isConnectionLikeDioException(makeError(DioExceptionType.connectionTimeout)),
        isTrue,
      );
      expect(
        isConnectionLikeDioException(makeError(DioExceptionType.sendTimeout)),
        isTrue,
      );
      expect(
        isConnectionLikeDioException(makeError(DioExceptionType.receiveTimeout)),
        isTrue,
      );
    });

    test('returns false for non connection-like failures', () {
      expect(
        isConnectionLikeDioException(makeError(DioExceptionType.badResponse)),
        isFalse,
      );
      expect(
        isConnectionLikeDioException(makeError(DioExceptionType.cancel)),
        isFalse,
      );
      expect(
        isConnectionLikeDioException(makeError(DioExceptionType.badCertificate)),
        isFalse,
      );
      expect(
        isConnectionLikeDioException(makeError(DioExceptionType.unknown)),
        isFalse,
      );
    });
  });
}
