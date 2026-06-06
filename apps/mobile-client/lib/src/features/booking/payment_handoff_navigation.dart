import '../../router/app_router.dart';

String paymentHandoffProfileSetupRoute(String bookingId) {
  return AppRoutes.profileBootstrapSetup(
    next: AppRoutes.paymentHandoff(bookingId),
  );
}

String paymentHandoffMethodSetupRoute(String bookingId) {
  return AppRoutes.profilePaymentsSetup(
    next: AppRoutes.paymentHandoff(bookingId),
  );
}

String paymentHandoffBackFallbackRoute(String bookingId) {
  return AppRoutes.bookingDetailPath(bookingId);
}
