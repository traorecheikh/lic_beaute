import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:beauteavenue_mobile_client/src/core/services/engagement_notification_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngagementNotificationService', () {
    test('extracts first name safely', () {
      expect(
        EngagementNotificationService.extractFirstName('Cheikh Ahmed Tijani'),
        'Cheikh',
      );
      expect(
        EngagementNotificationService.extractFirstName('   Awa   Ndiaye  '),
        'Awa',
      );
      expect(EngagementNotificationService.extractFirstName(''), isNull);
      expect(EngagementNotificationService.extractFirstName('12345'), isNull);
    });

    test('welcome copy may use name and stays short', () {
      final copy = EngagementNotificationService.buildWelcomeCopy(
        fullName: 'Cheikh Ahmed',
        now: DateTime(2026, 6, 20, 12),
      );

      expect(copy.title, contains('Cheikh'));
      expect(copy.body.length, lessThan(80));
    });

    test('reengagement copy stays natural without name', () {
      final copy = EngagementNotificationService.buildReengagementCopy(
        fullName: null,
        now: DateTime(2026, 6, 21, 12),
      );

      expect(copy.title, isNotEmpty);
      expect(copy.body, isNotEmpty);
      expect(copy.body.length, lessThan(90));
    });

    test('picks the first unseen nearby prestige salon', () {
      final seenIds = {'salon_seen'};
      final candidate = EngagementNotificationService.pickPrestigeCandidate(
        salons: [
          _salon(
            id: 'salon_seen',
            name: 'Maison Prestige',
            distanceKm: 2,
            isPrestige: true,
          ),
          _salon(
            id: 'salon_new',
            name: 'Atelier Luxe',
            distanceKm: 3,
            isPrestige: true,
          ),
        ],
        seenIds: seenIds,
      );

      expect(candidate?.id, 'salon_new');
    });

    test('prestige copy stays short and clear', () {
      final copy = EngagementNotificationService.buildPrestigeCopy(
        salonName: 'Atelier Luxe',
        city: 'Dakar',
      );

      expect(copy.title, 'Nouveau salon prestige');
      expect(copy.body, contains('Atelier Luxe'));
      expect(copy.body.length, lessThan(90));
    });
  });
}

SearchSuggestionsResponseTopMatchesInner _salon({
  required String id,
  required String name,
  required num distanceKm,
  required bool isPrestige,
}) {
  return SearchSuggestionsResponseTopMatchesInner(
    (b) => b
      ..id = id
      ..name = name
      ..category = 'Coiffure'
      ..city = 'Dakar'
      ..averageRating = 4.8
      ..reviewCount = 12
      ..subscriptionTier =
          SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum.premium
      ..featured = true
      ..isPrestige = isPrestige
      ..distanceKm = distanceKm,
  );
}
