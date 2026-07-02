import 'package:beauteavenue_mobile_client/src/router/app_router.dart';
import 'package:beauteavenue_mobile_client/src/router/guards.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveRequiredSetupRedirect', () {
    test('treats payment callback as public without auth', () {
      expect(isPublicRouteWithoutAuth(AppRoutes.paymentCallback), isTrue);
    });

    test('does not block general app access for incomplete profiles', () {
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
        isNull,
      );
    });

    test('forces payment setup only inside payment handoff flow', () {
      expect(
        resolveRequiredSetupRedirect(
          location: AppRoutes.paymentHandoff('booking_1'),
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
        AppRoutes.profilePaymentsSetup(
          next: AppRoutes.paymentHandoff('booking_1'),
        ),
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
              },
            ],
          },
        ),
        isNull,
      );
    });

    test(
      'normalizes hive-shaped dynamic payment method maps before redirect checks',
      () {
        expect(
          resolveRequiredSetupRedirect(
            location: AppRoutes.paymentHandoff('booking_1'),
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
                Map<dynamic, dynamic>.from({
                  'id': 'pm_1',
                  'provider': 'paydunya',
                  'phoneNumber': '771234567',
                  'method': 'orange_senegal',
                  'country': 'sn',
                  'isDefault': true,
                }),
              ],
            },
          ),
          isNull,
        );
      },
    );
  });
}
