import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class AppContacts {
  static const supportPhone = '+221338671010';
  static const supportWhatsApp = 'https://wa.me/221338671010';
  static const supportEmail = 'support@beauteavenue.sn';
  static const supportEmailUri = 'mailto:support@beauteavenue.sn';
  static const supportTelUri = 'tel:+221338671010';

  // Legal
  static const websiteUrl = 'https://beauteavenue.sn';
  static const termsUrl = 'https://beauteavenue.sn/terms';
  static const privacyUrl = 'https://beauteavenue.sn/privacy';
  static const legalNoticeUrl = 'https://beauteavenue.sn/legal-notice';
  static const cookiesUrl = 'https://beauteavenue.sn/cookies';

  /// Safely launch [url] in the external browser.
  ///
  /// Checks [canLaunchUrl] first; if the device cannot handle the URL,
  /// logs a warning instead of crashing or silently failing.
  static Future<bool> launchExternal(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    debugPrint('AppContacts.launchExternal: cannot launch $url');
    return false;
  }
}
