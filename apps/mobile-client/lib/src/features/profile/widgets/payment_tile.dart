import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_icon_box.dart';
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
  final VoidCallback onTap;
  final VoidCallback? onDefault;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final channel = _resolveChannel(method.provider, method.label);
    final title = _displayTitle(channel);
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
                radius: BorderRadius.circular(14.r),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.sm.r),
                  child: logoAsset != null
                      ? Image.asset(logoAsset, fit: BoxFit.contain)
                      : Icon(
                          Icons.account_balance_wallet_outlined,
                          color: AppColors.onSurfaceVariant,
                          size: 20.r,
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
                    if (method.label != null && method.label!.isNotEmpty)
                      Text(
                        method.label!,
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          gapH12,
          Row(
            children: [
              TextButton(
                onPressed: onDefault == null
                    ? null
                    : () {
                        AppHaptics.light();
                        onDefault!();
                      },
                child: const Text('Définir par défaut'),
              ),
              const Spacer(),
              TextButton(
                onPressed: onDelete == null
                    ? null
                    : () {
                        AppHaptics.light();
                        onDelete!();
                      },
                child: const Text('Supprimer'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _resolveChannel(String provider, String? label) {
    if (provider == 'wave' ||
        provider == 'orange_money' ||
        provider == 'free_money') {
      return provider;
    }
    if (provider == 'om') return 'orange_money';
    final normalized = (label ?? '').toLowerCase();
    if (normalized.contains('orange')) return 'orange_money';
    if (normalized.contains('free')) return 'free_money';
    return 'wave';
  }

  static String _displayTitle(String channel) {
    switch (channel) {
      case 'orange_money':
        return 'Orange Money';
      case 'free_money':
        return 'Free Money';
      default:
        return 'Wave';
    }
  }

  static String? _logoAsset(String channel) {
    switch (channel) {
      case 'wave':
        return 'assets/wave.png';
      case 'orange_money':
        return 'assets/om.png';
      default:
        return null;
    }
  }
}
