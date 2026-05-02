import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';

/// tests for SalonsApi
void main() {
  final instance = BeauteavenueApi().getSalonsApi();

  group(SalonsApi, () {
    // List salons
    //
    //Future<SalonSummaryListResponse> apiV1SalonsGet() async
    test('test apiV1SalonsGet', () async {
      // TODO
    });

    // Salon details
    //
    //Future<SalonDetail> apiV1SalonsIdGet(String id) async
    test('test apiV1SalonsIdGet', () async {
      // TODO
    });
  });
}
