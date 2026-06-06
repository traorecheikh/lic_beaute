import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'minimal smoke: 1+1 = 2',
    ($) async {
      // Just verify the patrol test runner works at all
      expect(1 + 1, 2);
    },
  );
}
