import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_contacts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/utils/app_launcher.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_top_bar.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

class LegalPage extends ConsumerWidget {
  const LegalPage({super.key});

  static const _documents = [
    (
      title: 'Conditions Générales d\'Utilisation',
      url: AppContacts.termsUrl,
    ),
    (
      title: 'Politique de Confidentialité',
      url: AppContacts.privacyUrl,
    ),
    (
      title: 'Mentions Légales',
      url: AppContacts.legalNoticeUrl,
    ),
    (
      title: 'Gestion des Cookies',
      url: AppContacts.cookiesUrl,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      appBar: AppTopBar(title: AppStrings.legalTitle, showBackButton: true),
      body: ListView(
        padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 28.h),
        children: [
          ..._documents.map(
            (doc) => _buildLegalTile(context, doc.title, doc.url),
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
                  'Beauté Avenue',
                  style: AppTextStyles.bodyMd.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Plateforme exploitée par NumuConnect', style: AppTextStyles.bodySm),
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
    String url,
  ) {
    return AppPressable(
      onTap: () {
        AppHaptics.light();
        openExternalUrl(context, url);
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
