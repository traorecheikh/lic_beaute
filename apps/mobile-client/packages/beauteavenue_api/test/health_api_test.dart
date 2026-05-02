import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';

/// tests for HealthApi
void main() {
  final instance = BeauteavenueApi().getHealthApi();

  group(HealthApi, () {
    // Healthcheck
    //
    //Future<HealthGet200Response> healthGet() async
    test('test healthGet', () async {
      // TODO
    });
  });
}
