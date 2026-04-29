import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_snackbar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Notifications', style: AppTextStyles.headlineMd),
        actions: [
          TextButton(
            onPressed: () {
              AppHaptics.select();
              AppSnackbar.success(context, 'Toutes les notifications marquées comme lues.');
            },
            child: const Text('Tout marquer lu'),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: 5,
        separatorBuilder: (_, __) => Divider(height: 1, color: colorScheme.outlineVariant),
        itemBuilder: (context, index) => _buildNotificationItem(
          context,
          title: index == 0 ? 'Rappel de rendez-vous' : 'Nouvelle promotion',
          body: index == 0 
            ? 'N\'oubliez pas votre RDV demain à 14:30 chez L\'Atelier de Beauté.' 
            : 'Bénéficiez de -20% sur tous les soins du visage ce weekend !',
          time: 'Il y a 2h',
          isRead: index > 0,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required String title,
    required String body,
    required String time,
    required bool isRead,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: isRead ? Colors.transparent : colorScheme.primaryContainer.withOpacity(0.05),
      padding: EdgeInsets.all(20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: isRead ? colorScheme.surfaceVariant : colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRead ? Icons.notifications_none : Icons.notifications_active,
              color: isRead ? colorScheme.onSurfaceVariant : colorScheme.primary,
              size: 20.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTextStyles.labelLg.copyWith(fontWeight: isRead ? FontWeight.w600 : FontWeight.bold)),
                    Text(time, style: AppTextStyles.bodySm.copyWith(fontSize: 12.sp, color: colorScheme.onSurfaceVariant)),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(body, style: AppTextStyles.bodyMd.copyWith(color: isRead ? colorScheme.onSurfaceVariant : colorScheme.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
