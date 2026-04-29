import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../router/app_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: CustomScrollView(
        slivers: [
          // ── Header — Editorial ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: EdgeInsets.fromLTRB(24.w, 80.h, 24.w, 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://i.pravatar.cc/150?u=awa',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Awa Ndiaye', style: AppTextStyles.headlineLg),
                          Text('Dakar, Sénégal', style: AppTextStyles.bodySm),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => context.push(AppRoutes.profileEdit),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Menu — Architecturally Clean ────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.all(24.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildEditorialMenuItem(
                  context,
                  icon: Icons.calendar_month_outlined,
                  label: 'Mes Rendez-vous',
                  onTap: () => context.go(AppRoutes.bookingsList),
                ),
                _buildEditorialMenuItem(
                  context,
                  icon: Icons.favorite_border_rounded,
                  label: 'Mes Favoris',
                  onTap: () => context.push(AppRoutes.favorites),
                ),
                _buildEditorialMenuItem(
                  context,
                  icon: Icons.location_on_outlined,
                  label: 'Adresses enregistrées',
                  onTap: () => context.push(AppRoutes.profileAddresses),
                ),
                _buildEditorialMenuItem(
                  context,
                  icon: Icons.payment_outlined,
                  label: 'Moyens de paiement',
                  onTap: () => context.push(AppRoutes.profilePayments),
                ),
                _buildEditorialMenuItem(
                  context,
                  icon: Icons.card_giftcard_outlined,
                  label: 'Mes Bons Cadeaux',
                  onTap: () => context.push(AppRoutes.profileVouchers),
                ),
                SizedBox(height: 40.h),
                _buildEditorialMenuItem(
                  context,
                  icon: Icons.help_outline_rounded,
                  label: 'Support & Assistance',
                  onTap: () => context.push(AppRoutes.profileSupport),
                ),
                _buildEditorialMenuItem(
                  context,
                  icon: Icons.quiz_outlined,
                  label: 'FAQ',
                  onTap: () => context.push(AppRoutes.profileFaq),
                ),
                _buildEditorialMenuItem(
                  context,
                  icon: Icons.info_outline_rounded,
                  label: "À propos de l'application",
                  onTap: () => context.push(AppRoutes.profileAbout),
                ),
                SizedBox(height: 12.h),
                _buildEditorialMenuItem(
                  context,
                  icon: Icons.logout_rounded,
                  label: 'Déconnexion',
                  onTap: () async {
                    AppHaptics.heavy();
                    await ref.read(sessionProvider.notifier).logout();
                    if (!context.mounted) return;
                    context.go(AppRoutes.auth);
                  },
                  isDestructive: true,
                ),
                SizedBox(height: 100.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorialMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: () {
        isDestructive ? AppHaptics.heavy() : AppHaptics.light();
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22.w,
              color: isDestructive
                  ? AppColors.error
                  : AppColors.onSurfaceVariant,
            ),
            SizedBox(width: 16.w),
            Text(
              label,
              style: AppTextStyles.labelLg.copyWith(
                color: isDestructive ? AppColors.error : AppColors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 12.w, color: AppColors.outline),
          ],
        ),
      ),
    );
  }
}
