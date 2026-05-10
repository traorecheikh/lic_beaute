import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../widgets/faq_tile.dart';
import '../widgets/support_tile.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: const AppTopBar(
        title: 'Support & Assistance',
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 60.h),
        children: [
          Text(
            'Contactez-nous',
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          gapH12,
          SupportTile(
            icon: 'chat',
            title: 'Chat en direct',
            subtitle: 'Réponse en moins de 5 minutes',
            onTap: () {
              AppHaptics.select();
              _launchUrl('https://wa.me/221770000000');
            },
          ),
          gapH12,
          SupportTile(
            icon: 'phone',
            title: 'Appel téléphonique',
            subtitle: 'Lun-Sam, 9h à 19h',
            onTap: () {
              AppHaptics.select();
              _launchUrl('tel:+221338000000');
            },
          ),
          gapH12,
          SupportTile(
            icon: 'mail',
            title: 'Email',
            subtitle: 'support@beauteavenue.com',
            onTap: () {
              AppHaptics.select();
              _launchUrl('mailto:support@beauteavenue.com');
            },
          ),
          SizedBox(height: 32.h),
          Text(
            'Questions fréquentes',
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          gapH12,
          const FaqTile(
            question: 'Comment annuler un rendez-vous ?',
            answer:
                'Vous pouvez annuler un rendez-vous jusqu’à 24h à l’avance depuis l’onglet "Mes RDV". L’acompte vous sera alors remboursé.',
          ),
          gapH12,
          const FaqTile(
            question: 'Le paiement est-il sécurisé ?',
            answer:
                'Oui, BeautéAvenue utilise les passerelles de paiement Wave et Orange Money qui sont certifiées et 100% sécurisées.',
          ),
          gapH12,
          const FaqTile(
            question: 'Puis-je modifier ma prestation ?',
            answer:
                'Pour modifier une prestation, nous vous conseillons d’annuler et de reprendre rendez-vous, ou de contacter directement le salon.',
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
