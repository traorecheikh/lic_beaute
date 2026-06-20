import 'package:url_launcher/url_launcher.dart';

/// Attempts to launch a payment URI using multiple strategies.
///
/// Order of preference:
/// 1. External non-browser app (if [preferNonBrowser])
/// 2. External application
/// 3. Platform default (fallback)
Future<bool> launchExternalPaymentUri(
  Uri uri, {
  bool preferNonBrowser = false,
}) async {
  try {
    if (preferNonBrowser) {
      final launchedNonBrowser = await launchUrl(
        uri,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      if (launchedNonBrowser) return true;
    }
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (launched) return true;
    return launchUrl(uri, mode: LaunchMode.platformDefault);
  } catch (_) {
    try {
      return launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      return false;
    }
  }
}

/// Iterates through [candidates], launching the first one that succeeds.
Future<bool> launchExternalPaymentCandidates(
  Iterable<String?> candidates, {
  bool preferNonBrowser = false,
}) async {
  for (final candidate in candidates) {
    final uri = Uri.tryParse(candidate?.trim() ?? '');
    if (uri == null) continue;
    final launched = await launchExternalPaymentUri(
      uri,
      preferNonBrowser: preferNonBrowser,
    );
    if (launched) return true;
  }
  return false;
}
