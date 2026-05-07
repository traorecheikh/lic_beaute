import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../core/session/session_store.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'app_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  late final Animation<double> _wordmarkFade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );
    _wordmarkFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
      ),
    );

    _ctrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await ref.read(sessionProvider.notifier).restore();
    final session = ref.read(sessionProvider);
    if (session.isAuthenticated) {
      ref.read(fcmRegistrationServiceProvider).register();
    }
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    context.go(session.isAuthenticated ? AppRoutes.home : AppRoutes.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.splashGradient,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logomark
                AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, _) => FadeTransition(
                    opacity: _fade,
                    child: ScaleTransition(
                      scale: _scale,
                      child: const _LogoMark(),
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                // Wordmark
                AnimatedBuilder(
                  animation: _wordmarkFade,
                  builder: (_, _) => Opacity(
                    opacity: _wordmarkFade.value,
                    child: Column(
                      children: [
                        Text(
                          'Beauté Avenue',
                          style: AppTextStyles.displaySm.copyWith(
                            color: AppColors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'L\'excellence à votre portée',
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 72.h),
                // Loading dots
                AnimatedBuilder(
                  animation: _wordmarkFade,
                  builder: (_, _) => Opacity(
                    opacity: _wordmarkFade.value,
                    child: const _PulsingDots(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      width: 110.r,
      height: 110.r,
      fit: BoxFit.contain,
    );
  }
}

class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.25;
            final t = ((_ctrl.value - delay) % 1.0).clamp(0.0, 1.0);
            final opacity = (t < 0.5 ? t * 2 : 2 - t * 2).clamp(0.2, 1.0);
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              width: 5.r,
              height: 5.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: opacity),
              ),
            );
          }),
        );
      },
    );
  }
}
