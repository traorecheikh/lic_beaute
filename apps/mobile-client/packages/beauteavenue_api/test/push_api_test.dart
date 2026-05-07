import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';


/// tests for PushApi
void main() {
  final instance = BeauteavenueApi().getPushApi();

  group(PushApi, () {
    // Register a push notification token
    //
    //Future<ApiV1PushTokensPost201Response> apiV1PushTokensPost(PushTokenInput pushTokenInput) async
    test('test apiV1PushTokensPost', () async {
      // TODO
    });

    // Revoke a push notification token
    //
    //Future<DeletedResponse> apiV1PushTokensTokenIdDelete(String tokenId) async
    test('test apiV1PushTokensTokenIdDelete', () async {
      // TODO
    });

  });
}
