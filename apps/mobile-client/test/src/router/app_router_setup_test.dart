import 'package:beauteavenue_mobile_client/src/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveRequiredSetupRedirect', () {
    test('forces profile bootstrap when cached profile has no full name', () {
      expect(
        resolveRequiredSetupRedirect(
          location: AppRoutes.home,
          cachedProfile: {
            'id': 'user_1',
            'fullName': '',
            'preferredContactChannel': 'phone',
            'pushOptIn': true,
            'marketingOptIn': false,
            'preferredLanguage': 'fr',
          },
        ),
        AppRoutes.profileBootstrapSetup(next: AppRoutes.home),
      );
    });

    test('forces payment setup when profile exists but no payment methods exist', () {
      expect(
        resolveRequiredSetupRedirect(
          location: AppRoutes.bookingsList,
          cachedProfile: {
            'id': 'user_1',
            'fullName': 'Awa Ndiaye',
            'preferredContactChannel': 'phone',
            'pushOptIn': true,
            'marketingOptIn': false,
            'preferredLanguage': 'fr',
          },
          cachedPaymentMethods: {'items': []},
        ),
        AppRoutes.profilePaymentsSetup(next: AppRoutes.bookingsList),
      );
    });

    test('does not redirect when already on the required setup route', () {
      expect(
        resolveRequiredSetupRedirect(
          location: AppRoutes.profilePayments,
          cachedProfile: {
            'id': 'user_1',
            'fullName': 'Awa Ndiaye',
            'preferredContactChannel': 'phone',
            'pushOptIn': true,
            'marketingOptIn': false,
            'preferredLanguage': 'fr',
          },
          cachedPaymentMethods: {'items': []},
        ),
        isNull,
      );
    });

    test('does not redirect fully configured users', () {
      expect(
        resolveRequiredSetupRedirect(
          location: AppRoutes.home,
          cachedProfile: {
            'id': 'user_1',
            'fullName': 'Awa Ndiaye',
            'preferredContactChannel': 'phone',
            'pushOptIn': true,
            'marketingOptIn': false,
            'preferredLanguage': 'fr',
          },
          cachedPaymentMethods: {
            'items': [
              {
                'id': 'pm_1',
                'provider': 'paydunya',
                'phoneNumber': '771234567',
                'method': 'orange_senegal',
                'country': 'sn',
                'isDefault': true,
              }
            ]
          },
        ),
        isNull,
      );
    });
  });
}
