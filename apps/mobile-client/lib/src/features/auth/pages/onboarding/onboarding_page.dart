import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive_ce.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../router/app_router.dart';
import '../../widgets/auth_form_widgets.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _slides = [
    _SlideData(
      title: 'Découvrez les meilleurs salons',
      subtitle:
          'Une sélection exclusive de salons de beauté et de bien-être, triés pour vous.',
      imagePath: 'assets/onboarding/onboarding_1.svg',
    ),
    _SlideData(
      title: 'Réservez en quelques secondes',
      subtitle:
          'Choisissez votre prestation, votre professionnel et votre créneau sans friction.',
      imagePath: 'assets/onboarding/onboarding_2.svg',
    ),
    _SlideData(
      title: 'Vivez l\'expérience Beauté Avenue',
      subtitle:
          'Gérez vos rendez-vous, laissez des avis et fidélisez-vous à vos adresses préférées.',
      imagePath: 'assets/onboarding/onboarding_3.svg',
    ),
  ];

  Future<void> _complete() async {
    final box = Hive.box<dynamic>(StorageKeys.settingsBox);
    await box.put(StorageKeys.onboardingCompleted, true);
    if (!mounted) return;
    final granted = await context.push<bool>(AppRoutes.locationPermission);
    if (!mounted) return;
    context.go(AppRoutes.auth);
  }

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _slides.length - 1;

    return AppScaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBrandBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero zone: full SVG on the circles background
              Expanded(
                flex: 58,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _slides.length,
                  itemBuilder: (_, i) => _HeroSlide(slide: _slides[i]),
                ),
              ),

              // Card zone: title + subtitle + dots + button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xl.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 40,
                      offset: const Offset(0, -12),
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 0),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dot indicators
                      Row(
                        children: List.generate(
                          _slides.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 240),
                            margin: EdgeInsets.only(right: 6.w),
                            height: 6.h,
                            width: _currentPage == i ? 20.w : 6.w,
                            decoration: BoxDecoration(
                              color: _currentPage == i
                                  ? AppColors.primary
                                  : AppColors.outline.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        child: Column(
                          key: ValueKey(_currentPage),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _slides[_currentPage].title,
                              style: AppTextStyles.displaySm,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              _slides[_currentPage].subtitle,
                              style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.onSurfaceVariant,
                                height: 1.55,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          if (isLast)
                            Expanded(
                              flex: 1,
                              child: AuthPrimaryButton(
                                label: 'COMMENCER',
                                loading: false,
                                onTap: _next,
                              ),
                            )
                          else ...[
                            AppPressable(
                              onTap: _complete,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 8.h,
                                ),
                                child: Text(
                                  'Passer',
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            AuthPrimaryButton(
                              label: 'SUIVANT',
                              loading: false,
                              onTap: _next,
                              expand: false,
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroSlide extends StatelessWidget {
  const _HeroSlide({required this.slide});
  final _SlideData slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(32.w, MediaQuery.paddingOf(context).top + 16.h, 32.w, 24.h),
      child: SvgPicture.asset(
        slide.imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _SlideData {
  const _SlideData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  final String title;
  final String subtitle;
  final String imagePath;
}
