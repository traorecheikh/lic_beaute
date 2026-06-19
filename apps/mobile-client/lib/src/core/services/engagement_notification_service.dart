import 'dart:math' as math;

import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../location/location_service.dart';
import '../network/api_client_provider.dart';
import '../../features/profile/models/account_models.dart';
import '../constants/storage_keys.dart';
import '../storage/app_model_cache.dart';
import '../storage/app_cache.dart';
import 'foreground_notification_service.dart';

class EngagementNotificationService {
  static const int _welcomeNotificationId = 42001;
  static const int _reengagementNotificationId = 42002;
  static const int _prestigeNotificationId = 42003;

  static const _welcomeDueAtKey = 'engagement_welcome_due_at';
  static const _lastWelcomeAtKey = 'engagement_last_welcome_at';
  static const _reengagementDueAtKey = 'engagement_reengagement_due_at';
  static const _prestigeDueAtKey = 'engagement_prestige_due_at';
  static const _prestigeLastSentAtKey = 'engagement_prestige_last_sent_at';
  static const _prestigeLastSyncAtKey = 'engagement_prestige_last_sync_at';
  static const _prestigeSeenIdsKey = 'engagement_prestige_seen_ids';
  static const _prestigeCandidateKey = 'engagement_prestige_candidate';

  static const Duration _welcomeDelay = Duration(minutes: 30);
  static const Duration _welcomeCooldown = Duration(days: 3);
  static const Duration _reengagementDelay = Duration(days: 21);
  static const Duration _prestigeDelay = Duration(minutes: 95);
  static const Duration _prestigeCooldown = Duration(days: 30);
  static const Duration _prestigeSyncCooldown = Duration(hours: 6);

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
        'soft_checkin_channel',
        'Relances Beauté Avenue',
        channelDescription: 'Petits rappels locaux de reprise',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: false,
      );

  static const DarwinNotificationDetails _iosDetails =
      DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: false,
      );

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    tz.initializeTimeZones();

    await ForegroundNotificationService.plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'soft_checkin_channel',
            'Relances Beauté Avenue',
            description: 'Petits rappels locaux de reprise',
            importance: Importance.defaultImportance,
            playSound: false,
          ),
        );
  }

  static Future<void> handleAppResumed() async {
    final now = DateTime.now();
    final settings = AppCache.settings;

    final welcomeDueAt = _readDate(settings, _welcomeDueAtKey);
    if (welcomeDueAt != null) {
      if (!now.isBefore(welcomeDueAt)) {
        await settings.put(_lastWelcomeAtKey, welcomeDueAt.toIso8601String());
      }
      await ForegroundNotificationService.plugin.cancel(
        id: _welcomeNotificationId,
      );
      await settings.delete(_welcomeDueAtKey);
    }

    final reengagementDueAt = _readDate(settings, _reengagementDueAtKey);
    if (reengagementDueAt != null) {
      await ForegroundNotificationService.plugin.cancel(
        id: _reengagementNotificationId,
      );
      await settings.delete(_reengagementDueAtKey);
    }

    final prestigeDueAt = _readDate(settings, _prestigeDueAtKey);
    if (prestigeDueAt != null) {
      if (!now.isBefore(prestigeDueAt)) {
        await settings.put(
          _prestigeLastSentAtKey,
          prestigeDueAt.toIso8601String(),
        );
      }
      await ForegroundNotificationService.plugin.cancel(
        id: _prestigeNotificationId,
      );
      await settings.delete(_prestigeDueAtKey);
      await settings.delete(_prestigeCandidateKey);
    }
  }

  static Future<void> handleAppBackgrounded() async {
    final profile = _readProfile();
    if (profile?.pushOptIn == false) {
      await cancelAll();
      return;
    }

    final now = DateTime.now();
    final settings = AppCache.settings;
    final lastWelcomeAt = _readDate(settings, _lastWelcomeAtKey);

    if (_canScheduleWelcome(now, lastWelcomeAt)) {
      final dueAt = now.add(_welcomeDelay);
      final content = buildWelcomeCopy(fullName: profile?.fullName, now: dueAt);
      await _schedule(
        id: _welcomeNotificationId,
        title: content.title,
        body: content.body,
        scheduledAt: dueAt,
        payload: 'type=engagement_welcome',
      );
      await settings.put(_welcomeDueAtKey, dueAt.toIso8601String());
    }

    final reengagementDueAt = now.add(_reengagementDelay);
    final reengagementContent = buildReengagementCopy(
      fullName: profile?.fullName,
      now: reengagementDueAt,
    );
    await _schedule(
      id: _reengagementNotificationId,
      title: reengagementContent.title,
      body: reengagementContent.body,
      scheduledAt: reengagementDueAt,
      payload: 'type=engagement_reengagement',
    );
    await settings.put(
      _reengagementDueAtKey,
      reengagementDueAt.toIso8601String(),
    );

    await _scheduleStoredPrestigeRecommendation();
  }

  static Future<void> cancelAll() async {
    await ForegroundNotificationService.plugin.cancel(
      id: _welcomeNotificationId,
    );
    await ForegroundNotificationService.plugin.cancel(
      id: _reengagementNotificationId,
    );
    await ForegroundNotificationService.plugin.cancel(
      id: _prestigeNotificationId,
    );
    await AppCache.settings.delete(_welcomeDueAtKey);
    await AppCache.settings.delete(_reengagementDueAtKey);
    await AppCache.settings.delete(_prestigeDueAtKey);
    await AppCache.settings.delete(_prestigeCandidateKey);
  }

  static Future<void> syncPrestigeCandidate(WidgetRef ref) async {
    final profile = _readProfile();
    if (profile == null ||
        profile.pushOptIn == false ||
        profile.marketingOptIn == false) {
      await _clearPrestigeCandidate();
      return;
    }

    final settings = AppCache.settings;
    final lastSyncAt = _readDate(settings, _prestigeLastSyncAtKey);
    final now = DateTime.now();
    if (lastSyncAt != null &&
        now.difference(lastSyncAt) < _prestigeSyncCooldown) {
      return;
    }

    try {
      final position = await ref.read(locationProvider.future);
      if (position == null) {
        await _clearPrestigeCandidate();
        await settings.put(_prestigeLastSyncAtKey, now.toIso8601String());
        return;
      }

      final api = ref.read(apiClientProvider).getSearchApi();
      final response = await api.apiV1SearchSalonsGet(
        q: '*',
        lat: position.latitude,
        lng: position.longitude,
        sort: 'prestige',
        limit: 8,
      );
      final salons = response.data?.results.toList() ?? const [];
      final nearbyPrestige = salons.where(isNearbyPrestigeSalon).toList();
      final seenIds = _readStringSet(settings.get(_prestigeSeenIdsKey));
      final candidate = pickPrestigeCandidate(
        salons: nearbyPrestige,
        seenIds: seenIds,
      );

      final updatedSeenIds = {
        ...seenIds,
        ...nearbyPrestige.map((salon) => salon.id),
      }.take(48).toList(growable: false);
      await settings.put(_prestigeSeenIdsKey, updatedSeenIds);
      await settings.put(_prestigeLastSyncAtKey, now.toIso8601String());

      if (candidate == null) {
        await settings.delete(_prestigeCandidateKey);
        return;
      }

      await settings.put(_prestigeCandidateKey, <String, dynamic>{
        'id': candidate.id,
        'name': candidate.name,
        'city': candidate.city,
        'distanceKm': candidate.distanceKm?.toDouble(),
      });
    } catch (_) {
      await settings.put(_prestigeLastSyncAtKey, now.toIso8601String());
    }
  }

  static Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String payload,
  }) async {
    await ForegroundNotificationService.plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
      notificationDetails: const NotificationDetails(
        android: _androidDetails,
        iOS: _iosDetails,
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static bool _canScheduleWelcome(DateTime now, DateTime? lastWelcomeAt) {
    if (lastWelcomeAt == null) return true;
    return now.difference(lastWelcomeAt) >= _welcomeCooldown;
  }

  static ClientAccountProfile? _readProfile() {
    final raw = AppModelCache.getMap(
      StorageKeys.profileBox,
      StorageKeys.currentUser,
    );
    if (raw == null) return null;
    return ClientAccountProfile.fromJson(raw);
  }

  static DateTime? _readDate(dynamic box, String key) {
    final raw = box.get(key);
    if (raw is! String) return null;
    return DateTime.tryParse(raw);
  }

  static EngagementCopy buildWelcomeCopy({
    required String? fullName,
    required DateTime now,
  }) {
    final firstName = extractFirstName(fullName);
    final useName = shouldUseName(firstName: firstName, now: now);
    return EngagementCopy(
      title: useName ? 'Salut $firstName' : 'Salut',
      body: _pick(now, const [
        'On est là si tu veux réserver.',
        'On peut te trouver un bon salon.',
        'Ton prochain rendez-vous peut se faire ici.',
      ]),
    );
  }

  static EngagementCopy buildReengagementCopy({
    required String? fullName,
    required DateTime now,
  }) {
    final firstName = extractFirstName(fullName);
    final useName = shouldUseName(firstName: firstName, now: now);
    return EngagementCopy(
      title: useName ? 'Coucou $firstName' : 'Un petit coucou',
      body: _pick(now, const [
        'Tu veux tester un nouveau salon ?',
        'Tu cherches une idée pour ton prochain rendez-vous ?',
        'Passe voir ce qu\'il y a de nouveau.',
      ]),
    );
  }

  static bool shouldUseName({
    required String? firstName,
    required DateTime now,
  }) {
    if (firstName == null || firstName.isEmpty) return false;
    return (now.day + firstName.length).isEven;
  }

  static String? extractFirstName(String? fullName) {
    if (fullName == null) return null;
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return null;
    final first = trimmed.split(RegExp(r'\s+')).first.trim();
    if (first.isEmpty || RegExp(r'\d').hasMatch(first)) return null;
    return first;
  }

  static String _pick(DateTime now, List<String> options) {
    final index = math.max(0, now.day % options.length);
    return options[index];
  }

  static bool isNearbyPrestigeSalon(
    SearchSuggestionsResponseTopMatchesInner salon,
  ) {
    final distance = salon.distanceKm?.toDouble();
    return salon.isPrestige && distance != null && distance <= 5;
  }

  static SearchSuggestionsResponseTopMatchesInner? pickPrestigeCandidate({
    required Iterable<SearchSuggestionsResponseTopMatchesInner> salons,
    required Set<String> seenIds,
  }) {
    for (final salon in salons) {
      if (!seenIds.contains(salon.id)) {
        return salon;
      }
    }
    return null;
  }

  static EngagementCopy buildPrestigeCopy({
    required String salonName,
    required String? city,
  }) {
    return EngagementCopy(
      title: 'Nouveau salon prestige',
      body: city != null && city.trim().isNotEmpty
          ? '$salonName est maintenant dispo vers $city.'
          : '$salonName est maintenant près de vous.',
    );
  }

  static Future<void> _scheduleStoredPrestigeRecommendation() async {
    final profile = _readProfile();
    if (profile == null ||
        profile.pushOptIn == false ||
        profile.marketingOptIn == false) {
      await _clearPrestigeCandidate();
      return;
    }

    final settings = AppCache.settings;
    final now = DateTime.now();
    final dueAt = _readDate(settings, _prestigeDueAtKey);
    if (dueAt != null && now.isBefore(dueAt)) {
      return;
    }

    final lastSentAt = _readDate(settings, _prestigeLastSentAtKey);
    if (lastSentAt != null && now.difference(lastSentAt) < _prestigeCooldown) {
      return;
    }

    final candidate = _readPrestigeCandidate(
      settings.get(_prestigeCandidateKey),
    );
    if (candidate == null) return;

    final scheduledAt = now.add(_prestigeDelay);
    final content = buildPrestigeCopy(
      salonName: candidate.name,
      city: candidate.city,
    );

    await _schedule(
      id: _prestigeNotificationId,
      title: content.title,
      body: content.body,
      scheduledAt: scheduledAt,
      payload: 'type=engagement_prestige_salon&salonId=${candidate.id}',
    );
    await settings.put(_prestigeDueAtKey, scheduledAt.toIso8601String());
  }

  static Future<void> _clearPrestigeCandidate() async {
    await ForegroundNotificationService.plugin.cancel(
      id: _prestigeNotificationId,
    );
    await AppCache.settings.delete(_prestigeCandidateKey);
    await AppCache.settings.delete(_prestigeDueAtKey);
  }

  static Set<String> _readStringSet(dynamic raw) {
    if (raw is! List) return <String>{};
    return raw.map((value) => value.toString()).toSet();
  }

  static _PrestigeCandidate? _readPrestigeCandidate(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    final name = raw['name']?.toString();
    if (id == null || id.isEmpty || name == null || name.isEmpty) {
      return null;
    }
    return _PrestigeCandidate(
      id: id,
      name: name,
      city: raw['city']?.toString(),
    );
  }
}

class EngagementCopy {
  const EngagementCopy({required this.title, required this.body});

  final String title;
  final String body;
}

class _PrestigeCandidate {
  const _PrestigeCandidate({
    required this.id,
    required this.name,
    required this.city,
  });

  final String id;
  final String name;
  final String? city;
}
