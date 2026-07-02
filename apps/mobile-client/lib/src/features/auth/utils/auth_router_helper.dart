import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../router/app_router.dart';
import '../providers/auth_provider.dart';
import '../../profile/providers/payment_methods_provider.dart';

bool needsProfileBootstrap(String? fullName) => (fullName ?? '').trim().isEmpty;

bool needsPaymentMethodSetup(int paymentMethodCount) => paymentMethodCount <= 0;

String resolvePostAuthRoute({
  required String? fullName,
  required int paymentMethodCount,
  String fallbackRoute = AppRoutes.home,
}) {
  // Keep app access unblocked after authentication. Profile and payment setup
  // are now enforced contextually inside flows that genuinely require them.
  return fallbackRoute;
}

Future<void> navigateAfterAuth(BuildContext context, WidgetRef ref) async {
  final user = await ref.read(currentUserProvider.future);
  List<dynamic> paymentMethods;
  bool paymentFetchFailed = false;
  try {
    paymentMethods = await ref.read(paymentMethodsProvider.future);
  } catch (_) {
    paymentMethods = const [];
    paymentFetchFailed = true;
  }

  // If the payment-method fetch failed (network error), skip the
  // payment-setup redirect — the user likely has methods, we just
  // can't reach the server right now.
  if (paymentFetchFailed) {
    paymentMethods = [Object()]; // non-empty to bypass needsPaymentMethodSetup
  }
  if (!context.mounted) return;
  context.go(
    resolvePostAuthRoute(
      fullName: user?.fullName,
      paymentMethodCount: paymentMethods.length,
    ),
  );
}
