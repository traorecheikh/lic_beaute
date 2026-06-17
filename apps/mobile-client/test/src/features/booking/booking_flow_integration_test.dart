import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/features/booking/paydunya_launch.dart';

/// Simulates an initiate payment response from the API.
Map<String, dynamic> initiateResponse({String? paymentId}) {
  return {
    'paymentId': paymentId ?? 'pay_test_123',
    'status': 'pending',
  };
}

/// Simulates an execute payment response with OM deep links.
Map<String, dynamic> executeOmResponse() {
  return {
    'success': true,
    'other_url': <String, dynamic>{
      'om_url': 'https://orangemoneysn.page.link/pay_abc',
      'maxit_url': 'https://sugu.orange-sonatel.com/mp/pay_abc',
    },
    'url': 'https://app.paydunya.com/recharge?token=abc',
    'paymentId': 'pay_test_123',
  };
}

Map<String, dynamic> executeWizallResponse() {
  return {
    'success': true,
    'data': <String, dynamic>{
      'cid': 'wiz_cid_abc',
      'details': <String, dynamic>{'cid': 'wiz_cid_abc'},
    },
  };
}

/// Simulates a failed execute payment response.
Map<String, dynamic> executeFailureResponse({String? message}) {
  return {
    'success': false,
    'message': message ?? 'Solde insuffisant.',
    'paymentId': 'pay_test_123',
  };
}

void main() {
  group('Payment flow - initiate', () {
    test('initiate response contains paymentId', () {
      final response = initiateResponse(paymentId: 'pay_test_456');
      expect(response['paymentId'], 'pay_test_456');
      expect(response['status'], 'pending');
    });



    test('initiate response handles empty paymentId', () {
      final response = initiateResponse(paymentId: '');
      final paymentId = response['paymentId'] as String?;
      expect(paymentId, isEmpty);
    });
  });

  group('Payment flow - execute with OM/Maxit deep links', () {
    test('execute response provides OM URL as preferred launch target', () {
      final response = executeOmResponse();
      expect(response['success'], isTrue);

      final otherUrl = response['other_url'] as Map<String, dynamic>;
      expect(otherUrl['om_url'], 'https://orangemoneysn.page.link/pay_abc');
      expect(otherUrl['maxit_url'], 'https://sugu.orange-sonatel.com/mp/pay_abc');
      expect(response['url'], 'https://app.paydunya.com/recharge?token=abc');
    });

    test('paydunyaLaunchCandidates orders OM first, Maxit second, hosted last', () {
      final ordered = paydunyaLaunchCandidates(
        omUrl: 'https://orangemoneysn.page.link/abc',
        maxitUrl: 'https://sugu.orange-sonatel.com/mp/abc',
        hostedUrl: 'https://app.paydunya.com/recharge?token=abc',
      );

      expect(ordered.length, 3);
      expect(ordered[0], contains('orangemoneysn.page.link'));
      expect(ordered[1], contains('sugu.orange-sonatel.com'));
      expect(ordered[2], contains('app.paydunya.com'));
    });
  });

  group('Payment flow - execute failure', () {
    test('execute failure returns false success and message', () {
      final response = executeFailureResponse();
      expect(response['success'], isFalse);
      expect(response['message'], 'Solde insuffisant.');
    });

    test('execute failure with custom message', () {
      final response = executeFailureResponse(message: 'Code OTP invalide.');
      expect(response['message'], 'Code OTP invalide.');
    });
  });

  group('Payment flow - polling reconciliation', () {
    test('timeout logic: 49 intervals < 5 min, 50 intervals >= 5 min', () {
      const pollInterval = Duration(seconds: 6);
      const timeout = Duration(minutes: 5);

      int elapsed = 0;

      for (int i = 0; i < 49; i++) {
        elapsed += pollInterval.inSeconds;
      }
      expect(elapsed < timeout.inSeconds, isTrue);

      elapsed += pollInterval.inSeconds;
      expect(elapsed >= timeout.inSeconds, isTrue);
    });
  });

  group('Payment flow - Wizall OTP flow', () {
    test('Wizall response provides cid via data.details.cid', () {
      final response = executeWizallResponse();
      final data = response['data'] as Map<String, dynamic>;
      final details = data['details'] as Map<String, dynamic>;
      expect(details['cid'], 'wiz_cid_abc');
    });

    test('Wizall OTP confirmation response shape', () {
      const result = {
        'success': true,
        'return_url': 'https://app.paydunya.com/success',
      };
      expect(result['success'], isTrue);
      expect(result['return_url'], isNotNull);
    });
  });

  group('Payment error handling', () {
    test('DioException with phone_required code is parseable', () {
      final dioError = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/api/v1/payments/deposits/execute'),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: '/api/v1/payments/deposits/execute'),
          data: {'code': 'phone_required', 'message': 'Ajoutez un numéro de téléphone.'},
        ),
      );

      final data = dioError.response?.data as Map<String, dynamic>?;
      expect(data?['code'], 'phone_required');
      expect(data?['message'], 'Ajoutez un numéro de téléphone.');
    });

    test('DioException with reconcile_throttled code is parseable', () {
      final dioError = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/api/v1/payments/deposits/execute'),
        response: Response(
          statusCode: 429,
          requestOptions: RequestOptions(path: '/api/v1/payments/deposits/execute'),
          data: {'code': 'reconcile_throttled', 'message': 'Trop de tentatives.'},
        ),
      );

      final data = dioError.response?.data as Map<String, dynamic>?;
      expect(data?['code'], 'reconcile_throttled');
      expect(data?['message'], 'Trop de tentatives.');
    });
  });
}
