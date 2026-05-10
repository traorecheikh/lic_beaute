import 'package:dio/dio.dart';

import 'dio_exception_utils.dart';

Future<T> retryWithBackoff<T>(
  Future<T> Function() run, {
  int maxAttempts = 3,
  Duration initialDelay = const Duration(milliseconds: 900),
}) async {
  Object? lastError;
  StackTrace? lastStack;

  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await run();
    } on DioException catch (error, stack) {
      lastError = error;
      lastStack = stack;
      final isRetryable = isConnectionLikeDioException(error);
      final hasMoreAttempts = attempt < maxAttempts;
      if (!isRetryable || !hasMoreAttempts) {
        rethrow;
      }

      final factor = 1 << (attempt - 1);
      final delay = Duration(milliseconds: initialDelay.inMilliseconds * factor);
      await Future<void>.delayed(delay);
    }
  }

  Error.throwWithStackTrace(lastError!, lastStack!);
}
