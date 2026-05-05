import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_sliver_salon_list.dart';
import '../../../router/app_router.dart';
import '../providers/favorites_provider.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../widgets/salon_list_card.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesListProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        title: const Text('Mes Favoris'),
        centerTitle: true,
      ),
      body: AppAsyncView(
        value: favoritesAsync,
        errorTitle: 'Impossible de charger vos favoris',
        serverTitle: 'Les favoris sont indisponibles',
        onRetry: () => ref.refresh(favoritesListProvider.future),
        builder: (resource) {
          final favorites = (resource.data as List<dynamic>?) ?? [];

          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              if (favorites.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: AppEmptyState(
                      icon: Icons.favorite_border,
                      title: 'Aucun favori',
                      subtitle:
                          'Enregistrez vos salons préférés pour les retrouver ici facilement.',
                      actionLabel: 'Découvrir des salons',
                      action: () => context.go(AppRoutes.home),
                    ),
                  ),
                )
              else
                AppSliverSalonList(
                  items: favorites,
                  isStale: resource.isStale,
                  cachedAt: resource.cachedAt,
                  itemBuilder: (context, i, salon) => SalonListCard(
                    salon: salon,
                    onTap: () => context.push(AppRoutes.salon(salon.id)),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.heart_broken_rounded,
                        color: AppColors.primary,
                        size: 20.r,
                      ),
                      onPressed: () {
                        AppHaptics.light();
                        ref.read(favoritesProvider.notifier).toggle(salon.id);
                      },
                    ),
                  ),
                ),
              SliverPadding(padding: EdgeInsets.only(bottom: 120.h)),
            ],
          );
        },
      ),
    );
  }
}
