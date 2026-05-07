import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/session/session_store.dart';
import '../../../core/sync/app_outbox.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_resource_view.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final pendingSyncCount = ref.watch(pendingSyncCountProvider);

    return Scaffold(
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
                                ? Icon(
                                    Icons.person_outline,
                                    size: 34.r,
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
                                  profile.city ?? 'Ville non renseignée',
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
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () =>
                                context.push(AppRoutes.profileEdit),
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
                            color: const Color(0xFFFFF8E8),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: const Color(0xFFE8D6A6)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.sync_outlined,
                                color: Color(0xFF8C6A1C),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  'Modifications en attente de synchronisation.',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: const Color(0xFF6F5718),
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
                      icon: Icons.favorite_border_rounded,
                      label: 'Mes favoris',
                      onTap: () => context.push(AppRoutes.favorites),
                    ),
                    _MenuTile(
                      icon: Icons.notifications_none_rounded,
                      label: 'Préférences de notifications',
                      onTap: () =>
                          context.push(AppRoutes.notificationPreferences),
                    ),
                    _MenuTile(
                      icon: Icons.payment_outlined,
                      label: 'Moyens de paiement',
                      onTap: () => context.push(AppRoutes.profilePayments),
                    ),
                    // Promos hidden — _MenuTile(
                    //   icon: Icons.card_giftcard_outlined,
                    //   label: 'Mes bons et codes',
                    //   onTap: () => context.push(AppRoutes.profileVouchers),
                    // ),
                    _MenuTile(
                      icon: Icons.workspace_premium_outlined,
                      label: 'Mes abonnements',
                      onTap: () => context.push(AppRoutes.profileMemberships),
                    ),
                    SizedBox(height: 30.h),
                    _MenuTile(
                      icon: Icons.help_outline_rounded,
                      label: 'Support & assistance',
                      onTap: () => context.push(AppRoutes.profileSupport),
                    ),
                    _MenuTile(
                      icon: Icons.quiz_outlined,
                      label: 'FAQ',
                      onTap: () => context.push(AppRoutes.profileFaq),
                    ),
                    _MenuTile(
                      icon: Icons.info_outline_rounded,
                      label: 'À propos',
                      onTap: () => context.push(AppRoutes.profileAbout),
                    ),
                    SizedBox(height: 12.h),
                    _MenuTile(
                      icon: Icons.logout_rounded,
                      label: 'Déconnexion',
                      destructive: true,
                      onTap: () async {
                        AppHaptics.heavy();
                        await ref.read(sessionProvider.notifier).logout();
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

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        destructive ? AppHaptics.heavy() : AppHaptics.light();
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22.w,
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
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  trailingText!,
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                size: 12.w,
                color: AppColors.outline,
              ),
          ],
        ),
      ),
    );
  }
}
