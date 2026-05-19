import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/constants/app_contacts.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_top_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.neutral,
      appBar: const AppTopBar(title: 'À propos', showBackButton: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 60.h),
        child: Column(
          children: [
            // Logo + app name
            Image.asset('assets/logo.png', width: 80.r, height: 80.r),
            gapH16,
            Text(
              'Beauté Avenue',
              style: AppTextStyles.displaySm.copyWith(height: 1.1),
            ),
            SizedBox(height: 6.h),
            Text(
              "L'excellence à votre portée",
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            gapH4,
            Text(
              'Version 1.0.0',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
            ),
            SizedBox(height: 40.h),
            _InfoCard(
              title: 'Notre mission',
              body:
                  "Beauté Avenue connecte les clients sénégalais aux meilleurs salons de beauté de leur quartier. Réservez en quelques secondes, payez en toute sécurité avec Wave ou Orange Money, et profitez d'une expérience beauté sans stress.",
            ),
            gapH12,
            _InfoCard(
              title: 'Qui sommes-nous ?',
              body:
                  "Nous sommes une startup basée à Dakar, fondée par des passionnés de beauté et de technologie. Notre ambition : digitaliser l'expérience beauté en Afrique de l'Ouest, en partant du Sénégal.",
            ),
            gapH12,
            _InfoCard(
              title: 'Contactez-nous',
              body:
                  "${AppContacts.supportEmail}\n${AppContacts.supportPhone}\nDakar, Sénégal",
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
        borderRadius: BorderRadius.circular(20.r),
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
