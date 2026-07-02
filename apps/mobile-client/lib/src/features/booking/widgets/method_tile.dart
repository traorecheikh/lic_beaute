import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';

/// A branded tile for selecting a payment method.
class MethodTile extends StatelessWidget {
  const MethodTile({
    required this.id,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String id, label;
  final bool selected;
  final VoidCallback onTap;

  String? get _logoAsset {
    final normalized = id.toLowerCase();
    if (normalized.contains('wave')) return 'assets/wave.png';
    if (normalized.contains('orange') || normalized.startsWith('om_')) {
      return 'assets/om.png';
    }
    return null;
  }

  String get _displayLabel => label.toLowerCase().contains('paydunya')
      ? 'Portefeuille mobile'
      : label;

  String get _supportingLabel {
    if (id == 'carte_bancaire') return 'Carte bancaire';
    if (id == 'paydunya_wallet') return 'Portefeuille mobile';
    return 'Paiement mobile';
  }

  @override
  Widget build(BuildContext context) {
    final logoAsset = _logoAsset;
    return Semantics(
      button: true,
      selected: selected,
      label: _displayLabel,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.05)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: logoAsset != null
                    ? Image.asset(logoAsset, fit: BoxFit.contain)
                    : AppIcon(
                        id == 'carte_bancaire' ? 'credit-card' : 'wallet',
                        size: 22,
                        color: AppColors.onSurfaceVariant,
                      ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_displayLabel, style: AppTextStyles.labelLg),
                    SizedBox(height: 2.h),
                    Text(
                      _supportingLabel,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AppIcon(
                selected ? 'check-circle' : 'circle',
                color: selected ? AppColors.primary : AppColors.outline,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
