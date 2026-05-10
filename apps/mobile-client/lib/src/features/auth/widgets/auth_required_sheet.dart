import 'package:flutter/material.dart';

import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/app_sheet_content.dart';

Future<void> showAuthRequiredSheet(
  BuildContext context, {
  required VoidCallback onLogin,
  String title = 'Connexion requise',
  String body =
      'Connectez-vous pour accéder à vos rendez-vous et à votre profil.',
  String confirmLabel = 'Se connecter',
  String cancelLabel = 'Plus tard',
}) {
  return AppSheet.show<void>(
    context,
    builder: (ctx) => AppSheetContent(
      title: title,
      body: body,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: () {
        Navigator.of(ctx).pop();
        onLogin();
      },
      onCancel: () => Navigator.of(ctx).pop(),
    ),
  );
}
