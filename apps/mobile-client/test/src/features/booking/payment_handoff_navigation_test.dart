import 'package:beauteavenue_mobile_client/src/features/booking/payment_handoff_navigation.dart';
import 'package:beauteavenue_mobile_client/src/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('payment handoff navigation', () {
    test('builds the required profile setup route with a return to the booking payment screen', () {
      expect(
        paymentHandoffProfileSetupRoute('booking_123'),
        AppRoutes.profileBootstrapSetup(
          next: AppRoutes.paymentHandoff('booking_123'),
        ),
      );
    });

    test('builds the required payment-method setup route with a return to the booking payment screen', () {
      expect(
        paymentHandoffMethodSetupRoute('booking_123'),
        AppRoutes.profilePaymentsSetup(
          next: AppRoutes.paymentHandoff('booking_123'),
        ),
      );
    });

    test('uses booking detail as the back fallback route', () {
      expect(
        paymentHandoffBackFallbackRoute('booking_123'),
        AppRoutes.bookingDetailPath('booking_123'),
      );
    });
  });
}
