import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../../core/widgets/app_icon.dart';

/// Horizontal salon card used inside search discovery modules.
class SearchModuleSalonCard extends StatelessWidget {
  const SearchModuleSalonCard({
    required this.salon,
    required this.onTap,
    this.heroTag,
    super.key,
  });

  final dynamic salon;
  final VoidCallback onTap;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final name = salon.name as String? ?? '';
    final category = salon.category as String? ?? '';
    final logoUrl = salon.logoUrl as String?;

    final imgWidget = logoUrl != null && logoUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: logoUrl,
            height: 80.h,
            width: 140.w,
            fit: BoxFit.cover,
            memCacheHeight: (160.h).toInt(),
            memCacheWidth: (280.w).toInt(),
            errorWidget: (_, _, _) => _PlaceholderImage(),
          )
        : _PlaceholderImage();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl.r),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl.r)),
              child: heroTag != null
                  ? Hero(tag: heroTag!, child: Material(color: Colors.transparent, child: imgWidget))
                  : imgWidget,
            ),
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                  SizedBox(height: 2.h),
                  Text(category, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h, width: 140.w,
      color: AppColors.surfaceVariant,
      child: AppIcon('image', size: 24, color: AppColors.outline),
    );
  }
}
