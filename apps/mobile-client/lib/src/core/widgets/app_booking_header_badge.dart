import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import 'app_icon.dart';

class AppBookingHeaderBadge extends StatelessWidget {
  final String salonName;
  final String serviceName;

  const AppBookingHeaderBadge({
    required this.salonName,
    required this.serviceName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(
            'sparkle',
            size: 13,
            color: AppColors.secondary,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              '$salonName · $serviceName',
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.onSecondaryContainer,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
