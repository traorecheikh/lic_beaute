import 'package:beauteavenue_mobile_client/src/features/auth/utils/auth_router_helper.dart';
import 'package:beauteavenue_mobile_client/src/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolvePostAuthRoute', () {
    test('keeps users without a name on the fallback route', () {
      expect(
        resolvePostAuthRoute(fullName: '', paymentMethodCount: 0),
        AppRoutes.home,
      );
    });

    test('keeps users without a payment method on the fallback route', () {
      expect(
        resolvePostAuthRoute(fullName: 'Awa Ndiaye', paymentMethodCount: 0),
        AppRoutes.home,
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
