import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/constants/app_strings.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_sliver_salon_list.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../router/app_router.dart';
import '../providers/favorites_provider.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../widgets/salon_list_card.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesListProvider);
    final favoriteIds = ref.watch(
      favoritesProvider.select((state) => state.salonIds),
    );

    return AppScaffold(
      appBar: AppTopBar(title: AppStrings.favoritesTitle, centerTitle: true),
      body: AppAsyncView(
        value: favoritesAsync,
        errorTitle: AppStrings.loadFavoritesError,
        serverTitle: AppStrings.loadFavoritesServer,
        onRetry: () => ref.refresh(favoritesListProvider.future),
        builder: (resource) {
          final favorites = (resource.data ?? const <SalonSummary>[])
              .where((salon) => favoriteIds.contains(salon.id))
              .toList(growable: false);

          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              if (favorites.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: AppEmptyState(
                      icon: 'heart',
                      title: AppStrings.noFavoritesTitle,
                      subtitle: AppStrings.noFavoritesSubtitle,
                      actionLabel: AppStrings.discoverSalonsCta,
                      action: () => context.go(AppRoutes.home),
                    ),
                  ),
                )
              else
                AppSliverSalonList(
                  items: favorites,
                  isStale: resource.isStale,
                  cachedAt: resource.cachedAt,
                  itemBuilder: (context, i, salon) {
                    final tag = 'favorites_salon_image_${salon.id}';
                    return SalonListCard(
                      salon: salon,
                      heroTag: tag,
                      onTap: () => context.push(
                        '${AppRoutes.salon(salon.id)}?heroTag=${Uri.encodeComponent(tag)}',
                      ),
                      trailing: AppPressable(
                        onTap: () {
                          AppHaptics.light();
                          ref.read(favoritesProvider.notifier).toggle(salon.id);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: AppIcon('heart-broken', size: 22, color: AppColors.error),
                        ),
                      ),
                    );
                  },
                ),
              SliverPadding(padding: EdgeInsets.only(bottom: 120.h)),
            ],
          );
        },
      ),
    );
  }
}
