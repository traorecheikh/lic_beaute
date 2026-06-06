import 'package:beauteavenue_mobile_client/src/core/session/session_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SessionState.isAuthenticated', () {
    test('is false when the user id is still empty', () {
      expect(
        const SessionState(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: '',
        ).isAuthenticated,
        isFalse,
      );
    });

    test('is true only when a non-empty user id exists', () {
      expect(
        const SessionState(
          accessToken: 'token',
          refreshToken: 'refresh',
          userId: 'user_1',
        ).isAuthenticated,
        isTrue,
      );
    });
  });
}
