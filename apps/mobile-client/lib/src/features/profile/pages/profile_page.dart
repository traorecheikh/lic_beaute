import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/sync/app_outbox.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_resource_view.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/location/location_service.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final pendingSyncCount = ref.watch(pendingSyncCountProvider);

    return AppScaffold(
      backgroundColor: AppColors.neutral,
      body: AppResourceView(
        value: profileAsync,
        onRetry: () => ref.refresh(profileProvider.future),
        errorTitle: 'Impossible de charger le profil',
        emptyMessage: 'Connectez-vous pour accéder à votre compte.',
        builder: (profile) {
          final avatarUrl = profile!.avatarUrl;
          final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.surface,
                  padding: EdgeInsets.fromLTRB(24.w, 80.h, 24.w, 32.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40.r,
                            backgroundColor: AppColors.primaryLight,
                            backgroundImage: hasAvatar
                                ? CachedNetworkImageProvider(avatarUrl)
                                : null,
                            child: !hasAvatar
                                ? AppIcon(
                                    'user',
                                    size: 34,
                                    color: AppColors.primary,
                                  )
                                : null,
                          ),
                          SizedBox(width: 18.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.fullName,
                                  style: AppTextStyles.headlineLg,
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  ref.watch(cityFromLocationProvider).asData?.value ??
                                      profile.city ??
                                      'Ville détectée automatiquement',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                if (profile.phone != null) ...[
                                  SizedBox(height: 2.h),
                                  Text(
                                    profile.phone!,
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          AppPressable(
                            onTap: () => context.push(AppRoutes.profileEdit),
                            child: Padding(
                              padding: EdgeInsets.all(12.r),
                              child: AppIcon(
                                'edit',
                                size: 20,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (pendingSyncCount > 0 || profile.pendingSync) ...[
                        SizedBox(height: 18.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warningContainer,
                            borderRadius: BorderRadius.circular(AppRadius.lg.r),
                            border: Border.all(color: AppColors.warningOutline),
                          ),
                          child: Row(
                            children: [
                              AppIcon(
                                'refresh',
                                size: 20,
                                color: AppColors.warning,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(                                  child: Text(
                                  'Modifications en attente de synchronisation.',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.onWarningContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(24.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _MenuTile(
                      icon: 'heart',
                      label: 'Mes favoris',
                      onTap: () => context.push(AppRoutes.favorites),
                    ),
                    _MenuTile(
                      icon: 'bell',
                      label: 'Préférences de notifications',
                      onTap: () =>
                          context.push(AppRoutes.notificationPreferences),
                    ),
                    _MenuTile(
                      icon: 'credit-card',
                      label: 'Moyens de paiement',
                      onTap: () => context.push(AppRoutes.profilePayments),
                    ),
                    // Promos hidden — _MenuTile(
                    //   icon: 'gift',
                    //   label: 'Mes bons et codes',
                    //   onTap: () => context.push(AppRoutes.profileVouchers),
                    // ),
                    SizedBox(height: 30.h),
                    _MenuTile(
                      icon: 'help-circle',
                      label: 'Support & assistance',
                      onTap: () => context.push(AppRoutes.profileSupport),
                    ),
                    _MenuTile(
                      icon: 'message-circle',
                      label: 'FAQ',
                      onTap: () => context.push(AppRoutes.profileFaq),
                    ),
                    _MenuTile(
                      icon: 'info',
                      label: 'À propos',
                      onTap: () => context.push(AppRoutes.profileAbout),
                    ),
                    SizedBox(height: 12.h),
                    _MenuTile(
                      icon: 'logout',
                      label: 'Déconnexion',
                      destructive: true,
                      onTap: () async {
                        await ref.read(authActionsProvider).logout();
                        if (!context.mounted) return;
                        AppSnackbar.success(context, 'Session fermée.');
                        context.go(AppRoutes.auth);
                      },
                    ),
                    SizedBox(height: 100.h),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
    this.trailingText, // ignore: unused_element_parameter
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: () {
        destructive ? AppHaptics.heavy() : AppHaptics.light();
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg.r),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            AppIcon(
              icon,
              size: 22,
              color: destructive ? AppColors.error : AppColors.onSurfaceVariant,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.labelLg.copyWith(
                  color: destructive ? AppColors.error : AppColors.onSurface,
                ),
              ),
            ),
            if (trailingText != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.full.r),
                ),
                child: Text(
                  trailingText!,
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              )
            else
              AppIcon('chevron-right', size: 12, color: AppColors.outline),
          ],
        ),
      ),
    );
  }
}
