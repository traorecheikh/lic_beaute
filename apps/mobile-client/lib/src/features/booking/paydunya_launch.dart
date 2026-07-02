import 'dart:async';

import '../../core/storage/app_cache.dart';

List<String> paydunyaLaunchCandidates({
  String? omUrl,
  String? maxitUrl,
  String? hostedUrl,
  String? channel,
}) {
  final seen = <String>{};
  final ordered = <String>[];
  // Orange Senegal should prefer its deep links over the hosted fallback.
  final candidates = channel == 'orange_senegal'
      ? [omUrl, maxitUrl]
      : [omUrl, maxitUrl, hostedUrl];
  for (final candidate in candidates) {
    final normalized = candidate?.trim();
    if (normalized == null || normalized.isEmpty || !seen.add(normalized)) {
      continue;
    }
    ordered.add(normalized);
  }
  return ordered;
}

String paydunyaLaunchLabel(String? url, {String? channel}) {
  final normalized = url?.toLowerCase() ?? '';
  if (normalized.contains('orangemoneysn.page.link')) return 'Orange Money';
  if (normalized.contains('sugu.orange-sonatel.com')) {
    return channel == 'orange_senegal' ? 'Orange Money' : 'Maxit';
  }
  if (normalized.contains('pay.wave.com')) return 'Wave';
  if (normalized.contains('app.paydunya.com') ||
      normalized.contains('paydunya.com')) {
    return 'la page de paiement';
  }
  return 'l’application de paiement';
}

class PaymentLaunchTargets {
  const PaymentLaunchTargets({
    this.preferredUrl,
    this.secondaryUrl,
    this.hostedUrl,
    this.channel,
  });

  final String? preferredUrl;
  final String? secondaryUrl;
  final String? hostedUrl;
  final String? channel;

  bool get hasAnyUrl =>
      (preferredUrl?.isNotEmpty ?? false) ||
      (secondaryUrl?.isNotEmpty ?? false) ||
      (hostedUrl?.isNotEmpty ?? false);

  Map<String, dynamic> toJson() => {
        'preferredUrl': preferredUrl,
        'secondaryUrl': secondaryUrl,
        'hostedUrl': hostedUrl,
        'channel': channel,
        'savedAt': DateTime.now().toIso8601String(),
      };

  factory PaymentLaunchTargets.fromJson(Map<dynamic, dynamic> json) {
    return PaymentLaunchTargets(
      preferredUrl: json['preferredUrl'] as String?,
      secondaryUrl: json['secondaryUrl'] as String?,
      hostedUrl: json['hostedUrl'] as String?,
      channel: json['channel'] as String?,
    );
  }
}

/// Persists the last external launch targets for a payment attempt.
///
/// External payment applications can return through a fresh route instance.
/// Keeping the URLs by payment ID means the customer can reopen the same
/// attempt instead of being stranded on a verification-only screen.
abstract final class PaymentLaunchSessionStore {
  static String _key(String paymentId) => 'payment_launch_$paymentId';

  static Future<void> save(
    String paymentId,
    PaymentLaunchTargets targets,
  ) async {
    if (!targets.hasAnyUrl) return;
    await AppCache.settings.put(_key(paymentId), targets.toJson());
  }

  static PaymentLaunchTargets? read(String paymentId) {
    final raw = AppCache.settings.get(_key(paymentId));
    if (raw is! Map) return null;
    return PaymentLaunchTargets.fromJson(raw);
  }

  static void clear(String paymentId) {
    unawaited(AppCache.settings.delete(_key(paymentId)));
  }
}
