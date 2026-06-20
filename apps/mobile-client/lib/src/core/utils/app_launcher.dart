import 'package:flutter/material.dart';

import '../constants/app_contacts.dart';
import '../widgets/app_snackbar.dart';

/// Opens [url] in the external browser with a user-facing fallback.
///
/// Shows an error snackbar if the URL cannot be opened on this device.
Future<void> openExternalUrl(BuildContext context, String url) async {
  final launched = await AppContacts.launchExternal(url);
  if (!launched && context.mounted) {
    AppSnackbar.error(context, "Impossible d'ouvrir le lien.");
  }
}
