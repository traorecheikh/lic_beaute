import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_snackbar.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mentions Légales', style: AppTextStyles.headlineSm),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(24.w),
        children: [
          _buildLegalTile(context, 'Conditions Générales d\'Utilisation'),
          _buildLegalTile(context, 'Politique de Confidentialité'),
          _buildLegalTile(context, 'Mentions Légales'),
          _buildLegalTile(context, 'Gestion des Cookies'),
          SizedBox(height: 32.h),
          Center(
            child: Column(
              children: [
                Image.asset('assets/logo.png', height: 60.h, errorBuilder: (c, e, s) => Icon(Icons.auto_awesome, size: 60.h, color: colorScheme.primary)),
                SizedBox(height: 16.h),
                Text('Beauté Avenue SARL', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.bold)),
                Text('Dakar, Sénégal', style: AppTextStyles.bodySm),
                SizedBox(height: 8.h),
                Text('© 2026 Tous droits réservés', style: AppTextStyles.bodyXs.copyWith(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalTile(BuildContext context, String title) {
    return ListTile(
      title: Text(title, style: AppTextStyles.bodyMd),
      trailing: const Icon(Icons.open_in_new, size: 20),
      onTap: () {
        AppHaptics.light();
        AppSnackbar.info(context, 'Document bientôt disponible.');
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
    );
  }
}
