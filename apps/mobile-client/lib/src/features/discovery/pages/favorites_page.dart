import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../router/app_router.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Mes Favoris', style: AppTextStyles.headlineMd),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(24.w),
        itemCount: 2,
        separatorBuilder: (_, __) => SizedBox(height: 24.h),
        itemBuilder: (context, index) => _buildFavoriteCard(
          context,
          id: 'fav-$index',
          name: index == 0 ? 'Beauté Zen' : 'Studio 221',
          image: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=500',
          category: 'Esthétique',
          rating: 4.9,
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context, {
    required String id,
    required String name,
    required String image,
    required String category,
    required double rating,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => context.push(AppRoutes.salon(id)),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(24.r)),
              child: Image.network(
                image,
                width: 100.w,
                height: 100.w,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.toUpperCase(), style: AppTextStyles.labelSm.copyWith(color: colorScheme.primary)),
                    SizedBox(height: 4.h),
                    Text(name, style: AppTextStyles.headlineMd.copyWith(fontSize: 18.sp)),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14.w),
                        SizedBox(width: 4.w),
                        Text(rating.toString(), style: AppTextStyles.labelSm),
                        const Spacer(),
                        Icon(Icons.favorite, color: colorScheme.primary, size: 20.w),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
