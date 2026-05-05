import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../router/app_router.dart';

class AuthChoicePage extends StatelessWidget {
  const AuthChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    width: 120.r,
                    height: 120.r,
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

                  // Buttons — directly on the background, no white card
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () => context.push(AppRoutes.otpLogin),
                      child: const Text('Commencer'),
                    ),
                  ),
                  gapH12,
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: OutlinedButton(
                      onPressed: () => context.push(AppRoutes.emailLogin),
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
