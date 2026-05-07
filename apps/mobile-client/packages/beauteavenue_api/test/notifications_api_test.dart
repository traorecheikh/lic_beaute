import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';


/// tests for NotificationsApi
void main() {
  final instance = BeauteavenueApi().getNotificationsApi();

  group(NotificationsApi, () {
    // List notifications
    //
    //Future<ApiV1NotificationsGet200Response> apiV1NotificationsGet() async
    test('test apiV1NotificationsGet', () async {
      // TODO
    });

    // Mark one notification as read
    //
    //Future<ApiV1NotificationsIdReadPost200Response> apiV1NotificationsIdReadPost(String id) async
    test('test apiV1NotificationsIdReadPost', () async {
      // TODO
    });

    // Mark all notifications as read
    //
    //Future<UpdatedResponse> apiV1NotificationsReadAllPost() async
    test('test apiV1NotificationsReadAllPost', () async {
      // TODO
    });

  });
}
