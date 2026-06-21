import 'package:flutter/foundation.dart';

/// Wraps [action] so that repeat invocations within [delay] of the last
/// accepted tap are silently ignored.
///
/// Each call to [debouncedAction] creates its own `_lastTap` timestamp, so
/// unrelated buttons never block each other.
///
/// Usage:
/// ```dart
/// GestureDetector(
///   onTap: debouncedAction(() => context.push(AppRoutes.salon(id))),
/// )
/// ```
VoidCallback debouncedAction(
  VoidCallback? action, {
  Duration delay = const Duration(milliseconds: 500),
}) {
  var lastTap = DateTime(0);
  return () {
    final now = DateTime.now();
    if (now.difference(lastTap) < delay) return;
    lastTap = now;
    action?.call();
  };
}
