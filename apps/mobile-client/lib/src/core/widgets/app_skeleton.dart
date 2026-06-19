import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';

/// Shape variant for skeleton placeholders.
enum SkeletonShape {
  rectangle,
  circle,
  text,
}

/// A shimmer-based skeleton loading placeholder.
/// Use [AppSkeleton] to show loading states instead of raw shimmer wrappers.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    this.width,
    this.height,
    this.shape = SkeletonShape.rectangle,
    this.radius,
    super.key,
  });

  /// Width of the skeleton. Defaults to fill available width for rectangle/text.
  final double? width;

  /// Height of the skeleton.
  final double? height;

  /// Shape variant.
  final SkeletonShape shape;

  /// Border radius for rectangle shapes.
  final double? radius;

  /// Creates a text-line skeleton (full width, small height).
  const AppSkeleton.text({
    this.width,
    this.height,
    super.key,
  }) : shape = SkeletonShape.text,
       radius = null;

  /// Creates a circular skeleton.
  const AppSkeleton.circle({
    required double size,
    super.key,
  }) : width = size,
       height = size,
       shape = SkeletonShape.circle,
       radius = null;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.outlineVariant,
      child: _buildShape(),
    );
  }

  Widget _buildShape() {
    switch (shape) {
      case SkeletonShape.circle:
        return Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
        );
      case SkeletonShape.text:
        return Container(
          width: width ?? double.infinity,
          height: height ?? 14.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      case SkeletonShape.rectangle:
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(radius ?? 8.r),
          ),
        );
    }
  }
}

/// Pre-built card skeleton that mimics a salon list card layout.
class AppCardSkeleton extends StatelessWidget {
  const AppCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.outlineVariant,
      child: const _CardLayout(),
    );
  }
}

class _CardLayout extends StatelessWidget {
  const _CardLayout();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(AppRadius.xl.r)),
            child: Container(width: 96.h, height: 96.h, color: AppColors.surface),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(60.w, 10.h),
                  SizedBox(height: 8.h),
                  _line(120.w, 14.h),
                  SizedBox(height: 8.h),
                  _line(80.w, 10.h),
                  SizedBox(height: 6.h),
                  _line(50.w, 10.h),
                ],
              ),
            ),
          ),
          SizedBox(width: 14.w),
        ],
      ),
    );
  }

  Widget _line(double width, double height) {
    return Container(
      width: width, height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
