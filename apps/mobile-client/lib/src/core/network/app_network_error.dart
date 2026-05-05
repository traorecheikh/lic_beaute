import 'dart:io';

import 'package:dio/dio.dart';

enum AppNetworkErrorType { offline, timeout, server, unauthorized, unknown }

class AppNetworkError {
  const AppNetworkError({
    required this.type,
    required this.title,
    required this.message,
  });

  final AppNetworkErrorType type;
  final String title;
  final String message;

  bool get isOfflineLike =>
      type == AppNetworkErrorType.offline ||
      type == AppNetworkErrorType.timeout;
}

AppNetworkError resolveAppNetworkError(
  Object error, {
  required bool isOnline,
  required String offlineTitle,
  required String serverTitle,
  required String fallbackTitle,
}) {
  if (error is SocketException) {
    return AppNetworkError(
      type: AppNetworkErrorType.offline,
      title: offlineTitle,
      message: 'Votre appareil ne parvient pas à joindre Internet.',
    );
  }

  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppNetworkError(
          type: AppNetworkErrorType.timeout,
          title: fallbackTitle,
          message: 'La connexion est trop lente pour terminer le chargement.',
        );
      case DioExceptionType.connectionError:
        return AppNetworkError(
          type: AppNetworkErrorType.offline,
          title: offlineTitle,
          message: 'Votre appareil ne parvient pas à joindre Internet.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return AppNetworkError(
            type: AppNetworkErrorType.unauthorized,
            title: 'Session expirée',
            message: 'Reconnectez-vous pour continuer.',
          );
        }
        if (statusCode != null && statusCode >= 500) {
          return AppNetworkError(
            type: AppNetworkErrorType.server,
            title: serverTitle,
            message: 'Nos services rencontrent un problème temporaire.',
          );
        }
        final apiMessage = extractApiMessage(error.response?.data);
        return AppNetworkError(
          type: AppNetworkErrorType.unknown,
          title: fallbackTitle,
          message:
              apiMessage ?? 'Une erreur est survenue pendant le chargement.',
        );
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        break;
    }
  }

  if (!isOnline) {
    return AppNetworkError(
      type: AppNetworkErrorType.offline,
      title: offlineTitle,
      message: 'Vérifiez votre connexion puis réessayez.',
    );
  }

  return AppNetworkError(
    type: AppNetworkErrorType.unknown,
    title: fallbackTitle,
    message: 'Une erreur est survenue pendant le chargement.',
  );
}

String? extractApiMessage(Object? data) {
  if (data is Map<String, dynamic>) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }
  }
  return null;
}
