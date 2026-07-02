import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../constants/app_strings.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/app_top_bar.dart';
import 'location_service.dart';

class LocationPermissionPage extends ConsumerWidget {
  const LocationPermissionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      appBar: AppTopBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        showBackButton: false,
      ),
      // top: false because AppScaffold/AppBar already handle the status bar inset
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            children: [
              const Spacer(),

              // Icon
              Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.card,
                ),
                child: Center(
                  child: AppIcon('map-pin', size: 48, color: AppColors.primary),
                ),
              ),

              gapH32,

              Text(
                'Salons près de vous',
                style: AppTextStyles.displaySm.copyWith(
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              gapH16,

              Text(
                'Activez la localisation pour découvrir les salons dans un rayon de 5 km autour de vous, avec la distance affichée sur chaque carte.',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.55,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40.h),

              // Perks list
              ...[
                ('Résultats triés par distance', 'map-pin'),
                ('Distance affichée sur chaque salon', 'map-pin'),
                ('Données jamais partagées avec des tiers', 'lock'),
              ].map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: Row(
                    children: [
                      Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: AppIcon(
                            item.$2,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Text(item.$1, style: AppTextStyles.bodyMd),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // CTA
              _LocationPermissionButton(),

              gapH16,
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationPermissionButton extends ConsumerStatefulWidget {
  @override
  ConsumerState<_LocationPermissionButton> createState() =>
      _LocationPermissionButtonState();
}

class _LocationPermissionButtonState
    extends ConsumerState<_LocationPermissionButton> {
  bool _loading = false;

  Future<void> _request() async {
    setState(() => _loading = true);
    final status = await requestLocationPermission();
    if (!mounted) return;
    setState(() => _loading = false);

    if (status == LocationStatus.granted) {
      ref.invalidate(locationStatusProvider);
      ref.invalidate(locationProvider);
      if (mounted) context.pop(true);
    } else if (status == LocationStatus.deniedForever) {
      await _showSettingsDialog();
      if (mounted) context.pop(false);
    } else if (status == LocationStatus.serviceDisabled) {
      await _showLocationServicesDialog();
      if (mounted) context.pop(false);
    } else {
      context.pop(false);
    }
  }

  Future<void> _showSettingsDialog() async {
    if (!mounted) return;
    bool openSettings = false;
    await AppDialog.show<void>(
      context,
      title: 'Autorisation requise',
      body:
          'La localisation a été refusée définitivement. Ouvrez les paramètres de l\'application pour l\'activer.',
      actions: [
        AppDialogAction(label: 'Annuler', onPressed: () {}),
        AppDialogAction(
          label: 'Paramètres',
          onPressed: () => openSettings = true,
        ),
      ],
    );
    if (openSettings) await openAppSettings();
  }

  Future<void> _showLocationServicesDialog() async {
    if (!mounted) return;
    bool openSettings = false;
    await AppDialog.show<void>(
      context,
      title: 'Localisation désactivée',
      body:
          'Activez les services de localisation sur votre appareil pour afficher les salons proches de vous.',
      actions: [
        AppDialogAction(label: 'Pas maintenant', onPressed: () {}),
        AppDialogAction(
          label: 'Réglages',
          onPressed: () => openSettings = true,
        ),
      ],
    );
    if (openSettings) await openLocationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: FilledButton(
        onPressed: _loading ? null : _request,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: _loading
            ? SizedBox(
                width: 20.r,
                height: 20.r,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              )
            : Text(
                AppStrings.continueAction,
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
      ),
    );
  }
}
