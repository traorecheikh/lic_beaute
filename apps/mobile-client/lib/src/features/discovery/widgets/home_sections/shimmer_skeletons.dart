import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

Widget shimmerBox({required double width, required double height, double radius = 8}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

Widget shimmerWrap(Widget child) => Shimmer.fromColors(
  baseColor: AppColors.surfaceVariant,
  highlightColor: AppColors.outlineVariant,
  child: child,
);

class SalonListCardSkeleton extends StatelessWidget {
  const SalonListCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return shimmerWrap(
      Container(
        height: 96.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(AppRadius.xl.r)),
              child: Container(
                width: 96.w,
                height: 96.w,
                color: AppColors.surface,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(width: 60.w, height: 10.h),
                    SizedBox(height: 8.h),
                    shimmerBox(width: 120.w, height: 14.h),
                    SizedBox(height: 8.h),
                    shimmerBox(width: 80.w, height: 10.h),
                    SizedBox(height: 6.h),
                    shimmerBox(width: 50.w, height: 10.h),
                  ],
                ),
              ),
            ),
            SizedBox(width: 14.w),
          ],
        ),
      ),
    );
  }
}

class TrendingCardSkeleton extends StatelessWidget {
  const TrendingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return shimmerWrap(
      ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl.r),
        child: Container(
          width: 110.w,
          height: 170.h,
          color: AppColors.surface,
        ),
      ),
    );
  }
}

class FeaturedCardSkeleton extends StatelessWidget {
  const FeaturedCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return shimmerWrap(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl.r),
            child: Container(
              width: 160.w,
              height: 220.h,
              color: AppColors.surface,
            ),
          ),
          SizedBox(height: 10.h),
          shimmerBox(width: 120.w, height: 14.h),
          SizedBox(height: 6.h),
          shimmerBox(width: 60.w, height: 10.h),
        ],
      ),
    );
  }
}
