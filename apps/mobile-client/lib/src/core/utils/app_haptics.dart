import 'package:flutter/services.dart';

abstract final class AppHaptics {
  /// Light tap — navigation, row taps, non-critical selections
  static Future<void> light() => HapticFeedback.lightImpact();

  /// Medium impact — primary CTAs, form submissions, confirmations
  static Future<void> medium() => HapticFeedback.mediumImpact();

  /// Heavy impact — destructive actions (delete, cancel booking)
  static Future<void> heavy() => HapticFeedback.heavyImpact();

  /// Selection click — toggles, checkboxes, radio buttons, star ratings
  static Future<void> select() => HapticFeedback.selectionClick();
}
