import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_snackbar.dart';

class MembershipsPage extends StatelessWidget {
  const MembershipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Mes Abonnements', style: AppTextStyles.headlineSm),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 60.h),
        children: [
          _MembershipCard(
            salonName: 'Élégance Spa',
            tierName: 'Premium Pass',
            price: '25 000 XOF/mois',
            benefits: ['4 prestations par mois', 'Accès prioritaire', '-15% sur les produits'],
            isActive: true,
            onAction: () {
              AppHaptics.medium();
              AppSnackbar.info(context, 'Gestion des abonnements bientôt disponible.');
            },
          ),
          SizedBox(height: 12.h),
          _MembershipCard(
            salonName: "Beauté d'Afrique",
            tierName: 'Standard',
            price: '10 000 XOF/mois',
            benefits: ['2 prestations par mois', 'Accès standard'],
            isActive: false,
            onAction: () {
              AppHaptics.medium();
              AppSnackbar.info(context, 'Réactivation bientôt disponible.');
            },
          ),
        ],
      ),
    );
  }
}

class _MembershipCard extends StatelessWidget {
  const _MembershipCard({
    required this.salonName,
    required this.tierName,
    required this.price,
    required this.benefits,
    required this.isActive,
    required this.onAction,
  });

  final String salonName;
  final String tierName;
  final String price;
  final List<String> benefits;
  final bool isActive;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: AppShadows.card,
        border: isActive
            ? Border.all(color: AppColors.primary, width: 1.5)
            : Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salonName,
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  Text(tierName, style: AppTextStyles.headlineSm),
                ],
              ),
              if (isActive)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Actif',
                    style: AppTextStyles.labelSm.copyWith(color: AppColors.primary),
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Inactif',
                    style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            price,
            style: AppTextStyles.priceMd.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: 16.h),
          Divider(color: AppColors.outlineVariant),
          SizedBox(height: 12.h),
          ...benefits.map((b) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline_rounded, size: 16.r, color: AppColors.success),
                SizedBox(width: 8.w),
                Text(b, style: AppTextStyles.bodyMd),
              ],
            ),
          )),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: isActive
                ? OutlinedButton(
                    onPressed: onAction,
                    child: const Text("Gérer l'abonnement"),
                  )
                : ElevatedButton(
                    onPressed: onAction,
                    child: const Text('Réactiver'),
                  ),
          ),
        ],
      ),
    );
  }
}
