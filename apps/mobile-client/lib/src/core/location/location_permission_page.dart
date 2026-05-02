import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_shadows.dart';
import 'location_service.dart';

class LocationPermissionPage extends ConsumerWidget {
  const LocationPermissionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
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
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 48.r,
                    color: AppColors.primary,
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              Text(
                'Salons près de vous',
                style: AppTextStyles.displaySm.copyWith(
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.h),

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
                ('Résultats triés par distance', Icons.near_me_rounded),
                ('Distance affichée sur chaque salon', Icons.straighten_rounded),
                ('Données jamais partagées avec des tiers', Icons.lock_rounded),
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
                          child: Icon(
                            item.$2,
                            size: 18.r,
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

              SizedBox(height: 12.h),

              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Plus tard',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),

              SizedBox(height: 16.h),
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
    }
    // denied: just stay on page, user can retry or dismiss
  }

  Future<void> _showSettingsDialog() async {
    if (!mounted) return;
    final open = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('Autorisation requise', style: AppTextStyles.headlineSm),
        content: Text(
          'La localisation a été refusée définitivement. Ouvrez les paramètres de l\'application pour l\'activer.',
          style: AppTextStyles.bodyMd,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Annuler',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Paramètres',
              style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
    if (open == true) await openAppSettings();
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
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              )
            : Text(
                'Activer la localisation',
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
      ),
    );
  }
}
