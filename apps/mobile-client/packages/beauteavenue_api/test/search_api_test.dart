import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';


/// tests for SearchApi
void main() {
  final instance = BeauteavenueApi().getSearchApi();

  group(SearchApi, () {
    // Track search interaction events for personalization
    //
    //Future<SearchEventsResponse> apiV1SearchEventsPost(SearchEventsRequest searchEventsRequest) async
    test('test apiV1SearchEventsPost', () async {
      // TODO
    });

    // Search salons with ranked results, facets, and discovery modules
    //
    //Future<SearchSalonsResponse> apiV1SearchSalonsGet(String q, { num lat, num lng, String category, String city, String neighborhood, int minPrice, int maxPrice, bool openNow, bool bookableSoon, String sort, String cursor, int limit }) async
    test('test apiV1SearchSalonsGet', () async {
      // TODO
    });

    // Get search suggestions and autocomplete
    //
    //Future<SearchSuggestionsResponse> apiV1SearchSuggestionsGet(String q, { num lat, num lng, String category, String city }) async
    test('test apiV1SearchSuggestionsGet', () async {
      // TODO
    });

  });
}
