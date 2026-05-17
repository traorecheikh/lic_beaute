import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/network/app_network_error.dart';
import '../../../core/widgets/app_snackbar.dart';

class ClientOnlyAuthException implements Exception {
  const ClientOnlyAuthException(this.message);
  final String message;
}

String parseDioAuthError(DioException error, String fallback) {
  return extractApiMessage(error.response?.data) ?? fallback;
}

String parseOtpError(DioException error, String fallback) {
  final data = error.response?.data;
  if (data is Map<String, dynamic>) {
    final code = data['code'] as String?;
    switch (code) {
      case 'otp_rate_limited':
        return 'Trop de tentatives. Réessayez dans quelques minutes.';
      case 'invalid_phone':
        return 'Numéro de téléphone invalide.';
      case 'otp_expired':
        return 'Code expiré. Demandez un nouveau code.';
      case 'invalid_otp':
        return 'Code incorrect. Vérifiez et réessayez.';
    }
  }
  return parseDioAuthError(error, fallback);
}

/// Wraps a typical auth action with the shared try/catch pattern.
///
/// Handles [DioException], [ClientOnlyAuthException], and any other error,
/// showing an [AppSnackbar.error] for each case. Calls [onSuccess] when the
/// action completes without error (before checking [mounted]).
Future<void> handleAuthAction(
  BuildContext context,
  Future<void> Function() action, {
  required String fallback,
  VoidCallback? onSuccess,
  String Function(DioException, String)? errorMapper,
}) async {
  try {
    await action();
    onSuccess?.call();
  } on DioException catch (error) {
    if (!context.mounted) return;
    final mapper = errorMapper ?? parseDioAuthError;
    AppSnackbar.error(context, mapper(error, fallback));
  } on ClientOnlyAuthException catch (error) {
    if (!context.mounted) return;
    AppSnackbar.error(context, error.message);
  } catch (_) {
    if (!context.mounted) return;
    AppSnackbar.error(context, fallback);
  }
}
