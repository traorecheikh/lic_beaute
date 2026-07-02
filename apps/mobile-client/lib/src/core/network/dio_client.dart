import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/storage_keys.dart';
import '../diagnostics/app_runtime_diagnostics.dart';
import '../env/app_env.dart';
import '../storage/secure_storage.dart';

Dio createDio(
  SecureStorage secureStorage, {
  Future<void> Function()? onSessionCleared,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.apiBaseUrl,
      connectTimeout: const Duration(seconds: 25),
      receiveTimeout: const Duration(seconds: 45),
      headers: const {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    if (diagnosticsEnabled) HttpInstrumentationInterceptor(),
    _AuthInterceptor(
      secureStorage: secureStorage,
      dio: dio,
      onSessionCleared: onSessionCleared,
    ),
    if (kDebugMode)
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 120,
        logPrint: (o) => debugPrint(o.toString()),
      ),
  ]);

  return dio;
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor({
    required this.secureStorage,
    required this.dio,
    this.onSessionCleared,
  });

  final SecureStorage secureStorage;
  final Dio dio;
  final Future<void> Function()? onSessionCleared;

  bool _isRefreshing = false;
  final List<({RequestOptions options, ErrorInterceptorHandler handler})>
  _queue = [];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for auth endpoints
    if (_isAuthPath(options.path)) {
      handler.next(options);
      return;
    }
    final token = await secureStorage.read(StorageKeys.accessToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 ||
        _isAuthPath(err.requestOptions.path)) {
      handler.next(err);
      return;
    }

    if (_isRefreshing) {
      _queue.add((options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;
    // Ensure queue is always resolved before exit
    String? attemptedRefreshToken;
    bool _queueAlreadyCleared = false;
    try {
      attemptedRefreshToken = await secureStorage.read(
        StorageKeys.refreshToken,
      );
      if (attemptedRefreshToken == null) {
        await _clearSession();
        handler.next(err);
        return;
      }

      final response = await dio.post<Map<String, dynamic>>(
        '/api/v1/auth/refresh',
        data: {'refreshToken': attemptedRefreshToken},
        options: Options(headers: {}), // no auth header on refresh
      );

      final newAccess = response.data?['accessToken'] as String?;
      final newRefresh = response.data?['refreshToken'] as String?;

      if (newAccess == null || newRefresh == null) {
        await _clearSessionIfRefreshTokenMatches(attemptedRefreshToken);
        handler.next(err);
        return;
      }

      await secureStorage.write(StorageKeys.accessToken, newAccess);
      await secureStorage.write(StorageKeys.refreshToken, newRefresh);

      // Retry original + queued requests with new token
      final retryOptions = err.requestOptions
        ..headers['Authorization'] = 'Bearer $newAccess';
      final retryResponse = await dio.fetch<dynamic>(retryOptions);
      handler.resolve(retryResponse);

      for (final queued in _queue) {
        queued.options.headers['Authorization'] = 'Bearer $newAccess';
        final r = await dio.fetch<dynamic>(queued.options);
        queued.handler.resolve(r);
      }
      _queue.clear();
    } catch (_) {
      await _clearSessionIfRefreshTokenMatches(attemptedRefreshToken);
      _queueAlreadyCleared = true;
      for (final queued in _queue) {
        queued.handler.next(err);
      }
      _queue.clear();
      handler.next(err);
    } finally {
      // Always drain any remaining queued handlers so they never hang
      if (!_queueAlreadyCleared && _queue.isNotEmpty) {
        for (final queued in _queue) {
          queued.handler.next(err);
        }
        _queue.clear();
      }
      _isRefreshing = false;
    }
  }

  Future<void> _clearSession() async {
    await secureStorage.delete(StorageKeys.accessToken);
    await secureStorage.delete(StorageKeys.refreshToken);
    await secureStorage.delete(StorageKeys.userId);
    if (onSessionCleared != null) {
      await onSessionCleared!();
    }
  }

  Future<void> _clearSessionIfRefreshTokenMatches(
    String? attemptedRefreshToken,
  ) async {
    final currentRefreshToken = await secureStorage.read(
      StorageKeys.refreshToken,
    );
    if (currentRefreshToken == attemptedRefreshToken) {
      await _clearSession();
    }
  }

  bool _isAuthPath(String path) =>
      path.contains('/auth/login') ||
      path.contains('/auth/register') ||
      path.contains('/auth/refresh') ||
      path.contains('/auth/otp');
}
