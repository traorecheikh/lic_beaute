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
}) async {
  try {
    await action();
    onSuccess?.call();
  } on DioException catch (error) {
    if (!context.mounted) return;
    AppSnackbar.error(context, parseDioAuthError(error, fallback));
  } on ClientOnlyAuthException catch (error) {
    if (!context.mounted) return;
    AppSnackbar.error(context, error.message);
  } catch (_) {
    if (!context.mounted) return;
    AppSnackbar.error(context, fallback);
  }
}
