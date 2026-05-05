import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

/// Animated page-indicator dots for image carousels.
///
/// Replaces the two near-identical List.generate patterns in
/// salon_detail_page (hero SliverAppBar + _GalleryViewerState).
class AppCarouselDots extends StatelessWidget {
  const AppCarouselDots({
    required this.count,
    required this.current,
    this.activeColor = AppColors.white,
    this.inactiveColor = const Color(0x73FFFFFF),
    this.animationDuration = 220,
    super.key,
  });

  final int count;
  final int current;
  final Color activeColor;
  final Color inactiveColor;
  final int animationDuration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: Duration(milliseconds: animationDuration),
          width: isActive ? 20.w : 5.w,
          height: 4.h,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        );
      }),
    );
  }
}
