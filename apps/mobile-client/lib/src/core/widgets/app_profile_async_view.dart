import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import 'app_error_state.dart';

class AppProfileAsyncView extends ConsumerWidget {
  final AsyncValue<dynamic> profileAsync;
  final Future<void> Function() onRetry;
  final Widget Function(dynamic profile) builder;

  const AppProfileAsyncView({
    required this.profileAsync,
    required this.onRetry,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => AppErrorState(
        title: 'Impossible de charger le profil',
        message: error.toString(),
        onRetry: onRetry,
      ),
      data: (profile) {
        if (profile == null) {
          return AppErrorState(
            title: 'Profil indisponible',
            message: 'Connectez-vous pour continuer.',
            onRetry: onRetry,
          );
        }
        return builder(profile);
      },
    );
  }
}
