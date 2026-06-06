import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/features/booking/utils/booking_format.dart';

void main() {
  group('xof', () {
    test('formats 0 XOF', () {
      expect(xof(0), '0 XOF');
    });

    test('formats small amounts', () {
      expect(xof(100), '100 XOF');
      expect(xof(500), '500 XOF');
      expect(xof(999), '999 XOF');
    });

    test('formats thousands with space separator', () {
      expect(xof(1000), '1\u{202f}000 XOF');
      expect(xof(5000), '5\u{202f}000 XOF');
      expect(xof(10000), '10\u{202f}000 XOF');
    });

    test('formats larger amounts', () {
      expect(xof(25000), '25\u{202f}000 XOF');
      expect(xof(100000), '100\u{202f}000 XOF');
      expect(xof(500000), '500\u{202f}000 XOF');
    });

    test('formats millions', () {
      expect(xof(1000000), '1\u{202f}000\u{202f}000 XOF');
      expect(xof(1500000), '1\u{202f}500\u{202f}000 XOF');
    });
  });
}
