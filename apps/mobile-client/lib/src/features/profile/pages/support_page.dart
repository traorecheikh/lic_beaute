import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_strings.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/providers/support_config_provider.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../widgets/faq_tile.dart';
import '../widgets/support_tile.dart';

class SupportPage extends ConsumerWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(supportConfigProvider);

    return AppScaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppTopBar(
        title: AppStrings.supportTitle,
        backgroundColor: AppColors.surface,
      ),
      body: configAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (_, _) => Center(child: Text(AppStrings.loadContactsError)),
        data: (config) => ListView(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 60.h),
          children: [
            Text(
              AppStrings.contactUs,
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            gapH12,
            SupportTile(
              icon: 'chat',
              title: AppStrings.liveChat,
              subtitle: AppStrings.liveChatSubtitle,
              onTap: () {
                AppHaptics.select();
                _launchUrl(config.whatsApp);
              },
            ),
            gapH12,
            SupportTile(
              icon: 'phone',
              title: AppStrings.phoneCall,
              subtitle: AppStrings.phoneCallSubtitle,
              onTap: () {
                AppHaptics.select();
                _launchUrl(config.telUri);
              },
            ),
            gapH12,
            SupportTile(
              icon: 'mail',
              title: AppStrings.email,
              subtitle: config.email,
              onTap: () {
                AppHaptics.select();
                _launchUrl(config.emailUri);
              },
            ),
            SizedBox(height: 32.h),
            Text(
              AppStrings.frequentlyAskedQuestions,
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            gapH12,
            const FaqTile(
              question: 'Comment annuler un rendez-vous ?',
              answer:
                  'Vous pouvez annuler un rendez-vous jusqu\'à 24h à l\'avance depuis l\'onglet "Mes RDV". L\'acompte vous sera alors remboursé.',
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
                  'Pour modifier une prestation, nous vous conseillons d\'annuler et de reprendre rendez-vous, ou de contacter directement le salon.',
            ),
          ],
        ),
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
