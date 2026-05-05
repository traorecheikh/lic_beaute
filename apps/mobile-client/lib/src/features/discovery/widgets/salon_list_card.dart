import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';

/// Horizontal salon card used in search results, favorites, and salon lists.
class SalonListCard extends StatelessWidget {
  const SalonListCard({
    this.salon,
    this.name,
    this.category,
    this.location,
    this.rating,
    this.imageUrl,
    required this.onTap,
    this.trailing,
    this.height,
    this.radius,
    super.key,
  });

  final SalonSummary? salon;
  final String? name, category, location, rating, imageUrl;
  final VoidCallback onTap;
  final Widget? trailing;
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final h = height ?? 96.h;
    final r = radius ?? 20.r;

    final displayName = salon?.name ?? name ?? '';
    final displayCategory = salon?.category ?? category ?? '';
    final displayLocation = salon?.formattedLocation ?? location ?? '';
    final displayRating = salon?.averageRating.toStringAsFixed(1) ?? rating ?? '0.0';
    final displayImageUrl = salon?.logoUrl ?? imageUrl ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(r),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(r)),
              child: displayImageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: displayImageUrl,
                      width: h,
                      height: h,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: h,
                      height: h,
                      color: AppColors.primaryLight,
                      child: Center(
                        child: AppIcon('sparkle', size: 26, color: AppColors.primary),
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 8.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: AppTextStyles.labelLg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      displayCategory,
                      style: AppTextStyles.bodySm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        AppIcon('map-pin', size: 11, color: AppColors.onSurfaceVariant),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            displayLocation,
                            style: AppTextStyles.bodyXs,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        AppIcon('star', size: 11, color: AppColors.secondary),
                        SizedBox(width: 3.w),
                        Text(
                          displayRating,
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
