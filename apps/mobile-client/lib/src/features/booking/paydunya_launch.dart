List<String> paydunyaLaunchCandidates({
  String? omUrl,
  String? maxitUrl,
  String? hostedUrl,
  String? channel,
}) {
  final seen = <String>{};
  final ordered = <String>[];
  // For Orange Senegal, skip the hostedUrl (PayDunya QR page) —
  // sugu.orange-sonatel.com is the correct URL to open.
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
  if (normalized.contains('app.paydunya.com') || normalized.contains('paydunya.com')) {
    return 'la page PayDunya';
  }
  return 'le moyen de paiement';
}
