/// Infers the payment method channel code from a stored payment method's label.
///
/// Maps human-readable labels like "Orange Money Sénégal" to internal
/// channel codes like "orange_senegal".
String channelFromMethodLabel(String label) {
  final lower = label.toLowerCase();
  if (lower.contains('portefeuille paydunya')) return 'paydunya_wallet';
  if (lower.contains('djamo')) return 'djamo';
  if (lower.contains('wizall')) return 'wizall_senegal';
  if (lower.contains('expresso')) return 'expresso_sn';
  if (lower.contains('free')) return 'free_senegal';
  if (lower.contains('orange money sénégal')) return 'orange_senegal';
  if (lower.contains('orange money côte')) return 'om_ci';
  if (lower.contains('orange money burkina')) return 'om_bf';
  if (lower.contains('orange money mali')) return 'om_ml';
  if (lower.contains('mtn money côte')) return 'mtn_ci';
  if (lower.contains('mtn bénin')) return 'mtn_bj';
  if (lower.contains('mtn cameroun')) return 'mtn_cm';
  if (lower.contains('moov côte')) return 'moov_ci';
  if (lower.contains('moov burkina')) return 'moov_bf';
  if (lower.contains('moov bénin')) return 'moov_bj';
  if (lower.contains('moov togo')) return 'moov_tg';
  if (lower.contains('moov mali')) return 'moov_ml';
  if (lower.contains('t-money')) return 't_money_tg';
  if (lower.contains('wave côte')) return 'wave_ci';
  if (lower.contains('wave')) return 'wave_senegal';
  if (lower.contains('carte bancaire')) return 'carte_bancaire';
  return '';
}

/// Infers the Djamo country code from a phone number.
///
/// Returns 'CI' for Côte d'Ivoire numbers (+225 prefix or 10 digits),
/// 'SN' for Senegal (+221 prefix or other lengths).
String inferDjamoCountryCode(String phone) {
  final normalized = phone.replaceAll(RegExp(r'[^0-9+]'), '');
  if (normalized.startsWith('+225') ||
      normalized.startsWith('225') ||
      normalized.length == 10) {
    return 'CI';
  }
  return 'SN';
}
