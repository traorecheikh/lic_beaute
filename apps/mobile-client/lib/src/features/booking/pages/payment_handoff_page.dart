import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/utils/app_share.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../router/app_router.dart';

class PaymentHandoffPage extends StatefulWidget {
  final String bookingId;
  const PaymentHandoffPage({super.key, required this.bookingId});

  @override
  State<PaymentHandoffPage> createState() => _PaymentHandoffPageState();
}

class _PaymentHandoffPageState extends State<PaymentHandoffPage> {
  String _selectedMethod = 'wave';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Paiement de l\'acompte', style: AppTextStyles.headlineMd),
        actions: [
          IconButton(
            icon: AppIcon('close', size: 20, color: AppColors.onSurface),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary card
            Container(
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Acompte à payer', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                      SizedBox(height: 4.h),
                      Text('3 000 XOF', style: AppTextStyles.displaySm.copyWith(fontSize: 28.sp)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Maison Kinka', style: AppTextStyles.labelLg),
                      Text('Shampoing + Brushing', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            Text('Choisir le moyen de paiement', style: AppTextStyles.labelMd),
            SizedBox(height: 14.h),
            _PaymentMethodTile(
              logoAsset: 'assets/wave.png',
              name: 'Wave',
              description: 'Paiement instantané via Wave',
              value: 'wave',
              groupValue: _selectedMethod,
              onChanged: (v) {
                AppHaptics.select();
                setState(() => _selectedMethod = v!);
              },
            ),
            SizedBox(height: 10.h),
            _PaymentMethodTile(
              logoAsset: 'assets/om.png',
              name: 'Orange Money',
              description: 'Paiement via Orange Money',
              value: 'om',
              groupValue: _selectedMethod,
              onChanged: (v) {
                AppHaptics.select();
                setState(() => _selectedMethod = v!);
              },
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AppHaptics.medium();
                  _redirect();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Payer 3 000 XOF via ${_selectedMethod == 'wave' ? 'Wave' : 'Orange Money'}'),
                    SizedBox(width: 8.w),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // Share booking card before paying
            SizedBox(
              width: double.infinity,
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
                    const Icon(Icons.ios_share_rounded, size: 16),
                    SizedBox(width: 8.w),
                    const Text('Partager ce rendez-vous'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.onSurfaceVariant),
                SizedBox(width: 4.w),
                Text(
                  'Paiement sécurisé · Ne fermez pas l\'app',
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _redirect() {
    // Navigate to success after simulated redirect
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) context.go(AppRoutes.success(widget.bookingId));
    });
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.logoAsset,
    required this.name,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String logoAsset;
  final String name;
  final String description;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: selected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(8.r),
              child: Image.asset(logoAsset, fit: BoxFit.contain),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.labelLg),
                  Text(
                    description,
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
