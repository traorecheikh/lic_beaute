import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/features/profile/models/account_models.dart';

void main() {
  group('BenefitRecord kind and status', () {
    test('creates membership benefit with all fields', () {
      final benefit = BenefitRecord.fromJson({
        'id': 'ben_1',
        'kind': 'membership',
        'name': 'Abonnement Mensuel Illimité',
        'status': 'active',
        'remainingUses': 10,
        'expiresAt': '2025-12-31T23:59:59.000Z',
        'billingDate': '2025-07-01T00:00:00.000Z',
        'salonId': 'salon_1',
        'salonName': 'Beauté Avenue Dakar',
        'createdAt': '2025-01-01T00:00:00.000Z',
      });

      expect(benefit.kind, 'membership');
      expect(benefit.remainingUses, 10);
      expect(benefit.status, 'active');
    });

    test('creates package benefit (non-membership)', () {
      final benefit = BenefitRecord.fromJson({
        'id': 'ben_2',
        'kind': 'package',
        'name': 'Forfait Découverte',
        'status': 'paused',
        'remainingUses': 3,
        'salonId': 'salon_2',
        'salonName': 'Beauté Avenue Thiès',
        'createdAt': '2025-03-01T00:00:00.000Z',
      });

      expect(benefit.kind, 'package');
      expect(benefit.status, 'paused');
      expect(benefit.remainingUses, 3);
    });

    test('handles expired benefit', () {
      final benefit = BenefitRecord.fromJson({
        'id': 'ben_3',
        'kind': 'membership',
        'name': 'Ancien Abonnement',
        'status': 'expired',
        'expiresAt': '2024-12-31T23:59:59.000Z',
        'salonId': 'salon_1',
        'salonName': 'Beauté Avenue',
        'createdAt': '2024-01-01T00:00:00.000Z',
      });

      expect(benefit.status, 'expired');
      expect(benefit.expiresAt!.year, 2024);
    });

    test('handles exhausted benefit', () {
      final benefit = BenefitRecord.fromJson({
        'id': 'ben_4',
        'kind': 'package',
        'name': 'Pack 5 séances',
        'status': 'exhausted',
        'remainingUses': 0,
        'salonId': 'salon_3',
        'salonName': 'Beauté Avenue Saint-Louis',
        'createdAt': '2025-06-01T00:00:00.000Z',
      });

      expect(benefit.status, 'exhausted');
      expect(benefit.remainingUses, 0);
    });

    test('handles cancelled benefit', () {
      final benefit = BenefitRecord.fromJson({
        'id': 'ben_5',
        'kind': 'membership',
        'name': 'Abonnement Annulé',
        'status': 'cancelled',
        'salonId': 'salon_4',
        'salonName': 'Beauté Avenue',
        'createdAt': '2025-06-01T00:00:00.000Z',
      });

      expect(benefit.status, 'cancelled');
    });

    test('String type kind falls back to membership', () {
      final benefit = BenefitRecord.fromJson({
        'id': 'ben_6',
        'kind': null,
        'name': null,
        'status': null,
        'salonId': null,
        'salonName': null,
        'createdAt': '2025-01-01T00:00:00.000Z',
      });

      expect(benefit.kind, 'membership');
      expect(benefit.name, '');
      expect(benefit.status, 'active');
      expect(benefit.salonId, '');
      expect(benefit.salonName, '');
    });
  });

  group('VoucherRecord status lifecycle', () {
    test('creates active voucher', () {
      final voucher = VoucherRecord.fromJson({
        'id': 'v_1',
        'code': 'BIENVENUE10',
        'title': '10€ de réduction',
        'discountLabel': '-10€',
        'status': 'active',
        'expiresAt': '2025-12-31T23:59:59.000Z',
        'redeemedAt': '2025-06-15T10:00:00.000Z',
      });

      expect(voucher.status, 'active');
      expect(voucher.code, 'BIENVENUE10');
      expect(voucher.expiresAt, isNotNull);
    });

    test('creates used voucher with usedAt date', () {
      final voucher = VoucherRecord.fromJson({
        'id': 'v_2',
        'code': 'SUMMER25',
        'title': '-25% été',
        'discountLabel': '-25%',
        'status': 'used',
        'redeemedAt': '2025-07-01T08:00:00.000Z',
        'usedAt': '2025-07-15T14:30:00.000Z',
        'salonId': 'salon_1',
        'salonName': 'Beauté Avenue Dakar',
      });

      expect(voucher.status, 'used');
      expect(voucher.usedAt, isNotNull);
      expect(voucher.salonId, 'salon_1');
    });

    test('creates expired voucher', () {
      final voucher = VoucherRecord.fromJson({
        'id': 'v_3',
        'code': 'OLD20',
        'title': '-20% ancien',
        'discountLabel': '-20%',
        'status': 'expired',
        'expiresAt': '2024-06-01T00:00:00.000Z',
        'redeemedAt': '2024-05-01T00:00:00.000Z',
      });

      expect(voucher.status, 'expired');
      expect(voucher.expiresAt!.year, 2024);
    });

    test('handles missing optional fields', () {
      final voucher = VoucherRecord.fromJson({
        'id': 'v_4',
        'code': 'NOEXPIRY',
        'title': 'Sans date',
        'discountLabel': 'Offert',
        'status': 'active',
        'redeemedAt': '2025-01-01T00:00:00.000Z',
      });

      expect(voucher.description, isNull);
      expect(voucher.expiresAt, isNull);
      expect(voucher.usedAt, isNull);
      expect(voucher.salonId, isNull);
      expect(voucher.salonName, isNull);
    });

    test('handles default createdAt for redeemedAt', () {
      final voucher = VoucherRecord.fromJson({
        'id': 'v_5',
        'code': 'TEST',
        'title': 'Test',
        'discountLabel': 'Test',
        'status': 'active',
        'redeemedAt': 'invalid-date',
      });

      // Falls back to epoch 0
      expect(voucher.redeemedAt.millisecondsSinceEpoch, 0);
    });
  });
}
