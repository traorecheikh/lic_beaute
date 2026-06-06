import 'package:beauteavenue_mobile_client/src/features/auth/utils/auth_router_helper.dart';
import 'package:beauteavenue_mobile_client/src/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolvePostAuthRoute', () {
    test('sends users without a name to the required profile bootstrap step', () {
      expect(
        resolvePostAuthRoute(fullName: '', paymentMethodCount: 0),
        AppRoutes.profileBootstrapSetup(next: AppRoutes.home),
      );
    });

    test('sends users without a payment method to the required payment step', () {
      expect(
        resolvePostAuthRoute(fullName: 'Awa Ndiaye', paymentMethodCount: 0),
        AppRoutes.profilePaymentsSetup(next: AppRoutes.home),
      );
    });

    test('keeps fully configured users on the fallback route', () {
      expect(
        resolvePostAuthRoute(
          fullName: 'Awa Ndiaye',
          paymentMethodCount: 1,
          fallbackRoute: AppRoutes.bookingsList,
        ),
        AppRoutes.bookingsList,
      );
    });
  });
}
