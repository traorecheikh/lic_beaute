import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';

/// Handles payment-related [DioException] errors with user-facing messages
/// and navigation actions (e.g., redirect to profile edit for missing phone).
Future<void> handlePaymentError(
  BuildContext context,
  Object error,
) async {
  if (error is DioException) {
    final code =
        (error.response?.data as Map<String, dynamic>?)?['code'] as String?;
    final retryAfter =
        (error.response?.data as Map<String, dynamic>?)?['message'] as String?;

    switch (code) {
      case 'phone_required':
        AppSnackbar.error(
          context,
          'Ajoutez un numéro de téléphone à votre profil pour payer.',
        );
        await Future.delayed(const Duration(milliseconds: 600));
        if (context.mounted) {
          Navigator.of(context).pushNamed(AppRoutes.profileEdit);
        }
        return;
      case 'reconcile_throttled':
        final safeRetryMessage = retryAfter != null &&
                !RegExp(
                  r'paydunya|provider|invoice|merchant|token|callback|webhook|reconcile',
                  caseSensitive: false,
                ).hasMatch(retryAfter)
            ? retryAfter
            : 'Veuillez patienter quelques secondes, puis réessayez.';
        AppSnackbar.info(context, safeRetryMessage);
        return;
      case 'invalid_status':
        AppSnackbar.error(
          context,
          "Cette tentative de paiement n'est plus valide. Relancez le paiement.",
        );
        return;
      case 'missing_invoice_token':
        AppSnackbar.error(
          context,
          "Le paiement n'a pas pu être préparé correctement. Réessayez.",
        );
        return;
      case 'payment_not_found':
        AppSnackbar.error(
          context,
          'Paiement introuvable. Recommencez la réservation ou relancez le paiement.',
        );
        return;
    }
  }
  if (context.mounted) {
    AppSnackbar.error(context, 'Le paiement n’a pas abouti. Réessayez.');
  }
}
