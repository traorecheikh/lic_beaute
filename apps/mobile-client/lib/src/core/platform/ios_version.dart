import 'dart:io' show Platform;

/// Reliable iOS version detection using [Platform.operatingSystemVersion].
///
/// Parses the raw version string (e.g. "Version 26.1 (Build 23B82)")
/// without relying on platform channels that can produce null in release builds.
///
/// Usage:
/// ```dart
/// if (IOSVersion.isIOS26Plus) { /* native Liquid Glass */ }
/// ```
abstract final class IOSVersion {
  static int? _cachedMajor;

  /// The cached major version number (e.g. 26 for iOS 26.1).
  /// Returns `null` on non-iOS platforms or if parsing fails.
  static int? get major {
    if (_cachedMajor != null) return _cachedMajor;
    if (!Platform.isIOS) return null;
    final versionString = Platform.operatingSystemVersion;
    final match = RegExp(r'Version (\d+)\.').firstMatch(versionString);
    _cachedMajor = int.tryParse(match?.group(1) ?? '');
    return _cachedMajor;
  }

  /// `true` on iOS 26.0 or later.
  static bool get isIOS26Plus => (major ?? 0) >= 26;

  /// `true` on iOS 13.0 through 25.x (supports Cupertino, no Liquid Glass).
  static bool get isIOS13To25 {
    final v = major;
    return v != null && v >= 13 && v < 26;
  }

  /// `true` on any iOS version (for feature gates that need at least iOS 13).
  static bool get isIOS13Plus => (major ?? 0) >= 13;

  /// Whether the current platform can display native Liquid Glass.
  /// Only iOS 26+ supports the native blur/glass backdrop material.
  static bool get supportsNativeGlass => Platform.isIOS && isIOS26Plus;
}
