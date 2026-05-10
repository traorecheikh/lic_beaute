import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppTopBar(title: 'Mentions Légales', showBackButton: true),
      body: ListView(
        padding: EdgeInsets.all(24.w),
        children: [
          _buildLegalTile(context, 'Conditions Générales d\'Utilisation'),
          _buildLegalTile(context, 'Politique de Confidentialité'),
          _buildLegalTile(context, 'Mentions Légales'),
          _buildLegalTile(context, 'Gestion des Cookies'),
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

  Widget _buildLegalTile(BuildContext context, String title) {
    return AppPressable(
      onTap: () {
        AppHaptics.light();
        AppSnackbar.info(context, 'Document bientôt disponible.');
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
