import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../router/app_router.dart';

class AuthChoicePage extends StatelessWidget {
  const AuthChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final redirectTo = GoRouterState.of(context).uri.queryParameters['redirectTo'];
    final query = redirectTo != null ? '?redirectTo=${Uri.encodeComponent(redirectTo)}' : '';

    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _FlatBackground(),
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
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () => _showSignUpOptions(context, query),
                      child: const Text('S\'inscrire'),
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // SECONDARY ACTION: Connexion (Existing Users)
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'Déjà un compte ?',
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: TextButton(
                      onPressed: () => context.push('${AppRoutes.emailLogin}$query'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.onSurface,
                        backgroundColor: AppColors.surface,
                        shape: StadiumBorder(),
                        side: BorderSide(color: AppColors.outline.withValues(alpha: 0.3)),
                      ),
                      child: const Text('Se connecter'),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  GestureDetector(
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
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
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
                icon: Icons.sms_outlined,
                onTap: () {
                  Navigator.pop(context);
                  GoRouter.of(context).push('${AppRoutes.otpLogin}$query');
                },
                isPrimary: true,
              ),
              gapH16,
              
              // Email Option
              _SignUpOptionTile(
                title: 'Via Email',
                subtitle: 'Classique avec mot de passe',
                icon: Icons.email_outlined,
                onTap: () {
                  Navigator.pop(context);
                  GoRouter.of(context).push('${AppRoutes.register}$query');
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
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              child: Icon(
                icon,
                color: isPrimary ? AppColors.white : AppColors.onSurface,
                size: 22.r,
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
            Icon(
              Icons.chevron_right,
              color: AppColors.outline,
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _FlatBackground extends StatelessWidget {
  const _FlatBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.sizeOf(context),
      painter: _BrandCirclesPainter(),
    );
  }
}

class _BrandCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    void circle(double cx, double cy, double r, Color color) =>
        canvas.drawCircle(Offset(cx, cy), r, Paint()..color = color);

    circle(
      size.width * 0.88,
      size.height * -0.04,
      size.width * 0.72,
      AppColors.primary.withValues(alpha: 0.07),
    );
    circle(
      size.width * -0.10,
      size.height * 0.12,
      size.width * 0.45,
      AppColors.secondary.withValues(alpha: 0.08),
    );
    circle(
      size.width * 1.05,
      size.height * 0.38,
      size.width * 0.28,
      AppColors.primaryMid.withValues(alpha: 0.05),
    );
    circle(
      size.width * 0.75,
      size.height * 0.28,
      size.width * 0.06,
      AppColors.secondary.withValues(alpha: 0.08),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
