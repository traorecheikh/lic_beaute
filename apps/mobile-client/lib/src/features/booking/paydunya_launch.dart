List<String> paydunyaLaunchCandidates({
  String? omUrl,
  String? maxitUrl,
  String? hostedUrl,
}) {
  final seen = <String>{};
  final ordered = <String>[];
  for (final candidate in [omUrl, maxitUrl, hostedUrl]) {
    final normalized = candidate?.trim();
    if (normalized == null || normalized.isEmpty || !seen.add(normalized)) {
      continue;
    }
    ordered.add(normalized);
  }
  return ordered;
}

String paydunyaLaunchLabel(String? url) {
  final normalized = url?.toLowerCase() ?? '';
  if (normalized.contains('orangemoneysn.page.link')) return 'Orange Money';
  if (normalized.contains('sugu.orange-sonatel.com')) return 'Maxit';
  if (normalized.contains('pay.wave.com')) return 'Wave';
  if (normalized.contains('app.paydunya.com') || normalized.contains('paydunya.com')) {
    return 'la page PayDunya';
  }
  return 'le moyen de paiement';
}
