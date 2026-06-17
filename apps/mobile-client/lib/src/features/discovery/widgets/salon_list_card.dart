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
    this.heroTag,
    super.key,
  });

  final Object? salon;
  final String? name, category, location, rating, imageUrl;
  final VoidCallback onTap;
  final Widget? trailing;
  final double? height;
  final double? radius;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final h = height ?? 96.h;
    final r = radius ?? AppRadius.xl.r;

    final displayName = _salonName(salon) ?? name ?? '';
    final displayCategory = _salonCategory(salon) ?? category ?? '';
    final displayLocation = _salonCity(salon) ?? location ?? '';
    final displayRating = _salonRating(salon) ?? rating;
    final displayImageUrl = _salonLogoUrl(salon) ?? imageUrl ?? '';
    final displayId = _salonId(salon);
    final activeHeroTag = heroTag ?? (displayId != null ? 'salon_image_$displayId' : null);

    final imageWidget = displayImageUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: displayImageUrl,
            width: h,
            height: h,
            memCacheWidth: (h * 2).toInt(),
            memCacheHeight: (h * 2).toInt(),
            fit: BoxFit.cover,
          )
        : Container(
            width: h,
            height: h,
            color: AppColors.primaryLight,
            child: Center(
              child: AppIcon('sparkle', size: 26, color: AppColors.primary),
            ),
          );

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
              child: activeHeroTag != null
                  ? Hero(
                      tag: activeHeroTag,
                      child: imageWidget,
                    )
                  : imageWidget,
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
                        if (displayRating != null) ...[
                          AppIcon('star', size: 11, color: AppColors.secondary),
                          SizedBox(width: 3.w),
                          Text(
                            displayRating,
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
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

String? _salonName(Object? salon) => switch (salon) {
  SalonSummary s => s.name,
  SalonSummaryListResponseItemsInner s => s.name,
  SearchSuggestionsResponseTopMatchesInner s => s.name,
  _ => null,
};

String? _salonCategory(Object? salon) => switch (salon) {
  SalonSummary s => s.category,
  SalonSummaryListResponseItemsInner s => s.category,
  SearchSuggestionsResponseTopMatchesInner s => s.category,
  _ => null,
};

String? _salonCity(Object? salon) => switch (salon) {
  SalonSummary s => s.city,
  SalonSummaryListResponseItemsInner s => s.city,
  SearchSuggestionsResponseTopMatchesInner s => s.city,
  _ => null,
};

String? _salonRating(Object? salon) => switch (salon) {
  SalonSummary s when s.reviewCount >= 3 => s.averageRating.toStringAsFixed(1),
  SalonSummaryListResponseItemsInner s when s.reviewCount >= 3 =>
    s.averageRating.toStringAsFixed(1),
  SearchSuggestionsResponseTopMatchesInner s when s.reviewCount >= 3 =>
    s.averageRating.toStringAsFixed(1),
  _ => null,
};

String? _salonLogoUrl(Object? salon) => switch (salon) {
  SalonSummary s => s.logoUrl,
  SalonSummaryListResponseItemsInner s => s.logoUrl,
  SearchSuggestionsResponseTopMatchesInner s => s.logoUrl,
  _ => null,
};

String? _salonId(Object? salon) => switch (salon) {
  SalonSummary s => s.id,
  SalonSummaryListResponseItemsInner s => s.id,
  SearchSuggestionsResponseTopMatchesInner s => s.id,
  _ => null,
};
