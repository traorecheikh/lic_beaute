import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../router/app_router.dart';
import '../widgets/auth_form_widgets.dart';

class AuthChoicePage extends StatelessWidget {
  const AuthChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final redirectTo = GoRouterState.of(context).uri.queryParameters['redirectTo'];
    final query = redirectTo != null ? '?redirectTo=${Uri.encodeComponent(redirectTo)}' : '';

    return AppScaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBrandBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Large logo
                  Image.asset(
                    'assets/logo.png',
                    height: 120.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20.h),

                  // Brand name
                  Text(
                    'Beauté Avenue',
                    style: AppTextStyles.displaySm.copyWith(letterSpacing: 0.5),
                  ),
                  SizedBox(height: 10.h),

                  // Tagline
                  Text(
                    'Réservez les meilleurs salons\nde beauté autour de vous.',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.55,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 3),

                  // PRIMARY ACTION: S'inscrire (Merged Entry)
                  AppButton.primary(
                    label: 'S\'inscrire',
                    onPressed: () => _showSignUpOptions(context, query),
                  ),

                  SizedBox(height: 32.h),

                  // SECONDARY ACTION: Connexion (Existing Users)
                  Row(
                    children: [
                      const Expanded(child: AppDivider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'Déjà un compte ?',
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Expanded(child: AppDivider()),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  AppButton.outline(
                    label: 'Se connecter',
                    onPressed: () => context.push('${AppRoutes.emailLogin}$query'),
                  ),

                  SizedBox(height: 20.h),

                  AppPressable(
                    onTap: () => context.go(AppRoutes.home),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        'Continuer sans compte',
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  gapH16,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignUpOptions(BuildContext context, String query) {
    AppSheet.show(
      context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(28.w, 32.h, 28.w, 40.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Créer un compte',
                style: AppTextStyles.headlineLg,
              ),
              gapH8,
              Text(
                'Choisissez votre méthode d\'inscription préférée.',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 32.h),
              
              // SMS Option
              _SignUpOptionTile(
                title: 'Via SMS',
                subtitle: 'Rapide et sécurisé (Recommandé)',
                icon: 'message',
                onTap: () {
                  GoRouter.of(ctx).pop();
                  GoRouter.of(ctx).push('${AppRoutes.otpLogin}$query');
                },
                isPrimary: true,
              ),
              gapH16,

              // Email Option
              _SignUpOptionTile(
                title: 'Via Email',
                subtitle: 'Classique avec mot de passe',
                icon: 'mail',
                onTap: () {
                  GoRouter.of(ctx).pop();
                  GoRouter.of(ctx).push('${AppRoutes.register}$query');
                },
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignUpOptionTile extends StatelessWidget {
  const _SignUpOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.isPrimary,
  });

  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary.withValues(alpha: 0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isPrimary ? AppColors.primary.withValues(alpha: 0.2) : AppColors.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isPrimary ? AppColors.primary : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: AppIcon(
                icon,
                color: isPrimary ? AppColors.white : AppColors.onSurface,
                size: 22,
              ),
            ),
            gapW16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLg.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            AppIcon(
              'chevron-right',
              color: AppColors.outline,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

