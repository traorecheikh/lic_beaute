import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';


/// tests for CatalogApi
void main() {
  final instance = BeauteavenueApi().getCatalogApi();

  group(CatalogApi, () {
    // Get subscription pricing tiers
    //
    //Future<ApiV1ConfigPricingGet200Response> apiV1ConfigPricingGet() async
    test('test apiV1ConfigPricingGet', () async {
      // TODO
    });

    // Get available booking slots
    //
    //Future<BuiltList<ApiV1SalonsIdAvailabilityGet200ResponseInner>> apiV1SalonsIdAvailabilityGet(String id, Date date, String serviceId, { String employeeId }) async
    test('test apiV1SalonsIdAvailabilityGet', () async {
      // TODO
    });

    // List salon reviews
    //
    //Future<ApiV1SalonsIdReviewsGet200Response> apiV1SalonsIdReviewsGet(String id, { String page, String pageSize }) async
    test('test apiV1SalonsIdReviewsGet', () async {
      // TODO
    });

  });
}
