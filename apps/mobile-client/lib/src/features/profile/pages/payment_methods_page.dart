import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_snackbar.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Moyens de paiement', style: AppTextStyles.headlineSm),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
        children: [
          Text(
            'Comptes liés',
            style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
          ),
          SizedBox(height: 12.h),
          _PaymentTile(
            logoAsset: 'assets/wave.png',
            title: 'Wave',
            subtitle: '+221 77 123 45 67',
            isDefault: true,
            onTap: () {
              AppHaptics.light();
              AppSnackbar.info(context, 'Gestion du compte Wave bientôt disponible.');
            },
          ),
          SizedBox(height: 10.h),
          _PaymentTile(
            logoAsset: 'assets/om.png',
            title: 'Orange Money',
            subtitle: '+221 78 987 65 43',
            onTap: () {
              AppHaptics.light();
              AppSnackbar.info(context, 'Gestion du compte Orange Money bientôt disponible.');
            },
          ),
          SizedBox(height: 32.h),
          _AddPaymentButton(
            onTap: () {
              AppHaptics.medium();
              AppSnackbar.info(context, 'Liaison de compte bientôt disponible.');
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.logoAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDefault = false,
  });

  final String logoAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDefault;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppShadows.card,
        border: isDefault
            ? Border.all(color: AppColors.primary, width: 1.5)
            : Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(14.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: Image.asset(logoAsset, fit: BoxFit.contain),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: AppTextStyles.labelLg),
                    if (isDefault) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'Par défaut',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.primary,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppIcon('chevron-right', size: 16, color: AppColors.outline),
        ],
      ),
    );
  }
}

class _AddPaymentButton extends StatelessWidget {
  const _AddPaymentButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.outlineVariant,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, size: 20.r, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(
              'Lier un compte',
              style: AppTextStyles.labelLg.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
