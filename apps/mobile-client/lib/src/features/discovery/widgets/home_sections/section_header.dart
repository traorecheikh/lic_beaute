import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_pressable.dart';

class SectionHeaderSliver extends StatelessWidget {
  const SectionHeaderSliver({
    required this.title,
    required this.action,
    required this.onAction,
    super.key,
  });

  final String title, action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.headlineMd),
            AppPressable(
              onTap: onAction,
              child: Text(
                action,
                style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
