import 'package:beauteavenue_mobile_client/src/features/profile/models/account_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClientAccountProfile', () {
    test('fromJson parses full JSON', () {
      final profile = ClientAccountProfile.fromJson({
        'id': 'user_1',
        'fullName': 'Awa Ndiaye',
        'email': 'awa@example.com',
        'phone': '771234567',
        'city': 'Dakar',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'preferredContactChannel': 'phone',
        'pushOptIn': true,
        'marketingOptIn': false,
        'preferredLanguage': 'fr',
      });

      expect(profile.id, 'user_1');
      expect(profile.fullName, 'Awa Ndiaye');
      expect(profile.email, 'awa@example.com');
      expect(profile.phone, '771234567');
      expect(profile.city, 'Dakar');
      expect(profile.avatarUrl, 'https://example.com/avatar.jpg');
      expect(profile.preferredContactChannel, 'phone');
      expect(profile.pushOptIn, isTrue);
      expect(profile.marketingOptIn, isFalse);
      expect(profile.preferredLanguage, 'fr');
      expect(profile.pendingSync, isFalse);
    });

    test('fromJson uses defaults for missing fields', () {
      final profile = ClientAccountProfile.fromJson({
        'id': 'user_2',
      });

      expect(profile.id, 'user_2');
      expect(profile.fullName, '');
      expect(profile.email, isNull);
      expect(profile.phone, isNull);
      expect(profile.city, isNull);
      expect(profile.avatarUrl, isNull);
      expect(profile.preferredContactChannel, 'phone');
      expect(profile.pushOptIn, isTrue);
      expect(profile.marketingOptIn, isFalse);
      expect(profile.preferredLanguage, 'fr');
    });

    test('fromJson accepts pendingSync parameter', () {
      final profile = ClientAccountProfile.fromJson(
        {'id': 'user_1', 'fullName': 'Awa'},
        pendingSync: true,
      );

      expect(profile.pendingSync, isTrue);
    });

    test('copyWith updates only provided fields', () {
      final original = ClientAccountProfile.fromJson({
        'id': 'user_1',
        'fullName': 'Awa Ndiaye',
        'email': 'awa@example.com',
        'phone': '771234567',
        'city': 'Dakar',
        'preferredContactChannel': 'phone',
        'pushOptIn': true,
        'marketingOptIn': false,
        'preferredLanguage': 'fr',
      });

      final updated = original.copyWith(
        fullName: 'Awa Diop',
        city: 'Thiès',
        pendingSync: true,
      );

      expect(updated.id, 'user_1');
      expect(updated.fullName, 'Awa Diop');
      expect(updated.email, 'awa@example.com');
      expect(updated.city, 'Thiès');
      expect(updated.pendingSync, isTrue);
    });

    test('toJson produces correct map', () {
      final profile = ClientAccountProfile.fromJson({
        'id': 'user_1',
        'fullName': 'Awa Ndiaye',
        'email': 'awa@example.com',
        'phone': '771234567',
        'city': 'Dakar',
        'avatarUrl': null,
        'preferredContactChannel': 'phone',
        'pushOptIn': true,
        'marketingOptIn': false,
        'preferredLanguage': 'fr',
      });

      final json = profile.toJson();
      expect(json['id'], 'user_1');
      expect(json['fullName'], 'Awa Ndiaye');
      expect(json['email'], 'awa@example.com');
      expect(json['city'], 'Dakar');
      expect(json['phone'], '771234567');
      expect(json['pushOptIn'], isTrue);
      expect(json['preferredLanguage'], 'fr');
    });
  });

  group('PaymentMethodRecord', () {
    test('fromJson parses full JSON', () {
      final record = PaymentMethodRecord.fromJson({
        'id': 'pm_1',
        'provider': 'paydunya',
        'phoneNumber': '771234567',
        'label': 'Orange Money',
        'method': 'orange_senegal',
        'country': 'sn',
        'isDefault': true,
        'lastUsedAt': '2025-06-01T12:00:00.000Z',
      });

      expect(record.id, 'pm_1');
      expect(record.provider, 'paydunya');
      expect(record.phoneNumber, '771234567');
      expect(record.label, 'Orange Money');
      expect(record.method, 'orange_senegal');
      expect(record.country, 'sn');
      expect(record.isDefault, isTrue);
      expect(record.lastUsedAt, isNotNull);
      expect(record.pendingSync, isFalse);
    });

    test('fromJson uses defaults for missing fields', () {
      final record = PaymentMethodRecord.fromJson({'id': 'pm_1'});

      expect(record.id, 'pm_1');
      expect(record.provider, 'paydunya');
      expect(record.phoneNumber, '');
      expect(record.label, isNull);
      expect(record.method, isNull);
      expect(record.country, isNull);
      expect(record.isDefault, isFalse);
      expect(record.lastUsedAt, isNull);
    });

    test('fromJson handles null lastUsedAt', () {
      final record = PaymentMethodRecord.fromJson({
        'id': 'pm_2',
        'lastUsedAt': null,
      });

      expect(record.lastUsedAt, isNull);
    });

    test('fromJson handles invalid lastUsedAt string', () {
      final record = PaymentMethodRecord.fromJson({
        'id': 'pm_3',
        'lastUsedAt': 'not-a-date',
      });

      expect(record.lastUsedAt, isNull);
    });

    test('copyWith preserves unchanged fields', () {
      final original = PaymentMethodRecord.fromJson({
        'id': 'pm_1',
        'phoneNumber': '771234567',
        'isDefault': false,
      });

      final updated = original.copyWith(isDefault: true);

      expect(updated.id, 'pm_1');
      expect(updated.phoneNumber, '771234567');
      expect(updated.isDefault, isTrue);
      expect(updated.provider, 'paydunya');
    });

    test('toJson serializes correctly', () {
      final record = PaymentMethodRecord.fromJson({
        'id': 'pm_1',
        'provider': 'paydunya',
        'phoneNumber': '771234567',
        'label': 'Wave',
        'method': 'wave_senegal',
        'country': 'sn',
        'isDefault': true,
        'lastUsedAt': '2025-06-01T12:00:00.000Z',
      });

      final json = record.toJson();
      expect(json['id'], 'pm_1');
      expect(json['phoneNumber'], '771234567');
      expect(json['isDefault'], isTrue);
      expect(json['lastUsedAt'], isNotNull);
    });
  });

  group('BenefitRecord', () {
    test('fromJson parses full JSON with all fields', () {
      final benefit = BenefitRecord.fromJson({
        'id': 'ben_1',
        'kind': 'membership',
        'name': 'Abonnement mensuel',
        'status': 'active',
        'remainingUses': 3,
        'expiresAt': '2025-12-31T00:00:00.000Z',
        'billingDate': '2025-07-01T00:00:00.000Z',
        'salonId': 'salon_1',
        'salonName': 'Beauté Avenue Dakar',
        'createdAt': '2025-01-15T10:00:00.000Z',
      });

      expect(benefit.id, 'ben_1');
      expect(benefit.kind, 'membership');
      expect(benefit.name, 'Abonnement mensuel');
      expect(benefit.status, 'active');
      expect(benefit.remainingUses, 3);
      expect(benefit.expiresAt, isNotNull);
      expect(benefit.billingDate, isNotNull);
      expect(benefit.salonId, 'salon_1');
      expect(benefit.salonName, 'Beauté Avenue Dakar');
      expect(benefit.createdAt.year, 2025);
    });

    test('fromJson uses defaults for missing fields', () {
      final benefit = BenefitRecord.fromJson({
        'id': 'ben_2',
        'createdAt': '2025-01-01T00:00:00.000Z',
      });

      expect(benefit.id, 'ben_2');
      expect(benefit.kind, 'membership');
      expect(benefit.name, '');
      expect(benefit.status, 'active');
      expect(benefit.remainingUses, isNull);
      expect(benefit.expiresAt, isNull);
      expect(benefit.billingDate, isNull);
      expect(benefit.salonId, '');
      expect(benefit.salonName, '');
    });

    test('handles various status values', () {
      for (final status in ['active', 'paused', 'expired', 'exhausted', 'cancelled']) {
        final benefit = BenefitRecord.fromJson({
          'id': 'ben_3',
          'status': status,
          'createdAt': '2025-01-01T00:00:00.000Z',
        });
        expect(benefit.status, status);
      }
    });

    test('handles null dates gracefully', () {
      final benefit = BenefitRecord.fromJson({
        'id': 'ben_4',
        'createdAt': '2025-01-01T00:00:00.000Z',
      });

      expect(benefit.expiresAt, isNull);
      expect(benefit.billingDate, isNull);
    });
  });

  group('VoucherRecord', () {
    test('fromJson parses full JSON', () {
      final voucher = VoucherRecord.fromJson({
        'id': 'v_1',
        'code': 'PROMO10',
        'title': '10% de réduction',
        'description': 'Sur toutes les prestations',
        'discountLabel': '-10%',
        'status': 'active',
        'expiresAt': '2025-12-31T00:00:00.000Z',
        'redeemedAt': '2025-06-15T10:00:00.000Z',
        'usedAt': null,
        'salonId': 'salon_1',
        'salonName': 'Beauté Avenue Dakar',
      });

      expect(voucher.id, 'v_1');
      expect(voucher.code, 'PROMO10');
      expect(voucher.title, '10% de réduction');
      expect(voucher.description, 'Sur toutes les prestations');
      expect(voucher.discountLabel, '-10%');
      expect(voucher.status, 'active');
      expect(voucher.expiresAt, isNotNull);
      expect(voucher.redeemedAt.year, 2025);
      expect(voucher.usedAt, isNull);
      expect(voucher.salonId, 'salon_1');
      expect(voucher.salonName, 'Beauté Avenue Dakar');
    });

    test('fromJson uses defaults for missing fields', () {
      final voucher = VoucherRecord.fromJson({'id': 'v_2'});

      expect(voucher.id, 'v_2');
      expect(voucher.code, '');
      expect(voucher.title, '');
      expect(voucher.description, isNull);
      expect(voucher.discountLabel, '');
      expect(voucher.status, 'active');
      expect(voucher.redeemedAt.millisecondsSinceEpoch, 0);
    });
  });

  group('ProfileOptions', () {
    test('fromJson parses lists of strings', () {
      final options = ProfileOptions.fromJson({
        'cities': ['Dakar', 'Thiès', 'Saint-Louis'],
        'languages': ['fr', 'en'],
        'contactChannels': ['phone', 'email'],
        'paymentProviders': ['paydunya', 'wave'],
      });

      expect(options.cities, ['Dakar', 'Thiès', 'Saint-Louis']);
      expect(options.languages, ['fr', 'en']);
      expect(options.contactChannels, ['phone', 'email']);
      expect(options.paymentProviders, ['paydunya', 'wave']);
    });

    test('fromJson uses empty lists for missing keys', () {
      final options = ProfileOptions.fromJson({});

      expect(options.cities, isEmpty);
      expect(options.languages, isEmpty);
      expect(options.contactChannels, isEmpty);
      expect(options.paymentProviders, isEmpty);
    });

    test('fromJson handles null values in lists', () {
      final options = ProfileOptions.fromJson({
        'cities': ['Dakar', null, 'Thiès'],
      });

      expect(options.cities, ['Dakar', 'null', 'Thiès']);
    });
  });
}
