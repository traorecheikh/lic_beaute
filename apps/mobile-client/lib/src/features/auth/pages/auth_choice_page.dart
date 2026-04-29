import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../router/app_router.dart';

class AuthChoicePage extends StatelessWidget {
  const AuthChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background photo
          _HeroBackground(),
          // Bottom content card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomCard(
              onLogin: () => context.push(AppRoutes.emailLogin),
              onRegister: () => context.push(AppRoutes.otpLogin),
              onGuest: () => context.go(AppRoutes.home),
            ),
          ),
          // Top logo
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
              child: _TopLogo(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _HeroBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          'https://images.unsplash.com/photo-1595475038784-bbe439ff41e6?q=80&w=1200',
          fit: BoxFit.cover,
        ),
        // Gradient: clear at top, dense at bottom
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.35, 0.65, 1.0],
              colors: [
                Colors.black.withOpacity(0.25),
                Colors.transparent,
                Colors.black.withOpacity(0.55),
                Colors.black.withOpacity(0.95),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TopLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/logo.png',
          width: 36.r,
          height: 36.r,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 10.w),
        Text(
          'Beauté Avenue',
          style: AppTextStyles.labelLg.copyWith(
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _BottomCard extends StatelessWidget {
  const _BottomCard({
    required this.onLogin,
    required this.onRegister,
    required this.onGuest,
  });

  final VoidCallback onLogin;
  final VoidCallback onRegister;
  final VoidCallback onGuest;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
        child: Container(
          padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 8.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Headline
              Text(
                "L’art de la\nperfection.",
                style: AppTextStyles.displaySm.copyWith(
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Réservez les meilleurs salons de beauté autour de vous.',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 24.h),

              // Primary CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRegister,
                  child: const Text('Commencer'),
                ),
              ),
              SizedBox(height: 12.h),

              // Secondary CTA
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onLogin,
                  child: const Text('Se connecter'),
                ),
              ),
              SizedBox(height: 16.h),

              // Guest link
              Center(
                child: GestureDetector(
                  onTap: onGuest,
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
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
