import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_contacts.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  static const _documents = [
    (
      title: 'Conditions Générales d\'Utilisation',
      subject: 'CGU - Beauté Avenue',
    ),
    (
      title: 'Politique de Confidentialité',
      subject: 'Politique de confidentialité - Beauté Avenue',
    ),
    (
      title: 'Mentions Légales',
      subject: 'Mentions légales - Beauté Avenue',
    ),
    (
      title: 'Gestion des Cookies',
      subject: 'Politique cookies - Beauté Avenue',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppTopBar(title: 'Mentions Légales', showBackButton: true),
      body: ListView(
        padding: EdgeInsets.all(24.w),
        children: [
          ..._documents.map(
            (doc) => _buildLegalTile(context, doc.title, doc.subject),
          ),
          gapH32,
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 60.h,
                  errorBuilder: (c, e, s) => AppIcon(
                    'sparkle',
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                gapH16,
                Text(
                  'Beauté Avenue SARL',
                  style: AppTextStyles.bodyMd.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Dakar, Sénégal', style: AppTextStyles.bodySm),
                gapH8,
                Text(
                  '© 2026 Tous droits réservés',
                  style: AppTextStyles.bodyXs.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalTile(
    BuildContext context,
    String title,
    String subject,
  ) {
    return AppPressable(
      onTap: () async {
        AppHaptics.light();
        final uri = Uri.parse(
          '${AppContacts.supportEmailUri}?subject=${Uri.encodeComponent(subject)}',
        );
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          if (context.mounted) {
            AppSnackbar.info(
              context,
              'Contactez-nous à ${AppContacts.supportEmail}',
            );
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppTextStyles.bodyMd)),
            AppIcon('external-link', size: 20, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
