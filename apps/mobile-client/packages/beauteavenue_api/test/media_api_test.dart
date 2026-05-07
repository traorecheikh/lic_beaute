import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';


/// tests for MediaApi
void main() {
  final instance = BeauteavenueApi().getMediaApi();

  group(MediaApi, () {
    // Confirm upload completed — triggers admin review
    //
    //Future<ApiV1MediaMediaIdCompletePost200Response> apiV1MediaMediaIdCompletePost(String mediaId) async
    test('test apiV1MediaMediaIdCompletePost', () async {
      // TODO
    });

    // Soft-delete a media asset
    //
    //Future<DeletedResponse> apiV1MediaMediaIdDelete(String mediaId) async
    test('test apiV1MediaMediaIdDelete', () async {
      // TODO
    });

    // Retrieve media metadata
    //
    //Future<MediaAsset> apiV1MediaMediaIdGet(String mediaId) async
    test('test apiV1MediaMediaIdGet', () async {
      // TODO
    });

    // Request a presigned PUT URL for direct R2 upload
    //
    //Future<ApiV1MediaUploadIntentPost201Response> apiV1MediaUploadIntentPost(ApiV1MediaUploadIntentPostRequest apiV1MediaUploadIntentPostRequest) async
    test('test apiV1MediaUploadIntentPost', () async {
      // TODO
    });

  });
}
