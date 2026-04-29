import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';

class BookingManagePage extends StatelessWidget {
  final String bookingId;
  const BookingManagePage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Modifier le RDV', style: AppTextStyles.headlineMd),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOptionCard(
              context,
              icon: Icons.calendar_month_outlined,
              title: 'Déplacer le rendez-vous',
              subtitle: 'Changer la date ou l\'heure de votre prestation.',
              onTap: () {
                // Navigate to slot selection with reschedule mode
              },
            ),
            SizedBox(height: 16.h),
            _buildOptionCard(
              context,
              icon: Icons.person_add_alt_1_outlined,
              title: 'Changer de prestataire',
              subtitle: 'Choisir une autre personne pour votre soin.',
              onTap: () {
                // Navigate to staff selection
              },
            ),
            SizedBox(height: 16.h),
            _buildOptionCard(
              context,
              icon: Icons.cancel_outlined,
              title: 'Annuler le rendez-vous',
              subtitle: 'Si vous ne pouvez plus venir.',
              isDestructive: true,
              onTap: () {
                // Handle cancellation
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDestructive ? colorScheme.errorContainer : colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                icon,
                color: isDestructive ? colorScheme.error : colorScheme.primary,
                size: 24.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 4.h),
                  Text(subtitle, style: AppTextStyles.bodySm.copyWith(color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
