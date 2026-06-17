import 'package:hive_ce/hive_ce.dart';

import '../../../core/constants/storage_keys.dart';

/// Manages per-booking review prompt debounce.
///
/// A booking is eligible for a proactive prompt when:
///   - its status is `completed` or `endsAt` is in the past
///   - it has not been reviewed yet (API returns no `reviewId`)
///   - the prompt count for this booking is < [_maxPrompts]
///
/// Counters live in [StorageKeys.settingsBox] under the key
/// `review_prompt_count:{bookingId}`.
abstract final class ReviewPromptManager {
  static const int _maxPrompts = 3;
  static const String _prefix = 'review_prompt_count:';
  static const String _dismissedPrefix = 'review_prompt_dismissed:';

  static Box<dynamic> get _box => Hive.box<dynamic>(StorageKeys.settingsBox);

  /// Whether this booking should trigger a proactive prompt.
  static bool shouldPrompt(String bookingId) {
    if (_box.get('$_dismissedPrefix$bookingId', defaultValue: false) as bool) {
      return false;
    }
    final count = _box.get('$_prefix$bookingId', defaultValue: 0) as int;
    return count < _maxPrompts;
  }

  /// Call this when the sheet is actually shown (auto-trigger).
  static Future<void> recordShown(String bookingId) async {
    final count = _box.get('$_prefix$bookingId', defaultValue: 0) as int;
    await _box.put('$_prefix$bookingId', count + 1);
  }

  /// Call this when the user explicitly dismisses ("Plus tard").
  /// Does NOT permanently suppress — only counts toward [_maxPrompts].
  static Future<void> recordDismissed(String bookingId) async {
    await recordShown(bookingId); // same counter — just bumps it
  }

  /// Call this after a review is successfully submitted or when the user
  /// explicitly closes with "Ne plus afficher".
  static Future<void> permanentlySuppress(String bookingId) async {
    await _box.put('$_dismissedPrefix$bookingId', true);
  }

  /// Remaining prompt budget for this booking (0 = exhausted).
  static int remaining(String bookingId) {
    final count = _box.get('$_prefix$bookingId', defaultValue: 0) as int;
    return (_maxPrompts - count).clamp(0, _maxPrompts);
  }
}
