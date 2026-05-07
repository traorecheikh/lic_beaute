import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';


/// tests for FavoritesApi
void main() {
  final instance = BeauteavenueApi().getFavoritesApi();

  group(FavoritesApi, () {
    // List client favorites
    //
    //Future<FavoriteListResponse> apiV1FavoritesGet() async
    test('test apiV1FavoritesGet', () async {
      // TODO
    });

    // Remove salon from favorites
    //
    //Future<DeletedResponse> apiV1FavoritesSalonIdDelete(String salonId) async
    test('test apiV1FavoritesSalonIdDelete', () async {
      // TODO
    });

    // Add salon to favorites
    //
    //Future<FavoriteItem> apiV1FavoritesSalonIdPost(String salonId) async
    test('test apiV1FavoritesSalonIdPost', () async {
      // TODO
    });

  });
}
