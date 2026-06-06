import 'package:flutter_test/flutter_test.dart';
import 'package:beauteavenue_mobile_client/src/features/booking/providers/payment_methods_provider.dart';

void main() {
  group('PaydunyaMethodRecord', () {
    test('fromJson parses full JSON', () {
      final record = PaydunyaMethodRecord.fromJson({
        'code': 'orange_senegal',
        'country': 'SN',
        'label': 'Orange Money',
        'enabled': true,
      });

      expect(record.code, 'orange_senegal');
      expect(record.country, 'SN');
      expect(record.label, 'Orange Money');
      expect(record.enabled, isTrue);
    });

    test('fromJson uses defaults for missing fields', () {
      final record = PaydunyaMethodRecord.fromJson({
        'code': 'wave_senegal',
      });

      expect(record.code, 'wave_senegal');
      expect(record.country, '');
      expect(record.label, '');
      expect(record.enabled, isTrue);
    });

    test('fromJson handles null values', () {
      final record = PaydunyaMethodRecord.fromJson({
        'code': 'test',
        'country': null,
        'label': null,
        'enabled': null,
      });

      expect(record.country, '');
      expect(record.label, '');
      expect(record.enabled, isTrue);
    });

    test('accepts null for enabled to fall back to true', () {
      final record = PaydunyaMethodRecord.fromJson({
        'code': 'test',
        'enabled': null,
      });

      expect(record.enabled, isTrue);
    });

    test('accepts explicit false for enabled', () {
      final record = PaydunyaMethodRecord.fromJson({
        'code': 'test',
        'enabled': false,
      });

      expect(record.enabled, isFalse);
    });

    test('const constructor creates immutable record', () {
      const record = PaydunyaMethodRecord(
        code: 'orange_senegal',
        country: 'SN',
        label: 'Orange Money',
        enabled: true,
      );

      expect(record.code, 'orange_senegal');
      expect(record.country, 'SN');
      expect(record.label, 'Orange Money');
      expect(record.enabled, isTrue);
    });
  });
}
