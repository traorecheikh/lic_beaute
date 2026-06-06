import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'debug: app launches and shows splash',
    ($) async {
      await $.pump();
      await $.pump(const Duration(seconds: 2));
      expect(find.text('Beauté Avenue'), findsOneWidget);
    },
  );
}
