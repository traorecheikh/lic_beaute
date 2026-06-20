import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_contacts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_launcher.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/providers/support_config_provider.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_top_bar.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(supportConfigProvider);

    return AppScaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppTopBar(title: AppStrings.aboutTitle, showBackButton: true),
      body: configAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(AppStrings.errorGeneric)),
        data: (config) => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 60.h),
          child: Column(
            children: [
              Image.asset('assets/logo.png', width: 80.r, height: 80.r),
              gapH16,
              Text(
                AppStrings.appTitle,
                style: AppTextStyles.displaySm.copyWith(height: 1.1),
              ),
              SizedBox(height: 6.h),
              Text(
                AppStrings.aboutSubtitle,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              gapH4,
              Text(
                AppStrings.versionStr,
                style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
              ),
              SizedBox(height: 40.h),
              _InfoCard(
                title: AppStrings.ourMission,
                body:
                    "Beauté Avenue connecte les clients sénégalais aux meilleurs salons de beauté de leur quartier. Réservez en quelques secondes, payez en toute sécurité avec Wave ou Orange Money, et profitez d'une expérience beauté sans stress.",
              ),
              gapH12,
              _InfoCard(
                title: AppStrings.whoWeAre,
                body:
                    "Nous sommes une startup basée à Dakar, fondée par des passionnés de beauté et de technologie. Notre ambition : digitaliser l'expérience beauté en Afrique de l'Ouest, en partant du Sénégal.",
              ),
              gapH12,
              _InfoCard(
                title: AppStrings.contactUs,
                body: '${config.email}\n${config.phone}\nDakar, Sénégal',
              ),
              gapH12,
              // Legal links
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.xl.r),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Column(
                  children: [
                    _LegalLinkTile(
                      label: AppStrings.termsLabel,
                      url: AppContacts.termsUrl,
                    ),
                    Divider(height: 1, color: AppColors.outlineVariant, indent: 20.w, endIndent: 20.w),
                    _LegalLinkTile(
                      label: AppStrings.privacyLabel,
                      url: AppContacts.privacyUrl,
                    ),
                  ],
                ),
              ),
              gapH32,
              Text(
                '© 2025 Beauté Avenue. Tous droits réservés.',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.labelMd),
          gapH8,
          Text(
            body,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalLinkTile extends StatelessWidget {
  const _LegalLinkTile({required this.label, required this.url});
  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: () => openExternalUrl(context, url),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: AppTextStyles.bodyMd),
            ),
            AppIcon('external-link', size: 18, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
