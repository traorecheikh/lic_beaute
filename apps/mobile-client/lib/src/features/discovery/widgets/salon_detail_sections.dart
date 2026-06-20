import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_icon.dart';

class SalonSectionLabel extends StatelessWidget {
  const SalonSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTextStyles.headlineSm);
}

class SalonInlineStats extends StatelessWidget {
  const SalonInlineStats({
    required this.staffCount,
    required this.servicesCount,
    super.key,
  });

  final int staffCount;
  final int servicesCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIcon('sparkle', size: 13, color: AppColors.primary),
        SizedBox(width: 5.w),
        Text(
          '$servicesCount prestation${servicesCount > 1 ? 's' : ''}',
          style: AppTextStyles.bodyMd,
        ),
        SizedBox(width: 12.w),
        Container(
          width: 3.r,
          height: 3.r,
          decoration: BoxDecoration(
            color: AppColors.outline,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 12.w),
        AppIcon('user', size: 13, color: AppColors.primary),
        SizedBox(width: 5.w),
        Text(
          '$staffCount spécialiste${staffCount > 1 ? 's' : ''}',
          style: AppTextStyles.bodyMd,
        ),
      ],
    );
  }
}

class SalonServiceRow extends StatelessWidget {
  const SalonServiceRow({
    required this.name,
    required this.duration,
    required this.price,
    super.key,
  });

  final String name, duration, price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.labelLg),
                SizedBox(height: 2.h),
                Text(
                  duration,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: AppTextStyles.priceMd.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
