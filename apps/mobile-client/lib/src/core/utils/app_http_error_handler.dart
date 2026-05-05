import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../widgets/app_snackbar.dart';

extension AppHttpErrorExtension on BuildContext {
  Future<void> handleHttpError(Object error, String fallback) async {
    if (!mounted) return;
    String message = fallback;
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        message = data['message'] as String? ?? fallback;
      }
    }
    AppSnackbar.error(this, message);
  }
}
