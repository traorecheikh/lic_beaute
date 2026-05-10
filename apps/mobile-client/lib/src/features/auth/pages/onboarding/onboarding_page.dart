import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive_ce.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../router/app_router.dart';
import '../../widgets/auth_form_widgets.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingSlide> _slides = [
    const _OnboardingSlide(
      title: 'Découvrez les meilleurs salons',
      subtitle: 'Accédez à une sélection exclusive de salons de beauté et de bien-être autour de vous.',
      imagePath: 'assets/onboarding/onboarding_1.svg',
    ),
    const _OnboardingSlide(
      title: 'Réservez en un clin d\'œil',
      subtitle: 'Choisissez votre prestation, votre professionnel et votre créneau en quelques secondes.',
      imagePath: 'assets/onboarding/onboarding_2.svg',
    ),
    const _OnboardingSlide(
      title: 'Vivez l\'expérience Beauté Avenue',
      subtitle: 'Profitez d\'un service irréprochable et gérez vos rendez-vous en toute sérénité.',
      imagePath: 'assets/onboarding/onboarding_3.svg',
    ),
  ];

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final box = Hive.box(StorageKeys.settingsBox);
    await box.put(StorageKeys.onboardingCompleted, true);
    if (!mounted) return;
    context.go(AppRoutes.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _slides.length,
            itemBuilder: (context, index) => _slides[index],
          ),
          
          // Navigation top
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            right: 20.w,
            child: TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'Passer',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // Navigation bottom
          Positioned(
            bottom: 20.h,
            left: 28.w,
            right: 28.w,
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        height: 8.h,
                        width: _currentPage == index ? 24.w : 8.w,
                        decoration: BoxDecoration(
                          color: _currentPage == index 
                              ? AppColors.primary 
                              : AppColors.outline.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 48.h),
                  AuthPrimaryButton(
                    label: _currentPage == _slides.length - 1 ? 'COMMENCER' : 'SUIVANT',
                    loading: false,
                    onTap: _onNext,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  final String title;
  final String subtitle;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 320.h,
            width: double.infinity,
            child: SvgPicture.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 60.h),
          Text(
            title,
            style: AppTextStyles.displaySm,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Text(
            subtitle,
            style: AppTextStyles.bodyLg.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 120.h), // Space for indicator and button
        ],
      ),
    );
  }
}
