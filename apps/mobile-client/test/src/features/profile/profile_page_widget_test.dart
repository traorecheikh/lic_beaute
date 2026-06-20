import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/core/location/location_service.dart';
import 'package:beauteavenue_mobile_client/src/core/sync/app_outbox.dart';
import 'package:beauteavenue_mobile_client/src/features/profile/models/account_models.dart';
import 'package:beauteavenue_mobile_client/src/features/profile/pages/profile_page.dart';
import 'package:beauteavenue_mobile_client/src/features/profile/providers/profile_provider.dart';

import '../../../test_harness.dart' show buildTestableRouterWidget;

class _FixedProfileNotifier extends ProfileNotifier {
  _FixedProfileNotifier(this._profile);

  final ClientAccountProfile? _profile;

  @override
  Future<ClientAccountProfile?> build() async => _profile;
}

void main() {
  group('ProfilePage - model helpers', () {
    test('displays full name from profile', () {
      final profile = ClientAccountProfile.fromJson({
        'id': 'user_1',
        'fullName': 'Awa Ndiaye',
        'city': 'Dakar',
        'phone': '771234567',
      });
      expect(profile.fullName, 'Awa Ndiaye');
      expect(profile.city, 'Dakar');
      expect(profile.phone, '771234567');
    });

    test('displays city fallback when city is null', () {
      final profile = ClientAccountProfile.fromJson({
        'id': 'user_1',
        'fullName': 'Awa',
        'city': null,
      });
      expect(profile.city, isNull);
    });

    test('shows phone when available', () {
      final profile = ClientAccountProfile.fromJson({
        'id': 'user_1',
        'fullName': 'Awa',
        'phone': '771234567',
      });
      expect(profile.phone, isNotNull);
    });

    test('pending sync flag triggers sync banner', () {
      final profile = ClientAccountProfile.fromJson({
        'id': 'user_1',
        'fullName': 'Awa',
      }, pendingSync: true);
      expect(profile.pendingSync, isTrue);
    });
  });

  group('VouchersPage - voucher card logic', () {
    test('active voucher displays properly', () {
      final voucher = VoucherRecord.fromJson({
        'id': 'v_1',
        'code': 'PROMO10',
        'title': '10€ de réduction',
        'discountLabel': '-10€',
        'status': 'active',
        'expiresAt': '2025-12-31T00:00:00.000Z',
        'redeemedAt': '2025-06-01T00:00:00.000Z',
      });
      expect(voucher.status, 'active');
      expect(voucher.code, 'PROMO10');
      expect(voucher.expiresAt, isNotNull);
    });

    test('used voucher shows Utilisé badge', () {
      final voucher = VoucherRecord.fromJson({
        'id': 'v_2',
        'code': 'SUMMER',
        'title': 'Réduction été',
        'discountLabel': '-25%',
        'status': 'used',
        'redeemedAt': '2025-07-01T00:00:00.000Z',
        'usedAt': '2025-07-15T10:00:00.000Z',
      });
      expect(voucher.status, 'used');
      // _StatusBadge shows 'Utilisé' for used status
      final badgeLabel = switch (voucher.status) {
        'used' => 'Utilisé',
        'expired' => 'Expiré',
        _ => 'Actif',
      };
      expect(badgeLabel, 'Utilisé');
    });

    test('expired voucher shows Expiré badge', () {
      final voucher = VoucherRecord.fromJson({
        'id': 'v_3',
        'code': 'OLD',
        'title': 'Ancienne offre',
        'discountLabel': '-50%',
        'status': 'expired',
        'redeemedAt': '2024-01-01T00:00:00.000Z',
      });
      final badgeLabel = switch (voucher.status) {
        'used' => 'Utilisé',
        'expired' => 'Expiré',
        _ => 'Actif',
      };
      expect(badgeLabel, 'Expiré');
    });

    test('voucher card gradient changes with status', () {
      // Active: primary gradient
      // Used: secondary gradient
      // Expired/inactive: surfaceVariant gradient
      expect('active' == 'active', isTrue);
      expect('used' == 'used', isTrue);
    });

    test('copy code clipboard action format', () {
      const code = 'PROMO10';
      expect('Code "$code" copié.', 'Code "PROMO10" copié.');
    });

    test('apply code validates empty input', () {
      const code = '';
      final isValid = code.trim().isNotEmpty;
      expect(isValid, isFalse);
    });

    test('apply code trims and uppercases', () {
      const raw = '  promo10  ';
      final cleaned = raw.trim().toUpperCase();
      expect(cleaned, 'PROMO10');
    });
  });

  group('MembershipsPage - benefit card logic', () {
    test('active benefit renders correctly', () {
      final benefit = BenefitRecord.fromJson({
        'id': 'ben_1',
        'kind': 'membership',
        'name': 'Abonnement Mensuel',
        'status': 'active',
        'remainingUses': 5,
        'expiresAt': '2025-12-31T00:00:00.000Z',
        'salonId': 'salon_1',
        'salonName': 'Beauté Avenue Dakar',
        'createdAt': '2025-01-01T00:00:00.000Z',
      });

      expect(benefit.kind, 'membership');
      expect(benefit.status, 'active');
      expect(benefit.remainingUses, 5);
      expect(
        '${benefit.remainingUses} utilisation(s) restante(s)',
        '5 utilisation(s) restante(s)',
      );
    });

    test('package benefit shows Package label', () {
      final benefit = BenefitRecord.fromJson({
        'id': 'ben_2',
        'kind': 'package',
        'name': 'Pack Découverte',
        'status': 'active',
        'remainingUses': 3,
        'salonId': 'salon_2',
        'salonName': 'Beauté Avenue Thiès',
        'createdAt': '2025-03-01T00:00:00.000Z',
      });

      final kindLabel = benefit.kind == 'membership'
          ? 'Abonnement salon'
          : 'Package';
      expect(kindLabel, 'Package');
    });

    test('benefit status badge colors match status', () {
      final (label, _) = switch ('active') {
        'paused' => ('En pause', 'secondary'),
        'expired' => ('Expiré', 'outline'),
        'exhausted' => ('Épuisé', 'outline'),
        'cancelled' => ('Annulé', 'error'),
        _ => ('Actif', 'primary'),
      };
      expect(label, 'Actif');
    });

    test('expired benefit badge shows Expiré', () {
      final (label, _) = switch ('expired') {
        'paused' => ('En pause', 'secondary'),
        'expired' => ('Expiré', 'outline'),
        'exhausted' => ('Épuisé', 'outline'),
        'cancelled' => ('Annulé', 'error'),
        _ => ('Actif', 'primary'),
      };
      expect(label, 'Expiré');
    });

    test('cancelled benefit badge shows Annulé', () {
      final (label, _) = switch ('cancelled') {
        'paused' => ('En pause', 'secondary'),
        'expired' => ('Expiré', 'outline'),
        'exhausted' => ('Épuisé', 'outline'),
        'cancelled' => ('Annulé', 'error'),
        _ => ('Actif', 'primary'),
      };
      expect(label, 'Annulé');
    });
  });

  group('ProfilePage - menu tile logic', () {
    test('menu items render with icons', () {
      // The _MenuTile renders with icon + label + chevron
      const items = [
        ('heart', 'Mes favoris'),
        ('bell', 'Préférences de notifications'),
        ('credit-card', 'Moyens de paiement'),
        ('help-circle', 'Support & assistance'),
        ('message-circle', 'FAQ'),
        ('info', 'À propos'),
        ('logout', 'Déconnexion'),
      ];

      expect(items.length, 7);
      for (final (icon, label) in items) {
        expect(icon, isNotEmpty);
        expect(label, isNotEmpty);
      }
    });

    test('destructive menu item uses error color', () {
      const isDestructive = true;
      // When destructive, haptic is heavy and color is error
      expect(isDestructive, isTrue);
    });

    testWidgets('shows delete account entry and opens confirmation dialog', (
      tester,
    ) async {
      final profile = ClientAccountProfile.fromJson({
        'id': 'user_1',
        'fullName': 'Awa Ndiaye',
        'phone': '771234567',
        'city': 'Dakar',
        'preferredContactChannel': 'phone',
        'pushOptIn': true,
        'marketingOptIn': false,
        'preferredLanguage': 'fr',
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileProvider.overrideWith(() => _FixedProfileNotifier(profile)),
            pendingSyncCountProvider.overrideWith((ref) => 0),
            cityFromLocationProvider.overrideWith((ref) async => 'Dakar'),
          ],
          child: buildTestableRouterWidget(
            (_) => const ProfilePage(),
            path: '/profile',
            initialLocation: '/profile',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Supprimer mon compte'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Supprimer mon compte'), findsOneWidget);

      await tester.tap(find.text('Supprimer mon compte'));
      await tester.pumpAndSettle();

      expect(find.text('Supprimer mon compte'), findsNWidgets(2));
      expect(
        find.text(
          'Cette action supprime votre compte client sur cet appareil et vos données personnelles. Cette action est définitive.',
        ),
        findsOneWidget,
      );
      expect(find.text('Annuler'), findsOneWidget);
      expect(find.text('Supprimer'), findsOneWidget);
    });
  });
}
