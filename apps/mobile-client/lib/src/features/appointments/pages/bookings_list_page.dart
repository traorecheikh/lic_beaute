import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../router/app_router.dart';

class BookingsListPage extends StatelessWidget {
  const BookingsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.neutral,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          title: Text('Mes Rendez-vous', style: AppTextStyles.headlineMd),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            labelStyle: AppTextStyles.labelLg,
            tabs: const [
              Tab(text: 'À VENIR'),
              Tab(text: 'PASSÉS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookingsList(context, isUpcoming: true),
            _buildBookingsList(context, isUpcoming: false),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context, {required bool isUpcoming}) {
    // Mocked data for editorial feel
    final bookings = isUpcoming 
      ? [
          _BookingItem(
            salonName: 'Maison Kinka',
            serviceName: 'Soin Visage Hydratant',
            date: 'Sam. 12 Juil.',
            time: '14:30',
            status: 'Confirmé',
            statusColor: AppColors.statusConfirmedBg,
            statusTextColor: AppColors.statusConfirmedText,
          ),
        ]
      : [
          _BookingItem(
            salonName: 'L\'Atelier de Beauté',
            serviceName: 'Shampoing + Brushing',
            date: 'Lun. 20 Juin',
            time: '10:00',
            status: 'Terminé',
            statusColor: AppColors.outlineVariant,
            statusTextColor: AppColors.onSurfaceVariant,
          ),
        ];

    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 64.w, color: AppColors.outline),
            SizedBox(height: 24.h),
            Text('Aucun rendez-vous', style: AppTextStyles.headlineMd),
            SizedBox(height: 8.h),
            Text('Vos futures séances apparaîtront ici.', style: AppTextStyles.bodySm),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(24.w),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => SizedBox(height: 20.h),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return GestureDetector(
          onTap: () => context.push(
            '${AppRoutes.bookingDetailPath('booking-123')}${isUpcoming ? '' : '?past=true'}',
          ),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: booking.statusColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        booking.status.toUpperCase(),
                        style: AppTextStyles.labelSm.copyWith(color: booking.statusTextColor, fontSize: 10.sp),
                      ),
                    ),
                    Text('${booking.date} • ${booking.time}', style: AppTextStyles.labelSm),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(booking.salonName, style: AppTextStyles.labelLg),
                Text(booking.serviceName, style: AppTextStyles.bodySm),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      flex: isUpcoming ? 1 : 3,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text(isUpcoming ? 'Modifier' : 'Réserver'),
                      ),
                    ),
                    if (!isUpcoming) ...[
                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => context.push(AppRoutes.review('booking-123')),
                          child: const Text('Laisser un avis'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

class _BookingItem {
  final String salonName;
  final String serviceName;
  final String date;
  final String time;
  final String status;
  final Color statusColor;
  final Color statusTextColor;

  _BookingItem({
    required this.salonName,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
  });
}
