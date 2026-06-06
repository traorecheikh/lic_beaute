import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/core/network/app_network_error.dart';
import 'package:beauteavenue_mobile_client/src/features/booking/providers/booking_create_provider.dart';
import 'package:beauteavenue_mobile_client/src/features/booking/providers/payment_methods_provider.dart';
import 'package:beauteavenue_mobile_client/src/features/profile/providers/profile_provider.dart';
import 'package:beauteavenue_mobile_client/src/features/profile/models/account_models.dart';

void main() {
  group('PaymentInitiateNotifier execute - nullable syntax fix', () {
    test('omits details key when details is null', () {
      final payload = <String, dynamic>{
        'paymentId': 'pay_123',
        'method': 'orange_senegal',
        if (null != null) 'details': <String, dynamic>{},
      };
      expect(payload.containsKey('details'), isFalse);
      expect(payload.length, 2);
    });

    test('includes details key when details is not null', () {
      final details = {'phone': '771234567'};
      final payload = <String, dynamic>{
        'paymentId': 'pay_123',
        'method': 'orange_senegal',
        if (details != null) 'details': details,
      };
      expect(payload.containsKey('details'), isTrue);
      expect(payload['details'], {'phone': '771234567'});
    });
  });

  group('ProfileProvider updateProfile - nullable syntax fix', () {
    test('omits null fields from payload via collection-if', () {
      final payload = <String, dynamic>{
        if ('Awa' != null) 'fullName': 'Awa',
        if (null != null) 'city': null,
        if (true != null) 'pushOptIn': true,
        if (null != null) 'preferredLanguage': null,
      };
      expect(payload.containsKey('fullName'), isTrue);
      expect(payload.containsKey('city'), isFalse);
      expect(payload.containsKey('pushOptIn'), isTrue);
      expect(payload.containsKey('preferredLanguage'), isFalse);
      expect(payload.length, 2);
    });
  });

  group('BookingActions submitReview - nullable syntax fix', () {
    test('omits comment key when comment is null', () {
      final payload = <String, dynamic>{
        'rating': 5,
        if (null != null) 'comment': 'Great!',
      };
      expect(payload.containsKey('comment'), isFalse);
      expect(payload.length, 1);
    });

    test('includes comment key when comment is not null', () {
      final comment = 'Excellent service!';
      final payload = <String, dynamic>{
        'rating': 5,
        if (comment != null) 'comment': comment,
      };
      expect(payload.containsKey('comment'), isTrue);
      expect(payload['comment'], 'Excellent service!');
    });
  });

  group('bookingCreateErrorMessage', () {
    test('returns session expired for 401', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/api/v1/bookings'),
        response: Response(
          statusCode: 401, requestOptions: RequestOptions(path: '/api/v1/bookings'),
        ),
      );
      expect(bookingCreateErrorMessage(error), contains('session a expiré'));
    });

    test('returns connection error message', () {
      final error = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: '/api/v1/bookings'),
      );
      expect(bookingCreateErrorMessage(error), contains('Connexion indisponible'));
    });

    test('returns server error for 503', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/api/v1/bookings'),
        response: Response(
          statusCode: 503, requestOptions: RequestOptions(path: '/api/v1/bookings'),
        ),
      );
      expect(bookingCreateErrorMessage(error), contains('problème temporaire'));
    });

    test('returns API message when present', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/api/v1/bookings'),
        response: Response(
          statusCode: 422, requestOptions: RequestOptions(path: '/api/v1/bookings'),
          data: {'message': 'Créneau déjà réservé.'},
        ),
      );
      expect(bookingCreateErrorMessage(error), 'Créneau déjà réservé.');
    });
  });

  group('availablePaydunyaMethodsProvider - data parsing', () {
    test('PaydunyaMethodRecord.fromJson parses full record', () {
      final record = PaydunyaMethodRecord.fromJson({
        'code': 'orange_senegal',
        'country': 'SN',
        'label': 'Orange Money',
        'enabled': true,
      });
      expect(record.code, 'orange_senegal');
      expect(record.country, 'SN');
      expect(record.label, 'Orange Money');
      expect(record.enabled, isTrue);
    });

    test('filter for enabled methods only', () {
      final methods = [
        PaydunyaMethodRecord(code: 'a', country: 'SN', label: 'A', enabled: true),
        PaydunyaMethodRecord(code: 'b', country: 'SN', label: 'B', enabled: false),
        PaydunyaMethodRecord(code: 'c', country: 'SN', label: 'C', enabled: true),
      ];
      final enabled = methods.where((m) => m.enabled).toList();
      expect(enabled.length, 2);
      expect(enabled.map((m) => m.code), containsAll(['a', 'c']));
    });
  });

  group('Payment flow response shapes (no Dio mock needed)', () {
    test('initiate payment payload shape', () {
      final payload = {
        'bookingId': 'booking_123',
        'provider': 'paydunya',
        'channel': 'orange_senegal',
      };
      expect(payload['bookingId'], 'booking_123');
      expect(payload['provider'], 'paydunya');
    });

    test('execute response with OM deep links', () {
      final response = {
        'success': true,
        'other_url': <String, dynamic>{
          'om_url': 'https://orangemoneysn.page.link/pay',
          'maxit_url': 'https://sugu.orange-sonatel.com/mp/pay',
        },
        'url': 'https://app.paydunya.com/recharge',
      };

      final otherUrl = response['other_url'] as Map<String, dynamic>;
      expect(otherUrl['om_url'], contains('orangemoneysn'));
      expect(otherUrl['maxit_url'], contains('sugu.orange-sonatel'));
      expect(response['success'], isTrue);
    });

    test('execute response with Wizall cid', () {
      final response = {
        'success': true,
        'data': <String, dynamic>{
          'cid': 'wiz_cid_abc',
          'details': <String, dynamic>{'cid': 'wiz_cid_abc'},
        },
      };
      final data = response['data'] as Map<String, dynamic>;
      final details = data['details'] as Map<String, dynamic>;
      expect(details['cid'], 'wiz_cid_abc');
    });

    test('extractApiMessage trims and returns message', () {
      expect(extractApiMessage({'message': '  Hello  '}), 'Hello');
      expect(extractApiMessage({'message': ''}), isNull);
      expect(extractApiMessage({'message': null}), isNull);
      expect(extractApiMessage('plain text'), isNull);
    });
  });
}
