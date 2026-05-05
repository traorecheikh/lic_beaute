import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

class BookingStatusChip extends StatelessWidget {
  const BookingStatusChip({
    required this.label,
    this.isUpcoming = false,
    super.key,
  });

  final String label;
  final bool isUpcoming;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isUpcoming
            ? AppColors.statusConfirmedBg
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(
          color: isUpcoming
              ? AppColors.statusConfirmedText
              : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
