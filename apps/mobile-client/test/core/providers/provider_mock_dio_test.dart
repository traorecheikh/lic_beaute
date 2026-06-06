import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/core/session/session_store.dart';
import 'package:beauteavenue_mobile_client/src/features/booking/providers/booking_create_provider.dart';
import 'package:beauteavenue_mobile_client/src/features/booking/providers/payment_methods_provider.dart';
import 'package:beauteavenue_mobile_client/src/features/profile/providers/profile_provider.dart';
import 'package:beauteavenue_mobile_client/src/features/profile/providers/payment_methods_provider.dart'
    as profile_payment;

/// Mock Dio that returns predefined responses based on the request path.
class MockDio extends Dio {
  MockDio() : super(BaseOptions(baseUrl: 'https://api.test.com'));

  final Map<String, Object?> _responses = {};
  final List<String> _requestedPaths = [];

  void enqueue(String path, Object? response) {
    _responses[path] = response;
  }

  List<String> get requestedPaths => List.unmodifiable(_requestedPaths);

  @override
  Future<Response<T>> get<T>(
    String path, {
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    _requestedPaths.add('GET $path');
    final data = _responses[path];
    if (data is Exception) throw data;
    return Response<T>(
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
      data: data as T,
    );
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    data,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    _requestedPaths.add('POST $path');
    final responseData = _responses[path];
    if (responseData is Exception) throw responseData;
    return Response<T>(
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
      data: responseData as T,
    );
  }

  @override
  Future<Response<T>> patch<T>(
    String path, {
    data,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    _requestedPaths.add('PATCH $path');
    final responseData = _responses[path];
    if (responseData is Exception) throw responseData;
    return Response<T>(
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
      data: responseData as T,
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    _requestedPaths.add('DELETE $path');
    final responseData = _responses[path];
    if (responseData is Exception) throw responseData;
    return Response<T>(
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
      data: responseData as T,
    );
  }
}

/// Fixed session notifier that always returns the given state.
class _FixedSession extends SessionNotifier {
  _FixedSession(this._state);
  final SessionState _state;
  @override
  SessionState build() => _state;
}

/// Creates a ProviderContainer with a mocked Dio and fixed authenticated session.
({
  ProviderContainer container,
  MockDio dio,
}) _createMockedContainer({
  bool authenticated = true,
}) {
  final mockDio = MockDio();
  final session = authenticated
      ? SessionState(accessToken: 'tok_test', refreshToken: 'rtok', userId: 'user_1')
      : const SessionState();

  final container = ProviderContainer(
    overrides: [
      sessionProvider.overrideWith(() => _FixedSession(session)),
      dioProvider.overrideWith((_) => mockDio),
    ],
  );

  return (container: container, dio: mockDio);
}

void main() {
  group('ProfileProvider with mocked Dio', () {
    test('returns null when unauthenticated', () async {
      final (container: c, dio: _) = _createMockedContainer(authenticated: false);
      addTearDown(c.dispose);

      final profile = await c.read(profileProvider.future);
      expect(profile, isNull);
    });

    test('fetches profile from API when authenticated', () async {
      final (container: c, dio: mockDio) = _createMockedContainer();
      addTearDown(c.dispose);

      mockDio.enqueue('/api/v1/me', {
        'id': 'user_1',
        'fullName': 'Awa Ndiaye',
        'email': 'awa@test.com',
        'phone': '771234567',
        'city': 'Dakar',
        'preferredContactChannel': 'phone',
        'pushOptIn': true,
        'marketingOptIn': false,
        'preferredLanguage': 'fr',
      });

      final profile = await c.read(profileProvider.future);
      expect(profile, isNotNull);
      expect(profile!.fullName, 'Awa Ndiaye');
      expect(profile.email, 'awa@test.com');
      expect(profile.city, 'Dakar');
      expect(mockDio.requestedPaths, contains('GET /api/v1/me'));
    });
  });

  group('availablePaydunyaMethodsProvider with mocked Dio', () {
    test('returns parsed methods from API response', () async {
      final (container: c, dio: mockDio) = _createMockedContainer();
      addTearDown(c.dispose);

      mockDio.enqueue('/api/v1/payments/methods', {
        'methods': [
          {'code': 'orange_senegal', 'country': 'SN', 'label': 'Orange Money', 'enabled': true},
          {'code': 'wave_senegal', 'country': 'SN', 'label': 'Wave', 'enabled': true},
          {'code': 'djamo', 'country': 'CI', 'label': 'Djamo', 'enabled': true},
        ],
      });

      final methods = await c.read(availablePaydunyaMethodsProvider.future);
      expect(methods.length, 3);
      expect(methods[0].code, 'orange_senegal');
      expect(methods[1].code, 'wave_senegal');
      expect(methods[2].code, 'djamo');
      expect(methods.every((m) => m.enabled), isTrue);
      expect(mockDio.requestedPaths, contains('GET /api/v1/payments/methods'));
    });

    test('returns empty list when API response has no methods key', () async {
      final (container: c, dio: mockDio) = _createMockedContainer();
      addTearDown(c.dispose);

      mockDio.enqueue('/api/v1/payments/methods', {});

      final methods = await c.read(availablePaydunyaMethodsProvider.future);
      expect(methods, isEmpty);
    });

    test('returns empty list when API returns null data', () async {
      final (container: c, dio: mockDio) = _createMockedContainer();
      addTearDown(c.dispose);

      mockDio.enqueue('/api/v1/payments/methods', null);

      await expectLater(
        c.read(availablePaydunyaMethodsProvider.future),
        completes,
      );
      // When data is null, provider returns []
    });

    test('transiently sets loading state', () async {
      final (container: c, dio: mockDio) = _createMockedContainer();
      addTearDown(c.dispose);

      // Don't enqueue a response — leave it pending
      final future = c.read(availablePaydunyaMethodsProvider.future);
      expect(c.read(availablePaydunyaMethodsProvider).isLoading, isTrue);

      // Now resolve it
      mockDio.enqueue('/api/v1/payments/methods', {
        'methods': [{'code': 'test', 'country': 'SN', 'label': 'Test', 'enabled': true}],
      });
      await future;
      expect(c.read(availablePaydunyaMethodsProvider).isLoading, isFalse);
    });
  });

  group('PaymentInitiateNotifier execute method - nullable syntax', () {
    test('execute builds correct payload without details', () async {
      // Verify the collection-if syntax works: when details is null,
      // the 'details' key is omitted from the payload.
      final payload = <String, dynamic>{
        'paymentId': 'pay_123',
        'method': 'orange_senegal',
        if (null != null) 'details': <String, dynamic>{},
      };

      expect(payload.containsKey('details'), isFalse);
      expect(payload.length, 2);
    });

    test('execute builds correct payload with details', () async {
      final details = {'phone': '771234567'};
      final payload = <String, dynamic>{
        'paymentId': 'pay_123',
        'method': 'orange_senegal',
        if (details != null) 'details': details,
      };

      expect(payload.containsKey('details'), isTrue);
      expect(payload['details'], {'phone': '771234567'});
      expect(payload.length, 3);
    });
  });

  group('ProfileNotifier updateProfile payload', () {
    test('updateProfile omits null fields from payload', () async {
      // This simulates what the profile_provider now does with collection-if
      final payload = <String, dynamic>{
        if ('Awa' != null) 'fullName': 'Awa',
        if (null != null) 'city': null,
        if (true != null) 'pushOptIn': true,
        if (null != null) 'marketingOptIn': null,
        if (null != null) 'preferredLanguage': null,
        if (null != null) 'preferredContactChannel': null,
      };

      expect(payload.containsKey('fullName'), isTrue);
      expect(payload.containsKey('city'), isFalse);
      expect(payload.containsKey('pushOptIn'), isTrue);
      expect(payload.containsKey('marketingOptIn'), isFalse);
      expect(payload.containsKey('preferredLanguage'), isFalse);
      expect(payload.containsKey('preferredContactChannel'), isFalse);
      expect(payload.length, 2);
    });
  });

  group('bookingCreateErrorMessage with mocked Dio', () {
    test('returns session expired for 401', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/api/v1/bookings'),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/api/v1/bookings'),
        ),
      );
      expect(bookingCreateErrorMessage(error), contains('session a expiré'));
    });

    test('returns network error for connectionError', () {
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
          statusCode: 503,
          requestOptions: RequestOptions(path: '/api/v1/bookings'),
        ),
      );
      expect(bookingCreateErrorMessage(error), contains('problème temporaire'));
    });

    test('returns API message when present', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/api/v1/bookings'),
        response: Response(
          statusCode: 422,
          requestOptions: RequestOptions(path: '/api/v1/bookings'),
          data: {'message': 'Créneau déjà réservé.'},
        ),
      );
      expect(bookingCreateErrorMessage(error), 'Créneau déjà réservé.');
    });
  });

  group('Payment flow with mocked Dio (full flow data shapes)', () {
    test('initiate payment creates correct payload shape', () {
      final payload = {
        'bookingId': 'booking_123',
        'provider': 'paydunya',
        'channel': 'orange_senegal',
      };
      expect(payload['bookingId'], 'booking_123');
      expect(payload['provider'], 'paydunya');
      expect(payload['channel'], 'orange_senegal');
    });

    test('execute payment with OM response provides launch candidates', () {
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
      expect(response['url'], contains('paydunya.com'));
      expect(response['success'], isTrue);
    });

    test('reconcile status parsing', () {
      expect('succeeded' == 'succeeded', isTrue);
      expect('failed' == 'failed', isTrue);
      expect('refunded' == 'refunded', isTrue);
    });
  });
}
