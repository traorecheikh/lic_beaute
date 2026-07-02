import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_icon_box.dart';
import '../../../core/widgets/app_pressable.dart';
import '../models/account_models.dart';
import 'profile_card_shell.dart';

class PaymentTile extends StatelessWidget {
  const PaymentTile({
    required this.method,
    required this.onTap,
    required this.onDefault,
    required this.onDelete,
    super.key,
  });

  final PaymentMethodRecord method;
  final VoidCallback? onTap;
  final VoidCallback? onDefault;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final channel = _resolveChannel(method.provider, method.method, method.label);
    final savedLabel = method.label?.trim() ?? '';
    final title = savedLabel.isNotEmpty &&
            !savedLabel.toLowerCase().contains('paydunya')
        ? savedLabel
        : _displayTitle(channel);
    final logoAsset = _logoAsset(channel);

    return ProfileCardShell(
      highlighted: method.isDefault,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: 14.h,
      ),
      child: Column(
        children: [
          Row(
            children: [
              AppIconBox(
                size: 52.r,
                color: AppColors.surfaceVariant,
                radius: BorderRadius.circular(AppRadius.lg.r),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.sm.r),
                  child: logoAsset != null
                      ? Image.asset(logoAsset, fit: BoxFit.contain)
                      : AppIcon(
                          'wallet',
                          size: 20,
                          color: AppColors.onSurfaceVariant,
                        ),
                ),
              ),
              gapW16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AppSpacing.sm.w,
                      runSpacing: AppSpacing.xs.h,
                      children: [
                        Text(title, style: AppTextStyles.labelLg),
                        if (method.isDefault)
                          const AppBadge(
                            label: 'Par défaut',
                            color: AppColors.primary,
                          ),
                        if (method.pendingSync)
                          const AppBadge(
                            label: 'En attente',
                            color: Color(0xFF8C6A1C),
                          ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      method.phoneNumber,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                AppPressable(
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: AppIcon('edit', size: 20, color: AppColors.onSurfaceVariant),
                  ),
                ),
            ],
          ),
          gapH12,
          LayoutBuilder(
            builder: (context, constraints) {
              final defaultButton = AppButton.outline(
                label: 'Définir par défaut',
                onPressed: onDefault == null
                    ? null
                    : () {
                        AppHaptics.light();
                        onDefault!();
                      },
                isFullWidth: true,
              );

              final deleteButton = AppButton.outline(
                label: 'Supprimer',
                onPressed: onDelete == null
                    ? null
                    : () {
                        AppHaptics.light();
                        onDelete!();
                      },
                isFullWidth: true,
              );

              return Column(
                children: [
                  defaultButton,
                  gapH8,
                  deleteButton,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  static String _resolveChannel(String provider, String? methodCode, String? label) {
    final savedMethod = methodCode?.trim();
    if (savedMethod != null && savedMethod.isNotEmpty) {
      return savedMethod;
    }
    if (provider == 'wave') return 'wave_senegal';
    if (provider == 'orange_money' || provider == 'om') return 'orange_senegal';
    final normalized = (label ?? '').toLowerCase();
    if (normalized.contains('orange money sénégal')) return 'orange_senegal';
    if (normalized.contains("orange money cote") || normalized.contains("orange money côte")) return 'om_ci';
    if (normalized.contains('orange money burkina')) return 'om_bf';
    if (normalized.contains('orange money mali')) return 'om_ml';
    if (normalized.contains('wave côte') || normalized.contains('wave cote')) return 'wave_ci';
    if (normalized.contains('wave')) return 'wave_senegal';
    if (normalized.contains('free')) return 'free_senegal';
    if (normalized.contains('wizall')) return 'wizall_senegal';
    if (normalized.contains('expresso')) return 'expresso_sn';
    if (normalized.contains("mtn money côte") || normalized.contains("mtn money cote")) return 'mtn_ci';
    if (normalized.contains('mtn bénin') || normalized.contains('mtn benin')) return 'mtn_bj';
    if (normalized.contains('mtn cameroun')) return 'mtn_cm';
    if (normalized.contains('moov côte') || normalized.contains('moov cote')) return 'moov_ci';
    if (normalized.contains('moov burkina')) return 'moov_bf';
    if (normalized.contains('moov bénin') || normalized.contains('moov benin')) return 'moov_bj';
    if (normalized.contains('moov togo')) return 'moov_tg';
    if (normalized.contains('moov mali')) return 'moov_ml';
    if (normalized.contains('t-money')) return 't_money_tg';
    if (normalized.contains('djamo')) return 'djamo';
    if (normalized.contains('portefeuille paydunya')) return 'paydunya_wallet';
    return 'paydunya';
  }

  static String _displayTitle(String channel) {
    switch (channel) {
      case 'orange_senegal':
      case 'om_ci':
      case 'om_bf':
      case 'om_ml':
        return 'Orange Money';
      case 'wave_senegal':
      case 'wave_ci':
        return 'Wave';
      case 'free_senegal':
        return 'Free Money';
      case 'wizall_senegal':
        return 'Wizall';
      case 'expresso_sn':
        return 'Expresso';
      case 'djamo':
        return 'Djamo';
      case 'paydunya_wallet':
        return 'Portefeuille mobile';
      default:
        return 'Moyen de paiement';
    }
  }

  static String? _logoAsset(String channel) {
    switch (channel) {
      case 'wave_senegal':
      case 'wave_ci':
        return 'assets/wave.png';
      case 'orange_senegal':
      case 'om_ci':
      case 'om_bf':
      case 'om_ml':
        return 'assets/om.png';
      default:
        return null;
    }
  }
}
