import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/utils/app_share.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';

class BookingSuccessPage extends StatelessWidget {
  final String bookingId;
  const BookingSuccessPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Success illustration
              Container(
                width: 120.r,
                height: 120.r,
                decoration: BoxDecoration(
                  color: AppColors.successContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AppIcon('check', size: 52, color: AppColors.success),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                "C'est réservé !",
                style: AppTextStyles.displaySm.copyWith(
                  color: AppColors.onSurface,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                "Votre rendez-vous chez Maison Kinka est confirmé.\nVous recevrez un rappel 24h avant.",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 40.h),
              // Booking summary pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: AppShadows.card,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: AppIcon('calendar', size: 20, color: AppColors.primary),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Samedi 12 Juin · 14:30', style: AppTextStyles.labelLg),
                          SizedBox(height: 2.h),
                          Text(
                            'Maison Kinka · Marie Ndiaye',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    AppHaptics.medium();
                    context.go(AppRoutes.bookingDetailPath(bookingId));
                  },
                  child: const Text('Voir mon rendez-vous'),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        AppHaptics.light();
                        await AppShare.card(
                          context: context,
                          card: const BookingShareCard(
                            salonName: 'Maison Kinka',
                            service: 'Shampoing + Brushing',
                            date: 'Samedi 12 Juin',
                            time: '14:30',
                            staffName: 'Marie Ndiaye',
                            price: '7 500 XOF',
                          ),
                          filename: 'mon_rdv.png',
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.ios_share_rounded, size: 18),
                          SizedBox(width: 6.w),
                          const Text('Partager'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: Text(
                        "Accueil",
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
