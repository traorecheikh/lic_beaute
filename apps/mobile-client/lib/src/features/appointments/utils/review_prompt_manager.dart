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
  static const String _showPrefix = 'review_prompt_count:';
  static const String _dismissCountPrefix = 'review_prompt_dismiss_count:';
  static const String _dismissedPrefix = 'review_prompt_dismissed:';

  static Box<dynamic> get _box => Hive.box<dynamic>(StorageKeys.settingsBox);

  /// Whether this booking should trigger a proactive prompt.
  ///
  /// Budget is exhausted when EITHER the show counter or the dismiss counter
  /// reaches [_maxPrompts] — whichever hits first.
  static bool shouldPrompt(String bookingId) {
    if (_box.get('$_dismissedPrefix$bookingId', defaultValue: false) as bool) {
      return false;
    }
    final showCount = _box.get('$_showPrefix$bookingId', defaultValue: 0) as int;
    if (showCount >= _maxPrompts) return false;
    final dismissCount =
        _box.get('$_dismissCountPrefix$bookingId', defaultValue: 0) as int;
    if (dismissCount >= _maxPrompts) return false;
    return true;
  }

  /// Call this when the sheet is actually shown (auto-trigger).
  static Future<void> recordShown(String bookingId) async {
    final count = _box.get('$_showPrefix$bookingId', defaultValue: 0) as int;
    await _box.put('$_showPrefix$bookingId', count + 1);
  }

  /// Call this when the user explicitly dismisses ("Plus tard").
  ///
  /// Increments a separate dismiss counter so that exhausting the
  /// dismiss budget independently stops prompts — without double-counting
  /// against the show counter.
  static Future<void> recordDismissed(String bookingId) async {
    final count =
        _box.get('$_dismissCountPrefix$bookingId', defaultValue: 0) as int;
    await _box.put('$_dismissCountPrefix$bookingId', count + 1);
  }

  /// Call this after a review is successfully submitted or when the user
  /// explicitly closes with "Ne plus afficher".
  static Future<void> permanentlySuppress(String bookingId) async {
    await _box.put('$_dismissedPrefix$bookingId', true);
  }

  /// Remaining prompt budget for this booking (0 = exhausted).
  /// Returns the lower of remaining show budget and remaining dismiss budget.
  static int remaining(String bookingId) {
    final showCount = _box.get('$_showPrefix$bookingId', defaultValue: 0) as int;
    final dismissCount =
        _box.get('$_dismissCountPrefix$bookingId', defaultValue: 0) as int;
    final remainingShows = (_maxPrompts - showCount).clamp(0, _maxPrompts);
    final remainingDismissals =
        (_maxPrompts - dismissCount).clamp(0, _maxPrompts);
    return remainingShows < remainingDismissals
        ? remainingShows
        : remainingDismissals;
  }
}
