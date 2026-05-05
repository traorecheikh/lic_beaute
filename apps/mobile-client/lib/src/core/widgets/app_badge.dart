import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_styles.dart';

/// Colored pill label used for statuses, categories, and tags.
///
/// Replaces the recurring Container + BoxDecoration(borderRadius: 20.r) +
/// Text pattern in payment_methods_page and salon_detail_page.
class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    required this.color,
    this.fontSize,
    super.key,
  });

  final String label;
  final Color color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(
          color: color,
          fontSize: fontSize ?? 10.sp,
        ),
      ),
    );
  }
}
